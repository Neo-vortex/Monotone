using MediatR;
using OneOf;

namespace Monotone.Services.Application.Queries.Chat;

public class GetNumberOfUnreadMessagesForMeQuery : IRequest<OneOf<long, Exception>>
{
    public GetNumberOfUnreadMessagesForMeQuery(string userId, string chatId)
    {
        UserId = userId;
        ChatId = chatId;
    }

    public string UserId { get; set; }
    
    public string ChatId { get; set; }
    
}