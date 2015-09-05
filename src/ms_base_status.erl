-module(ms_base_status).
-include("ms_base.hrl").

-compile({parse_transform, ms_base_parse_transform}).

-behaviour(cowboy_http_handler).
-export([
  init/3,
  handle/2,
  terminate/3
]).

%% public
-spec init({tcp, http}, cowboy_req:req(), []) ->
    {ok, cowboy_req:req(), undefined}.

init(_, Req, []) ->
    {ok, Req, undefined}.

-spec handle(cowboy_req:req(), undefined) ->
    {ok, cowboy_req:req(), undefined}.

handle(Req, undefined) ->
    Body = status(),
    {ok, Req2} = cowboy_req:reply(200, [?CONTENT_TYPE_JSON], Body, Req),
    {ok, Req2, undefined}.

-spec terminate(term(), cowboy_req:req(), undefined) -> ok.

terminate(_Reason, _Req, undefined) ->
    ok.

%% private
unix_time() ->
    {Mega, Sec, Micro} = os:timestamp(),
    (Mega * 1000000 * 1000000 + Sec * 1000000) + Micro.

status() ->
    jiffy:encode({[
        {<<"status">>, <<"OK">>},
        {<<"git_sha">>, GIT_SHA},
        {<<"build_date">>, BUILD_DATE},
        {<<"now_unix">>, unix_time()}
    ]}, [pretty]).
