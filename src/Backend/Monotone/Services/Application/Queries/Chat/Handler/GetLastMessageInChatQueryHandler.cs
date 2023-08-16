using MediatR;
using Microsoft.EntityFrameworkCore;
using Monotone.Models;
using Monotone.Models.@base;
using Monotone.Models.Enums;
using OneOf;

namespace Monotone.Services.Application.Queries.Chat.Handler;

public class GetLastMessageInChatQueryHandler : IRequestHandler<GetLastMessageInChatQuery, OneOf<Message, Exception>>
{
    private readonly ApplicationDbContext _applicationDbContext;

    public GetLastMessageInChatQueryHandler(ApplicationDbContext applicationDbContext)
    {
        _applicationDbContext = applicationDbContext;
    }

    public async Task<OneOf<Message, Exception>> Handle(GetLastMessageInChatQuery request, CancellationToken cancellationToken)
    {
        try
        {
            var chat = await _applicationDbContext.Chats
                .Include(chat => chat.Participants)
                .Include(chat => chat.Creator)
                .SingleOrDefaultAsync(chat => chat.Id == request.ChatId, cancellationToken: cancellationToken);

            if (chat == null)
            {
                return new Exception("no such a chat");
            }

            if (chat.Creator.Id != request.UserId || !(chat.Participants.Any(party => party.Id == request.UserId)))
            {
                return new Exception("you are not part of the specified chat");
            }

            var result = _applicationDbContext.Messages
                .Include(message => message.TargetChat)
                .OrderByDescending(message => message.CreatedAt);
            if (!await result.AnyAsync(cancellationToken: cancellationToken))
            {
                return new Message() with { MessageType = MessageType.NULL };
            }

            return await result.FirstAsync(cancellationToken: cancellationToken);
        }
        catch (Exception e)
        {
            Console.WriteLine(e);
            throw;
        }
    }
}