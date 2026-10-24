---
name: zuq-plan-course
description: Plan and build a ZUQ video course or employee training course. Use when the user wants a course, a series of video lessons, onboarding or policy training, or to learn a subject from scratch with videos.
---

# Plan and build a ZUQ course

1. Settle what is missing, with one question at most: who the course is for, the total length in minutes (5 to 1800; suggest 15 when none is given) and the level (beginner, intermediate, advanced or expert).
2. Draft a plan: a course title (up to 100 characters), a one-sentence goal (up to 300), and 2 to N lessons where N is the smaller of 60 and the number of minutes. Each lesson has a title (up to 80 characters) and up to three objectives (up to 160 each). About three minutes per lesson fits best.
3. Show the plan and ask the user to approve or change it. Do not build before the user approves, unless the user asks ZUQ to plan the lessons itself; then call create_training_course without lessons.
4. After approval, tell the user the course uses that many minutes of their ZUQ account, then call create_training_course once with subject, minutes, level, lessons, course_title and course_goal, plus material_text and material_name when the user shared notes or a policy to teach from. Pass that material as written, not a summary, up to 20,000 characters.
5. Then follow steps 5 to 7 of the zuq-make-video skill.
