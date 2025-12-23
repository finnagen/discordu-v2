--// MODULES
local intents = {}

--// TYPES
export type Intent = {
    guilds: boolean,
    members: boolean,
    moderation: boolean,
    expressions: boolean,
    integrations: boolean,
    webhooks: boolean,
    invites: boolean,
    voice_states: boolean,
    presences: boolean,
    messages: boolean,
    reactions: boolean,
    typing: boolean,

    dm_messages: boolean,
    dm_reactions: boolean,
    dm_typing: boolean,

    message_content: boolean,

    scheduled_events: boolean,

    automod_configuration: boolean,
    automod_execution: boolean,

    polls: boolean,
    dm_polls: boolean,
}

--// STATICS
intents.Intents = {
    guilds = bit32.lshift(1, 0),
    members = bit32.lshift(1, 1),
    moderation = bit32.lshift(1, 2),
    expressions = bit32.lshift(1, 3),
    integrations = bit32.lshift(1, 4),
    webhooks = bit32.lshift(1, 5),
    invites = bit32.lshift(1, 6),
    voice_states = bit32.lshift(1, 7),
    presences = bit32.lshift(1, 8),

    messages = bit32.lshift(1, 9),
    reactions = bit32.lshift(1, 10),
    typing = bit32.lshift(1, 11),

    dm_messages = bit32.lshift(1, 12),
    dm_reactions = bit32.lshift(1, 13),
    dm_typing = bit32.lshift(1, 14),

    message_content = bit32.lshift(1, 15),

    scheduled_events = bit32.lshift(1, 16),

    automod_configuration = bit32.lshift(1, 20),
    automod_execution = bit32.lshift(1, 21),

    polls = bit32.lshift(1, 24),
    dm_polls = bit32.lshift(1, 25),
}

local default_intents: Intent = {
    guilds = false,
    members = false,
    moderation = false,
    expressions = false,
    integrations = false,
    webhooks = false,
    invites = false,
    voice_states = false,
    presences = false,

    messages = false,
    reactions = false,
    typing = false,

    dm_messages = false,
    dm_reactions = false,
    dm_typing = false,

    message_content = false,

    scheduled_events = false,

    automod_configuration = false,
    automod_execution = false,

    polls = false,
    dm_polls = false,
}

--// MAIN FUNCTIONS
function intents.get_intent(intent: string): number?
    return intents.Intents[string.lower(intent)]
end

function intents.calculate_intents(...: string): number
    local final_intents = 0

    for _, intent in {...} do
        local intent_object = intents.get_intent(intent)
        if intent_object == nil then
            continue
        end

        final_intents += intent_object
    end

    return final_intents
end

function intents.get_enabled_intents(intent: Intent): {string}
    local enabled_intents = {}

    for k, v in intent do
        if v == true then
            table.insert(enabled_intents, k)
        end
    end

    return enabled_intents
end

--// CONSTRUCTORS
function intents.New(...: string): Intent
    local intent = table.clone(default_intents)

    for _, v in {...} do
        if intent[v] ~= nil then
            intent[v] = true
        else
            warn(`Intent {v} doesn't exist!`)
        end
    end

    return intent
end

function intents.all(): Intent
    return intents.New(
        'guilds',
        'members',
        'moderation',
        'expressions',
        'integrations',
        'webhooks',
        'invites',
        'voice_states',
        'presences',
        'messages',
        'reactions',
        'typing',
        'dm_messages',
        'dm_reactions',
        'dm_typing',
        'message_content',
        'scheduled_events',
        'automod_configuration',
        'automod_execution',
        'polls',
        'dm_polls'
    )
end

function intents.default(): Intent
    return intents.New(
        'guilds',
        'messages',
        'reactions',
        'typing',
        'dm_messages',
        'dm_reactions',
        'dm_typing',
        'voice_states',
        'scheduled_events'
    )
end

return intents