local types = require('../types')
local net = require('@lune/net')

type identity_variables = {
    application_ID: string?,
    application: types.application,
    user: types.user?,

    intents: number,
    token: string,

    shard_count: number?,

    latency: number?,
    interaction_latency: number?,
}

type shard_info = {
    guilds: {types.guild},

    _last_sent_heartbeat: number?,
    _heartbeat_interval: number,

    _last_sequence_num: number?,

    _gateway_URL: string,
    _session_num: number,
}

type private_variables = {
    _gateways: {[number]: net.WebSocket},
    _started: boolean,

    _recommended_shards: number,
    _session_limits: types.session_start_limits,

    _gateway_URL: string,
    _shards: {[number]: shard_info},

    _can_resume: boolean?,
    _commands: {
        GUILD: {
            [string]: {
                [string]: string
            }
        },
        GLOBAL: {
            [string]: string
        }
    }
}

type connections = {
    _tasks: {{[string]: thread}},

    _event_listeners: {[string]: (...any) -> ()},
    _component_listeners: {[string]: (...any) -> ()},
}

type bot_methods = {
    Run: (self: Bot) -> (),
    NetRequest: (self: Bot, method: string, url_path: string, body: any?, headers: {[string]: string}?) -> any?,
    End: (self: Bot) -> (),
    On: (self: Bot, event: string, callback: (...any) -> ()) -> (),
    OnComponent: (self: Bot, custom_id: string, callback: (any) -> ()) -> (),
    
    DisconnectListener: (self: Bot, event: string) -> (),
    DisconnectTask: (self: Bot, task_to_cancel: string) -> (),

    _Identify: (self: Bot, shard: number) -> (),
    _Resume: (self: Bot, shard: number) -> (),

    _RegisterGateway: (self: Bot, shard_id: number, resume_gateway_url: string?) -> (),

    _StartHeartbeat: (self: Bot, shard: number) -> (),
    _StartEventHandling: (self: Bot, shard: number) -> (),
}

export type Bot = identity_variables & private_variables & bot_methods & connections

return {}
