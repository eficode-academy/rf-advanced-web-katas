# Execute JavaScript

## Learning Goals

- You understand when it's good to use `Execute Javascript`.

## Introduction

By now, our form should be fully submittable. We can still modify
our datepicker and slider a little.

Executing JavaScript in Robot Framework is a handy (and a little hacky)
way to manipulate certain things in websites. For example, we can
change, add, or remove attributes. We can also input values directly
to certain fields where it would be otherwise impossible without
using a mouse. So, in general we're bypassing some of the programmatically
tricky user flow to make test development a little bit more tolerable.

## Exercise

### Overview

- Add logic to the keyword you implemented in the [previous exercise](./07-slider.md) to optionally
run it by using `Execute JavaScript`.
- Implement a keyword that submits your form and validates submission succeeded.

### Step-by-step

<details>
  <summary>Change "Important number" with <code>Execute Javascript</code></summary>

<br />

Even though we've successfully filled our form, we notice that when we run the test, most of the execution
time is used on `Change Important Number` execution. We should fix that. We could try to
optimize the clicking at a specific point, but we can also bypass this extremly long keyword by using
`Execute Javascript`.

Because "we can", doesn't necessarily mean "we should". Robot Framework is an acceptance testing framework
and typically we want to simulate human behaviour as much as possible, so skipping some steps with
`Execute Javascript` shouldn't be the first option to do something. However, sometimes it just makes more
sense to call `Execute Javascript` than to spend a long time implementing a keyword that will be inefficient
at best.

We've already done our `Change Important Number`, so we can just modify that. We can give it a boolean
argument to determine if we want to run `Execute Javascript` or not. In order to avoid breaking our
test case, we'll give it a default value. Now, we'll want our argument to specify if we want to execute
JavaScript, so a variable name like `execute_javascript` with a default value of `${FALSE}` should be good.

- Add an argument `execute_javascript` to `Change Important Number` and give it a default value `${FALSE}`.

Next, we want to run `Execute Javascript` if `execute_javascript` is `True` and skip the rest of the keyword.
Here we have several different ways to do this. We could call `Run Keyword If` multiple times,
use a combination of `Run Keyword If` and `Run Keywords` to combine them in a single if-statement, or create
wrapper keyword which are called based on `execute_javascript` value. It doesn't really matter which option
we use, so let's just the first option. We're actually going to use `Run Keyword If` once and then
`Return From Keyword If` once.

> Since we're evaluating a boolean variable, we don't need to specify the value of the boolean (
`${execute_javascript}==${TRUE}`) and we can just use the variable on its own (`${execute_javascript}`).

- Add two steps before your for-loop starting `Run Keyword If` and `Return From Keyword If`. The condition
for both keywords is `execute_javascript`.

Executing JavaScript is fun when the elements have `id` attributes. In those cases, we can use
`document.getElementById("myId")` to find our elements. For example, we could change our datepicker logic
to use that as well. However, our "Important number" doesn't have an `id`, so we're forced to use something
else. Throughout this training, we've used XPaths. Using XPaths in JavaScript much more complex than what
we've used in SeleniumLibrary keywords. We can use XPaths in JavaScript by using the following code:

```js
document.evaluate("//our/xpath", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue
```

Compared to using `xpath://our/xpath`, that is a bit more difficult, right? We can use that by all means,
but we can also use `document.querySelector()` The difference is, that `querySelector()` doesn't use
XPaths. It uses CSS. So, in other words if we want to find `//parent/child[@attribute='value']` with
`querySelector()`, our selector will be `parent child[attribute='value']`. We used the `name` attribute
in the previous exercise as the locator for our "Important number". We can transform that into an XPath
simply by using `//input[@name='important_number']`.

Doesn't matter if we use XPath or CSS, the function returns our element. Then we still need to change its
attribute value. Changing an attribute value in JavaScript is as simple as `element.attribute=value`.
We notice that the "Important number" element has an attribute called `value` and our new value is in
our `wanted_value` argument. So, full execution would be
`document.evaluate(...).singleNodeValue.value = ${wanted_value};`.

As we now have our `Execute Javascript` implementation ready, we can change the logic inside
`Fill All Form Fields` keyword to change the important number with JavaScript.

- Write `Execute Javascript` implementation using either the XPath or CSS selector to change the "Important
number" value to `wanted_value`.
- Add `${TRUE}` as a final argument when you call `Change Important Number` inside `Fill All Form Fields`.

> `Execute Javascript` can return values normally, but in order to get values
> you need to explicitly tell the JavaScript command to `return` even though
> the command would normally return a value when running in the browser console,
> e.g. `${element}=       Execute Javascript    return document.getElementById("myId");`

</details> <!-- Change important number -->

---

<details>
  <summary>Submit form</summary>

<br />

When we run our test, we can see that the slider is automatically moved to the correct position. However, the
label doesn't change. This might cause trouble, but we should test our solution if it works. The only
way to test it is to submit our form and validate the outcome.

Let's create a keyword, which submits the form and validates submission succeeded.

- Create a keyword called `Submit Form Successfully`.

<details>
  <summary>SeleniumLibrary</summary>

We can submit the form directly with the SeleniumLibrary `Submit Form` keyword. This means that we're
left with validating that the submission succeeded.
If our form was successfully filled, we should see `Submit successful!` at the top of the page.
We can validate that with `Wait Until Page Contains` to check that our submission
succeeded.

- Inside `Submit Form Successfully` call `Submit Form` inside an iframe.
- Call `Wait Until Page Contains` inside an iframe to validate the page contans `Submit successful!`.

</details> <!-- SeleniumLibrary -->

<details>
  <summary>Browser</summary>

We can submit the form by using the `Click` keyword. There's only one `button` in the whole form,
so we can just simply use that as the locator.

Browser library has builtin waiting and no separate validation keywords. Instead, you can use `Get Text`
to validate the text automatically. Python validations such as `==`, `!=`, `contains`, and `not contains`
are available for validation. The syntax is Pythonesque:

```robot
Get Text    locator    ==    some text
```

If the submission was successful, we should see a `Submit successful!` text in a `h3` element. That means
that we simply need to use `Get Text` from the header element and verify the text is what is expected.

- Use `Click` to click the `button` on the form.
- Use `Get Text` to verify the `h3` has the text `Submit successful!`.

</details> <!-- Browser -->

> :bulb: Remember that the form is inside an iframe

</details> <!-- Submit form -->
