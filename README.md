# ZUQ for Claude Code and other agents

ZUQ (https://zuq.si) turns a prompt or a document into a narrated, animated explainer video, a video course or a training video. This plugin connects your agent to your own ZUQ account through ZUQ's remote MCP server and adds two skills that teach the agent how to brief a video and how to plan a course.

## What it does

It starts builds in your ZUQ account, checks their progress, lists the videos you made, and reports the minutes you have left. Each build uses that account's minutes of video, and your agent may ask you to approve it first. Videos are private by default and play on their own page at zuq.si. Each video is a sequence of animated scenes - text, diagrams, charts and worked examples - rendered from code, with a synthesized voice reading the script over background music that may be AI-generated. No video generation model is used.

ZUQ explains what a document says; it does not give legal, financial or medical advice. Do not send documents that hold health records, ID numbers or payment details.

## What it sends, and to whom

- Only what each tool call carries goes to https://zuq.si/mcp over HTTPS: your request in your own words, the chosen length and level, and, when you ask for a video of a document or a course from your notes, the text of that document, up to 20,000 characters. ZUQ keeps that request, including any document text, with the video in your account.
- What ZUQ stores per video: the request text, the scene code, the soundtrack (narration and background music), a status file and a poster image. A video and its request are kept in your ZUQ account until you delete the video or your account; no MP4 is stored.
- ZUQ never receives your conversation, and it never reads or fetches your files itself.
- ZUQ sends back only facts about your own videos and account: titles, status, progress, watch and share links, minutes left and length limits. If your agent asks for it when you connect, it also receives your ZUQ account email address and whether it is verified.
- Sign-in happens on zuq.si with OAuth. The plugin stores no password, key or token in its files.

## What it runs

Nothing local. The plugin is two skills (skills/) and one remote MCP server entry (.mcp.json). It has no hooks, commands, agents, binaries or scripts that Claude Code runs, and it fetches nothing else.

The evals/ folder holds test cases for `claude plugin eval`. They run only when you start that command yourself, they answer from mock files instead of the real server, and every run is a paid model call.

The openai/ folder holds the ChatGPT and Codex package (it points at https://zuq.si/mcp/openai) and the script that zips it; Claude Code never reads or runs it.

## Install in Claude Code

In a Claude Code session:

```
/plugin marketplace add ashishsalve/zuq-plugin
/plugin install zuq@zuq
```

Or from a shell:

```
claude plugin marketplace add ashishsalve/zuq-plugin
claude plugin install zuq@zuq
```

On Claude Code v2.1.292 or later, one step works too: `claude plugin install zuq --marketplace ashishsalve/zuq-plugin`. Then run `/mcp` in Claude Code and authenticate the zuq server; sign-in opens zuq.si in your browser. You need a ZUQ account with a confirmed email; a new account completes a one-time check on zuq.si before its first build.

## Repository layout

- Claude Code plugin and marketplace (this folder is both): .claude-plugin/plugin.json, .claude-plugin/marketplace.json, .mcp.json (https://zuq.si/mcp), skills/, assets/icon.png, evals/.
- ChatGPT and Codex package: openai/plugin.json, openai/mcp.json (https://zuq.si/mcp/openai), openai/assets/, openai/build-openai-zip.sh. The script copies the shared skills/ and the images into a ZIP whose root holds plugin.json, mcp.json, skills/ and assets/. Run `sh openai/build-openai-zip.sh`; the ZIP lands in openai/dist/.

## Links

Privacy policy: https://zuq.si/privacy-policy/. Terms: https://zuq.si/terms-of-service/. Help: https://zuq.si/docs/chatgpt-and-claude/ or billing@zuq.si (support and security reports).

ZUQ is published by Ashish Salve (9owls, Inc.). Source: https://github.com/ashishsalve/zuq-plugin. The files in this repository are under the MIT license (LICENSE); the ZUQ service is under its own terms.
