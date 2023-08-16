using MediatR;
using Microsoft.EntityFrameworkCore;
using Monotone.Models;
using OneOf;
using Exception = System.Exception;

namespace Monotone.Services.Application.Queries.Chat.Handler;

public class GetMyChatsQueryHandler : IRequestHandler<GetMyChatsQuery, OneOf<List<Models.@base.Chat>, Exception>>
{
    private readonly ApplicationDbContext _applicationDbContext;

    public GetMyChatsQueryHandler(ApplicationDbContext applicationDbContext)
    {
        _applicationDbContext = applicationDbContext;
    }

    public async Task<OneOf<List<Models.@base.Chat>, Exception>> Handle(GetMyChatsQuery request, CancellationToken cancellationToken)
    {
        try
        {
            var chats = _applicationDbContext.Chats
                .Include(chat => chat.Creator)
                .Include(chat => chat.Participants)
                .Where(chat =>
                    chat.Creator.Id == request.UserId || chat.Participants
                        .Any(user => user.Id == request.UserId));

            if (!await chats.AnyAsync(cancellationToken: cancellationToken))
            {
                return new List<Models.@base.Chat>();
            }

            return chats.ToList();
        }
        catch (Exception e)
        {
            return e;
        }
    }
}