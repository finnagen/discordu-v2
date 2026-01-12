--!nocheck

--// DEPENDENCIES
local client = require('./DiscorduDependencies/Classes/client')
local interaction = require('./DiscorduDependencies/Classes/interaction')

local messages = require('./DiscorduDependencies/Libraries/messages')
local discordu_intents = require('./DiscorduDependencies/Libraries/intents')
local embeds = require('./DiscorduDependencies/Libraries/embeds')

local types = require('./DiscorduDependencies/types')

--// TYPES
type discordU_client_methods = {
    --/// LISTENERS
    on_ready: (self: Bot, callback: (...any) -> ()) -> (),
    listen_for_button: (self: Bot, button_custom_id: string, listener: (interaction: interaction.interaction) -> ()) -> (),

    --/// POST FUNCTIONS
    send_message: (self: Bot, message: types.message_args, channel_id: string, reply: types.message?, guild_id: string?) -> types.message?,
    get_reactions: (self: Bot, message: types.message, reaction_emoji: types.emoji) -> {types.user},
    add_reaction: (self: Bot, message: types.message, reaction_emoji: types.emoji) -> (),

    slash_command: (self: Bot, arguments: types.slash_command_args, listener: (interaction: interaction.interaction) -> (), guilds: {string}?) -> {types.slash_command}?,
    create_dm: (self: Bot, user: types.user | string) -> types.channel?,

    --/// DELETE FUNCTIONS
    delete_slash_command: (self: Bot, name: string, guilds: {string}?) -> (),
}

export type Bot = client.Bot & discordU_client_methods

--// MODULES
local discordU = {
    intents = discordu_intents,
    messages = messages,
    embeds = embeds,

    types = types,
}

--// PRIVATE FUNCTIONS \\--
local char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
end

local function url_encode(url)
    if url == nil then
        return
    end

    return url:gsub("([^%w%-_%.~])", char_to_hex)
end -- this code is from https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99

--// MAIN FUNCTIONS
function client.client_methods.on_ready(self: Bot, callback: (...any) -> ()): ()
    self:On("READY", callback)
end

function client.client_methods.get_reactions(self: Bot, message: types.message, reaction_emoji: types.emoji): {user}
    local emoji_id = reaction_emoji.id and `{reaction_emoji.name}:{reaction_emoji.id}` or reaction_emoji.name
    emoji_id = url_encode(emoji_id)

    local endpoint = `channels/{message.channel_id}/messages/{message.id}/reactions/{emoji_id}`
    return self.NetRequest(self, "get", endpoint)
end

function client.client_methods.add_reaction(self: Bot, message: types.message, reaction_emoji: types.emoji)
    local emoji_id = reaction_emoji.id and `{reaction_emoji.name}:{reaction_emoji.id}` or reaction_emoji.name
    emoji_id = url_encode(emoji_id)

    local endpoint = `channels/{message.channel_id}/messages/{message.id}/reactions/{emoji_id}/@me`

    self:NetRequest("put", endpoint)
end

function client.client_methods.create_dm(self: Bot, user: types.user | string): types.channel?
    if type(user) == 'table' then
        user = user.id
    end

    local request_packet = {
        recipient_id = user
    }

    return self:NetRequest("post", `/users/@me/channels`,  request_packet)
end

function client.client_methods.send_message(self: Bot, message: types.message_args, channel_id: string, reply: types.message?, guild_id: string?): types.message?
    return messages.create_message(self, channel_id, message, reply, guild_id)
end

function client.client_methods.listen_for_button(self: Bot, button_custom_id: string, listener: (interaction: interaction.interaction, ...any) -> ()): ()
    self:OnComponent(button_custom_id, listener)
end

function client.client_methods.slash_command(self: Bot, arguments: types.slash_command_args, listener: (interaction: interaction.interaction) -> (), guilds: {string}?): {types.slash_command}?
    local is_guild = type(guilds) == "table" and next(guilds) ~= nil

    local endpoints = {}

    arguments.type = 1
    arguments.name = string.lower(arguments.name)

    if is_guild == false then
        table.insert(endpoints, `applications/{self.application_ID}/commands`)
    else
        for _, guild in guilds do
            table.insert(endpoints, `applications/{self.application_ID}/guilds/{guild}/commands`)
        end
    end

    local commandToReturn = is_guild and {} or nil

    for _, endpoint in endpoints do
        local success, result = pcall(function()
            return self:NetRequest('post', endpoint, arguments)
        end)

        if success ~= true or result == nil then
            warn(`Slash Command registration error:\n`..(result or "Unknown Error Occured!"))
        elseif is_guild == true then
            local cmd = result :: types.slash_command
            local guild_Id = cmd.guild_id
            local cmd_Id = cmd.id
            local name = cmd.name

            if self._commands.GUILD[guild_Id] == nil then
                self._commands.GUILD[guild_Id] = {}
            end

            if self._commands.GUILD[guild_Id][name] ~= nil then
                warn("Can't double-register a command!")
                continue
            end

            self._commands.GUILD[guild_Id][name] = cmd_Id
            table.insert(commandToReturn, cmd)
        else
            local cmd = result :: types.slash_command
            local name = cmd.name

            if self._commands.GLOBAL[name] == nil then
                self._commands.GLOBAL[name] = cmd.id
                commandToReturn = cmd
            else
                warn("Can't double-register a command!")
            end
        end
    end

    if commandToReturn == nil then
        return nil
    else
        self:On(arguments.name, listener)
    end
    
    return is_guild and commandToReturn or {commandToReturn}
end

function client.client_methods.delete_slash_command(self: Bot, name: string, guilds: {string}?)
    local is_guild = type(guilds) == "table" and next(guilds) ~= nil
    name = string.lower(name)

    if is_guild then
        for _, guild_id in guilds do
            local commands = self._commands.GUILD[guild_id]
            if commands == nil then
                warn(`Can't delete command {name} from guild {guild_id} as no commands are registered under it.`)
                continue
            end

            local found_command = commands[name]
            if found_command == nil then
                warn(`Can't delete command {name} from guild {guild_id} as no command of the name exists!`)
                continue
            end

            local success, result = pcall(function() 
                return self:NetRequest("delete", `applications/{self.application_ID}/guilds/{guild_id}/commands/{found_command}`)
            end)

            if success ~= true or result == nil then
                warn(`Slash Command deletion error in guild {guild_id}:\n`..(result or "Unknown Error Occured!"))
            else
                print(result)
                self:DisconnectListener(name)
                self._commands.GUILD[guild_id][name] = nil

                if next(self._commands.GUILD[guild_id]) == nil then
                    self._commands.GUILD[guild_id] = nil
                end
            end
        end
    else
        local found_command = self._commands.GLOBAL[name]
        if found_command == nil then
            warn(`Can't delete command {name} as it isn't cached by the bot.`)
            return
        end

        local success, result = pcall(function() 
            return self:NetRequest("delete", `applications/{self.application_ID}/commands/{found_command}`)
        end)

        if success ~= true or result == nil then
            warn(`Slash Command deletion error:\n`..(result or "Unknown Error Occured!"))
        else
            self:DisconnectListener(name)
            self._commands.GLOBAL[name] = nil
        end
    end
end

function discordU.Bot(token: string, intents: discordu_intents.Intent, shards: number?): Bot
    local standard_client = client.New(token, intents, shards)
    standard_client._commands = {
        GUILD = {},
        GLOBAL = {},
    }
    return standard_client
end

return discordU
