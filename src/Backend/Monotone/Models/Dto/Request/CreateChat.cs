using System.ComponentModel.DataAnnotations;

namespace Monotone.Models.Dto.Request;

public class CreateChat
{
    
    public string? GroupName { get; set; } 
    
    [Required]
    public List<string> OtherParticipents { get; set; }


    public bool Validate()
    {
        return OtherParticipents.Count <= 1 || GroupName != null;
    }
}