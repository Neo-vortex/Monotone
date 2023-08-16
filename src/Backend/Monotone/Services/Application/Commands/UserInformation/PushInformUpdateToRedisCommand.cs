using MediatR;
using OneOf;

namespace Monotone.Services.Application.Commands.UserInformation;

public class PushInformUpdateToRedisCommand : IRequest<OneOf<bool, Exception>>
{
    public PushInformUpdateToRedisCommand(string userId)
    {
        UserId = userId;
    }

    public string UserId { get; set; }
}