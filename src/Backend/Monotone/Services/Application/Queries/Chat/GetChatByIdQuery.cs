using MediatR;
using OneOf;

namespace Monotone.Services.Application.Queries.Chat;

public class GetChatByIdQuery : IRequest<OneOf<Models.@base.Chat, Exception>>
{
    public GetChatByIdQuery(string chatId)
    {
        ChatId = chatId;
    }

    public string ChatId { get; set; }
}