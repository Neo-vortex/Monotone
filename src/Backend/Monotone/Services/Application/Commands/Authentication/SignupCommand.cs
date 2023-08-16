
using MediatR;
using Monotone.Models.Dto.Request;
using OneOf;

namespace Monotone.Services.Application.Commands.Authentication;

public class SignupCommand : IRequest<OneOf<bool, Exception>>
{
    public Signup Signup { get; set; }
    public SignupCommand(Signup signup)
    {
        Signup = signup;
    }
    
}