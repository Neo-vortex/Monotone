using MediatR;
using Monotone.Models;
using OneOf;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using System.Data;

namespace Monotone.Services.Application.Commands.Authentication.Handler;

public class SignupCommandHandler : IRequestHandler<SignupCommand, OneOf<bool , Exception>>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ApplicationDbContext _applicationDbContext;

    public SignupCommandHandler(UserManager<ApplicationUser> userManager, ApplicationDbContext applicationDbContext)
    {
        _userManager = userManager;
        _applicationDbContext = applicationDbContext;
    }

    public async Task<OneOf<bool, Exception>> Handle(SignupCommand request, CancellationToken cancellationToken)
    {
        await using var transaction =
            await _applicationDbContext.Database.BeginTransactionAsync(IsolationLevel.Serializable, cancellationToken: cancellationToken);
        try
        {
            var user =
                await _userManager.FindByNameAsync(request.Signup.Username);

            if (user != null)
            {
                return new Exception("user already exists");
            }

            user = new ApplicationUser()
            {
                UserName = request.Signup.Username,
                CreatedAt = DateTime.UtcNow
            };
            var result =
                await _userManager.CreateAsync(user, request.Signup.Password);
            if (!result.Succeeded)
                return new Exception("User creation failed! Please check user details and try again." +
                                     Environment.NewLine + string.Join(Environment.NewLine,
                                         result.Errors.Select(err => err.Description)));
            
            await _applicationDbContext.SaveChangesAsync(cancellationToken);
            await transaction.CommitAsync(cancellationToken);
            return result.Succeeded;
        }
        catch (Exception e)
        {
            await transaction.RollbackAsync(cancellationToken);
            return e;
        }
    }
}