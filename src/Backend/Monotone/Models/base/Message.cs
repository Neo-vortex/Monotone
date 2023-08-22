using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Monotone.Models.Enums;

namespace Monotone.Models.@base;

public record Message
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string Id { get; set; } = null!;
    public byte[] Content { get; set; } = Array.Empty<byte>();
    public ApplicationUser Sender { get; set; } = null!;
    public Chat TargetChat { get; set; } = null!;
    [DataType(DataType.Date)]
    public DateTime CreatedAt { get; set; }
    public MessageType MessageType { get; set; }
    public string ResourceAddress { get; set; } = string.Empty;
    
    public MessageResourceType MessageResourceType { get; set; } 
    public bool IsReplay { get; set; }
    public string Metadata { get; set; } = string.Empty;
    public List<ApplicationUser> SeenBy { get; set; } = new();
}