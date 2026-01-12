--// DEPENDENCIES
local types = require('../types')
local bot_type = require('../TypesFolder/Bot')

--// TYPES
type Bot = bot_type.Bot
export type button_style = "Primary" | "Secondary" | "Success" | "Danger" | "Link" | "Premium"

local STYLE_ENUMS: {[button_style]: number} = {
    Primary = 1,
    Secondary = 2,
    Success = 3,
    Danger = 4,
    Link = 5,
    Premium = 6
}

--// MODULES
local messages = {}

--// PRIVATE FUNCTIONS
function get_open_action_row(message: types.message_args): types.component_row?
    assert(message.components ~= nil)

    local hit_rows = 0

    for _, v in ipairs(message.components) do
        if v.type == 1 then
            hit_rows += 1

            if #v.components < 5 then
                return v
            end

            if hit_rows >= 5 then
                break
            end
        end
    end

    if hit_rows < 5 then
        local new_row: types.component_row = {
            type = 1,
            components = {},
        }

        table.insert(message.components, new_row)
        return new_row
    end

    return nil
end


--// MAIN FUNCTIONS
function messages.append_button(message: types.message_args, button_params: {text: string?, emoji: types.emoji?, id: string, style: button_style?}): types.message_args
    if message.components == nil then
        message.components = {}
    end

    local row = get_open_action_row(message)
    if row == nil then
        return message
    end

    if button_params.style ~= "Link" then
        assert(button_params.text ~= nil, "Buttons that have a non-link style have to contain text.")
    end

    assert(#button_params.id <= 100, "Button's id must be 100 characters or fewer")

    local style: button_style = button_params.style or "Primary"
    local style_value = STYLE_ENUMS[style]

    assert(style_value ~= nil, "Invalid style!")

    local button: types.button = {
        type = 2,
        style = STYLE_ENUMS[style],

        label = button_params.text,
        emoji = button_params.emoji,
        custom_id = button_params.id
    }

    table.insert(row.components, button)

    return message
end

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

function messages.delete_message(bot: Bot, channel_id: string, message_id: string): ()
    bot:NetRequest("delete", `channels/{channel_id}/messages/{message_id}`)
end

function messages.create_message(bot: Bot, channel_id: string, message: types.message_args, reply: types.message?, guild_id: string?): types.message?
    if reply ~= nil then
        message = messages.message_to_reply(message, reply, guild_id)
    end

    local posted_message = bot:NetRequest("post", `channels/{channel_id}/messages`, message)
    return posted_message
end

return messages