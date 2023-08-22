using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Monotone.Models;
using Monotone.Services.SignalR;
using StackExchange.Redis;
using VortexUtils;
using Role = Monotone.Models.Role;

var builder = WebApplication.CreateBuilder(args);


builder.AddVortexSerilog(overrideMicrosoftDebugLogLevel: true);


builder.Services.SwitchLegacyTimestampBehaviorPostgres();

builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false,
            ValidateAudience = false,
            ValidateLifetime = false,
            ValidateIssuerSigningKey = true,
            ValidAudience = "false",
            ValidIssuer = "false",
            IssuerSigningKey =
                new SymmetricSecurityKey("supersecretkeysupersecretkeysupersecretkeysupersecretkey"u8.ToArray())
        };
        options.Events = new JwtBearerEvents
        {
            OnMessageReceived = context =>
            {
                if (context.Request.Query.TryGetValue("access_token", out var token)) context.Token = token[0];

                return Task.CompletedTask;
            },
            OnAuthenticationFailed = context =>
            {
                var catchException = context.Exception;
                return Task.CompletedTask;
            }
        };
    });

builder.Services.AddIdentityCore<ApplicationUser>()
    .AddDefaultTokenProviders()
    .AddRoles<IdentityRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>();

builder.Services.AddSignalR()
    .AddJsonProtocol(options => { options.PayloadSerializerOptions.PropertyNamingPolicy = null; });
builder.Services.AddVortexController();
builder.Services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(typeof(Program).Assembly));
builder.Services.AddStackExchangeRedisCache(options =>
{
    if (builder.Environment.IsDevelopment())
        options.Configuration = "localhost:6379";
    else
        options.Configuration = Environment.GetEnvironmentVariable("redisPath") ??
                                throw new Exception("No redis database path is provided");
    options.InstanceName = "Monotone";
});
builder.Services.AddScoped<IDatabase>(serviceProvider =>
{
    ConnectionMultiplexer connectionMultiplexer;
    if (builder.Environment.IsDevelopment())
    {
        
         connectionMultiplexer = ConnectionMultiplexer.Connect("localhost:6379");
 
    }
    else
    {
         connectionMultiplexer = ConnectionMultiplexer.Connect(Environment.GetEnvironmentVariable("redisPath") ??
                                                                  throw new Exception(
                                                                      "No redis database path is provided"));

    }
       
   return connectionMultiplexer.GetDatabase();
});

builder.Services.AddDbContext<ApplicationDbContext>(options =>
{
    if (builder.Environment.IsDevelopment())
    {
        options.UseSqlite("Data Source=Application.db;");
    }
    else
    {
        var databaseConnectionString = Environment.GetEnvironmentVariable("dbPath") ??
                                       throw new Exception("No database path is provided");
        var databaseUser = Environment.GetEnvironmentVariable("dbUser") ??
                           throw new Exception("No database user is provided");
        var databasePassword = Environment.GetEnvironmentVariable("dbPassword") ??
                               throw new Exception("No database password is provided");
        var databasePort = Environment.GetEnvironmentVariable("dbport") ??
                           throw new Exception("No database port is provided");
        options.UseNpgsql(
            $"Host={databaseConnectionString};Port={databasePort};Database=fundedmax;Username={databaseUser};Password={databasePassword}");
    }
});
builder.Services.AddVortexResponseCompressor();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaagerWithJwt("Monotone", "Monotone.xml");


var app = builder.Build();
app.UseAuthentication();
app.UseAuthorization();
app.UseVortexCores();


app.UseSwagger();
app.UseSwaggerUI();



app.MapControllers();
app.UseVortexResponseCompressor();



SetupDatabase();

void SetupDatabase()
{
    using var scope = app.Services.CreateScope();
    var dbContext = scope.ServiceProvider
        .GetRequiredService<ApplicationDbContext>();
    dbContext.Database.EnsureCreated();
}


app.MapHub<RealTimeServices>("/notification");
app.Run();