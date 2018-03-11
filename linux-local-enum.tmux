#! /usr/bin/env bash

CURRENT_DIR=$(absdir $(dirname ${BASH_SOURCE[0]}))
echo $CURRENT_DIR

tmux bind-key M-e run-shell ${CURRENT_DIR}/scripts/linux-local-enum.sh
