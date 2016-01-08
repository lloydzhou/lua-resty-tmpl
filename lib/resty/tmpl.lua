-- Copyright (C) 2015 Lloyd Zhou

local _M = { _VERSION = '0.1'  }
local mt = {__index = _M}

function _M.new(callback, minify, tags, cacheable)
    tags = ("table" == type(tags) and 4 == #tags) and tags or {"{{", "}}", "{%%", "%%}"}
    return setmetatable({
        callback = callback or (nil == ngx and io.write or ngx.print),
        minify = minify or false,
        cacheable = cacheable or true,
        replace_templae = {
            ["\\"] = "\\\\",
            ["'"] = "\'",
            ['"'] = "\"",
            [tags[1]] = "]=]_(",
            [tags[2]] = ")_[=[",
            [tags[3]] = "]=]  ",
            [tags[4]] = " _[=["
        },
        cache = {}
    }, mt)
end

function _M.parse(self, tmpl, minify)
    -- see https://github.com/dannote/lua-template
    for k, v in pairs(self.replace_templae) do
        tmpl = tmpl:gsub(k, v)
    end
    local str = "return function(_) _[=[" .. tmpl .. "]=] end"
    return minify and str:gsub("%s+", " ") or str
end

function _M.compile(self, tmpl, minify, cacheable)
    local key = nil == ngx and tmpl or ngx.md5(tmpl)
    if cacheable or self.cacheable then
        self.cache[key] = self.cache[key] or loadstring(_M.parse(self, tmpl, minify))()
        return self.cache[key]
    end
    return loadstring(_M.parse(self, tmpl, minify))()
end

-- can render compiled function or template string
function _M.render(self, tmpl, data, callback, minify, cacheable)
    local compile = type(tmpl) == "function" and tmpl or _M.compile(self, tmpl, minify or self.minify, cacheable or self.cacheable)
    setmetatable(data, {__index = _G})
    setfenv(compile, data)
    return compile(callback or self.callback)
end

setmetatable(_M, {__call = function(self, ...) return _M.render(_M.new(), ...) end})

return _M

