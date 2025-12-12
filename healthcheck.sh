#!/bin/bash -e

set -e

rcon -a "127.0.0.1:${RCON_PORT}" -p "${RCON_PASSWORD}" players
