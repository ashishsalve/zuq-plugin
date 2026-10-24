---
name: zuq-make-video
description: Make a narrated, animated ZUQ video from a question or a document. Use when the user asks for an explainer video, a video that teaches or explains something, or a plain-words video of a handbook, policy, research paper or notes they shared.
---

# Make a ZUQ video

1. Choose the tool. The user asked for a video of a document they shared: create_document_video. One topic or question: create_explainer_video. A whole subject in several lessons: follow the zuq-plan-course skill.
2. Settle what is missing, with one question at most: the length in whole minutes (suggest 3 when none is given), the level (beginner, intermediate, advanced or expert; intermediate by default) and, for a document, what to focus on.
3. For a document, pass its own text in document_text, not a summary, up to 20,000 characters, and its file name or title in document_name. If it is longer, ask which part to explain. Only make a document video when the user asks for one. Do not send a document that holds health records, ID numbers or payment details.
4. Tell the user the build uses that many minutes of their ZUQ account, then call the tool once.
5. Reply with the title, that it is building, and the watch_url. Never call a create tool again for the same request.
6. Call get_video after a create tool when the user asks how it is going; give the status in one line, and the watch link when it is done.
7. If a tool returns an error, pass on its message and link as written. Do not suggest buying anything.
