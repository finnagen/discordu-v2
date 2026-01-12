--!nocheck

--// DEPENDENCIES
local types = require('../types')
local serde = require('@lune/serde')

--// MODULES
local embeds = {}

--// STATICS
local DEFAULT_COLOR = 16777215

--// MAIN FUNCTIONS
function embeds.Embed(embed_template: types.embed_args): types.embed
    local new_embed: types.embed = {
        title = embed_template.title,
        description = embed_template.description,
        type = "rich",

        color = embed_template.color or DEFAULT_COLOR,

        footer = embed_template.footer,
        author = embed_template.author,
        fields = embed_template.fields,
        thumbnail = embed_template.thumbnail,
        image = embed_template.image,
    }

    return new_embed
end

function embeds.from_json(embed): types.embed?
    local success, result = pcall(serde.decode, "json", embed)
    return success and result or nil
end

return embeds