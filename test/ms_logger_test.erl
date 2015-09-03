-module(ms_logger_test).
-include("../include/ms_logger.hrl").
-include_lib("eunit/include/eunit.hrl").

-define(LOG_FILE, "../log/2015-09-03-09.log").
-define(TIMESTAMP, {1441, 271599, 757400}).

-spec test() -> ok.

-spec logger_test() -> ok.

logger_test() ->
    % no_tty(),

    ms_logger_app:start(),

    file:delete(?LOG_FILE),

    ms_logger:log(?TIMESTAMP, <<"test">>),
    ms_logger:log(?TIMESTAMP, <<"test">>),

    {ok, Log} = file:read_file(?LOG_FILE),
    ?assertEqual(<<"">>, Log),

    ms_logger_app:stop().

% no_tty() ->
%     error_logger:tty(false),
%     application:load(lager),
%     application:set_env(lager, error_logger_redirect, false).
