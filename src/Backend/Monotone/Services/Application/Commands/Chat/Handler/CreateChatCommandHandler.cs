using MediatR;
using Monotone.Models;
using OneOf;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using System.Data;
namespace Monotone.Services.Application.Commands.Chat.Handler;

public class CreateChatCommandHandler : IRequestHandler<CreateChatCommand, OneOf<string , Exception>>
{
    private readonly ApplicationDbContext _applicationDbContext;

    public CreateChatCommandHandler(ApplicationDbContext applicationDbContext)
    {
        _applicationDbContext = applicationDbContext;
    }

    public async Task<OneOf<string, Exception>> Handle(CreateChatCommand request, CancellationToken cancellationToken)
    {
        await using var transaction =
            await _applicationDbContext.Database.BeginTransactionAsync(IsolationLevel.Serializable, cancellationToken: cancellationToken);
        try
        {
            var creator = await _applicationDbContext.Users.SingleOrDefaultAsync(user => user.Id == request.CreatorId, cancellationToken: cancellationToken);
           if (creator == null)
           {
               return new Exception("no such a user as creator");
           }
           var participantsId = request.CreateChat.OtherParticipents;
           var participents = new List<ApplicationUser>();
           foreach (var participentId in participantsId)
           {
               var user = await _applicationDbContext.Users.SingleOrDefaultAsync(user => user.Id == participentId, cancellationToken: cancellationToken);
               if (user == null)
               {
                   return new Exception($"participant with id {participentId} is not found" );
               }
               participents.Add(user);
           }

           var chat = new Models.@base.Chat()
           {
               Creator = creator,
               CreatedAt = DateTime.UtcNow,
               Participants = participents,
               IsGroup = participents.Count > 2,
               GroupName = participents.Count > 2 ? request.CreateChat.GroupName! : string.Join('@', participents.Select(user => user.UserName))
           };
            var result = await _applicationDbContext.Chats.AddAsync(chat, cancellationToken);
            await _applicationDbContext.SaveChangesAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);
            return result.Entity.Id;
        }
        catch (Exception e)
        {
            await transaction.RollbackAsync(cancellationToken);
            return e;
        }
    }
}