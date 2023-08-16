using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Identity;

namespace Monotone.Models;

public class ApplicationUser : IdentityUser<string>
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public override string Id { get; set; } = null!;

    public override string? UserName { get; set; }
    [JsonIgnore]
    public override string? NormalizedUserName { get; set; }
    [JsonIgnore]
    public override string? Email { get; set; }
    [JsonIgnore]
    public override string? NormalizedEmail { get; set; }
    [JsonIgnore]
    public override bool EmailConfirmed { get; set; }
    [JsonIgnore]
    public override string? PasswordHash { get; set; }
    [JsonIgnore]
    public override string? SecurityStamp { get; set; }
    [JsonIgnore]
    public override string? ConcurrencyStamp { get; set; }
    [JsonIgnore]
    public override string? PhoneNumber { get; set; }
    [JsonIgnore]
    public override bool PhoneNumberConfirmed { get; set; }
    [JsonIgnore]
    public override bool TwoFactorEnabled { get; set; }
    [JsonIgnore]
    public override DateTimeOffset? LockoutEnd { get; set; }
    [JsonIgnore]
    public override bool LockoutEnabled { get; set; }
    [JsonIgnore]
    public override int AccessFailedCount { get; set; }
    [JsonIgnore]

    public byte[] ProfilePicture { get; set; } = Array.Empty<byte>();
    [JsonIgnore]

    public List<ApplicationUser> Contacts { get; set; } = new List<ApplicationUser>();
    [JsonIgnore]
    public DateTime CreatedAt { get; set; } 
    
}