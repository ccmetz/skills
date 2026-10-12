---
name: review
description: Describes the process for reviewing code changes
disable-model-invocation: true
license: MIT
metadata:
  author: Cody Metz
  version: "1.1.0"
---

You are being asked to review the implementation and tests for the most recent code changes. Follow the Review Process defined below.

## Review Process

1. Ask the user if there is a specific plan document for the implementation
  a. If yes, review the plan document to get the relevant context needed and understand the goal
  b. If no, review the latest changes on the current branch and gather relevant context yourself. Ask the user if you are unsure.

2. Run any verification checks if they have not been ran already (linting, formatting, typechecking, tests)

3. Proceed with reviewing the implementation code first and any added tests second. Look for the following during your review:

  - Code should be easily maintainable and readable
  - Code should follow best practices for the language and framework that they are implemented in
  - Code should favor clarity over cleverness
  - The implementation should be as simple as possible and avoid introducing unnecessary complexity
  - Code should avoid redundancies (DRY) unless doing so would create more complexity and harder maintainability
  - Code that is unavoidably complex should include a comment
  - Unit tests should not test any child components or external dependencies.
  - Tests should follow existing conventions and use existing helpers for consistency
  - Based on the earlier conversation context and requirements, is there anything missing from the implementation?

4. Once you are done reviewing the code:
  - list out the test statements for any tests that were added or modified. Make sure to include the component or service each statement belongs to.
  - list out any suggestions or comments for the user to read and give a severity score to each one
  - give the review a score (0 - 10 with 10 being the best)
