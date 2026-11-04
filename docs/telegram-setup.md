# Connect Telegram to an open source Kortix project

Everything below is what the Kortix Guide documents for the Telegram channel,
with the page it comes from. Read on 2026-11-04.

Source: <https://kortix.com/docs/guide#channels>

## 1. Create the bot

In Telegram, message **@BotFather**, send `/newbot`, and copy the token it gives
you. The bot exists as soon as BotFather answers; nothing about Kortix is
involved yet.

## 2. Connect the channel in Kortix

In Kortix open **Project admin → Connectors**, select the **Channels** scope,
select **Connect** on Telegram, and paste:

- the **bot token** BotFather gave you;
- the **allowed Telegram user ids**.

Kortix keeps the token on the server. It is not written to `kortix.yaml`, not
placed in a session workspace, and it does not belong in this repository.

Channels connect a project to Slack, Microsoft Teams, Telegram and Discord. A
mention or a direct message reaches the project's agent, and the agent replies
in the same thread.

## 3. Who may talk to the bot

The allowed-user list decides who may talk to the bot. Telegram has no account
link, so a Kortix account is not what grants access here.

- A message from an allowed user starts a session.
- Anyone else gets a reply showing their user ID. A private chat with the bot
  also puts them under **Allowed users → Wants access**, where a project manager
  allows them with one click.

A user id is a number, and it is the only identity Telegram gives you. Treat the
list as the access control it is: remove an id and that person's next message is
no longer a session.

## 4. What the bot reads

- **Direct chat.** Every message goes to the agent, including one that starts
  with `/` and is a command for another bot.
- **Group.** The bot reads only commands, replies to it and mentions.
- **Files.** Photos, files, voice notes and videos reach the agent; Kortix
  downloads up to 8 MB of files per message into the session's workspace.
- **Order.** Messages arrive in the order they were sent.

## 5. Sessions

One chat is one session. In a forum group, each topic is its own session. After
`/new`, the next message starts a new session.

A session's agent writes only in the chat that started it: it sends, edits and
deletes messages only there and in its topics, and quotes only messages from
there.

## 6. The commands Kortix keeps

Eleven verbs: `new`, `reset`, `stop`, `cancel`, `status`, `model`, `models`,
`agent`, `agents`, `help` and `start`.

- `/status` shows the chat's project, agent, model and session.
- `/stop` stops the agent's run.
- `/model` and `/agent` switch the chat to another model or agent.

Everything else in a direct chat is a message to the agent.

## 7. Questions arrive as buttons

The agent is told to ask with its question tool, so a choice arrives as buttons,
not as a typed list. One question shows one button per option. Several questions
arrive one at a time, and the agent gets every answer together after the last
tap.

This shipped in Kortix v0.14.16 on 2026-11-03: "Answer agent questions with
Telegram buttons, including several questions at once (#11469)."
(<https://github.com/kortix-ai/CompanyOS/releases/tag/v0.14.16>)

## 8. Where an approval happens (not in the chat)

A held connector call is decided on **Review → Needs you**, in Kortix, or on the
approval card in a Slack or Teams thread. Telegram has no account link, so a
connector approval is not a tap in the Telegram chat. `docs/approval-split.md`
covers the three decisions and where each one is made.

## 9. Check the token before you connect it

```bash
TELEGRAM_BOT_TOKEN=123456:ABC... ./scripts/check-bot-token.sh
```

The script calls `getMe` and prints the bot's username and id. It reads the
token from the environment and never prints it, so the output is safe to paste
into a ticket.
