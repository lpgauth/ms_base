-module(ms_base_metric).
-include("ms_base.hrl").

-export([
    gauge/3,
    increment/3,
    timing/3
]).

-type key() :: binary() | iolist().
-type sample_rate() :: 0..1 | float().

%% public
-spec gauge(key(), integer(), sample_rate()) -> ok.

gauge(Key, Value, SampleRate) ->
    statsderl:gauge(Key, Value, SampleRate).

-spec increment(key(), integer(), sample_rate()) -> ok.

increment(Key, Value, SampleRate) ->
    statsderl:gauge(Key, Value, SampleRate).

-spec timing(key(), integer(), sample_rate()) -> ok.

timing(Key, Value, SampleRate) ->
    statsderl:gauge(Key, Value, SampleRate).
