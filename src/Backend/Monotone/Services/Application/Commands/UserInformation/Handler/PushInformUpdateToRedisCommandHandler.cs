using MediatR;
using Monotone.Models.Cache;
using Monotone.Models.Enums;
using OneOf;
using StackExchange.Redis;

namespace Monotone.Services.Application.Commands.UserInformation.Handler;

public class PushInformUpdateToRedisCommandHandler : IRequestHandler< PushInformUpdateToRedisCommand, OneOf<bool, Exception>>
{
    private readonly IDatabase _database;

    public PushInformUpdateToRedisCommandHandler(IDatabase database)
    {
        _database = database;
    }

    public async Task<OneOf<bool, Exception>> Handle(PushInformUpdateToRedisCommand request, CancellationToken cancellationToken)
    {

        try
        {
            var cacheKey = new CacheKey()
            {
                EventType = CacheEventType.ONLINE,
                TargetId = request.UserId
            };
            await _database.StringSetAsync(await cacheKey.GenerateKey(), true, TimeSpan.FromSeconds(30), When.Always) ;
            return true;
        }
        catch (Exception e)
        {
            return e;
        }
        
   
    }
}