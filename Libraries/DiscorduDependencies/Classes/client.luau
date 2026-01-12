--!nocheck

--[[
    THIS IS A RE-WRITE OF THE ORIGINAL 'client.luau' MODULE IN DISCORDU V1.0!
    IT HAS IMPROVED SYNTAX, MUCH BETTER FORMATTING, AND MORE FLEXIBILITY.
    IT ALSO INTRODUCES MORE FEATURES FROM THE DISCORD API, INCLUDING SHARDING.

    THIS MODULE IS HEAVILY INSPIRED BY "Nactari" (https://github.com/thekingofspace/NactariLibs).
    
    (background tiem)
    The only reason I made Discordu is because I saw Nactari and decided it'd be sick.
    Countless hours of studying Nactari's source code, along with many more studying the API documentation has let me create this wrapper.

    Thanks, Raikin :3
]]

--// MODULES
local client = {}

local discordu_intents = require('../Libraries/intents')
local interaction = require('./interaction')

local task: typeof(task) = require('@lune/task')
local serde = require('@lune/serde')
local net = require('@lune/net')
local DateTime = require('@lune/datetime')

--// METHODS
client.client_methods = {}

--// STATIC VARIABLES
local API_ENDPOINT = 'https://discord.com/api/v10'

local RETRY_CONNECTION_TIME = 1

--// TABLE CONSTRUCTORS
local HEARTBEAT_PACKET = {
    op = 1,
    d = 0,
}

local IDENTIFY_PACKET = {
    op = 2,
    d = {
        token = "",
        intents = 0,
        shard = {0, 1},

        properties = {
            os = "windows",
            browser = "discu_v2",
            device = "discu_v2",
        }
    }
}

local RESUME_PACKET = {
    op = 6,
    d = {
        token = "",
        session_id = "",
        seq = 0,
    }
}

--// TYPES
local types = require('../types')
local bot_type = require('../TypesFolder/Bot')

export type Bot = bot_type.Bot

--// FUNCTIONS
local function snowflake_to_epoch(snowflake: string): number
    local num = tonumber(snowflake)
    if num == nil then
        return 0
    end

    local timestamp_ms = math.floor(num / 4194304)
    return (timestamp_ms + 1420070400000)
end

--// BOT METHODS
function client.client_methods.Run(self: Bot): ()
    if self._started == true then
        return
    end

    self._started = true

    local gateway_packet = self:NetRequest('get', 'gateway/bot')
    if gateway_packet == nil then
        error('ERROR FINDING GATEWAY URL. BOT FAILED TO RUN.')
    end

    self._gateway_URL = gateway_packet.url .. "?v=10&encoding=json"
    self._recommended_shards = gateway_packet.shards
    if self.shard_count == 0 then
        self.shard_count = self._recommended_shards
    end
    self._session_limits = gateway_packet.session_start_limit

    IdentifyProcesses = 0

    for i = 1, self.shard_count do
        local shard_id = i - 1

        while IdentifyProcesses >= self._session_limits.max_concurrency do
            task.wait(0.1)
        end

        IdentifyProcesses += 1

        local shard_info = self._shards[shard_id]
        self:_RegisterGateway(shard_id, shard_info and shard_info._gateway_URL or nil)

        if self._can_resume == false then
            self:_Identify(shard_id)
        else
            self:_Resume(shard_id)
        end

        local hello_packet = serde.decode('json', self._gateways[shard_id]:next())
        self._shards[shard_id]._heartbeat_interval = hello_packet.d.heartbeat_interval / 1000

        self:_StartHeartbeat(shard_id)
        self:_StartEventHandling(shard_id)
    end

    local application = self:NetRequest('get', 'applications/@me')
    self.application_ID = application.id
    self.application = application
end

function client.client_methods.End(self: Bot)
    if self._tasks["ending"] ~= nil then
        self._tasks["ending"]()
    end

    for _, v in self._tasks do
        self:DisconnectTask(v)
    end
    table.clear(self._tasks)

    self._started = false

    for shard_id, shard in self._shards do
        local gateway = self._gateways[shard_id]
        if gateway ~= nil then
            gateway:close(4000)
        end
    end
end

function client.client_methods.On(self: Bot, event: string, callback: (...any) -> ())
    self._event_listeners[string.lower(event)] = callback
end

function client.client_methods.OnComponent(self: Bot, custom_id: string, callback: (interaction: interaction.interaction) -> ())
    self._component_listeners[string.lower(custom_id)] = callback
end

function client.client_methods.DisconnectListener(self: Bot, event: string)
    self._event_listeners[string.lower(event)] = nil
    self._component_listeners[string.lower(event)] = nil
end

function client.client_methods.DisconnectTask(self: Bot, task_to_cancel: string): ()
    if self._tasks[task_to_cancel] ~= nil then
        task.cancel(self._tasks[task_to_cancel])
        self._tasks[task_to_cancel] = nil
    end
end

function client.client_methods._RegisterGateway(self: Bot, shard_id: number, resume_gateway_url: string?)
    local url = (resume_gateway_url or self._gateway_URL)
    self._gateways[shard_id] = net.socket(url)
    
    if self._shards[shard_id] == nil then
        self._shards[shard_id] = {
            _last_sequence_num = 0,
            _heartbeat_interval = 0,
            guilds = {},
        }
    end
end

function client.client_methods._StartHeartbeat(self: Bot, shard: number): ()
    local shard_info = self._shards[shard]
    local gateway = self._gateways[shard]

    self._tasks[`heartbeat_{shard}`] = task.spawn(function()
        while self._started == true do
            if self._shards[shard]._last_sent_heartbeat ~= nil then
                task.wait(shard_info._heartbeat_interval)
            else
                task.wait(shard_info._heartbeat_interval*math.random())
            end

            self._shards[shard]._last_sent_heartbeat = os.clock()

            local heartbeat_packet = table.clone(HEARTBEAT_PACKET)
            heartbeat_packet.d = self._shards[shard]._last_sequence_num

            gateway:send(serde.encode('json', heartbeat_packet))
        end

        self:DisconnectTask('heartbeat')
    end)
end

function client.client_methods._StartEventHandling(self: Bot, shard: number): ()
    local gateway = self._gateways[shard]

    self._tasks[`event_handling_{shard}`] = task.spawn(function()
        while self._started == true do
            local event_packet = gateway:next()
            if event_packet == nil then
                continue
            end

            local decoded_event = serde.decode('json', event_packet)
            self._shards[shard]._last_sequence_num = decoded_event.s or self._shards[shard]._last_sequence_num or 0

            task.spawn(function() 
                if decoded_event.op == 7 then
                    self._can_resume = true
                    self:_Resume(shard)
                    return
                elseif decoded_event.op == 11 then
                    self.latency = os.clock()-self._shards[shard]._last_sent_heartbeat
                end

                if decoded_event.op == 9 then
                    task.wait(RETRY_CONNECTION_TIME)

                    if decoded_event.d == true then
                        self:_Resume(shard)
                    else
                        self:_Identify(shard)
                    end

                    return
                end

                if decoded_event.op == 0 and decoded_event.t ~= nil then
                    if decoded_event.t == 'READY' then
                        self._shards[shard]._session_num = decoded_event.d.session_id
                        if decoded_event.d.resume_gateway_url then
                            self._shards[shard]._gateway_URL = decoded_event.d.resume_gateway_url..'?v=10&encoding=json'
                        end
                        
                        self.user = decoded_event.d.user
                        
                        IdentifyProcesses -= 1
                        if IdentifyProcesses <= 0 then
                            IdentifyProcesses = nil
                        end
                    elseif decoded_event.t == 'INTERACTION_CREATE' then
                        local interaction_obj: types.interaction = decoded_event.d

                        local time_in_ms = DateTime.now().unixTimestampMillis
                        local latency = (time_in_ms-snowflake_to_epoch(interaction_obj.id))/1000

                        self.interaction_latency = math.abs(latency)

                        for k, v in self._event_listeners do
                            if k == interaction_obj.data.name then
                                local interaction: interaction.interaction = interaction.CommandInteraction(self, interaction_obj)
                                v(interaction, shard)
                            end
                        end

                        if interaction_obj.data.custom_id ~= nil then
                            for k, v in self._component_listeners do
                                if k == interaction_obj.data.custom_id then
                                    local interaction: interaction.interaction = interaction.CommandInteraction(self, interaction_obj)
                                    v(interaction, shard)
                                end
                            end
                        end
                    end

                    local event_name = string.lower(decoded_event.t)
                    if self._event_listeners[event_name] then
                        self._event_listeners[event_name](decoded_event.d)
                    end
                end
            end)
        end

        self:DisconnectTask('event_handling')
    end)
end

function client.client_methods._Identify(self: Bot, shard: number): ()
    local gateway = self._gateways[shard]
    local identify_packet = table.clone(IDENTIFY_PACKET)

    identify_packet.d.token = self.token
    identify_packet.d.intents = self.intents
    identify_packet.d.shard = {shard, self.shard_count}

    gateway:send(serde.encode('json', identify_packet))
end

function client.client_methods._Resume(self: Bot, shard: number): ()
    local gateway = self._gateways[shard]
    local shard_info = self._shards[shard]

    local resume_packet = table.clone(RESUME_PACKET)
    resume_packet.d.token = self.token
    resume_packet.d.session_id = shard_info._session_num
    resume_packet.d.seq = shard_info._last_sequence_num

    gateway:send(serde.encode('json', resume_packet))
end

function client.client_methods.NetRequest(self: Bot, method: string, url_path: string, body: any?, headers: {[string]: string}?): any?
    local request_url = `{API_ENDPOINT}/{url_path}`
    local packet = {
        url = request_url,
        method = string.upper(method),
        headers = {
            ["Authorization"] = `Bot {self.token}`,
            ["Content-Type"] = 'application/json',
        }
    }

    if headers ~= nil then
        for k, v in headers do
            packet.headers[k] = v
        end
    end

    if body ~= nil then
        local encoded_body

        if type(body) == 'table' then
            encoded_body = serde.encode('json', body)
            packet.headers["Content-Type"] = 'application/json'
        else
            encoded_body = body
        end
        
        packet.body = encoded_body
    end

    local request_result = net.request(packet)
    if request_result.statusCode >= 400 then
        if request_result.statusCode == 429 then
            local retry_after = request_result.body.retry_after
            task.delay(retry_after, function()
                self:NetRequest(method, url_path, body, headers)
            end)

            return
        end
        error(`NETREQUEST ERROR CODE {request_result.statusCode} | DETAILS: {request_result.statusMessage}.\nBODY RETURNED:\n{request_result.body}`)
    end

    if request_result.body == nil then
        return
    end

    local success, result = pcall(serde.decode, "json", request_result.body)
    return success and result or request_result.body
end

local methods = {}
methods.__newindex = rawset
methods.__index = function(self, key): any?
    if client.client_methods[key] ~= nil then
        return client.client_methods[key]
    end

    return rawget(self, key)
end

--// FUNCTIONS
function client.New(token: string, intents: discordu_intents.Intent?, shard_count: number?): Bot
    intents = intents or discordu_intents.default()
    local stringed_intents = discordu_intents.get_enabled_intents(intents)

    local used_intents = discordu_intents.calculate_intents(table.unpack(stringed_intents))

    local self = setmetatable({
        intents = used_intents,
        token = token,

        shard_count = shard_count or 0,

        _tasks = {},
        _event_listeners = {},
        _component_listeners = {},

        _shards = {},
        _gateways = {},

        _can_resume = false,
    }, methods)

    return self
end

return client
