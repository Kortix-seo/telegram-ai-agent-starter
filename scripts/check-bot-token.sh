#!/usr/bin/env bash
# Check a Telegram bot token without printing it.
#
#   TELEGRAM_BOT_TOKEN=123456:ABC... ./scripts/check-bot-token.sh
#
# Calls Telegram's getMe on the token and prints the bot's id and username, so
# you can confirm the token is live and belongs to the bot you think it does
# before you paste it into Project admin -> Connectors -> Channels in an open
# source Kortix project.

set -euo pipefail

if [ -z "${TELEGRAM_BOT_TOKEN:-}" ]; then
  echo "error: set TELEGRAM_BOT_TOKEN to the token @BotFather gave you" >&2
  exit 2
fi

response="$(curl -sS --max-time 15 \
  "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getMe")" || {
  echo "error: could not reach api.telegram.org" >&2
  exit 3
}

ok="$(printf '%s' "$response" | sed -n 's/.*"ok":[[:space:]]*\(true\|false\).*/\1/p')"
if [ "$ok" != "true" ]; then
  # Telegram's error text never contains the token; print it, drop nothing else.
  description="$(printf '%s' "$response" | sed -n 's/.*"description":[[:space:]]*"\([^"]*\)".*/\1/p')"
  echo "invalid token: ${description:-unknown error}" >&2
  exit 1
fi

bot_id="$(printf '%s' "$response" | sed -n 's/.*"id":[[:space:]]*\([0-9]*\).*/\1/p')"
bot_username="$(printf '%s' "$response" | sed -n 's/.*"username":[[:space:]]*"\([^"]*\)".*/\1/p')"

echo "token ok"
echo "bot id:   ${bot_id:-unknown}"
echo "bot name: @${bot_username:-unknown}"
echo
echo "Next: Project admin -> Connectors -> Channels -> Connect on Telegram,"
echo "then paste the token and the allowed Telegram user ids there."
