using System.ComponentModel.DataAnnotations;

namespace Monotone.Models.Dto.Request;

public class Signup
{
    [Required]
    public string Username { get; set; } = null!;
    [Required]
    public string Password { get; set; } = null!;
}