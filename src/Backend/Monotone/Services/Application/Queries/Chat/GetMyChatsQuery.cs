using MediatR;
using OneOf;

namespace Monotone.Services.Application.Queries.Chat;

public class GetMyChatsQuery : IRequest<OneOf<List<Models.@base.Chat>, Exception>>
{
    public GetMyChatsQuery(string userId)
    {
        UserId = userId;
    }

    public string UserId { get; set; }
}