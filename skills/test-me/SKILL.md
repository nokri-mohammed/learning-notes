---
name: test-me
description: Quiz the CEO on a topic, one conceptual question at a time, marking each answer briefly before asking the next. Use only when the CEO asks to be tested, for example "test me on X", "quiz me", "check my understanding", on a topic from this session or the notes. Never start a quiz unprompted.
---

# test-me

A short quiz that checks whether the core ideas stuck. It runs only when the CEO asks for it.

## What to ask

- Test only what is worth remembering: the core ideas and why they matter.
- Ask conceptual questions: "Why does a long round trip need a bigger window?", "What problem does
  a reverse proxy solve?".
- Never ask for details: exact figures, sizes, formulas, setting or command names, tuning values,
  dates. "How many KB?" is a bad question.
- Mix recall ("what is X for?") and reasoning ("why does X happen?", "what breaks if X is missing?").
- Start easy and get a little harder. Five questions unless the CEO asks for another number.
- Take the topic from what the CEO named; use this session and the notes in `notes/` as the source,
  so questions match what was actually covered.

## How to run it

1. One question per message. Nothing else in that message: no answer, no hint, no list of upcoming
   questions.
2. Wait for the answer.
3. Mark it in one line: **Correct**, **Partly** or **Not quite**.
4. If it was partly right or wrong, give the short fix in one or two sentences. Do not re-explain a
   concept the CEO already got right.
5. Then ask the next question in the same message.
6. Stop at once when the CEO says stop, enough, or changes the subject.

Keep every message short and plain. No filler, no em dashes, no praise beyond the one-word mark.
During the quiz, end each message with the question itself, not a **Next:** line: the question is
the next step.

## At the end

- Two lines: the score (for example "4 of 5") and the weak spots in a few words.
- Offer to turn the weak spots into flashcards (flashdeck deck in `notes/<topic>/assets/`).
- One line: "Save a note?" if a weak spot is worth a short note.
- Then end with a normal **Next:** line.
