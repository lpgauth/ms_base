-module(ms_base_sup).
-include("ms_base.hrl").

%% public
-export([
    start_link/0
]).

-behaviour(supervisor).
-export([
    init/1
]).

%% public
-spec start_link() -> {ok, pid()}.

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% supervisor callbacks
-spec init([]) -> {ok, {{one_for_one, 5, 10}, [supervisor:child_spec()]}}.

init([]) ->
    {ok, {{one_for_one, 5, 10}, [
        ?CHILD(ms_base_heartbeat)
    ]}}.
