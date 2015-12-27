# vim:set ft= ts=4 sw=4 et:

use Test::Nginx::Socket::Lua;
use Cwd qw(cwd);

repeat_each(2);

plan tests => repeat_each() * (blocks() * 3);

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "$pwd/lib/?.lua;;";
};

$ENV{TEST_NGINX_RESOLVER} = '8.8.8.8';

#no_long_string();
#no_diff();

run_tests();

__DATA__

=== TEST 1: lock is subject to garbage collection 
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local template = require "resty.template"
            local t = template.new(ngx.say, true)
            t:render([[<h1>{{title}}</h1>]], {title = "TITLE"})
        ';
    }

--- request
GET /t
--- response_body
<h1>
TITLE
</h1>

--- no_error_log
[error]
