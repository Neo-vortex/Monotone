using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Monotone.Models.@base;

namespace Monotone.Models;

public class ApplicationDbContext : IdentityDbContext<ApplicationUser, Role, string>
{
    
    public DbSet<Chat> Chats { get; set; }
    public DbSet<Message> Messages { get; set; }
    protected ApplicationDbContext()
    {
    }

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
    {
    }



    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
    }
}