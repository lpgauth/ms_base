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
    {ok, Local} = application:get_env(?APP, local_resource_types),
    {ok, Target} = application:get_env(?APP, target_resource_types),

    [resource_discovery:add_local_resource_tuple({Type, node()}) ||
        Type <- Local],
    resource_discovery:add_target_resource_types(Target),
    resource_discovery:trade_resources(),

    ms_base_sup:start_link().

-spec stop(term()) -> ok.

stop(_State) ->
    Local = resource_discovery:get_local_resource_tuples(),
    resource_discovery:delete_local_resource_tuples(Local),
    resource_discovery:trade_resources(),
    ok.
