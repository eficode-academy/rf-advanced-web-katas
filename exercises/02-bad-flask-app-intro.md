# Introduction to Bad Flask App

## Learning Goals

- Understand general good steps to do at the beginning of developing
test cases.

## Introduction

This is the SeleniumLibrary portion of the training. The overall goal for the rest of
the exercices is to fill the form successfully. The exercises will not necessarily get
more difficult as they go on, but will tackle completely different issues.

## Exercise

### Overview

- Create a new test case called `Form Filled With Valid Data Should Submit Successfully`.
- Tag your test case to mark it as unfinished.
- Implement suite setup and teardown.
- Have your test pass by running only setup and teardown.

### Step-by-step

**Create your test case.**

In the following exercises, we're going to write all our keywords into `bad_flask_app.robot` file
in the `resources` directory and our only test case into the `form.robot` file.

> Remember that the `bad_flask_app.robot` file is in the `resources` folder, so the resource file
> is imported with a relative path. Also, we've named our resource file based on the application
> we're testing and our test suite file based on the type of actions we're going to do with the
> application.

A test suite file is no use without any test cases. Each test case should have a descriptive name.
Our goal is to submit the form successfully, so a name like `Form Filled With Valid Data Should
Submit Successfully` is a good name. A test case should also have at least one step. For now, you
can add `No Operation` call to your test case, just to make sure it runs.

- Create a test case called `Form Filled With Valid Data Should Submit Successfully` to your test suite.
- Add `No Operation` call into your case.

It's a good practice to separate ready tests from unfinished ones, so that CI won't run your unfinished
tests. Tags are the best way to do this. Your CI run should have some `--exclude` (or `-e`) flag to
exclude unfinished tests. The tag name can be whatever is clear enough, but `wip` (work in progress)
is commonly used to indicate this.

- Add a `wip` tag to your test case.

> :bulb: Tags need be defined with a `[Tags]` at the beginning of your test case.

---

**Implement setup and teardown.**

Our goal is to fill the form in a website. Opening a browser is a relatively time consuming task
and it's not really part of our test, so we should add that to our `Suite Setup` in the `Settings`
table of our test suite file. In order to avoid having too much detail in our test suite, we can
add that call to our resource file. Also, our browser should close at the end of our test suite, so
we can add a `Suite Teardown` as well to do that.

Since we're dealing with browsers, we need to remember to add `SeleniumLibrary` as a `Library` in
the files we call its keywords directly. We're creating a custom keyword to our resource file and
we can close the browser directly without having any details in our test suite file, we should add
the `Library` import to both files, even though having it only once would work. Resourcing and
importing all the files our file is calling directly makes it easier to jump between keywords and
we don't need to guess where a particular keyword is implemented.

- Create a keyword that opens your browser to Bad Flask App (should be running on `localhost:5000`)
to your resource file.
- Add `Suite Setup` and `Suite Teardown` to your test suite file.

> We're going to write only a single test throughout this training, so a `Test Setup` and a
`Test Teardown` would've been perfectly fine in _this_ particular case as well. However, it's best
practice to open and close a browser only once during your test suite, so they're better to be put
in `Suite Setup` and `Suite Teardown`. This way we ensure the browser is opened and closed only
once, if we decided to expand our test suite.
>
> While debugging a test case, you might actually want to leave the browser open. You can use the
`Pause Execution` keyword from the [Dialogs](http://robotframework.org/robotframework/latest/libraries/Dialogs.html)
library for this purpose. This will give you a popup when you reach the
keyword and nothing will happen in the test case until you manually
close the popup.
