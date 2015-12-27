# lua-resy-template
Simple template engine for lua and openresty

# Syntax

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

please see detail in "test.lua"
