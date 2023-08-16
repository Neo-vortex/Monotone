using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Monotone.Models.@base;

public class Chat
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string Id { get; set; } = null!;

    public List<ApplicationUser> Participants { get; set; } = new();
    
    public ApplicationUser Creator { get; set; } = null!;
    
    public DateTime CreatedAt { get; set; }
    
    public bool IsGroup { get; set; }
    
    public string GroupName { get; set; } = string.Empty;
}