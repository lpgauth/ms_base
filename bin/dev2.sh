#!/bin/bash
exec erl -sname ms_base_dev2 \
         -pa ebin deps/*/ebin test \
         -config config/dev2 \
         -boot start_sasl \
         -s ms_base_app \
         -setcookie secret
