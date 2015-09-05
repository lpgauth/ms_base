-module(ms_base).
-include("ms_base.hrl").

-export([
    apply/4,
    apply_all/4
]).

%% public
-spec apply(atom(), module(), atom(), [term()]) -> term() | {badrpc, term()}.

apply(Type, Module, Function, Args) ->
    Local = ?ENV(local_resource_types, ?DEFAULT_LOCAL_TYPES),
    case lists:any(fun (Type2) -> Type =:= Type2 end, Local) of
        true ->
            erlang:apply(Module, Function, Args);
        false ->
            case resource_discovery:get_resource(Type) of
                {ok, Node} ->
                    rpc:call(Node, Module, Function, Args);
                {error, not_found} ->
                    {badrpc, no_node}
            end
    end.

-spec apply_all(atom(), module(), atom(), [term()]) ->
    [term() | {badrpc, term()}].

apply_all(Type, Module, Function, Args) ->
    Local = node(),
    io:format("~p~n", [resource_discovery:get_resources(Type)]),
    lists:map(fun (Node) ->
        case Node of
            Local -> erlang:apply(Module, Function, Args);
            _ -> rpc:call(Node, Module, Function, Args)
        end
    end, resource_discovery:get_resources(Type)).
