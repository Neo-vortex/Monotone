using System.Collections.Concurrent;
using System.Security.Claims;
using System.Text.Json;
using MediatR;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Monotone.Models.Cache;
using Monotone.Models.Dto.Request;
using Monotone.Models.Enums;
using Monotone.Models.Interface;
using Monotone.Services.Application.Commands.UserInformation;
using Monotone.Services.Application.Queries.Chat;
using StackExchange.Redis;

namespace Monotone.Services.SignalR;

[Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
public class Notification : Hub
{
    private static readonly ConcurrentDictionary<string, string> Connections = new();
    private readonly IMediator _mediator;

    public Notification(IMediator mediator)
    {
        _mediator = mediator;
    }

    public async Task StartListeningToSpecificChatEvents(string chatId)
    {
        var userId = Context.User!.Claims.SingleOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (userId == null) return;


        var chatResult = await _mediator.Send(new GetChatByIdQuery(chatId));
        if (chatResult.IsT0)
        {
            if (chatResult.AsT0.Participants.All(participant => participant.Id != userId)) return;

            await Groups.AddToGroupAsync(Context.ConnectionId, chatId);
        }
    }

    public async Task StopListeningToSpecificChatEvents(string chatId)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, chatId);
    }

    public async Task InformOnline()
    {
        var userId = Context.User!.Claims.SingleOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (userId == null) return;

        await _mediator.Send(new PushInformUpdateToRedisCommand(userId));
        await Clients.Others.SendAsync(NotificationMethods.ONLINE, userId);
    }
    
    public async Task<string> SendMessage( string message)
    {
       var parseResult =  Utilities.Utilities.TryValidateAndDeserilize<SendMessage>(message, out var sendMessage);
       if (!parseResult) return "invalid message";

       return "sdfsdf";
    }

    public override Task OnConnectedAsync()
    {
        var userId = Context.User!.Claims.SingleOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (userId == null) return base.OnConnectedAsync();

        Connections.TryAdd(Context.ConnectionId, userId);
        return base.OnConnectedAsync();
    }

    public override Task OnDisconnectedAsync(Exception? exception)
    {
        var userId = Context.User!.Claims.SingleOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
        if (userId == null) return base.OnDisconnectedAsync(exception);

        Connections.TryRemove(Context.ConnectionId, out _);
        return base.OnDisconnectedAsync(exception);
    }
}