using MediatR;
using Microsoft.EntityFrameworkCore;
using Monotone.Models;
using OneOf;

namespace Monotone.Services.Application.Queries.Chat.Handler;

public class GetChatByIdQueryHandler : IRequestHandler<GetChatByIdQuery, OneOf<Models.@base.Chat, Exception>>
{
    private readonly ApplicationDbContext _applicationDbContext;

    public GetChatByIdQueryHandler(ApplicationDbContext applicationDbContext)
    {
        _applicationDbContext = applicationDbContext;
    }

    public async Task<OneOf<Models.@base.Chat, Exception>> Handle(GetChatByIdQuery request, CancellationToken cancellationToken)
    {
        try
        {
            var chat = await _applicationDbContext.Chats
                .Include(chat =>chat.Creator)
                .Include(chat => chat.Participants)
                .SingleOrDefaultAsync(chat => chat.Id == request.ChatId, cancellationToken: cancellationToken);

            if (chat == null)
            {
                return new Exception("no such a chat");
            }

            return chat;
        }
        catch (Exception e)
        {
            return e;
        }
     
    }
}