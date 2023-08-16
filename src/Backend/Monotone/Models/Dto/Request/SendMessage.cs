using System.Text.Json.Serialization;
using Monotone.Models.Enums;
using Monotone.Utilities;

namespace Monotone.Models.Dto.Request;

public class SendMessage
{
    [JsonConverter(typeof(ByteArrayConverter))]
    public byte[] Content { get; set; } = Array.Empty<byte>();
    public string TargetChatId { get; set; } = null!;
    public MessageType MessageType { get; set; }
    public string ResourceAddress { get; set; } = string.Empty;
    public bool IsReplay { get; set; }
    public string Metadata { get; set; } = string.Empty;

}