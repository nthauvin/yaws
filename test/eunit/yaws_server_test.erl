-module (yaws_server_test).

%% test callback
-export ([custom_auth/1]).

-include_lib ("eunit/include/eunit.hrl").
-include ("../../include/yaws.hrl").
-include ("../../include/yaws_api.hrl").

custom_auth_test () ->
    Headers = #headers{cookie = ["foo=bar; login=ABC"]},
    SC = #sconf{custom_auth = ?MODULE},
    Result = yaws_server:custom_auth(Headers, SC),
    Expected = Headers#headers{authorization = {"abc", undefined, undefined}},
    ?assertEqual(Expected, Result).

custom_auth (#headers{cookie = Cookie} = Headers) ->
    Value = yaws_api:find_cookie_val("login", Cookie),
    Auth = {string:to_lower(Value), undefined, undefined},
    Headers#headers{authorization = Auth}.

custom_auth_not_defined_test () ->
    Headers = #headers{cookie = ["foo=bar; login=ABC"]},
    SC = #sconf{},
    Result = yaws_server:custom_auth(Headers, SC),
    ?assertEqual(Headers, Result).
