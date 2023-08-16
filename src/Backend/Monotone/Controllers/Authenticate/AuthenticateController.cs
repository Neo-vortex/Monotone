

using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Monotone.Models.Dto.Request;
using Monotone.Services.Application.Commands.Authentication;
using Monotone.Services.Application.Queries.Authentication;

namespace Monotone.Controllers.Authenticate
{
    [Route("api/v1/[controller]/[action]")]
    [ApiController]
    public class AuthenticateController : ControllerBase
    {
        private readonly IMediator _mediator;

        public AuthenticateController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> Login([FromBody] Login login)
        {
            try
            {
                var result = await _mediator.Send(new LoginQuery(login));
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

        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> Signup([FromBody] Signup signup)
        {
            try
            {
                var result = await _mediator.Send(new SignupCommand(signup));
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
