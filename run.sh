#!/bin/bash

# First, run the Shiny app on port 8001
PYTHONPATH=/usr/local/src/myscripts/app DEBUG=TRUE /usr/local/src/myscripts/bin/pipenv run uvicorn --host=0.0.0.0 --port=8001 --log-level=debug app:app &

# Next, run the proxy server on port 8000
nginx -g "daemon off;" &

# Wait for both things to exit, then end
wait
