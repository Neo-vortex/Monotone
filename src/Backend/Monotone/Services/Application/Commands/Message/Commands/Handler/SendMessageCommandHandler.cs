using MediatR;
using Monotone.Models;
using OneOf;
using System.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Monotone.Models.Enums;

namespace Monotone.Services.Application.Commands.Message.Commands.Handler;

public class SendMessageCommandHandler : IRequestHandler<SendMessageCommand, OneOf<Models.@base.Message, Exception>>
{
    private readonly ApplicationDbContext _applicationDbContext;

    public SendMessageCommandHandler(ApplicationDbContext applicationDbContext)
    {
        _applicationDbContext = applicationDbContext;
    }

    public async Task<OneOf<Models.@base.Message, Exception>> Handle(SendMessageCommand request, CancellationToken cancellationToken)
    {
        await using var transaction =
            await _applicationDbContext.Database.BeginTransactionAsync(IsolationLevel.Serializable, cancellationToken: cancellationToken);
        try
        {
            var creator = await _applicationDbContext.Users
                .SingleOrDefaultAsync(user => user.Id == request.SenderId, cancellationToken: cancellationToken);
            if (creator == null)
            {
                return new Exception("no such a user as creator");
            }
           
            var targetChat = await _applicationDbContext.Chats
                .Include(chat => chat.Participants)
                .Include(chat => chat.Creator)
                .SingleOrDefaultAsync(chat => chat.Id == request.Message.TargetChatId, cancellationToken: cancellationToken);

            if (targetChat == null)
            {
                return new Exception("no such a chat");
            }
            
            if (targetChat.Participants.All(user => user.Id != request.SenderId) && targetChat.Creator.Id != request.SenderId)
            {
                return new Exception("you are not a member of this chat");
            }
            
            if (request.Message is { MessageType: MessageType.TEXT, Content: null })
            {
                return new Exception("text message must have a content");
            }
            
            if (request.Message.MessageType!= MessageType.TEXT && request.Message.ResourceAddress.IsNullOrEmpty())
            {
                return new Exception("non text message must have a resource address");
            }
            
            var message = new Models.@base.Message()
            {
                Content = request.Message.Content,
                CreatedAt = DateTime.UtcNow,
                Sender = creator,
                TargetChat = targetChat,
                Metadata = request.Message.Metadata,
                IsReplay = request.Message.IsReplay,
                MessageType = request.Message.MessageType,
                MessageResourceType = request.Message.MessageType == MessageType.TEXT ? MessageResourceType.INTERNAL : MessageResourceType.EXTERNAL,
                SeenBy = new List<ApplicationUser>(),
                ResourceAddress = request.Message.ResourceAddress
            };
            
            var result = await _applicationDbContext.Messages.AddAsync(message, cancellationToken);
            await _applicationDbContext.SaveChangesAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);
            return result.Entity;
        }
        catch (Exception e)
        {
            await transaction.RollbackAsync(cancellationToken);
            return e;
        }
    }
}