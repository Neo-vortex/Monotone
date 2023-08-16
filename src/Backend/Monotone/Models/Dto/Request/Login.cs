using System.ComponentModel.DataAnnotations;

namespace Monotone.Models.Dto.Request;

public class Login
{
    [Required]
    public string Username { get; set; } = null!;
    [Required]
    public string Password { get; set; } = null!;
}