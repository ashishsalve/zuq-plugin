---
type: llm
focus: mock_calls
---

PASS if the document_text sent to create_document_video is the handbook text as written: its section numbers (4.1 to 4.4) and its sentences appear word for word, and nothing is left out except, at most, surrounding whitespace.
FAIL if document_text is a summary, a paraphrase or a shortened version of the handbook text, or if create_document_video was not called.
