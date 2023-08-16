using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Monotone.Models;
using OneOf;

namespace Monotone.Services.Application.Queries.Authentication.Handler;

public class LoginQueryHandler : IRequestHandler<LoginQuery, OneOf<string, Exception>>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ApplicationDbContext _applicationDbContext;

    public LoginQueryHandler(UserManager<ApplicationUser> userManager, ApplicationDbContext applicationDbContext)
    {
        _userManager = userManager;
        _applicationDbContext = applicationDbContext;
    }

    public async Task<OneOf<string, Exception>> Handle(LoginQuery request, CancellationToken cancellationToken)
    {
        try
        {
            var user = await _applicationDbContext.Users.FirstOrDefaultAsync(user => user.UserName == request.Login.Username, cancellationToken: cancellationToken);
            if (user == null)
            {
                return new Exception("no such a user");
            }

            var result = await _userManager.CheckPasswordAsync(user, request.Login.Password);
            if (!result)
            {
                return new Exception("invalid password");
            }
            var tokenHandler = new JwtSecurityTokenHandler();
            var authSigningKey = "supersecretkeysupersecretkeysupersecretkeysupersecretkey"u8.ToArray();
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new(ClaimTypes.Name, user.UserName!),
                    new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                    new(ClaimTypes.NameIdentifier, user.Id)
                }),
                Expires = DateTime.UtcNow.AddYears(100),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(authSigningKey),
                    SecurityAlgorithms.HmacSha512Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            var jwt = tokenHandler.WriteToken(token);
            return jwt;
        }
        catch (Exception e)
        {
            return e;
        }
    }
}