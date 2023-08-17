using MediatR;
using Microsoft.EntityFrameworkCore;
using Monotone.Models;
using OneOf;

namespace Monotone.Services.Application.Queries.Authentication.Handler;

public class GetUserByUsernameQueryHandler : IRequestHandler<GetUserByUsernameQuery, OneOf<ApplicationUser, Exception>>
{
    private readonly ApplicationDbContext _applicationDbContext;

    public GetUserByUsernameQueryHandler(ApplicationDbContext applicationDbContext)
    {
        _applicationDbContext = applicationDbContext;
    }

    public async Task<OneOf<ApplicationUser, Exception>> Handle(GetUserByUsernameQuery request, CancellationToken cancellationToken)
    {
        try
        {
            var user = await _applicationDbContext.Users
                .Where(user => user.UserName == request.Username)
                .Select(user => new ApplicationUser() {Id = user.Id, UserName = user.UserName , ProfilePicture = user.ProfilePicture})
                .SingleOrDefaultAsync(cancellationToken: cancellationToken);
            if (user == null)
            {
                return new Exception("user not found");
            }
            return user;
        }
        catch (Exception e)
        {
            return e;
        }
    }
}