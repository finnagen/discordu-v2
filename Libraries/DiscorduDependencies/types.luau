--// TYPES

---// DATA
export type thread_member = {
    id: string?,
    user_id: string?,

    join_timestamp: string,
    
    flags: number,
    member: guild_member,
}

export type default_reaction = {
    emoji_id: string?,
    emoji_name: string?,
}

export type thread_metadata = {
    archived: boolean,
    auto_archive_duration: number,
    archive_timestamp: string,

    locked: boolean,
    invitable: boolean?,

    create_timestamp: string?,
}

export type tag = {
    id: string,
    name: string,
    emoji_id: string?,
    emoji_name: string?,

    moderated: boolean,
}

export type avatar_decoration_data = {
    asset: string,
    sku_id: string?,
}

export type nameplate_data = {
    sku_id: string,

    asset: string,
    label: string,

    pallete: string
}

export type collectible = {
    nameplate: nameplate_data
}

export type overwrite = {
    id: string,

    type: number,
    
    allow: string,
    deny: string,
}

export type user_primary_guild = {
    identity_guild_id: number?,
    identity_enabled: boolean?,

    tag: string?,
    bridge: string?,
}

export type channel_mention = {
    id: string,
    guild_id: string,

    type: number,
    name: string,
}

export type reaction_count_details = {
    burst: number,
    normal: number,
}

export type emoji = {
    id: string?,
    name: string?,

    roles: {string},
    user: user?,

    require_colons: boolean?,
    managed: boolean?,
    available: boolean?,

    animated: boolean?,
}

export type reaction = {
    count: number,
    count_details: reaction_count_details,

    me: boolean,
    me_burst: boolean,
    burst_colors: {string},

    emoji: emoji,
}

export type message_activity = {
    type: number,
    party_id: string?,
}

export type team_member = {
    membership_state: number,
    team_id: string,
    user: user,
    role: string,
}

export type team = {
    icon: string?,
    id: string,
    name: string,

    members: {team_member},
    owner_user_id: string,
}

export type role_colors = {
    primary_color: number,
    secondary_color: number?,
    tertiary_color: number?,
}

export type role_tags = {
    bot_id: string?,
    integration_id: string?,

    premium_subscriber: false?,
    subscription_listing_id: string?,

    available_for_purchase: false?,
    guild_connections: false?,
}

export type role = {
    id: string,
    name: string,

    color: number,
    colors: role_colors,

    hoist: boolean,

    icon: string?,
    unicode_emoji: string?,
    
    position: number,
    permissions: string,

    managed: boolean,
    mentionable: boolean,

    tags: role_tags?,
    flags: number,
}

export type guild_features = "ANIMATED_BANNER" | "ANIMATED_ICON" | "APPLICATION_COMMAND_PERMISSIONS_V2" | "AUTO_MODERATION" | "BANNER" | "COMMUNITY" | "CREATOR_MONETIZABLE_PROVISIONAL" | "CREATOR_STORE_PAGE" | "DEVELOPER_SUPPORT_SERVER" | "DISCOVERABLE" | "FEATURABLE" | "INVITES_DISABLED" | "INVITE_SPLASH" | "MEMBER_VERIFICATION_GATE_ENABLED" | "MORE_SOUNDBOARD" | "MORE_STICKERS" | "NEWS" | "PARTNERED" | "PREVIEW_ENABLED" | "RAID_ALERTS_DISABLED" | "ROLE_ICONS" | "ROLE_SUBSCRIPTIONS_AVAILABLE_FOR_PURCHASE" | "ROLE_SUBSCRIPTIONS_ENABLED" | "SOUNDBOARD" | "TICKETED_EVENTS_ENABLED" | "VANITY_URL" | "VERIFIED" | "VIP_REGIONS" | "WELCOME_SCREEN_ENABLED" | "GUESTS_ENABLED" | "GUILD_TAGS" | "ENHANCED_ROLE_COLORS"

export type welcome_screen_channel = {
    channel_id: string,
    description: string,

    emoji_id: string?,
    emoji_name: string?,
}

export type message_sticker_item = {
    id: string,
    name: string,
    format_type: number,
}

