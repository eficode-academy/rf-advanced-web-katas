# XPaths

## Learning Goals

- You know how to navigate XPaths
- You are aware of common pitfalls with XPaths

## Introduction

Ideally, web development and test automation goes hand in hand, so
that the people who develop the websites, would also do (at least
a bit of) test automation. However, more often than not this is not
the case and that causes trouble to test automation developers.
Websites are usually creates "UX first", which is good for the users,
but it typically means more work for the test automation developers.

Nowadays, websites are created with modern frameworks, which generates
nice looking websites from templates. Most often this causes developers
to forget to add unique `id` attributes to elements, so we need
alternative locators for our elements.

This is where XPaths step in. Sure enough, there are other locators
with SeleniumLibrary and Browser than XPaths and IDs, but quite often using an XPath is the
only way to find a truly unique identifier for an element.

A trick with XPaths is to get a locator which is accurate enough to get
your element, but not too accurate as to make the test case too fragile.
If a website is prone to change, using bad XPaths is a good way to find
ourself in a swamp of refactoring and debugging. A good mind set for XPaths
is to keep them as short as possible. Shorter XPaths mean fewer places
for it to break and less time wasted on unnecessary debugging.

A few general tips for good XPath usage:

1. Don't use the browser's `Copy XPath` button. This will give you a way too
obscure and accurate XPath. For example, Firefox gives the XPath for the
Bad Flask App dropdown menu as `/html/body/section[1]/nav/div/a`, which
will break from the slightest change to the structure and is also unnecessarily
long. All elements should be behind `/html/body`, so your XPaths should
**always** start `//` when testing websites.
2. Ensure your locator matches **exactly** 1 element. The first element that matches
the a given XPath is used even if there are multiple
matching XPaths. In theory it's safe to use an XPath if your element is the first
element matched, but a small change in the website can change the order and cause
unexpected behaviour.
3. Always **test your locator** in the console before adding it to your test
case. You can `ctrl+F` in the `inspector` tab of the developer tools or you
can use the `console` tab to use basic JavaScript queries to get your XPath,
such as `$x("//path/to/my/element");`.
4. Use variables whenever possible. Store your XPaths in variables, so you
need to fix only 1 XPath if the test breaks and you don't need to go searching
for all occurences of hard-coded locators in your tests.

## Exercise

### Overview

- Close the dropdown _if it's opened_ in the test setup.
- Open the form in the test setup.
  - Test should pass with or without the dropdown initially opened.
- **Optional:** Investigate what might happen if you don't close the dropdown beforehand.
What errors do you find?

### Step-by-step

<details>
  <summary>Close the dropdown if it's open.</summary>

<br />

As we land on Bad Flask App, we _might_ see a huge dropdown opened
covering the whole website. It opens at random, so there's no knowing whether it
will open in our test case or not. While we're looking at the Bad Flask App, let's
open our developer console by right-clicking anywhere on the screen and selecting `inspect`.
It's a good idea to keep the developer console opened always when you're writing Selenium tests.
We notice, that the dropdown doesn't have an `id` field that would allow us to
easily access that element.

Let's start by finding suitable locators for our element. We notice that the dropdown is an
`a` element, which has classes we could use, for example `dropdown-toggle`. However, there's a hidden
element before our dropdown, so we can't use that directly. Instead of the `a`, we can also use its parent
`div` element to handle the click. It has a class called `open` when the dropdown is opened and it's missing
when it's closed. So, in other words we should click the `div` element _if_ it has a class called `open`.

We don't want to add XPaths directly into our keyword, so let's add all static XPaths
into a `Variables` table with a meaningful name. Following Robot Framework's best
practices, we should give our variable a name that is in UPPER CASE.

- Add `//div[contains(@class, 'open')]` into a variable with a meaningful name, such
as `OPENED DROPDOWN`.
- Create a keyword called `Close Dropdown If Opened` that clicks the element `OPENED DROPDOWN`.

<details>
  <summary>SeleniumLibrary</summary>

To check if the element is visible we need to first get the element status, then combine that with
`Run Keyword If`. We can ge the element status with `Run Keyword And Return Status` combined with
`Page Should Contain Element`

- Use `Run Keyword And Return Status` and `Page Should Contain Element` to check if the dropdown is opened.
Store the result in a variable.
- Using your new variable, use `Run Keyword If` to conditionally close the dropdown.

</details> <!-- SeleniumLibrary -->

<details>
  <summary>Browser</summary>

To check if the element is visible, we can use `Get Element State` and check the state for `visible`.

- Use `Get Element State` with `visible` as the state and store it in a variable.
- Using your new variable, use `Run Keyword If` to conditionally close the dropdown.

> The default locator type for Browser library is `css`, which could work here just as well.
> However, sometimes XPath is the only solution (for example with certain mobile applications),
> so this training will take the slightly more "annoying" path of handling XPaths instead of css
> selectors.

</details> <!-- Browser -->

> :bulb: When you click the dropdown in your browser window, there is an additional attribute
> added to the dropdown element: `aria-expanded: "true"` (or `false`). However, using this
> **doesn't** work, since the element doesn't have that attribute when the page is
> initially loaded. It loads the first time the element is clicked.
>
> In this case, we could've also used the `style="display: none;"` attribute of the first
> `a` element to determine our dropdown element. Typically in XPaths, there's not a "one
> right answer".

</details> <!-- Close the dropdown -->

---

<details>
  <summary>Open the form and set test setup.</summary>

<br />

Ok, we're able to close the dropdown if it's opened. We still need to show our form.
Again, we don't have an `id` for our element, but luckily the page has only one `button`,
so our XPath is fairly straightforward: `//button`. Again, even though our XPath is short,
let's add to our `Variables` table.

- Add a variable for our `//button` XPath.
- Create a keyword called `Show Form` which clicks the `//button` element.

Now we have two new keywords: one that closes the dropdown if it is opened and one
that clicks the "Show Form" button. Let's add this to our `Test Setup`. We could
write a wrapper keyword that calls both our new keywords or we can use the `Run Keywords`
keyword from the BuiltIn library directly. Using `Run Keywords` is a way to group
keywords into a single step if needed. We can link different keywords with `AND` after
each keyword and its parameters.

- Add `Test Setup` to your `Settings` table and call both new keywords.

> It's possible that your line becomes quite long when you call multiple keywords.
> You can always split your keywords into multiple lines using `...` at the beginning
> of the next line.
>
> E.g.
>
> ```robot
> *** Settings ***
> Test Setup    Run Keywords
> ...           My First Keyword
> ...           AND
> ...           My Second Keyword
> ```

We can still validate our test behaves as expected by running `robot -d output tests/form.robot`.
Our test should open the browser to Bad Flask App, check if the dropdown is opened and close it
when possible, click the "Show Form" button, and finally close the browser.

</details> <!-- Open the form. -->

---

### Possible Errors

#### `ElementClickInterceptedException`

If you don't close the dropdown you might get an error which says something like this:

```text
ElementClickInterceptedException: Message: element click intercepted: Element <button id="showForm" style="width: 100px; margin: -100 auto 20 auto;">...</button> is not clickable at point (120, 206). Other element would receive the click: <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">...</ul>
```

This means that you're trying to access an element that _behind_ another element
and if we would try to click where the element is, top element on top would
receive our click instead.

This is common when there are hover tooltips or menus. Some fields are hidden
behind other elements and typically you need to close a menu or move your
cursor somewhere else to make the hover go away. For example, some forms
have a helpful tooltip, but then the tooltip covers the "Submit" button and
your test execution fails due to that.
