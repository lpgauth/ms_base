-module(ms_base_reconnaissance).

-export([
    request/0,
    response/3,
    handle_response/3
]).

%% public
-spec request() -> binary().

request() ->
    <<"ping">>.

-spec response(tuple(), pos_integer(), binary()) -> binary().

response(_Ip, _Port, _Request) ->
    term_to_binary(node()).

-spec handle_response(tuple(), pos_integer(), binary()) ->
    {tuple(), pos_integer(), binary()}.

handle_response(Ip, Port, Response) ->
    net_adm:ping(binary_to_term(Response)),
    resource_discovery:trade_resources(),
    {Ip, Port, Response}.
