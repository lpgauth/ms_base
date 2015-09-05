-module(ms_base_global).
-include("ms_base.hrl").

-export([
    lookup/1,
    register/2,
    start/0,
    stop/0,
    unregister/1
]).

%% public
-spec lookup(atom()) -> term() | undefined.

lookup(Name) ->
    try ets:lookup_element(?ETS_GLOBAL, Name, 2)
    catch
        error:badarg ->
            undefined
    end.

-spec register(atom(), term()) -> ok | registered_name.

register(Name, Object) ->
    try
        ets:insert_new(?ETS_GLOBAL, {Name, Object}),
        ok
    catch
        error:badarg ->
            registered_name
    end.

-spec start() -> ok.

start() ->
    Opts = [
        set,
        named_table,
        public,
        {read_concurrency, true}
    ],

    try
        ets:new(?ETS_GLOBAL, [set] ++ Opts),
        ok
    catch
        error:badarg ->
            ok
    end.

-spec stop() -> ok.

stop() ->
    try
        ets:delete(?ETS_GLOBAL),
        ok
    catch
        error:badarg ->
            ok
    end.

-spec unregister(atom()) -> ok.

unregister(Name) ->
    ets:delete(?ETS_GLOBAL, Name),
    ok.
