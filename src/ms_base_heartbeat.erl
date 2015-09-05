-module(ms_base_heartbeat).
-include("ms_base.hrl").

-export([
    start_link/0
]).

-behaviour(gen_server).
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-define(HEARTBEAT_MSG, heartbeat).

-record(state, {
    heartbeat_delay :: pos_integer(),
    timer_ref       :: reference()
}).

-type state() :: #state {}.

%% public
-spec start_link() -> {ok, pid()}.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% gen_server callbacks
-spec init([]) -> {ok, state()}.

init([]) ->
    HeartbeatDelay = ?ENV(heartbeat_delay, ?DEFAULT_HEARTBEAT_DELAY),

    heartbeat(),

    {ok, #state {
        heartbeat_delay = HeartbeatDelay,
        timer_ref = heartbeat_timer(HeartbeatDelay)
    }}.

-spec handle_call(term(), term(), state()) -> {reply, ignored, state()}.

handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

-spec handle_cast(term(), state()) -> {noreply, state()}.

handle_cast(_Msg, State) ->
    {noreply, State}.

-spec handle_info(?HEARTBEAT_MSG, state()) -> {noreply, state()}.

handle_info(?HEARTBEAT_MSG, #state {
        heartbeat_delay = Heartbeat
    } = State) ->

    reconnaissance:discover(),
    resource_discovery:trade_resources(),

    {noreply, State#state {
        timer_ref = heartbeat_timer(Heartbeat)
    }}.

-spec terminate(term(), state()) -> ok.

terminate(_Reason, _State) ->
    ok.

-spec code_change(term(), state(), term()) -> {ok, state()}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% private
heartbeat() ->
    reconnaissance:discover(),
    resource_discovery:trade_resources().

heartbeat_timer(HeartbeatDelay) ->
    erlang:send_after(HeartbeatDelay, self(), ?HEARTBEAT_MSG).
