#!/bin/sh
set -e

CFG_FILE="/etc/tac_plus/tac_plus.cfg"
USER_FILE="/etc/tac_plus/tac_user.cfg"
BIN="/usr/local/sbin/tac_plus"

if [ ! -x "$BIN" ]; then
  echo "Error: $BIN not found or not executable!"
  exit 1
fi

if [ ! -f "$CFG_FILE" ]; then
  echo "Error: $CFG_FILE not found!"
  exit 1
fi

if [ ! -f "$USER_FILE" ]; then
  echo "Warning: file $USER_FILE not found, continuing anyway"
fi

echo "Starting TACACS+ with config $CFG_FILE"
exec "$BIN" -f -d 16 "$CFG_FILE"