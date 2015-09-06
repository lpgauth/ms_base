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

-spec apply_all(atom(), module(), atom(), [term()]) ->
    [term() | {badrpc, term()}].

apply_all(Type, Module, Function, Args) ->
    Local = node(),
    lists:map(fun (Node) when Node =:= Local ->
            erlang:apply(Module, Function, Args);
                  (Node) ->
            case rpc:call(Node, Module, Function, Args) of
                {badrpc, Reason} = Error ->
                    lager:warning("ms_base ~p badrpc: ~p~n", [Type, Reason]),
                    Error;
                Response ->
                    Response
            end
    end, resource_discovery:get_resources(Type)).
