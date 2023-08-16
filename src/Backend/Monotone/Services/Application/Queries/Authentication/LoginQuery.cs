
using MediatR;
using Monotone.Models.Dto.Request;
using OneOf;

namespace Monotone.Services.Application.Queries.Authentication;

public class LoginQuery : IRequest<OneOf<string, Exception>>
{
    public LoginQuery(Login login)
    {
        Login = login;
    }

    public Login Login { get; set; } = null!;
}