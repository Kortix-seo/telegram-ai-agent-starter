# The approval split in an open source Telegram agent

A Telegram bot answers in a chat in under a second. The question that takes
longer is who answers for it when it writes into a company system. This project
splits that into three decisions, and each one is made somewhere different. The
split is the reason the manifest in this repository can be handed to a team.

## Decision 1: the question in the chat

The agent asks with its question tool, and the choice arrives as buttons. One
question shows one button per option; several questions arrive one at a time and
the agent gets every answer together after the last tap (Kortix v0.14.16,
2026-11-03).

What the chat decides: which ticket to read, which report to run, which of two
drafts to work on. What it never decides: whether an action that changes a
company system may happen.

## Decision 2: the held connector call

A connector call that writes is held by Kortix. A person decides it on
**Review → Needs you**, or on the approval card in a Slack or Teams thread. The
card shows the title, a summary, a risk note and the buttons; every card also
has **View in Kortix**.

Telegram has no account link — the allowed-user list is the only identity the
channel carries — so a connector approval is not a tap in the Telegram chat.
Anyone who tells you otherwise is describing a different product.

`kortix.yaml` bounds the wait:

```yaml
approvals:
  ttl: 24h
```

Kortix clamps the value to 5 minutes through 30 days; the default is 24 hours. A
held call that expires is not an approval, and the agent must not retry it as
one.

## Decision 3: what reaches `main`

Session work reaches `main` through a change request. Merge is default-deny for
agents. The manifest grants:

```yaml
kortix_permissions:
  - project.read
  - project.file.read
  - project.file.write
  - project.session.start
  - project.session.read
  - project.review.read
  - project.review.submit
  - project.connector.read
```

`project.gitops.merge` is not on that list. A chat message can start a session
that opens a change request; it cannot land the commit.

## Why the split matters to a reader deciding

Two failure modes look the same in a demo and are different in production:

- **Everything in the chat.** The agent asks "shall I send it?" and the person
  taps yes. That works until the person who taps is not the person who owns the
  system, or until nobody can tell afterwards who approved what.
- **Nothing in the chat.** Every action needs a ticket, and the agent is a
  slower way to file one.

The split here keeps the fast loop in the chat and the accountable loop in the
review queue: the chat decides conversation, a named person decides writes, a
change request decides what ships. Every action is recorded, so the audit log
matches the conversation.

## Reading next

- `docs/telegram-setup.md` — BotFather, allowed users, DM vs group, the eleven
  commands, the 8 MB file limit, each with its source.
- `skills/approvals/SKILL.md` — the rules the agent loads before it plans a
  write.
- The site's page on
  [approvals in Telegram](https://agentsfortelegram.com/approvals-in-telegram)
  for the same split with the screens a person actually sees.

Sources: <https://kortix.com/docs/guide#channels> and
<https://github.com/kortix-ai/CompanyOS>, read 2026-11-04.
