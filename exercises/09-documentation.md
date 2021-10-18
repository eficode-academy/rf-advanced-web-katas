# Documentation

## Learning Goals

- You understand how to create meaningful documentation

## Introduction

Congratulations! The test now fills out the form successfully! However, a few
more steps will make your future self a lot happier: good documentation.

We've added a bunch of new keywords. So far, the test suite and resource
files are still small, so reading through the file is fairly easy.
However, as with all software projects, our files are likely to grow,
people will leave and new people will jump in and to make their job easier,
it's good to add documentation for all our keywords. It's also good
for us, since when the test is done we will probably move on
to other tests, maybe even on another platform. Then, after a few weeks
or months an architectural change in the service breaks our test and we
need to fix it. It's easier to refresh our memory if we've added
documentation to our keywords.

Keywords should be named in a way that already gives a good idea of
what the keyword does. Therefore, documentation should be added just to things
that we think are not obvious, and will be relevant in the future, such as special clauses,
restrictions, possible return values, expected arguments, etc.

## Exercise

### Overview

- Add documentation to your `Change Important Number` keyword, which tells the difference in
running with `execute_javascript=${TRUE}` or with `${FALSE}`.
- Add proper tags to your test case.

### Step-by-step

<details>
  <summary>Add meaningful documentation.</summary>

<br />

Keyword and test case documentation shouldn't be added just to state the obvious. However,
in case of special requirements and nontrivial cases, there should be documented explanation.
The keywords
in this training are pretty concise and self-explanatory, but there's at least one
place we could add documentation in:
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
tool, we should have the ticket id as a tag already. In this training, it's not, so we
ignore that now. However, we added a `wip` at the beginning of the training to our
test suite. Now our test is finished, so we should remove it.

For the sake of getting used to tags, let's imagine this test is for an existing
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
