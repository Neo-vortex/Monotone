using MediatR;
using Monotone.Models.Cache;
using Monotone.Models.Enums;
using OneOf;
using StackExchange.Redis;

namespace Monotone.Services.Application.Queries.Authentication.Handler;

public class GetOnlineStatusForUserQueryHandler : IRequestHandler<GetOnlineStatusForUserQuery, OneOf<bool, Exception>>
{
    private readonly IDatabase _redisDatabase;

    public GetOnlineStatusForUserQueryHandler(IDatabase redisDatabase)
    {
        _redisDatabase = redisDatabase;
    }

    public async Task<OneOf<bool, Exception>> Handle(GetOnlineStatusForUserQuery request, CancellationToken cancellationToken)
    {
        try
        {
            var cacheKey = new CacheKey()
            {
                EventType = CacheEventType.ONLINE,
                TargetId = request.UserId
            };
            var result =  await _redisDatabase.StringGetAsync(await cacheKey.GenerateKey()) ;

            return result.HasValue &&(bool) result.Box()!;
        }
        catch (Exception e)
        {
            return e;
        }
    }
}