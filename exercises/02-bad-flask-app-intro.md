# Introduction to Bad Flask App

## Learning Goals

- You understand general good steps to take at the beginning of developing
test cases.

## Introduction

This is the UI portion of the training. The goal for the rest of
the exercises is to fill out the form successfully. The exercises will not necessarily get
more difficult, but will tackle completely different issues.

In the following exercises, we're going to implement all keywords listed in `bad_flask_app.robot` file
in the `resources` directory, all tied to the test case in the `form.robot` file.

> Remember that the `bad_flask_app.robot` file is in the `resources` folder, so the resource file
> is imported with a relative path. Also, we've named our resource file based on the application
> we're testing and our test suite file based on the type of actions we're going to do with the
> application.

## Exercise

### Overview

- Review the test case `Form Filled With Valid Data Should Submit Successfully`.
- Tag the test case to mark it as unfinished.
- Import the library of your choice to do the rest of the exercises with.
- Implement the suite setup keyword (and add a suite teardown).
- Have your test pass including the setup (and teardown).
- **Optional:** Parametrize opening browser in headless/headful mode

### Step-by-step

<details>
  <summary>Review the test case and tag it as unfinished</summary>

<br />

A test suite file is not useful without any test cases. Moreover, each test case should have a descriptive name.
Our goal is to submit the form successfully, so a name like `Form Filled With Valid Data Should
Submit Successfully` is a good name. A test case should also have at least one step. The provided skeleton contains 3 steps, all of which are just calling the dummy keyword.

- Read the steps of test case `Form Filled With Valid Data Should Submit Successfully`, and locate them in resource file.

It's a good practice to separate ready tests from unfinished ones, so that CI won't run your unfinished
tests. Tags are the best way to do this. Your CI run should have some `--exclude` (or `-e`) flag to
exclude unfinished tests. The tag name can be whatever is clear enough, but `wip` (work in progress)
is commonly used to indicate this.

- Add a `wip` tag to the test case.

> :bulb: Test case specific tags need be defined with a `[Tags]` at the beginning of your test case.

</details> <!-- Review the test case and tag it as unfinished -->

---

<details>
  <summary>Import the library, use it to implement the suite setup (and teardown)</summary>

<br />

Our goal is to fill out the form in a website. Opening a browser is a relatively time-consuming task,
and it's not really part of our test, so we should add do it as part of the  `Suite Setup`, so it will run once per test suite.
The `Suite Setup` resides in the `Settings`
table of our test suite file. In order to avoid having too much detail in our test suite file,
the implementation of the setup keyword is done in the resource file.
The variable storing the default browser has also been already added there.

- Find the keyword called `Open Browser To Application` in your resource file.
- Find the `BROWSER` variable into your resource file and ensure it has the value your environment supports.

Since we're dealing with external libraries, we need to remember to import our library into our resource file

- Add `SeleniumLibrary` **or** `Browser` as a `Library` to your resource file.

> It might be a good idea to add library imports to all files that call library keywords directly, so
> you know all dependencies of the file you're inspecting. However, this might cause unexpected behaviour
> if the libraries are imported with initialization values.
>
> :bulb: If you completed [exercise 01](./01-rest-api.md) with Browser library, you already have your
> library import ready in your resource file.

<details>
  <summary>SeleniumLibrary</summary>

Bad Flask App is running at `localhost:5000`, so we need to open our browser in that address. Note that SeleniumLibrary
doesn't close any open browser instances automatically, which can cause major performance and scaling issues.
So we need to remember to close the browser in our suite teardown.

- Use `Open Browser` to open a browser to Bad Flask App (`localhost:5000`) in your `Open Browser To Application` keyword.
- Add `Close Browser` keyword call as your `Suite Teardown` in your test suite file.

> We're going to write only a single test throughout this training, so a `Test Setup` and a
`Test Teardown` would've been perfectly fine in _this_ particular case as well. However, it's a best
practice to open and close a browser only once during your test suite, so they're better to be put
in `Suite Setup` and `Suite Teardown`. This way we ensure the browser is opened and closed only
once, if we decided to expand our test suite.

</details> <!-- SeleniumLibrary -->

<details>
  <summary>Browser</summary>

Browser library automatically closes the browser after the test or suite has finished, to we don't
need to handle closing the browser separately. We can use `New Page` keyword to open the browser
to Bad Flask App, like before with the `api.robot` tests.

- Call `New Page` in `Open Browser To Application` to open Bad Flask App (`localhost:5000`).

</details> <!-- Browser -->

> :bulb: If you're running your server with Docker, you might need to use the Docker container's
> IP address instead of `localhost`. You can find the IP address by using
> `docker inspect <container_name>`.
>
> While debugging a test case, you might actually want to leave the browser open. You can use the
`Pause Execution` keyword from the [Dialogs](http://robotframework.org/robotframework/latest/libraries/Dialogs.html)
library for this purpose. This will give you a popup when you reach the
keyword and nothing will happen in the test case until you manually
close the popup.

</details> <!-- Import the library, use it to implement the suite setup (and teardown) -->

---

<details>
  <summary>Optional: Parametrize opening browser to headless or headful mode</summary>

<details>
  <Summary>SeleniumLibrary</summary>

By default, SeleniumLibrary opens a browser in headful state. This is good while developing, but when running
in CI, opening and closing browser windows take a lot of time, so they could/should be run in headless state. This is
easy to accomplish with the command line parameter `--variable BROWSER:headlessfirefox` (or `headlesschrome`,
provided that you have a variable called `BROWSER`). Although using the command line parameter is preferred,
it can also be parametrized in our `Open Browser To Application` by adding another parameter `headless` and
giving it a value of `${TRUE}` or `${FALSE}`.

We can then concatenate strings and variables by using `Set Variable If`. Headful Firefox is `firefox` and headful
Chrome is `chrome`. Similarly, headless Firefox is `headlessfirefox` and headless Chrome is `headlesschrome`.
We only need to check if our `headless` variable is `${TRUE}` and add `headless` before our browser variable.
We can give `Set Variable If` a value for the `else` bracket right away as the third argument.
For example `${chosen_browser}=    Set Variable If    ${headless}    headless${BROWSER}    ${BROWSER}`.

- Add a new argument called `headless` to `Open Browser To Application` keyword.
- Use `Set Variable If` to set `chosen_browser` variable to `headless${BROWSER}` or `${BROWSER}` depending
on the value of `headless`
- Change the `BROWSER` variable in `Open Browser` to use `chosen_browser`.

</details>

<details>
  <summary>Browser</summary>

By default, Browser library opens browsers in a headless state. We need to specifically open it in a
headful state if we want to see what is happening during the test. It's not necessary for the final
test, but it makes debugging a lot easier to see what the tests are doing. If you use `New Page` alone,
without first calling `New Browser`, the latter keyword will be called for you,
with default parameters. This means, that if we want to change those defaults, we need to first explicitly call
`New Browser` with `headless=${FALSE}` before calling `New Page`.

Let's take that one step further. Currently, the same keyword is being called by both UI and API tests, but
we don't really want to see the browser open during the API tests. We can parametrize opening in headless
state and have it open headless by default, and we can then just use `headless=${FALSE}` in our `Suite Setup`
while we're debugging.

- Add `headless` parameter to `Open Browser To Our Application` keyword and give it `${TRUE}` as a default
value.
- Add call to `New Browser` before `New Page` and give it the parameter `headless=${headless}`.
- Add a parameter to your `Suite Setup` to set `headless=${TRUE}`.

</details> <!-- Browser -->

</details> <!-- Optional exercise -->
