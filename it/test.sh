#!/usr/bin/env bash
sleep 10
curl -sS http://config-server:8080/health || exit 1