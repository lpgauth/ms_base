-module(ms_base_app).
-include("ms_base.hrl").

%% public
-export([
    start/0,
    stop/0
]).

-behaviour(application).
-export([
    start/2,
    stop/1
]).

%% public
-spec start() -> {ok, [atom()]}.

start() ->
    application:ensure_all_started(?APP).

-spec stop() -> ok | {error, {not_started, ?APP}}.

stop() ->
    application:stop(?APP).

%% application callbacks
-spec start(application:start_type(), term()) -> {ok, pid()}.

start(_StartType, _StartArgs) ->
    Local = ?ENV(local_resource_types, ?DEFAULT_LOCAL_TYPES),
    Target = ?ENV(target_resource_types, ?DEFAULT_TARGET_TYPES),

    [resource_discovery:add_local_resource_tuple({Type, node()}) ||
        Type <- Local],
    resource_discovery:add_target_resource_types(Target),
    reconnaissance:discover(),

    ms_base_sup:start_link().

-spec stop(term()) -> ok.

stop(_State) ->
    {ok, Local} = application:get_env(?APP, local_resource_types),

    [resource_discovery:delete_local_resource_tuple({Type, node()}) ||
        Type <- Local],
    resource_discovery:trade_resources(),

    ok.
