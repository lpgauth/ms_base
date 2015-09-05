-module(ms_base_cowboy).
-include("ms_base.hrl").

-export([
    start/0,
    stop/0
]).

%% public
-spec start() -> ok.

start() ->
    StatusIp = ?ENV(status_ip, ?DEFAULT_STATUS_IP),
    StatusPort = ?ENV(status_port, ?DEFAULT_STATUS_PORT),

    Dispatch = cowboy_router:compile([{'_', [
        {"/status", ms_base_status, []}
    ]}]),

    try cowboy:start_http(?APP, 2, [
        {ip, StatusIp},
        {port, StatusPort}
    ], [
        {env, [{dispatch, Dispatch}]}
    ]) of
        {ok, _Pid} ->
            ok;
        {error, Reason} ->
            lager:warning("ms_base_cowboy start_http error: ~p~n", [Reason]),
            ok
    catch
        _:_ -> ok
    end.

-spec stop() -> ok.

stop() ->
     cowboy:stop_listener(?APP).
