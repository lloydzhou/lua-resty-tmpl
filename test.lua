local template = require "lib.resty.template"

local t = template.new()
--local t = template.new(io.write, true, {"{{", "}}", "{%%", "%%}"})

local tmpl = [[
<h1>{{title}}</h1>
<h2>{{title .. " -" .. '- ' .. subtitle}}</h2>
{% if messages then %}
    {% for i, message in ipairs(messages) do %}
        <p>{{message}}</p>
    {% end %}
{% end %}
{% local testvar = 'set val in template'%}{{ testvar }}
]]
--print (t:parse(tmpl))
--print (t:compile(tmpl))

local data = {title = 'Title', subtitle = 'Sub Title', messages = {'test message 1', 'test message 2'}}

t:render(tmpl, data)

--t:render(t:compile(tmpl), data)

