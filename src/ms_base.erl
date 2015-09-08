-module(ms_base).
-include("ms_base.hrl").

-export([
    apply/4,
    apply_all/4,
    apply_all_not_local/4
]).

%% public
-spec apply(atom(), module(), atom(), [term()]) ->
    term() | {error, not_found} | {badrpc, term()}.

apply(Type, Module, Function, Args) ->
    Local = ?ENV(local_resource_types, ?DEFAULT_LOCAL_TYPES),
    case lists:any(fun (Type2) -> Type =:= Type2 end, Local) of
        true ->
            erlang:apply(Module, Function, Args);
        false ->
            case resource_discovery:get_resource(Type) of
                {ok, Node} ->
                    case rpc:call(Node, Module, Function, Args) of
                        {badrpc, Reason} = Error ->
                            lager:warning("ms_base ~p badrpc: ~p~n", [Type, Reason]),
                            Error;
                        Response ->
                            Response
                    end;
                {error, not_found} = Error ->
                    lager:warning("ms_base ~p badrpc: not_found~n", [Type]),
                    Error
            end
    end.

-spec apply_all(atom(), module(), atom(), [term()]) -> [term()].

apply_all(Type, Module, Function, Args) ->
    Local = node(),
    Nodes = resource_discovery:get_resources(Type),
    apply_map(Nodes, Type, Module, Function, Args, Local).

-spec apply_all_not_local(atom(), module(), atom(), [term()]) -> [term()].

apply_all_not_local(Type, Module, Function, Args) ->
    Local = node(),
    Nodes = resource_discovery:get_resources(Type),
    apply_map(Nodes -- [Local], Type, Module, Function, Args, Local).

%% private
apply_map([], _Type, _Module, _Function, _Args, _Local) ->
    [];
apply_map([Node | T], Type, Module, Function, Args, Local) when Node =:= Local ->
    [erlang:apply(Module, Function, Args) | apply_map(T, Type, Module, Function, Args, Local)];
apply_map([Node | T], Type, Module, Function, Args, Local) ->
    case rpc:call(Node, Module, Function, Args) of
        {badrpc, Reason} ->
            lager:warning("ms_base ~p badrpc: ~p~n", [Type, Reason]),
            apply_map(T, Type, Module, Function, Args, Local);
        Response ->
            [Response | apply_map(T, Type, Module, Function, Args, Local)]
    end.
