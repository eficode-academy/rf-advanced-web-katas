# XPaths

## Learning Goals

- You know how to navigate XPaths
- You are aware of common pitfalls with XPaths

## Introduction

When web development is done in a way that includes plans for test automation,
the creation of automated tests is easy. This is not always the case, and the
result is that web UI elements have no `id` attribute. Aside from unique `id`s,
we could use other attributes like name, and class, or CSS paths. When even
those are not enough, you can still use XPaths.

Locators made with XPath can be good and reliable, but they can be constructed
poorly too. Be cautious in making them, so they will not break easily, especially
on websites still under development. You do not want to waste time fixing them.

Some tips on working with XPath:

1. Don't use the browser's `Copy XPath` button. They return bad locators.

2. Remember to always **test your locator** in the console before adding it to
your test case. You can use JavaScript queries in browser console:
`$x("//path/to/my/element");`

3. Ensure your locator matches **exactly** 1 element. The first element that
matches a given XPath is used even if more were found. Newer Browser library versions
will raise an error by default if your locator matches more than 1 element.

## Exercise

### Overview

- Implement the logic to close the dropdown _if it's opened_ as part of the test setup.
- Implement the keyword to open the form, and make it a part of the test setup.
  - Test should pass with or without the dropdown initially opened.
- **Optional:** Investigate what happens if you don't close the dropdown beforehand.
What errors do you see?


---
### Implement the logic to close the dropdown if it's open.

- Using your browser's console, look for a suitable locator to identify an opened dropdown.
- Create a variable in Variables table, called `OPENED DROPDOWN` and give it the value of your locator.
- Add a new keyword called `Close Dropdown If Opened`.
   - Check if the dropdown is opened with a library-specific keyword.
   - Catch the result of that keyword into a local variable, called `${element visible}`.
   - You can use a keyword from the BuiltIn library to click the dropdown if `${element visible}` is true.

### Useful keywords
<details>
  <summary>SeleniumLibrary</summary>

- Use BuiltIn library's `Run Keyword And Return Status` and SeleniumLibrary's `Page Should Contain Element` to check if the dropdown is opened.

</details> <!-- SeleniumLibrary -->

<details>
  <summary>Browser</summary>

- Use `Get Element State` with `visible` as the state and store it in a variable.

</details> <!-- Browser -->

---
### Find the locator


As we open the Bad Flask App, we _might_ see a huge dropdown opened
covering the whole website. It opens at random, so we cannot predict it. We need to
create a reliable way to close it, if it's in the way, so we can continue with tests.

We need a locator that detects it, when it is open, and not when it is closed. When you
open browser's developer console, you will see there's no `id` field. A different approach
is necessary.

Try to construct the xpath by yourself first.
<details>
  <summary>If you are stuck, here's a more detailed explanation.</summary>

The dropdown button is an
`a` element, which has classes we could use, for example `dropdown-toggle`. However, there's a similar, but hidden `a`
element before in the HTML, so we can't use that `a` alone. Instead, we can use its parent
`div` element to handle the click, as it is the size of the button. Also, it has a class called `open` when the dropdown is opened which disappears when it's closed. So, in other words _if_ the `div` element has a class called `open`, we can click it to close it.

So the xpath that we can use here is `//div[contains(@class, 'open')]`.

> :bulb: Bad Flask App's code is deceptive. When you click the dropdown in your browser window, there is an additional attribute
> added to the dropdown element: `aria-expanded: "true"` (or `false`). However, using this
> **doesn't** work, since the element doesn't have that attribute when the page is
> initially loaded. It loads the first time the element is clicked.
>
> In this case, we could've also used the `style="display: none;"` attribute of the first
> `a` element to determinate our dropdown element. Yet another way would be to check if the `ul` with class
> `dropdown-menu` is visible in the page, after checking that the page is fully loaded, to avoid
> creating race conditions. Often with XPaths, there is more than "one true answer".

</details> <!-- Constructing the xpath. Here's a more detailed explanation. -->
<br/>

Since our locator is pretty generic, we add it to the `Variables` table in our resource file.
Following Robot Framework's best practices, we give our
variable an UPPER CASE name. As we write more code, we can add new XPaths into the table of `Variables`, every time giving them meaningful names.

We check if the dropdown is open, or not, and store the result in a local variable.
We can the use Robot Framework's native inline `IF` to execute a keyword based on the value of `${element visible}`.

---

### Implement the keyword to open the form, and make it a part of the test setup.

- Using your browser's console, look for a suitable locator for the button that shows the form.
- Create a variable in Variables table, called `SHOW FORM BUTTON`, and give it the value of your locator.
- Implement the keyword called `Show Form` which clicks that element.
- Add `Test Setup` to your `Settings` table and find a way to call both `Close Dropdown If Opened` and `Show Form`.

Now we're able to close the dropdown if it's opened, but we still need to show our form.
Again, we don't have an `id` for our element, but luckily the page has only one `button`,
so our XPath is fairly straightforward: `//button`. Again, even though our XPath is short,
it sounds too general, so better add it to the `Variables` table.

<details>
  <summary>How to run multiple keywords in setup</summary>
Now we have two new keywords: one that closes the dropdown if it is opened and one
that clicks the `SHOW FORM BUTTON`. Let's add this to our `Test Setup`. We could
write a wrapper keyword that calls both our new keywords, or we can use the `Run Keywords`
keyword from the BuiltIn library directly. Using `Run Keywords` is a way to group
keywords into a single step if needed. We can link different keywords with `AND` after
each keyword and its parameters.

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

</details> <!-- Setup multiple keywords -->
<br />

Run the test with `robot -d output tests/form.robot`.
It should open the browser to Bad Flask App, check if the dropdown is opened and close it
when possible, click the "Show Form" button, and finally close the browser.

---

### Possible Errors

<details>
  <summary>ElementClickInterceptedException</summary>

If you don't close the dropdown you might get an error which says something like this:

```text
ElementClickInterceptedException: Message: element click intercepted: Element <button id="showForm" style="width: 100px; margin: -100 auto 20 auto;">...</button> is not clickable at point (120, 206). Other element would receive the click: <ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">...</ul>
```

This means that you're trying to access an element that is _behind_ another element.
If you try to click the area where the element is, but another element is on top of it, that top
element will receive our click instead, just as if a human was interacting with it. This occurs even
if the top element is completely transparent.

This is common with hover tooltips or menus. Some fields are hidden
behind other elements, and typically you need to close a menu or move your
cursor somewhere else to make the hover go away. For example, some forms
show helpful tooltips, but when a tooltip covers the "Submit" button,
your test execution will fail.

</details>
