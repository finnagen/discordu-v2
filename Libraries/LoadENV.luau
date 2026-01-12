--!nocheck
local process = require("@lune/process")
local fs = require("@lune/fs")

--// MODULE \\--
return function(path_to_env: string)
    local env_file: string? = fs.readFile(path_to_env)
    if env_file == nil then
        return
    end

    for line in env_file:gmatch("[^\r\n]+") do
        if line:match("^%s*#") == nil and line:match("=") ~= nil then
            local k, v = line:match("^%s*([^=]+)%s*=%s*(.+)%s*$")

            if k ~= nil and v ~= nil then
                v = v:gsub('^"(.*)"$', "%1")
                v = v:gsub("^'(.*)'$", "%1")

                process.env[k] = v
            end
        end
    end
end