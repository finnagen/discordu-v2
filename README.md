# discordu-v2
An advanced Discord API wrapper written entirely in luau.
# Overview
Discordu is an advanced multi-module library that allows you to create complex discord bots with Roblox's Luau language. The library is powered by [Lune](https://github.com/lune-org/lune), a stand-alone Luau runtime.
It's still heavily WIP and destined to change, so beware of frequent changes (as of 23/12/2025). It's designed to above all have easily readable syntax; though, I still *have* to make good memory management and functionality. >:(

Heavily inspired by [Nocturn](https://github.com/thekingofspace/Nocturn), a back-end base for Luau-Discord botting.
# Example Bot
```lua
--// test-bot.luau
local discordu = require('./Libraries/Discordu/')
local intents_module = discordU.intents

local bot_intents = intents_module.default()
bot_intents.message_content = true

local bot = discordu.Bot('TOKEN', bot_intents)
bot_intents = nil -- memory saving :3

bot:on_ready(function (ready_packet))
    print(`Logged in as {bot.user.username}!`)
end

bot:Run()
```

# How to run
## WINDOWS:
There are two options on Windows to run a `.luau` file with Lune:
### OPTION 1 | BATCH
> - Create a `.bat` file in your directory (`lune.exe` and your `.luau` file should be in the same folder).
> - Insert the code: `lune run (.luau filename)`. You do not need to add `.luau` to the end.
> - Run the `.bat` file.
### OPTION 2 | TERMINAL
> - Insert the code: `.\lune run (.luau filename)` into your terminal. You do not need to add `.luau` to the end.
> - Run the code.
## MACOS/LINUX GUIDE UNAVAIABLE FOR NOW.
> I don't know how :(

# Features
Most, if not all, features that are inside of Discordu. Will likely move this to a documentation site once I find the energy to do so.
## Bot
The **Bot** class is provided directly by the Discordu module. It represents the heart of your bot, handling things such as:
> - API Requests
> - Heartbeats
> - Gateway Events
> - ...and most other backend necessities.

The class itself is divided into 3 modules. The **Bot.luau** file simply stores the type constructed by **client.luau**, which handles all of the bot's internal processes.
**Discordu.luau**, the libraries main module, wraps the methods of **client.luau** into easily-usable and readable functions. 
### Properties
> This will only list **public** properties of the class.
> 
> \* = will only be assigned after :Run() has been called on the Bot.
#### Bot.application_ID: string?*
The bot's application's snowflake ID. *Note that this is separate from the application property due to how many methods require the application ID instead of the entire object.*
#### Bot.application: types.application?*
The bot's application object.
#### Bot.user: types.user?
The bot's user object. *This will only be assigned after the bot has recieved the ready event from Discord's API.*
#### Bot.latency: number?
The bot's heartbeat ACK latency. *This will only be assigned after the bot has recieved a Heartbeat ACK event from Discord's API.*
#### Bot.interaction_latency: number?
The bot's interaction latency. *This will only be assigned after the bot has recieved an INTERACTION_CREATE event from Discord's API.*
### Client Methods
> This will only display select **client.luau** methods.
#### Bot:Run() -> ()
Begins all bot connections, including:
> - Gateway Handling
> - Heartbeats
> - Identifying/Resuming
> - Command/Event listening
> - Assigning some variables.
#### Bot:End() -> ()
Cancels all bot tasks, connections, and gateways, effectively "turning off" the bot.
#### Bot:NetRequest(method: string, url_path: string, body: any?, headers: {[string]: string}) -> any?
Creates a direct request from the bot to the Discord API. This will throw an error if Discord responds with one.
#### Bot:On(event: string, callback: (...any) -> ()) -> ()
Adds a listener (callback) for a specified Gateway Event on the client.
### Discordu methods
> This will display all **Discordu.luau** methods for the bot.
#### Bot:on_ready(callback: (...any) -> ()) -> ()
Wraps a call to Bot:On("READY", callback).
#### Bot:send_message(message: types.message_args, channel_id: string, reply: types.message?, guild_id: string?) -> types.message?
Wraps a call to **messages.luau**.create_message(Bot, channel_id, message, reply, guild_id).
#### Bot:slash_command(arguments: types.slash_command_args, listener: (interaction: **interaction.luau**.Command_Interaction) -> (), guild_ids: {string}?) -> {types.slash_command}?
Creates/gets a slash command from the bot. If guild_ids is nil, the command will be global.
If the command is global, it will return a table with a single command object. Guild commands will return every command object created.
#### Bot:create_dm(user: types.user | string) -> types.channel?
Creates a dm with the specified user/user id. Returns the DMChannel created.
#### Bot:delete_slash_command(name: string, guilds: {string}?) -> (),
Sends a delete request for the specified command names and/or guild ids, may take a while for Discord to process these requests, especially for global commands.
The command **must** be cached by the bot to be deleted. This means if you with to delete a command, you must send a Bot:slash_command() of the command and/or guilds before calling this method.
