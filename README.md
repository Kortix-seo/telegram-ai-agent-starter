# telegram-ai-agent-starter

An open source starter for a Telegram AI agent that does company work: a
Kortix project manifest, the agent's prompt, the approval rules it loads, and
a token check you can run before anything else.

Kortix is the open source CompanyOS: your agents, their skills, your company
memory, and every connector in one git repo you own, with the agents working
on real cloud computers.

## The bot is the easy part

@BotFather gives anyone a working Telegram bot in under a minute, and every
tutorial stops there. What decides whether you can hand that bot company work
is a different question: which actions the chat may decide on its own, and
which ones wait for a named person. Get that split wrong and the agent either
does nothing useful or writes to a system nobody approved.

This repo is that split, as three files you can read and diff before you run
them:

- `kortix.yaml` — what the agent is allowed to reach. Note what is absent:
  `project.gitops.merge` is not in the permission list, so the agent can open a
  change request and cannot merge it.
- `agents/telegram-ops.md` — the prompt: ask with the question tool, never
  take a credential into the chat, say where a held action waits.
- `skills/approvals/SKILL.md` — the rules the agent loads for the actions that
  touch a company system.

## Quick start

1. In Telegram, message **@BotFather**, send `/newbot`, and copy the token it
   gives you.
2. Copy this repo into a Kortix project (or start a project from it) so
   `kortix.yaml` sits at the repository root.
3. In Kortix open **Project admin → Connectors**, select the **Channels**
   scope, select **Connect** on Telegram, and paste the bot token and the
   allowed Telegram user ids. Kortix keeps the token on the server.
4. Check the token from a shell before you connect anything:

   ```bash
   TELEGRAM_BOT_TOKEN=123456:ABC... ./scripts/check-bot-token.sh
   ```

The script calls Telegram's `getMe` and prints the bot's username and id. It
never prints the token.

## Telegram setup

`docs/telegram-setup.md` has the BotFather steps, the allowed-user list, what
the bot reads in a direct chat versus a group, the eleven commands Kortix
keeps, and the file limit. Every line has its source.

## The approval split

`docs/approval-split.md` walks the three cases people ask about: a question the
agent asks in the chat, a connector call that has to wait, and a change that
has to reach `main`. Short version:

- **Questions come as buttons.** The agent is told to ask with its question
  tool, so a choice arrives as buttons, not as a typed list. Several questions
  arrive one at a time, and the agent gets every answer together after the last
  tap (Kortix v0.14.16, 2026-11-03).
- **A held connector call waits on the Review page.** The approval card lives
  in a Slack or Teams thread, and the decision is also at **Review → Needs
  you**. Telegram has no account link, so a connector approval is not a tap in
  the Telegram chat — the Guide documents the card for Slack and Teams.
- **Merge is default-deny for agents.** Session work reaches `main` through a
  change request. The manifest in this repo grants no merge permission.

The queue for held calls is bounded by `approvals.ttl` in `kortix.yaml` (24
hours here); Kortix clamps the value to 5 minutes through 30 days.

## What each file is

| Path | What it holds |
| --- | --- |
| `kortix.yaml` | Project manifest: the agent, its grants, the approval TTL. No version line — the format has none. |
| `agents/telegram-ops.md` | The agent's whole system prompt. |
| `skills/approvals/SKILL.md` | The approval rules the agent loads by name. |
| `docs/telegram-setup.md` | BotFather, allowed users, DM vs group, commands, file limit. |
| `docs/approval-split.md` | The three decisions and where each is made. |
| `scripts/check-bot-token.sh` | `getMe` check for a token, without echoing it. |

## Reading, in order

If you are deciding whether an agent in Telegram is worth connecting, these
pages answer one question each, and each shows its source:

- [An open source Telegram AI agent with work a person approves](https://agentsfortelegram.com/) — what comes back to the chat and what waits.
- [Open source Telegram AI agents you can read before they run](https://agentsfortelegram.com/open-source-telegram-ai-agent) — compare agents by the file behind them instead of by the demo.
- [Where an open source Telegram agent keeps company logins](https://agentsfortelegram.com/telegram-agent-with-company-tools) — the bot token is not the CRM login.
- [An open source Telegram agent's approval waits on the Review page](https://agentsfortelegram.com/approvals-in-telegram) — one exact action, one named person.
- [Telegram vs Slack for open-source AI agents: what a message proves](https://agentsfortelegram.com/telegram-vs-slack-for-ai-agents) — what a channel can and cannot prove about the sender.
- [An open source Telegram agent on your server runs in three parts](https://agentsfortelegram.com/self-hosted-telegram-agent) — where a self-hosted instance ends and the session sandbox begins.

## What is not in this repo

No bot token, no connector credentials, no `.env`. Kortix keeps the bot token
on the server and brokers connector credentials server-side, so neither belongs
in a git repository. The manifest carries grant names, never secrets.

Documentation sources are the live Kortix Guide (https://kortix.com/docs/guide)
and the Kortix repository (https://github.com/kortix-ai/CompanyOS), read on
2026-11-04.
