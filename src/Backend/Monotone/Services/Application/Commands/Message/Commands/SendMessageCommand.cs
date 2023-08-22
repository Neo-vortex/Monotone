using MediatR;
using Monotone.Models.Dto.Request;
using OneOf;

namespace Monotone.Services.Application.Commands.Message.Commands;

public class SendMessageCommand : IRequest<OneOf<Models.@base.Message, Exception>>
{
    public SendMessageCommand(SendMessage message, string senderId)
    {
        Message = message;
        SenderId = senderId;
    }

    public string SenderId { get; set; }
    public SendMessage Message { get; set; }
}