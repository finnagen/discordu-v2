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
#### user: types.user?
The bot's user object. *This will only be assigned after the bot has recieved the ready event from Discord's API.*
### Methods
> This will only list **public** methods of the class.
