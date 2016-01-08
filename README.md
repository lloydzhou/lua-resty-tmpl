# lua-resy-tmpl
Simple template engine for lua and openresty

# Methods

## new
`syntax: t = template.new(callback, minify, tags, cacheable)`

create new template instance, all params is optional  
the default value of callback is "io.write" or "ngx.print"  
the default value of minify is false
the default value of tags is {"{{", "}}", "{%%", "%%}"}  
the default value of cacheable is true

## parse
`syntax: code = t:parse(tmpl, minify)`

parse the template into lua code.

## compile
`syntax: func = t:compile(tmpl, minify, cacheable)`

compile the template into lua function, this method will call parse method.  
this method will auto cache the compiled function.

## render
`syntax: t:render(tmpl_or_func, data, callback, minify, cacheable)`

render the template with variables stored in data, 
the first param can be template string or compiled function.  
the callback, minify and cacheable params will replace the default value gived from "new" method.


# Template Syntax

In short, statements must be included between percent signs and expressions must be placed between brackets.

## Variables and expressions

variables or expressions will be replaced

      <h1>
        {{title}}
      </h1>
      <b>{{ title .. "-" .. subtitle }}</b>

## Conditional and Loops

      <!-- just using plain lua code, example for conditional and loops -->
      {% if messages then %}
        {% for i, message in ipairs(messages) do %}
          <p>{{message}}</p>
        {% end %}
      {% end %}

## Set Variables

      <!-- set Variables and display it -->
      {% local testval = 'set var in template.' %}{{ testval }}

# Demo 

the test demo in file "test.lua"

    local template = require "lib.resty.template"
    local t = template.new()
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
    local data = {title = 'Title', subtitle = 'Sub Title', messages = {'test message 1', 'test message 2'}}
    t:render(tmpl, data)

will get result:

    <h1>Title</h1>
    <h2>Title -- Sub Title</h2>
            <p>test message 1</p>
            <p>test message 2</p>
        set val in template
    
    
