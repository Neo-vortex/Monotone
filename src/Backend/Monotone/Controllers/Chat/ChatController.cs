using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Monotone.Models.Dto.Request;
using Monotone.Services.Application.Commands.Chat;
using Monotone.Services.Application.Queries.Chat;

namespace Monotone.Controllers.Chat
{
    [Authorize]
    [Route("api/v1/[controller]/[action]")]
    [ApiController]
    public class ChatController : ControllerBase
    {
        private readonly IMediator _mediator;

        public ChatController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost]
        public async Task<IActionResult> CreateChat( [FromBody] CreateChat createChat )
        {
            try
            {
                if (!createChat.Validate())
                {
                    return BadRequest("chats with more than 2 people are considered group and must have a non null name");
                }
                var userId = User!.Claims.SingleOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
                if (userId == null)
                {
                    return BadRequest("invalid jtw token");
                }
                var result = await _mediator.Send(new CreateChatCommand(createChat, userId));
                if (result.IsT0)
                {
                    return Ok(result.AsT0);
                }

                return BadRequest(result.AsT1.Message);
            }
            catch (Exception e)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, e.Message);
            }
           
        }
        
        
        [HttpGet]
        public async Task<IActionResult> GetMyChats( )
        {
            try
            {
                var userId = User!.Claims.SingleOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
                if (userId == null)
                {
                    return BadRequest("invalid jtw token");
                }
                var result = await _mediator.Send(new GetMyChatsQuery(userId));
                if (result.IsT0)
                {
                    return Ok(result.AsT0);
                }

                return BadRequest(result.AsT1.Message);
            }
            catch (Exception e)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, e.Message);
            }
           
        }
        
        
        [HttpGet]
        public async Task<IActionResult> GetNumberOfUnreadMessagesForMe([FromQuery]  string chatId  )
        {
            try
            {
                var userId = User!.Claims.SingleOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
                if (userId == null)
                {
                    return BadRequest("invalid jtw token");
                }
                var result = await _mediator.Send(new GetNumberOfUnreadMessagesForMeQuery(userId,chatId));
                if (result.IsT0)
                {
                    return Ok(result.AsT0);
                }

                return BadRequest(result.AsT1.Message);
            }
            catch (Exception e)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, e.Message);
            }
           
        }

        
        [HttpGet]
        public async Task<IActionResult> GetLastMessageInChat([FromQuery]  string chatId  )
        {
            try
            {
                var userId = User!.Claims.SingleOrDefault(claim => claim.Type == ClaimTypes.NameIdentifier)?.Value;
                if (userId == null)
                {
                    return BadRequest("invalid jtw token");
                }
                var result = await _mediator.Send(new GetLastMessageInChatQuery(userId , chatId));
                if (result.IsT0)
                {
                    return Ok(result.AsT0);
                }

                return BadRequest(result.AsT1.Message);
            }
            catch (Exception e)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, e.Message);
            }
           
        }

        
    }
}
