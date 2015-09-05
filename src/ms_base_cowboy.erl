-module(ms_base_cowboy).
-include("ms_base.hrl").

-export([
    start/0,
    stop/0
]).

%% public
-spec start() -> ok.

start() ->
    HttpIp = ?ENV(http_ip, ?DEFAULT_HTTP_IP),
    HttpPort = ?ENV(http_port, ?DEFAULT_HTTP_PORT),

    Dispatch = cowboy_router:compile([{'_', [
        {"/status", ms_base_status, []}
    ]}]),

    try cowboy:start_http(?APP, 2, [
        {ip, HttpIp},
        {port, HttpPort}
    ], [
        {env, [{dispatch, Dispatch}]}
    ]) of
        {ok, _Pid} ->
            ok;
        {error, Reason} ->
            lager:warning("ms_http_app start_http error: ~p~n", [Reason]),
            ok
    catch
        _:_ -> ok
    end.

-spec stop() -> ok.

stop() ->
     cowboy:stop_listener(?APP).
