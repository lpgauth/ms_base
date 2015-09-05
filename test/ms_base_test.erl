-module(ms_base_test).
-include_lib("ms_base/include/ms_base.hrl").
-include_lib("eunit/include/eunit.hrl").

-spec test() -> ok.

%% runners
-spec ms_base_test_() -> ok.

ms_base_test_() ->
    {setup,
        fun () -> setup() end,
        fun (_) -> cleanup() end,
    [
        fun apply/0,
        fun status/0
    ]}.

-spec ms_base2_test_() -> ok.

ms_base2_test_() ->
    [
        fun global/0,
        fun parse_transform/0,
        fun reconnaissance/0
    ].

%% tests
apply() ->
    ?assertEqual(ok,
        ms_base:apply(test, ms_base_global, register, [test, <<>>])),

    ?assertEqual([registered_name],
        ms_base:apply_all(test, ms_base_global, register, [test, <<>>])).

global() ->
    ok = ms_base_global:start(),
    Name = my_key,
    Object = <<"foo">>,
    ok = ms_base_global:register(Name, Object),
    registered_name = ms_base_global:register(Name, Object),
    Object = ms_base_global:lookup(Name),
    ok = ms_base_global:unregister(Name),
    undefined= ms_base_global:lookup(Name),
    ok = ms_base_global:stop().

parse_transform() ->
    ?assertNotEqual([{var, 1, 'BUILD_DATE'}],
        ms_base_parse_transform:parse_transform([{var, 1, 'BUILD_DATE'}], [])),

    ?assertNotEqual([{var, 1, 'GIT_SHA'}],
        ms_base_parse_transform:parse_transform([{var, 1, 'GIT_SHA'}], [])),

    ?assertEqual([{var, 1, test}],
        ms_base_parse_transform:parse_transform([{var, 1, test}], [])).

reconnaissance() ->
    Ip = {127, 0, 0, 1},
    Port = 62592,
    Request = ms_base_reconnaissance:request(),
    Response = ms_base_reconnaissance:response(Ip, Port, Request),

    ?assertEqual({Ip, Port, Response},
        ms_base_reconnaissance:handle_response(Ip, Port, Response)).

status() ->
    {ok, Status, Headers, Body} = perform_request(get, url("/status")),

    ?assertEqual(200, Status),

    assert_prop("content-length", Headers),
    assert_prop_value("application/json", "content-type", Headers),

    {KeyValues} = jiffy:decode(Body),
    Keys = [Key || {Key, _Value} <- KeyValues],

    ?assertEqual([
        <<"status">>,
        <<"git_sha">>,
        <<"build_date">>,
        <<"now_unix">>
    ], Keys),

    assert_prop_value(<<"OK">>, <<"status">>, KeyValues).

%% utils
assert_prop_value(Expected, Header, Headers) ->
    ?assertEqual(Expected, lookup(Header, Headers)).

assert_prop(Header, Headers) ->
    ?assertNotEqual(undefined, lookup(Header, Headers)).

cleanup() ->
    ms_base_app:stop(),
    inets:stop().

lookup(Key, List) ->
    lookup(Key, List, undefined).

lookup(Key, List, Default) ->
    case lists:keyfind(Key, 1, List) of
        false -> Default;
        {_, Value} -> Value
    end.

perform_request(Method, Url) ->
    perform_request(Method, Url, [], undefined).

perform_request(Method, Url, Headers, Body) ->
    Request = case Method of
        get -> {Url, Headers};
        delete -> {Url, Headers};
        _   -> {Url, Headers, lookup("content-type", Headers), Body}
    end,
    case httpc:request(Method, Request, [], []) of
        {ok, Response} ->
            {{_, StatusCode, _}, ResHeaders, ResBody} = Response,
            {ok, StatusCode, ResHeaders, ResBody};
        {error, Reason} ->
            {error, Reason}
    end.

setup() ->
    error_logger:tty(false),
    application:load(lager),
    application:set_env(lager, error_logger_redirect, false),
    inets:start(),
    ms_base_app:start().

url(Path) ->
    Port = ?ENV(http_port, ?DEFAULT_STATUS_PORT),
    "http://127.0.0.1:" ++ integer_to_list(Port) ++ Path.
