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
using Monotone.Services.Application.Commands.Message.Commands;
using Monotone.Services.Application.Commands.UserInformation;
using Monotone.Services.Application.Queries.Chat;
using StackExchange.Redis;

namespace Monotone.Services.SignalR;

[Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
public class RealTimeServices : Hub
{
    private static readonly ConcurrentDictionary<string, string> Connections = new();
    private readonly IMediator _mediator;

    public RealTimeServices(IMediator mediator)
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
       var userId = Context.User!.Claims.SingleOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
       if (userId == null) return "invalid token";

       var parseResult =  Utilities.Utilities.TryValidateAndDeserilize<SendMessage>(message, out var sendMessage);
       if (!parseResult) return "invalid message";

       var result = await _mediator.Send(new SendMessageCommand(sendMessage,userId ));

       if (result.IsT1)
       {
           return result.AsT1.Message;
       }
       await Clients.OthersInGroup(sendMessage.TargetChatId).SendAsync(NotificationMethods.SEND_MESSAGE_GROUP_EVENT, JsonSerializer.Serialize(result.AsT0));
       var chat = await _mediator.Send(new GetChatByIdQuery(sendMessage.TargetChatId));
       
       if (chat.IsT1)
       {
           return chat.AsT1.Message;
       }
       foreach (var connection in Connections.Where(connection => chat.AsT0.Participants.Any( user => user.Id == connection.Value)))
       {
           await Clients.Client(connection.Key).SendAsync(NotificationMethods.SEND_MESSAGE_EVENT, JsonSerializer.Serialize(result.AsT0));
       }
       
       return result.IsT1 ? result.AsT1.Message : "OK";
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