#!/bin/bash
exec erl -sname ms_base_dev \
         -pa ebin deps/*/ebin test \
         -config config/dev \
         -boot start_sasl \
         -s ms_base_app \
         -setcookie secret
