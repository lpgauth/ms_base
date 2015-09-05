#!/bin/bash
exec erl -sname ms_base_dev2 \
         -pa ebin deps/*/ebin test \
         -config config/dev \
         -boot start_sasl \
         -s ms_base_app
