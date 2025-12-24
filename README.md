# discordu-v2
An advanced Discord API wrapper written entirely in luau.
# Overview
Discordu is an advanced multi-module library that allows you to create complex discord bots with Roblox's Luau language. The library is powered by [Lune](https://github.com/lune-org/lune), a stand-alone Luau runtime.
It's still heavily WIP and destined to change, so beware of frequent changes (as of 23/12/2025). It's designed to above all have easily readable syntax; though, I still *have* to make good memory management and functionality. >:(
# Features
Most, if not all, features that are inside of Discordu.
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
### Methods
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
