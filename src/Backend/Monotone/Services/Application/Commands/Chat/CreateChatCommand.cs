using MediatR;
using Monotone.Models.Dto.Request;
using OneOf;

namespace Monotone.Services.Application.Commands.Chat;

public class CreateChatCommand : IRequest<OneOf<string, Exception>>
{
    public CreateChatCommand(CreateChat createChat, string creatorId)
    {
        CreateChat = createChat;
        CreatorId = creatorId;
    }

    public CreateChat CreateChat { get; set; }
    
    public string CreatorId { get; set; }
}