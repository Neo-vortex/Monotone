using MediatR;
using Microsoft.EntityFrameworkCore;
using Monotone.Models;
using OneOf;

namespace Monotone.Services.Application.Queries.Authentication.Handler;

public class SearchUserByUsernameQueryHandler : IRequestHandler<SearchUserByUsernameQuery, OneOf<List<ApplicationUser>, Exception>>
{
    private readonly ApplicationDbContext _applicationDbContext;

    public SearchUserByUsernameQueryHandler(ApplicationDbContext applicationDbContext)
    {
        _applicationDbContext = applicationDbContext;
    }

    public async Task<OneOf<List<ApplicationUser>, Exception>> Handle(SearchUserByUsernameQuery request, CancellationToken cancellationToken)
    {
        try
        {
            var users = _applicationDbContext.Users
                .Where(user => user.UserName.Contains(request.SearchKey))
                .Take(20)
                .Select(user => new ApplicationUser() {Id = user.Id, UserName = user.UserName , ProfilePicture = user.ProfilePicture});
            if (!await users.AnyAsync(cancellationToken: cancellationToken))
            {
                return new List<ApplicationUser>();
            }

            return users.ToList();
        }
        catch (Exception e)
        {
            return e;
        }
    }
}