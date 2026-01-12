--!nocheck

--// DEPENDENCIES
local types = require('../types')
local messages = require(`../Libraries/messages`)

local bot_type = require('../TypesFolder/Bot')

--// STATICS
local Methods = {}
Methods.__index = Methods

--// TYPES
type Bot = bot_type.Bot

type interaction_methods = {
    send: (self: Interaction, message: types.message_args, reply_to_last: boolean?, ephemeral: boolean?) -> types.message?
}

type interaction_variables = {
    _bot: Bot,
    _last_message: types.message?,
}

export type interaction = types.interaction & interaction_methods & interaction_variables
export type Interaction = interaction

--// MODULES
local interaction = {}

--// INTERACTION METHODS
function Methods.send(self: Interaction, message: types.message_args, reply_to_last: boolean?, ephemeral: boolean?): types.message?
    if reply_to_last == true and self._last_message ~= nil then
        message = messages.message_to_reply(message, self._last_message, self.guild_id)
    end

    if ephemeral == true then
        message.flags = bit32.lshift(1, 6)
    end

    local RESPONSE = {
        type = 4,
        data = message,
    }

    local posted_message = self._bot:NetRequest('post', `/interactions/{self.id}/{self.token}/callback`, RESPONSE)
    self._last_message = posted_message

    return posted_message
end

function interaction.CommandInteraction(bot: Bot, interaction_data: types.interaction): CommandInteraction
    interaction_data._bot = bot
    return setmetatable(interaction_data, Methods)
end

return interaction