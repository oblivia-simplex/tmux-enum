#! /usr/bin/env bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
CURRENT_DIR=$(cd $CURRENT_DIR && pwd)
echo $CURRENT_DIR

tmux bind-key M-e run-shell ${CURRENT_DIR}/scripts/linux-local-enum.sh
