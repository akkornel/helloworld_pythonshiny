#!/bin/bash

# Trap SIGTERM
_sigterm() {
    echo "Run script caught signal.  Telling programs to exit."
    kill -TERM "$shiny_pid"
    kill -TERM "$nginx_pid"
}
trap _sigterm SIGTERM
trap _sigterm SIGINT

# First, run the Shiny app on port 3838
DEBUG=TRUE /usr/local/src/myscripts/bin/pipenv run shiny run --host=0.0.0.0 --port=3838 --log-level=trace --app-dir=app app &
shiny_pid=$!

# Next, run the proxy server on port 8000
nginx -g "daemon off;" &
nginx_pid=$!

# Wait for both things to exit, then end
wait
