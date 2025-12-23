--// DEPENDENCIES
local types = require('../types')
local bot_type = require('../TypesFolder/Bot')

--// TYPES
type Bot = bot_type.Bot

--// MODULES
local messages = {}

--// MAIN FUNCTIONS
function messages.message_to_reply(message: types.message_args, originating_message: types.message, guild_id: string?): types.message_args
    local reference: types.message_reference = {
        type = 0,
        message_id = originating_message.id,
        channel_id = originating_message.channel_id,
        guild_id = guild_id,
    }

    message.message_reference = reference
    return message
end

function messages.create_message(bot: Bot, channel_id: string, message: types.message_args, reply: types.message?, guild_id: string?): types.message?
    if reply ~= nil then
        message = messages.message_to_reply(message, reply, guild_id)
    end

    local posted_message = bot:NetRequest("post", `channels/{channel_id}/messages`, message)
    return posted_message
end

return messages