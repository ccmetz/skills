---
name: create-plan
description: Describes how to create a plan for a feature. Use me when the user tells you to create a plan.
disable-model-invocation: true
license: MIT
metadata:
  author: Cody Metz
  version: "1.0.0"
---

## What I do
- Identify if the current project has a `plans` directory. It should be located at either `/plans` or `/docs/plans`
- Create a new plan file in the `plans` directory and follow the format in `./plan-document-format.md`
- Only put a plan in the `plans/tmp` directory if the user asks you to
- Update the **Status** to "Completed" and add the **Completed** date when done
- Move completed plans to `plans/completed` directory after user verification
