using MediatR;
using Monotone.Models;
using OneOf;

namespace Monotone.Services.Application.Queries;

public class SearchUserByUsernameQuery : IRequest<OneOf<List<ApplicationUser>, Exception>>
{
    public SearchUserByUsernameQuery(string searchKey)
    {
        SearchKey = searchKey;
    }

    public string SearchKey { get; set; }
}