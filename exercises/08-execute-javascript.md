# Execute JavaScript

## Learning Goals

- You understand when it's good to use execute JavasScript instead of forcing human behaviour.

## Introduction

**NOTE:** The keyword to execute JavaScript in `SeleniumLibrary` is called `Execute Javascript`, whereas
in `Browser` it's called `Evaluate Javascript`. For the sake of clarity in the text, we're
calling it only `Execute JavaScript`, but each bullet points for both libraries will have the
correct library specific keyword.

By now, our form should be fully submittable. We can still modify
the slider keyword a little.

Executing JavaScript in web testing is a handy (but a little hacky)
way to manipulate objects and events. For example, we can
change, add, or remove attributes. We can also input or modify values of certain
fields directly, which would be impossible without deliberately imitating manual input, such as mouse movements.
So, in general we can bypass parts of the programmatically tricky user flow to make test development
a bit more tolerable, or test execution significantly faster.

Although "we can", to replace human-like behaviour with hacks like JavaScript
shouldn't be the default way to do things. Robot Framework is an acceptance testing framework,
and typically we want to simulate human behaviour as much as possible.
However, sometimes it just makes more sense to use it, than to spend a long time
implementing a keyword that will be inefficient at best, and inaccurate or
extremely time-consuming at worst.

## Exercise

### Overview

- Add logic to the keyword you implemented in the [previous exercise](./07-slider.md) to optionally
execute its task using `Execute JavaScript` (SeleniumLibrary) or `Evaluate Javascript` (Browser).

### Step-by-step

<details>
  <summary>Change "Important number" with <code>Execute Javascript</code></summary>

<br />

Even though we've successfully filled our form, we notice the run takes time, most of which is spent on executing `Change Important Number`.
We could try to optimize the clicking at a specific point, but we can also bypass this extremely operation by using
`Execute Javascript`.

We've already implemented `Change Important Number`, so we can just modify that. We can give it a boolean
argument to determine if we want to run `Execute Javascript` or not. In order to avoid breaking our
test case, we'll give it a default value. Now, we'll want our argument to specify if we want to execute
JavaScript, so a variable name like `execute_javascript` with a default value of `${FALSE}` should be good.

- Add an argument `execute_javascript` to `Change Important Number` and give it a default value `${FALSE}`.

Next, we want to run `Execute Javascript` if `execute_javascript` is `True` and skip the rest of the keyword.
Here we have multiple different ways to do this. The simplest way is to use Robot Framework's native `IF-END`
structure. An `IF` block is case sensitive and it needs the if condition on the same line as the `IF` statement.
All keywords inside the `IF` block must be indented with 4 spaces and the `IF` block ends with an upper case
`END`. Because we want to exit the keyword if we enter the `IF` block, we can call Robot Framework's native
`RETURN` statement inside our `IF` block to return from our keyword.

```robot
My Keyword
    IF    ${condition}
        Log to Console    Called inside an if block
        RETURN
    END
```

> Since we're evaluating a boolean variable, we don't need to specify the value of the boolean (
`${execute_javascript}==${TRUE}`) and we can just use the variable on its own (`${execute_javascript}`).

- Add an `IF-END` block to your `Change Important Number` keyword right before the for-loop.
  - The condition for the `IF` is `${execute_javascript}`.
- Add a step inside `IF` block, which simply calls `RETURN`.

<details>
  <summary>SeleniumLibrary</summary>

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

- Write `Execute Javascript` implementation using either the XPath or CSS selector to change the "Important
number" value to `wanted_value`.

> `Execute Javascript` can return values normally, but in order to get values
> you need to explicitly tell the JavaScript command to `return` even though
> the command would normally return a value when running in the browser console,
> e.g. `${element}=       Execute Javascript    return document.getElementById("myId");`
</details> <!-- SeleniumLibrary -->

<details>
  <summary>Browser</summary>

In contrast to SeleniumLibrary's implementation, Browser's keyword to execute JavaScript takes two arguments. The first argument is
a reference to an element in the web page, and the second one is the JS function,
that will be sent to that referenced element. Locator is not the same as a reference, so we will need to call another keyword to create a reference first.

The operation on the slider is thus not a one-liner, so let's make a
separate keyword for it, which can be then called by `IF` block.
The new keyword should contain the steps to get a reference for the slider, and change its value with a simple JS function.

- Add a keyword `Change Slider Value With JS` that will change the slider's value to `wanted_value`.

Reference to an element is returned by `Get Element` keyword, which takes a
locator as an argument. Store it in a local variable. It can be used like a
locator in other keywords, even without the need to specify the iframe.
With this direct reference to the slider, JS function needed is a simple change of the `value` property.
Example function syntax: `(element) => element.property = "new value"`.

- Use `Get Element` to get a reference to the slider element.
- Use `Evaluate Javascript` to assign `wanted_value` to the slider's `value` property using the reference element.

Our keyword should also check that the value stored by the slider indeed changed.
This can be done by confirming the value before the change is `0`, and after is
equal to the `wanted value`. Browser's keywords have built-in checking, so
there's no need to store the numbers and compare them as integers. The value is stored inside slider's properly, so you can use the `Get Property` keyword.

Browser library has builtin waiting and no separate validation keywords. Instead, you can use `Get Text`
to validate the text automatically. Python validations such as `==`, `!=`, `contains`, and `not contains`
are available for validation. The syntax is Python-esque:

```robot
Get Text    locator    ==    some text
```

- Implement checks with `Get Property` to ensure the value has been changed.

</details> <!-- Browser -->

As we now have our JavaScript implementation ready, we can modify the logic inside
`Fill All Form Fields` keyword to change the important number with JavaScript.

- Add `${TRUE}` as a final argument when you call `Change Important Number` inside `Fill All Form Fields`.

</details> <!-- Change important number -->
