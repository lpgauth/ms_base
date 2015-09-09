-module(ms_base_metric).
-include("ms_base.hrl").

-export([
    gauge/3,
    increment/3,
    timing/3
]).

-type sample_rate() :: 0..1 | float().

%% public
-spec gauge(iolist(), integer(), sample_rate()) -> ok.

gauge(Key, Value, SampleRate) ->
    statsderl:gauge(Key, Value, SampleRate).

-spec increment(iolist(), integer(), sample_rate()) -> ok.

increment(Key, Value, SampleRate) ->
    statsderl:gauge(Key, Value, SampleRate).

-spec timing(iolist(), integer(), sample_rate()) -> ok.

timing(Key, Value, SampleRate) ->
    statsderl:gauge(Key, Value, SampleRate).
