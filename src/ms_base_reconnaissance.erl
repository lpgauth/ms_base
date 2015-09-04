-module(ms_base_reconnaissance).

-export([
    request/0,
    response/3,
    handle_response/3
]).

%% public
request() ->
    <<"ping">>.

response(_IP, _Port, _Request) ->
    term_to_binary(node()).

handle_response(IP, Port, Response) ->
    net_adm:ping(binary_to_term(Response)),
    {IP, Port, Response}.
