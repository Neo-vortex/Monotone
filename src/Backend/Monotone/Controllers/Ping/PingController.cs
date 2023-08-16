using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Monotone.Controllers.Ping
{
    [Route("api/v1/[controller]/[action]")]
    [ApiController]
    public class PingController : ControllerBase
    {
        [HttpGet]
        [AllowAnonymous]
        public IActionResult Ping()
        {
            return Ok("Pong");
        }
    }
}
