# Iframes

## Learning Goals

- You know how you can handle iframes
- Better understanding of keyword settings
- Understand the difference between `${variable}` and `@{variable}`

## Introduction

**NOTE: `Browser` doesn't support selecting a frame separately with a keyword,
so this exercise is currently doable _only_ with `SelenliumLibrary`.**

Iframes are a way of displaying another website's contents
within another website. A key point here is that it is indeed _another website_.
This means that we cannot select elements from that website, while we're still
working on the original website.

The Bad Flask App uses iframes to present the form. Handling iframes is pretty straightforward
in itself, but there are few things to consider:

1. You must remember to deselect your frame when you're done using it
2. If a website has lots of iframes and you need to jump from one frame to another, it's
easy to get lost on which frame you've selected.
3. Another way to get lost is to get your resource files messy if multiple keywords are
using `Select Frame` and `Unselect Frame` from the SeleniumLibrary.

> Here's a little tricky part where Chrome and Firefox differ: in Chrome, when
> you use "pick element" tool in developer console and click on an element,
> Chrome automatically selects the iframe in the console tab. However, Firefox
> doesn't do this and if you're testing your locators in Firefox console, you
> might end up not seeing any results. On Firefox, you need to click one of the
> little icons on the top right corner of the developer console to bring you the
> iframe selector. Here you can select your frame and then do your queries.
>
> In Chrome, it's nice that you can just test your
> locators immediately, but it's very easy to forget to select the frame in the
> test case. In Firefox, you hardly forget to select the frame in the test once
> you realize you need to select in the browser, but you might use quite a bit of
> time wondering why the website doesn't find your element even though you're
> 100% sure your XPath is correct.

## Exercise

### Overview

- Implement a wrapper keyword for running other keywords inside an iframe.
  - The keyword takes 3 arguments: the iframe, the keyword, and the arguments for that keyword.
  - It selects the iframe as its first step.
  - It executes the given keyword as the second step.
  - It deselects the frame as the keyword teardown.

### Step-by-step

<details>
  <summary>Create new keyword.</summary>

<br />

In order to keep our resource file tidy, let's implement a keyword to work as a wrapper for
our iframes. Then, we can simply call that keyword whenever we want to run something inside
and iframe and be assured the frame won't be selected afterwards. For starters, we can define
our keyword and simply make it call `Select Frame` and `Unselect Frame`.

- Create a keyword called `Run Inside Iframe` and make it run `Select Frame` and `Unselect Frame`
in succession.

So far, our keyword doesn't really do anything. First, we need to know the frame we want to select
and pass it as an argument to our keyword. The iframe does have an `id` this time, but it not
really useful as the latter part is randomly generated numbers. So, we're going to use XPaths again.
We notice there are two iframes on the website, but one of them is hidden. What's more, they have the
same `src` attribute. If we take a closer look at the parent `div` element of both iframes, we notice
that the iframe we want to use _doesn't_ have the `hidden` class.

Just like with checking that an element attribute contains some value, we can check if an element
attribute doesn't contain some value. We can do this by using the `not()` wrapper around our `contains()`
wrapper, like this `//div[not(contains(@class,'hidden'))]/iframe`. Let's store our XPath into a variable again.

- Create a variable for the XPath of the iframe.

</details> <!-- Create new keyword -->

---

<details>
  <summary>Add keyword arguments.</summary>

<br />

In most cases we might want to change iframes when we're testing. We want to be able to use our
`Run Inside Iframe` keyword in all possible frames in our website, so we should specify the frame
as an argument for our keyword. Furthermore, our keyword still doesn't really _do_ anything. We want
it to be able to run _any_ keyword with _any_ arguments it might have.

The keyword is farly easy to handle with a single variable. However, our issues begin when our
keyword takes 0-n arguments and our keyword should be able to handle all situations.

In order to handle a varying amount of arguments we can use the `@{variable}` notation. Let's
consider the following list:

```robot
${my_list}=     Create List     Mickey      Mouse       Donald      Duck
```

When we use `${my_list}`, we are referring to the list _object_, meaning `["Mickey",
"Mouse", "Donald", "Duck"]`. However, when we use `@{my_list}`, we are referring to the list
_values_, meaning `Mickey`, `Mouse`, `Donald`, and `Duck` individually.
The best part of using `@{my_list}` is that it works even if the list is empty and it works with
a list with any amount of values as well. For example, if our keyword takes `${my_list}` as
an argument, it assumes there is a value for that argument. However, if we provide `@{my_list}`,
_we don't need to give it a value_.

Great, we now know that we need to specify our `frame`, `keyword` and `arguments` to our keyword
and we now _how_ to specify them. Let's add those to our keyword.

- Add `[Arguments]` to your `Run Inside Iframe` keyword and make it take three arguments: `frame`,
`keyword`, and the _values_ of `arguments` list.
- Specify the `frame` variable as an argument for the `Select Frame` keyword.

> :bulb: `@{arguments}` _must_ be the last argument for your keyword.
>
> Keywords can also take arguments in dictionary format (`key1=value1`, `key2=value2`, etc.). We
could handle those by using `&{kwargs}` format, but we're going to ignore that for now.

Now the keyword we want to run is a variable. We can't directly call `${keyword}` in Robot. We need
to wrap that in a `Run Keyword` call, so let's add a call for our keyword between our frame
selection and deselection.

- Call `Run Keyword` to run your argument `keyword` between selecting and deselecting a frame.

</details>

---

<details>
  <summary>Add keyword teardown.</summary>

<br />

Our keyword will now select a frame, run a keyword, and finally deselect a frame. But what if
our keyword fails before it reaches `Unselect Frame`? We would be stuck inside our iframe and
our test would have no idea how to behave. after that. Just like test cases, keywords can also
have a separate and `Teardown` specified by `[Teardown]` (but **not** a `Setup`).

Just to make sure our keyword always cleans up after itself, we should change frame deselection into
a keyword teardown.

- Add `[Teardown]` to `Unselect Frame`. Remember to have at least 2 spaces between your teardown
and keyword.

> We can also specify `[Documentation]`, `[Return]` value, and a custom `[Timeout]` for your keywords, but we're not
> going to into depth about those here.
>
> Even though Robot Framework supports writing keyword documentation, arguments, timeout, teardown,
> and return value in any order we choose, it's a good idea to have those in an order that makes sense.
>
> E.g.
>
> ```robot
> My Keyword
>    [Documentation]
>    [Arguments]
>    [Timeout]
>    # Actual keyword functionality
>    [Teardown]
>    [Return]
> ```

</details>
