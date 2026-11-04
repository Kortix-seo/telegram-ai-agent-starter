---
name: approvals
description: What an agent may decide in a Telegram chat, what waits for a person on the Review page, and what reaches main. Load before any step that writes into a company system.
---

# Approvals

An open source project still has to decide who may do what. In this project the
decisions are split three ways, and the split is the point: the chat decides
conversation, a person decides writes, and a change request decides what reaches
`main`.

## Before you act

1. Name the action: the system it touches, the record it changes, and what
   happens if it is wrong.
2. Classify it:
   - **Reads.** Read freely. Reading a ticket, a repository file or a report
     needs no approval.
   - **Writes inside the session.** Edit files in `/workspace`, run commands,
     build and test. These stay in your branch; nothing outside the session
     changes.
   - **Writes into a company system.** A connector call that creates, updates,
     deletes, sends or pays. Stop and follow "A held call" below.
   - **A change to `main`.** Open a change request. Never merge.
3. If you cannot classify it, treat it as a write into a company system.

## A held call

A held connector call is decided on **Review → Needs you**, or on the approval
card in a Slack or Teams thread. Telegram has no account link, so the decision
is not a tap in the Telegram chat.

When you hold a call, reply with:

- the action, in one sentence, in the words the person would use;
- the system and the record it touches;
- the consequence of approving and of denying;
- where the decision waits: the Review page, under **Needs you**.

Then stop. Do not retry the call, do not look for a shortcut through a second
connector, and do not perform part of it while you wait. A held call expires
(`approvals.ttl` in `kortix.yaml`, 24 hours in this project), and an expired
call is not an approval.

## A change request

Session work reaches `main` through a change request; merge is default-deny for
agents. Open the change request with a title that says what changes and a body
that says why, plus the commands you ran and their output. A person merges. If a
review asks for a change, fix it on the same branch and push.

## Things that are never a chat decision

- Adding a new credential. Name the connector or secret the task needs and stop.
- Deleting data. Describe the deletion, hold it, and let a person decide.
- Merging to `main`.
- Anything a person would have to take on trust because they cannot see the
  action in the review queue first.

## What to write down

Every action is recorded. In your reply name the record you touched — the file,
the ticket id, the change request number — so a reader of the audit log can
match the entry to the conversation.
