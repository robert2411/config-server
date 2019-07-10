#!/usr/bin/env bash
sleep 10
curl --connect-timeout 5 \
    --max-time 10 \
    --retry 10 \
    -sS http://config-server:8080/health || exit 1