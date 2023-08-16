using MessagePack;
using Monotone.Models.Enums;

namespace Monotone.Models.Cache;

[MessagePackObject]
public class CacheKey
{
    [MessagePack.Key(0)]
    public string TargetId { get; set; } = null!;
    [MessagePack.Key(1)]
    public CacheEventType EventType { get; set; }

    public async Task<string> GenerateKey()
    {
        var result = new MemoryStream();
        await MessagePack.MessagePackSerializer.SerializeAsync(result, this);
        return Convert.ToBase64String(result.ToArray());
    }
}