export type sticker_pack = {
    id: string,
    name: string,
    description: string,

    banner_asset_id: string?,

    stickers: {sticker},

    sku_id: string,
    cover_sticker_id: string?,
}

export type welcome_screen = {
    description: string?,
    welcome_channels: {welcome_screen_channel},
}

export type sticker = {
    id: string,
    pack_id: string?,

    name: string,
    description: string,

    tags: string,
    type: number,
    format_type: number,

    available: boolean?,
    guild_id: string?,

    user: user?,
    sort_value: number?,
}

export type incidents_data = {
    invites_disabled_until: string?,
    dms_disabled_until: string?,
    dm_spam_deteted_at: string?,
    raid_detected_at: string?,
}

export type install_params = {
    scopes: {string},
    permissions: string,
}

export type message_reference = {
    type: number?,

    message_id: string?,
    channel_id: string?,
    guild_id: string?,

    fail_if_not_exists: boolean?,
}

export type message_snapshot = {
    message: message,
}

export type message_interaction_metadata = {
    id: string,
    type: number,

    name: string,
    user: user,

    member: guild_member?,
}

export type message_interaction = {
    id: string,
    type: number,

    name: string,

    user: user,
    member: guild_member?,
}

export type component_row = {
    type: number,
    components: {button},
}

export type message_component = component_row

export type button_args = {
    type: number,

    custom_id: string?,
    url: string?,

    style: number,
    emoji: emoji?,

    disabled: boolean?,
}

export type attachment = {
    id: string,
    filename: string,

    title: string?,
    description: string?,

    content_type: string?,

    size: number,
    url: string,
    proxy_url: string,

    height: number?,
    width: number?,

    ephemeral: boolean?,

    duration_secs: number?,
    waveform: string?,

    flags: number?,
}

export type embed_footer = {
    text: string,

    icon_url: string?,
    proxy_icon_url: string?,
}

export type embed_image = {
    url: string,
    proxy_url: string?,

    height: number?,
    width: number?,
}

export type embed_video = {
    url: string?,
    proxy_url: string?,

    height: number?,
    width: number?,
}

export type embed_provider = {
    name: string?,
    url: string?,
}

export type embed_author = {
    name: string,
    url: string?,

    icon_url: string?,
    proxy_icon_url: string?,
}

export type embed_field = {
    name: string,
    value: string,

    inline: boolean?,
}

export type session_start_limits = {
    total: number,
    remaining: number,
    reset_after: number,
    max_concurrency: number,
}

export type embed_thumbnail = {
    url: string,
    proxy_url: string?,

    height: number?,
    width: number?,
}

export type button = {
    type: number,
    id: number?,

    style: number,
    label: string?,
    emoji: string?,

    custom_id: string,
    sku_id: string?,

    url: string?,
    disabled: boolean?,
}

export type embed = {
    title: string?,
    type: string?,

    description: string?,
    url: string?,

    timestamp: string?,

    color: number?,

    footer: embed_footer?,
    image: embed_image?,
    video: embed_video?,
    provider: embed_provider?,
    author: embed_author?,
    fields: {embed_field}?,
    thumbnail: embed_thumbnail?,
}

export type embed_args = {
    title: string?,
    description: string?,
    color: number,

    footer: embed_footer?,
    author: embed_author?,
    fields: {embed_field}?,
    image: embed_image?,
    thumbnail: embed_thumbnail?,
}

export type role_subscription_data = {
    role_subscription_listing_id: string,
    tier_name: string,

    total_months_subscribed: number,
    is_renewal: boolean,
}

export type resolved_data = {
    users: {[string]: user}?,
    members: {[string]: guild_member}?,

    roles: {[string]: role}?,

    channels: {[string]: channel}?,

    messages: {[string]: message}?,

    attachment: {[string]: attachment}?,
}

export type poll_media = {
    text: string?,
    emoji: emoji?,
}

export type poll_answer = {
    answer_id: string?,
    poll_media: poll_media,
}

export type poll_answer_count = {
    id: string,
    count: number,

    me_voted: boolean,
}

export type poll_results = {
    is_finalized: boolean,
    answer_counts: {poll_answer_count},
}

