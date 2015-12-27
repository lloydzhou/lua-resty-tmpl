local template = require "lib.resty.template"

local t = template.new(io.write, true, {"{{", "}}", "{%", "%}"})
--local t = template.new()

local tmpl = [[
<h1>{{title}}</h1>]]
--print (t:parse(tmpl))
--print (t:compile(tmpl))

local data = {title = 'Title'}
t:render(tmpl, data)
t:render(t:compile(tmpl), data)

