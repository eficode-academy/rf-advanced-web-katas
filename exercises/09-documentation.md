# Documentation

## Learning Goals

- You understand how to create meaningful documentation

## Introduction

Congratulations! Our test now fills the form successfully! However, a few
more steps will make future-you a lot happier: documentation.

We've added a buch of new keywords. Our test suite and resource
files are certainly small, so reading through the file is fairly easy.
However, as with all software projects, our files are likely to grow,
people will leave and new people will jump in and to make their job easier,
it's good to add documentation for all our keywords. Also, it's good
for us as well, since when the test is done we will probably move on
to more tests, probably even on another platform. Then, after a few weeks
or months an architectural change in the service breaks our test and we
need to fix it. It's easier to refresh our memory if we've added
documentation to our keywords.

Keywords should be named after a fashion that already gives a good idea
what the keyword does. Therefore, documentation should be added to things
that we think will be relevant in the future, such as special clauses,
restrictions, possible return values, expected arguments, etc.

## Exercise

### Overview

- Add documentation to your `Change Important Number` keyword, which tells the difference in
running with `execute_javascript=${TRUE}` or with `${FALSE}`.
- Add proper tags to your test case.

### Step-by-step

<details>
  <summary>Add meaningul documentation.</summary>

<br />

Keyword and test case documentation shouldn't be added just state the obvious. However,
in case of special requirements and nontrivial cases, there should be documentated explanation.
The keywords
in this training are pretty concise and self-explanatory, but there's at least one
place we could add documentation:
we could add a note that using `Change Important Number` from the UI is _slow_,
but using the `Execute Javascript` doesn't update the UI, even though it works.

- Add a notion to the documentation of `Change Important Number` that using the
`execute_javascript` causes an issue with the UI, but not using it dramatically
slows down the test.

</details>

---

<details>
  <summary>Tag your test case.</summary>

<br />

One final touch we should add to our test suite is to update the test tags.
If this was a test with a real requirement linked to a requirements management
tool, we should have the ticket id as a tag already. Well, it's not, so we can
ignore that. However, we added a `wip` at the beginning of the training for our
test suite. Now our test is finished, so we can safely take that away.

For the sake of becoming used to tags, let's imagine this test is an actual
requirement. Our test suite tests a business requirement `contacts` and they
will test it with `UI`. Our test case tests a feature `ABC-123`. Also, our
test case is a core part of Bad Flask App's functionality, so it should be a
`smoke` test.

Since all our test cases in this suite will have some categories in common,
let's add that tag to all our test cases. We can do that by adding `Force Tags`
to our `Settings` table. `ABC-123` and `smoke` are specific to our test case
in particular, so we'll add those separately to our test case.

- Remove the `wip` tag from your test suite.
- Add `contacts` and `UI` as `Force Tags` to your `Settings` table.
- Add `ABC-123` and `smoke` as tags to your test case.

</details>
