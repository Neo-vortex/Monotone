using MediatR;
using OneOf;

namespace Monotone.Services.Application.Queries;

public class GetOnlineStatusForUserQuery  : IRequest<OneOf<bool, Exception>>
{
        public GetOnlineStatusForUserQuery(string userId)
        {
                UserId = userId;
        }

        public   string UserId { get; set; } = null!;
}