export type poll = {
    question: poll_media,
    answers: {poll_answer},

    expiry: string?,

    allow_multiselect: boolean,
    layout_type: number,

    results: poll_results?,
}

export type poll_request = {
    question: poll_media,
    answers: {poll_answer},

    duration: number?,

    allow_multiselect: boolean?,
    layout_type: number?,
}

export type message_call = {
    participants: {number},
    ended_timestamp: string?,
}

export type allowed_mention = {
    parse: {"roles" | "users" | "everyone"}
}

export type message_args = {
    content: string?,
    nonce: string? | number?,

    tts: boolean?,

    embeds: {embed}?,
    allowed_mentions: allowed_mention?,
    
    message_reference: message_reference?,

    components: {message_component}?,

    sticker_ids: {string}?,

    payload_json: string?,
    attachments: {attachment}?,

    flags: number?,

    enforce_nonce: boolean?,
    poll: poll_request?,
}

export type slash_command_option_choice = {
    name: string,
    name_localizations: {[string]: string}?,

    -- Discord only allows string, integer, or number for choices
    value: string | number,
}

export type slash_command_option = {
    type: number,

    name: string,
    name_localizations: {[string]: string}?,
    description: string,
    description_localizations: {[string]: string}?,

    required: boolean?,

    choices: {slash_command_option_choice}?,
    options: {slash_command_option}?,

    channel_types: {number}?,

    min_value: number?,
    max_value: number?,
    
    min_length: number?,
    max_length: number?,

    autocomplete: boolean?,
}

export type slash_command_args = {
    name: string,
    description: string,

    name_localizations: {[string]: string}?,
    description_localizations: {[string]: string}?,

    options: {slash_command_option}?,

    nsfw: boolean?,
}

export type interaction_value = {
    name: string,
    value: string|number|boolean,
}

export type interaction_option = {
    name: string,
    type: number,

    value: string|number|boolean?,
    options: {interaction_option}?,
}

export type interaction_data = {
    id: string,
    name: string,

    options: {interaction_option}?,
    resolved: any?,
}

export type interaction = {
    type: number,
    token: string,

    member: guild_member?,

    id: string,
    application_id: string,

    channel_id: string,
    guild_id: string?,

    guild_locale: string?,
    locale: string?,

    app_permissions: string?,

    data: interaction_data,
}

export type interaction_callback_data_message = {
    tts: boolean?,

    content: string?,
    embeds: {embed}?,

    allowed_mentions: allowed_mention?,
    flags: number?,

    components: {message_component}?,
    attachments: {attachment}?,

    poll: poll_request?,
}

export type interaction_response = {
    type: number,
    data: interaction_callback_data_message,
}

---// CLASSES 
export type guild = {
    id: string,
    name: string,
    icon: string?,
    icon_hash: string?,
    splash: string?,
    discovery_splash: string?,

    owner: boolean?,
    owner_id: string,
    permissions: string?,

    region: string?,
    
    afk_channel_id: string?,
    afk_timeout: number,

    widget_enabled: boolean?,
    widget_channel_id: string?,

    verification_level: number,
    default_message_notifications: number,
    explicit_content_filter: number,

    roles: {role},
    emojis: {emoji},
    features: {guild_features},

    mfa_level: number,
    application_id: string?,
    system_channel_id: string?,
    system_channel_flags: number,

    rules_channel_id: string?,
    max_presences: number?,
    max_members: number,

    vanity_url_code: string?,
    description: string?,
    banner: string?,

    premium_tier: number,
    premium_subscription_count: number?,
    preferred_locale: string,

    public_updates_channel_id: string?,
    max_video_channel_users: number?,
    max_stage_video_channel_users: number?,

    approximate_member_count: number?,
    approximate_presence_count: number?,

    welcome_screen: welcome_screen?,

    nsfw_level: number,
    stickers: {sticker}?,

    premium_progress_bar_enabled: boolean,
    safety_alerts_channel_id: string?,
    incidents_data: incidents_data
}

