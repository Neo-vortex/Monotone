using MediatR;
using Monotone.Models;
using OneOf;

namespace Monotone.Services.Application.Queries;

public class GetUserByUsernameQuery : IRequest<OneOf<ApplicationUser, Exception>>
{
    public GetUserByUsernameQuery(string username)
    {
        Username = username;
    }

    public string Username { get; set; }
}