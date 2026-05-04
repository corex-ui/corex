#!/bin/sh -e

mix local.rebar --force
mix local.hex --force

# Install Dependencies
apk add --no-progress --update git socat make gcc libc-dev cmake g++

# Set up local proxies
socat TCP-LISTEN:5432,fork TCP-CONNECT:postgres:5432&

# Run installer tests
echo "Running installer tests"
cd installer
mix deps.get
mix test

echo "Running integration tests"
cd ../integration_test
mix deps.get
mix test --include database
