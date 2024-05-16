#!/bin/bash

# Trap SIGTERM
_sigterm() {
    echo "Run script caught signal.  Telling programs to exit."
    kill -TERM "$shiny_pid"
    kill -TERM "$nginx_pid"
}
trap _sigterm SIGTERM
trap _sigterm SIGINT

# First, run the Shiny app on port 8001
PYTHONPATH=/usr/local/src/myscripts/app DEBUG=TRUE /usr/local/src/myscripts/bin/pipenv run uvicorn --host=0.0.0.0 --port=8001 --log-level=debug app:app &
shiny_pid=$!

# Next, run the proxy server on port 8000
nginx -g "daemon off;" &
nginx_pid=$!

# Wait for both things to exit, then end
wait