export type application = {
    id: string,
    guild_id: string?,
    primary_sku_id: string?,

    slug: string?,

    guild: guild?,

    name: string,
    icon: string?,
    cover_image: string?,
    description: string,

    rpc_origins: {string}?,
    bot_public: boolean,
    bot_require_code_grant: boolean,

    bot: user?,

    terms_of_service_url: string?,
    privacy_policy_url: string?,

    owner: user?,
    team: team?,

    flags: number?,
    
    approximate_guild_count: number?,
    approximate_user_install_count: number?,
    approximate_user_authorization_count: number?,

    redirect_uris: {string}?,
    interactions_endpoint_url: string?,
    role_connections_verification_url: string?,

    event_webhooks_url: string?,
    event_webhooks_status: number,
    event_webhooks_types: {string}?,

    tags: {string}?,

    install_params: install_params?,
    integration_types_config: {[string]: {[string]: install_params}},
    custom_install_url: string?,

    verify_key: string,
}

export type user = {
    id: string,

    username: string,
    discriminator: string,
    global_name: string?,
    email: string?,

    locale: string?,
    verified: boolean?,

    flags: number?,
    public_flags: number?,
    
    primary_guild: user_primary_guild?,

    premium_type: number?,
    collectibles: {collectible},

    avatar: string?,
    avatar_decoration_data: avatar_decoration_data,
    banner: string?,
    accent_color: number?,

    bot: boolean?,
    system: boolean?,
    mfa_enabled: boolean?,
}

export type message = {
    id: string,
    channel_id: string,
    type: number,

    author: user?,
    content: string?,

    webhook_id: string?,

    timestamp: string,
    edited_timestamp: string?,

    tts: boolean,
    mention_everyone: boolean,
    pinned: boolean,

    mentions: {user},
    mention_roles: {string},
    mention_channels: {channel_mention}?,

    activity: message_activity?,

    nonce: number? | string?,

    application: application?,
    application_id: number?,

    flags: number?,
    
    message_reference: message_reference?,
    message_snapshots: {message_snapshot}?,

    referenced_message: message?,

    interaction_metadata: message_interaction_metadata?,
    interaction: message_interaction?,

    thread: channel?,

    sticker_ids: {string}?,
    stickers: {sticker}?,
    sticker_items: {message_sticker_item}?,

    position: number?,

    components: {message_component}?,

    attachments: {attachment}?,
    embeds: {embed}?,
    reactions: {reaction},

    resolved: resolved_data?,

    poll: poll?,
    call: message_call?,
}

export type channel = {
    id: string,    
    guild_id: string?,

    parent_id: string?,

    name: string?,
    topic: string?,

    position: number?,
    type: number,
    nsfw: boolean?,

    rtc_region: string?,
    video_quality_mode: number?,

    bitrate: number?,
    rate_limit_per_user: number?,

    permission_overwrites: {overwrite}?,
    permissions: string?,

    flags: number,
    available_tags: {tag},
    applied_tags: {string},

    recipients: {user}?,
    icon: string?,
    owner_id: string?,
    application_id: string?,
    managed: boolean?,

    last_pin_timestamp: string?,
    last_message_id: string?,

    message_count: number?,
    member_count: number?,
    total_message_sent: number?,

    thread_metadata: thread_metadata?,
    member: thread_member?,
    default_auto_archive_duration: number?,
    default_thread_rate_limit_per_user: number?,
    default_sort_order: number?,
    default_forum_layout: number?,

    default_reaction: default_reaction,
}

export type slash_command = {
    id: string,
    type: number?,

    application_id: string,
    guild_id: string?,

    name: string,
    name_localizations: {["string"]: string}?,
    description: string,
    description_localizations: {["string"]: string}?,

    options: {slash_command_option}?,

    default_member_permissions: string?,

    dm_permissions: boolean?,
    default_permission: boolean?,
    contexts: {number}?,

    nsfw: boolean?,

    integration_types: {[string]: {[string]: install_params}},

    version: string,
    handler: number?,
}

export type guild_member = {
    user: user?,

    nick: string?,
    avatar: string?,
    banner: string?,

    roles: {string},

    joined_at: string?,
    premium_since: string?,

    deaf: boolean,
    mute: boolean,
    flags: number,
    pending: boolean?,

    permissions: string?,

    communication_disabled_until: string?,
    avatar_decoration_data: avatar_decoration_data?,
}

--// CONVERSION TABLES
local types = {}
return types