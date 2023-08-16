using MediatR;
using Microsoft.EntityFrameworkCore;
using Monotone.Models;
using OneOf;

namespace Monotone.Services.Application.Queries.Chat.Handler;

public class GetNumberOfUnreadMessagesForMeQueryHandler : IRequestHandler<GetNumberOfUnreadMessagesForMeQuery, OneOf< long , Exception>>
{
    private readonly ApplicationDbContext _applicationDbContext;

    public GetNumberOfUnreadMessagesForMeQueryHandler(ApplicationDbContext applicationDbContext)
    {
        _applicationDbContext = applicationDbContext;
    }

    public async  Task<OneOf<long, Exception>> Handle(GetNumberOfUnreadMessagesForMeQuery request, CancellationToken cancellationToken)
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
                .Include(message => message.SeenBy)
                .Where(message => message.TargetChat.Id == request.ChatId)
                .Where(message => message.SeenBy.All(user => user.Id != request.UserId));

            return await result.LongCountAsync(cancellationToken: cancellationToken);

        }
        catch (Exception e)
        {
            return e;
        }
    }
}