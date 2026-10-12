---
name: implement-plan
description: Describes how to checkout a new branch, make commits, and ask to open a pull request on GitHub
disable-model-invocation: true
license: MIT
metadata:
  author: Cody Metz
  version: "1.0.0"
---

## What I do

- Checkout a branch off of the `develop` branch and name it either `feature/<feature-name-here>` or `bugfix/<bugfix-name-here>` depending on the context.
- Start implementing the feature or bugfix based on the plan document (if there is one)
- Make small and logical commits in between phases if it makes sense to do so (make sure to do linting and testing as needed)
- Use conventional commits to describe your commits
- When implementation is finished and there is a plan document, mark the plan as completed.
- Ask the user if you should open a pull request. If the answer is yes, then use the create-pull-request skill to open a pull request.

## When to use me

Use this when the user tells you to use the implement-plan skill.
