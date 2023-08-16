using MediatR;
using Monotone.Models.@base;
using OneOf;

namespace Monotone.Services.Application.Queries.Chat;

public class GetLastMessageInChatQuery : IRequest<OneOf<Message, Exception>>
{
    public GetLastMessageInChatQuery(string userId, string chatId)
    {
        UserId = userId;
        ChatId = chatId;
    }

    public string UserId { get; set; }
    
    public string ChatId { get; set; }
}