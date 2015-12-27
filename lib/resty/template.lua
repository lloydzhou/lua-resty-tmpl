-- Copyright (C) 2015 Lloyd Zhou

local _M = { _VERSION = '0.1'  }
local mt = {__index = _M}

-- cache the compile template to function array
local _C = {}

function _M.new(callback, minify, tags)
    return setmetatable({
        callback = callback or (nil == ngx and io.write or ngx.print),
        tags = ("table" == type(tags) and 4 == #tags) and tags or {"{{", "}}", "{%", "%}"},
        minify = minify or false
    }, mt)
end

function _M.parse(self, tmpl, minify)
    local str = "return function(_) _[=[" .. tmpl:
        gsub(self.tags[1], "]=]_("):
        gsub(self.tags[2], ")_[=["):
        gsub(self.tags[3], "]=]  "):
        gsub(self.tags[4], " _[=[") .. "]=] end"
    if minify then
        str = str:gsub("(^[ %s]*|[ %s]*$)", ""):gsub("%s+", " ")
    end
    return str
end
function _M.compile(self, tmpl, minify)
    _C[tmpl] = _C[tmpl] or loadstring(_M.parse(self, tmpl, minify))()
    return _C[tmpl]
end
function _M.render(self, tmpl, data, callback, minify)
    local callback = callback or self.callback
    local compile = type(tmpl) == "function" and tmpl or _M.compile(self, tmpl, minify or self.minify)
    setmetatable(data, {__index = _G})
    setfenv(compile, data)
    return compile(callback)
end

return _M

