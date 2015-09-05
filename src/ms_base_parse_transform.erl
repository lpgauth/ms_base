-module(ms_base_parse_transform).
-include("ms_base.hrl").

-export([
    parse_transform/2
]).

%% public
-spec parse_transform([erl_parse:abstract_form()], term()) ->
    [erl_parse:abstract_form()].

parse_transform(Forms, _Options) ->
    parse_trans:plain_transform(fun do_transform/1, Forms).

%% private
current_date() ->
    string:strip(os:cmd("date"), right, $\n).

do_transform({var, L, 'BUILD_DATE'}) ->
    {bin, L, [{bin_element, L, {string, L, current_date()}, default, default}]};
do_transform({var, L, 'GIT_SHA'}) ->
    {bin, L, [{bin_element, L, {string, L, git_sha()}, default, default}]};
do_transform(_) ->
    continue.

git_sha() ->
    string:strip(os:cmd("git rev-parse HEAD"), right, $\n).
