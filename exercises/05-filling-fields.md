# Filling the Form

## Learning Goals

- You know how to combine XPaths
- You recognize when you can and when you can't use variables
- You understand how to create modular keywords
- You know how to use embedded variables

## Introduction

XPaths should be as short as possible, and they should be stored in one place:
under the `Variables` table. However, this isn't always possible. We often need to
access an element with a changing value, for example, in the element's text. In
these cases we need to have the XPath in the keyword in itself and this can make
maintenance more difficult if many keywords have XPaths with similar parts, but
still different enough to not allow to use a common variable.

That is also the reason why we should focus on creating our keywords to be as reusable
as possible. We don't want to go through hundreds or thousands of lines code to find all
usages of a similar XPath if we can check only one.

## Exercise

### Overview

- Implement a modular keyword `Fill Form Field` which fills the
`Name`, `Email`, or `Message` field of the form.
  - Keyword should take the `field` name and the `value` you want to input as arguments.
- Find an XPath, which finds the `Name`, `Email`, and `Message` fields.
- Implement 2 more keywords:
  - First one calls your modular keyword multiple times for the different fields.
  - Second one calls your first keyword.
- **Optional:** Create an embedded variable variant of your fill keywords.
- **Optional:** Investigate what errors you get if you don't select the iframe beforehand.
- **Optional:** Investigate what errors you get if you don't show the form filling your form.

### Step-by-step

<details>
  <summary>SeleniumLibrary</summary>

**Define a modular keyword to fill your name, email, or message field.**

We've finally reached a point where we can start to fill our form. The easiest
fields to tackle are the name, email, and message fields. They're similar fields,
so we should create a keyword that fills each field just by specifying which
field we want to fill. We'll start by defining a keyword, which takes two arguments:
the field we want to fill and the value we want to give that field.

- Define a keyword `Fill Form Field`, which takes 2 arguments: `field` and `value`.

We know we'll input the value of the `value` argument, but we still don't know how
to access our element. However, as a placeholder, we can add already what we know
and make a note of what's missing.

- Add `Input Text` keyword call to your keyword. Use a some notion (for example `xpath://TODO`) to
indicate this isn't still working. The input value for the `Input Text` should
be your `value` argument.

---

**Find a good XPath to match the name, email, and message fields.**

Now that we have our initial keyword in place, let's take a look how we could best locate our
fields. Unfortunately, as we look at the form source code, we see that
the fields don't have any attributes that would really help us. Even worse, they're different
types: name and email fields are `input` and the message field is `textarea`. Seems like the
only element we can get a hand on is the `label` for each form field.

Let's first handle the situation with our mismatching input fields. One thing we know for sure:
our input field is _after_ the `label`. This means we can use the XPath `following-sibling` to
target elements that are children of the same parent, but come _after_  some specific element.
The `following-sibling` requires two colons (`::`) to indicate what element we want to match. XPath
supports wildcards, we could just use `*` to match any element after our `label`, but we want to
make sure we match our input field.

Similar to `following-sibling` we can check the type of
the current element by using `self`. For example, `//*[self::input]` is identical to `//input`.
Our input fields are either `input` or `textarea`, so our XPath should match both types. We can
use `or` inside our brackets (`[]`) to match either element. Half of our input field locator
is just about finished. There's no variables in our locator, so let's make it a static variable
in our `Variables` table.

- Write a variable for the `input` and `textarea` fields starting `following-sibling` into
your `Variables` table.

> You can use `preceding-sibling` to get an element _before_ some other element.
>
> :bulb: Remember to **test your XPath** in the browser. Without the `following-sibling` your XPath
> should match 6 fields, which are all the fields in the form.

Ok, we are now able to select all `input` and `textarea` fields of our form. Now we can start
to make our XPaths unique using the `label`. The label has a `:` and some extra spaces we don't
want to match in our XPath, so we'll use `contains()` again. This time we're not checking
the value of an attribute, so we can't use `contains(@attribute, 'value')`. Instead, we're matching
the `text` of the attribute. It works the same way, but the syntax is slightly different. Instead
of `@text`, we have to use `text()`.

Now, we have our `label` selector as well. This time however, the label holds a variable (our `field`
argument), so we cannot put that in our `Variables` table. Instead, we have to keep that as is
in our keyword and combine with our input field variable. Combining our XPath with a variable is as
simple as putting them right after each other so a case like this

```robot
*** Variables ***
${XPATH_VARIABLE}       c/d

*** Keywords ***
My Keyword
    Click Element       xpath://a/b/${XPATH_VARIABLE}
```

would click an element with the XPath `//a/b/c/d`. We now how the locator for both our input field
and our label. We're all set to combine our XPaths and input a value into our form field.

- Replace your `TODO` XPath in your `Fill Form Field` keyword with the combined XPath of your
static part variable and the dynamic part, which uses the `field` argument.

---

**Write a keyword to fill the form's name, email, and message fields.**

Now that we have our modular keyword we can use to fill any of our fields, we can
implement a new keyword, which calls our modular keyword several times for different
fields. However, _our form is inside an iframe_. We don't really want to call our wrapper multiple
times, if we're going to execute several steps there anyway. And neither we want to make
our test suite ugly by adding the wrapper call there. So, instead of only one new keyword,
we'll create 2: one to call from our test suite and one to call from that keyword.

Now that we're actually calling keywords in our test, we don't need the `No Operation` call
in our test suite anymore.

- Write 2 keywords to your resource file: `Fill All Form Fields` and
`Fill Form With Valid Data`.
- Add a call for `Fill All Form Fields` to your `Fill Form With Valid Data` keyword.
- Add a call for `Fill Form With Valid Data` to your test suite.
- Remove `No Operation` call from your test suite.

> :bulb: Remember that your form is inside an iframe. Your test suite will call
> `Fill Form With Valid Data`, so don't add `Run Inside Iframe` on your test suite level.
> You should call `Fill All Form Fields` inside an iframe.

We are now able to fill our fields. And think, we're able to do that with just one keyword!
In our other keyword `Fill All Form Fields` we can just call
`Fill Form Field` three times for the different fields and all should fill properly.

- Add `Fill Form Field` keyword calls for `Name`, `E-mail`, and `Message` fields
into your `Fill All Form Fields` keyword.

We can now hard-code our values for the three first fields. However, wouldn't it be cool if we
could give the keyword arguments and still call it from the test suite without arguments? We can do
that by using default values for arguments. Default values are given in a similar fashion to Python, by
using `${argument}=value` in our `[Arguments]`. Default values can be hardcoded or they can be other
variables we've defined in our `Variables` table or set as test/suite variables during our test case.

Let's add some default values for our `Name`, `E-mail`, and `Message` fields by new variables for each.
We'll call them `DEFAULT_<field>` for clarity. After we've created our variables, we can add arguments
to our `Fill All Form Fields` keyword for `name`, `email` and `message` and give them the default values
we just defined.

- Add three variables: `DEFAULT_NAME`, `DEFAULT_EMAIL`, and `DEFAULT_MESSAGE` to your `Variables` table
and give them some values (e.g `John Doe`, `john.doe@example.com`, `Hello, my name is John Doe.`
respectively).
- Add three arguments for your `Fill All Form Fields` named `name`, `email`, and `message` and give them
the default values based on your newly created variables.

---

**Create an embedded variable version of your keyword.**

We already have a working solution for filling our fields. There is, however, an alternative
solution, that has no other function than changing the keyword semantics a bit and it can
make reading the test case more natural.

Embedded arguments in a keyword allow the test case keywords to be read more fluently. For example,
we can change `Fill Form Field    Name    John Doe` into `Input "John Doe" Into Name Field` and
both will work in exactly the same way. Using embedded arguments in a keyword is only really powerful when
writing them directly in a test suite. Since the only difference for traditional keywords is
semantic, we don't really need to hide our arguments if we're only staying inside our resource files.
Furthermore, using embedded arguments can make it more difficult to jump between keywords in your editor.
We can't search keywords with embedded arguments directly by copy-pasting the keyword and during the
writing of this training, only some editors support jumping to keywords with embedded arguments.

We can define a keyword to use embedded arguments simply by placing the variable into the keyword
definition. So, for example `Input "John Doe" Into Name Field` keyword could be defined as
`Input "${value}" Into ${field} Field`. One thing to note is that keywords with embedded arguments
**cannot** take arguments with `[Arguments]`. If we try to have a keyword use both, we're going to
get an error when running our test case:

```text
[ ERROR ] Error in resource file '/path/to/our/file.robot': Creating keyword 'Input "${value}" Into ${field} Field' failed: Keyword cannot have both normal and embedded arguments.
```

> Embedded arguments are useful when we write our test case in user story format.
> For example, we could define our keyword like this:
> `As A ${user} I Should Be Able To ${do something}`. Then, we could define our test
> case with `As A Regular User I should Be Able To Login With Valid Credentials`,
> `As A Customer I Should Be Able To View My Orders`, etc.

- Add a keyword that takes embedded arguments instead of normal ones to fill your form.
- Modify your `Fill All Form Fields` to use the embedded arguments or call your embedded
arguments form the test case directly (you can modify them back after testing if you want,
it doesn't affect the outcome of the training).
- (Optional) Change your test suite to call the embedded argument keywords directly.

### Possible Errors

#### `ElementNotInteractableException`

If you don't show the form and try to do something with it, you're going to
see something like this:

```text
ElementNotInteractableException: Message: element not interactable
```

This means your element is hidden or blocked and you cannot do the operation
you're trying to do. This is very common when a page has multiple tabs, but
all tabs are loaded into the DOM. Your test finds the element, but it's
on another tab, thus, not interactable.

</details>

<details>
  <summary>Browser</summary>

**Define a modular keyword to fill your name, email, or message field.**

We've finally reached a point where we can start to fill our form. The easiest
fields to tackle are the name, email, and message fields. They're similar fields,
so we should create a keyword that fills each field just by specifying which
field we want to fill. We'll start by defining a keyword, which takes two arguments:
the field we want to fill and the value we want to give that field.

- Define a keyword `Fill Form Field`, which takes 2 arguments: `field` and `value`.

We know we'll input the value of the `value` argument, but we still don't know how
to access our element. However, as a placeholder, we can add already what we know
and make a note of what's missing.

- Add `Fill Text` keyword call to your keyword. Use a some notion for the locator
(for example `//TODO`) to indicate this isn't working yet. The input value for the
`Fill Text` should be your `value` argument.

---

**Find a good XPath to match the name, email, and message fields.**

Now that we have our initial keyword in place, let's take a look how we could best locate our
fields. Unfortunately, as we look at the form source code, we see that
the fields don't have any attributes that would really help us. Even worse, they're different
types: name and email fields are `input` and the message field is `textarea`. Seems like the
only element we can get a hand on is the `label` for each form field.

Let's first handle the situation with our mismatching input fields. One thing we know for sure:
our input field is _after_ the `label`. This means we can use the XPath `following-sibling` to
target elements that are children of the same parent, but come _after_  some specific element.
The `following-sibling` requires two colons (`::`) to indicate what element we want to match. XPath
supports wildcards, we could just use `*` to match any element after our `label`, but we want to
make sure we match our input field.

Similar to `following-sibling` we can check the type of
the current element by using `self`. For example, `//*[self::input]` is identical to `//input`.
Our input fields are either `input` or `textarea`, so our XPath should match both types. We can
use `or` inside our brackets (`[]`) to match either element. Half of our input field locator
is just about finished. There's no variables in our locator, so let's make it a static variable
in our `Variables` table.

- Write a variable called `INPUT_FIELD` for the `input` and `textarea` fields starting with
`following-sibling` into your `Variables` table.

> You can use `preceding-sibling` to get an element _before_ some other element.
>
> :bulb: Remember to **test your XPath** in the browser. Without the `following-sibling` your XPath
> should match 6 fields, which are all the fields in the form. Remember that the input fields are
> inside an iframe, so if you're testing with the console, you need to select the iframe first.

Ok, we are now able to select all `input` and `textarea` fields of our form. Now we can start
to make our XPaths unique using the `label`. The label has a `:` and some extra spaces we don't
want to match in our XPath, so we'll use `contains()` again. This time we're not checking
the value of an attribute, so we can't use `contains(@attribute, 'value')`. Instead, we're matching
the `text` of the attribute. It works the same way, but the syntax is slightly different. Instead
of `@text`, we have to use `text()`.

Our label XPath now looks something like this: `//label[contains(text(), 'some text')]`. The value
we want to insert into `some text` is of course the `field` argument. Since the XPath has a variable
inside it, we cannot put it in our `Variables` table and we have to keep it as it is in our keyword.

- Replace your `//TODO` XPath in your `Fill Form Field` keyword with an XPath selecting the `label`
based on your `field` argument.

All that's left is to combine the two XPaths we've gathered for this keyword. Combining our XPath
with a variable is as simple as putting them right after each other so a case like this

```robot
*** Variables ***
${XPATH_VARIABLE}       c/d

*** Keywords ***
My Keyword
    Click Element       xpath://a/b/${XPATH_VARIABLE}
```

would click an element with the XPath `//a/b/c/d`. We now how the locator for both our input field
and our label. We're all set to combine our XPaths and input a value into our form field.

- Add your `INPUT_FIELD` variable immediately after your XPath containing the `label`.

---

**Write a keyword to fill the form's name, email, and message fields.**

Now that we have our modular keyword we can use to fill any of our fields, we can
implement a new keyword, which calls our modular keyword several times for different
fields. However, _our form is inside an iframe_. Browser library doesn't have a way
to select a frame separately and execute a certain amount of steps inside the iframe
before deselecting the frame. Instead, the iframe needs to be selected separately for
each keyword call. Before we can go any further, we need to actually fix our `Fill Form Field`
keyword.

In Browser library iframes are handled with a special `>>>` syntax, which indicates that
we're selecting something from inside an iframe. For example `Click    my-frame >>> my-button`
click a button with the locator `my-button` inside an iframe with the locator `my-frame`.

- Add iframe handling to your `Fill Form Field` keyword by using `>>>` syntax.

We want to fill our form completely in a single keyword. However, we also want to keep our
test case clean regardless if we're filling the form with valid data or invalid data (in
this course we're only filling it once with valid data, but it's a preferable to have the
option to extend it easily). So, instead of only one new keyword,
we'll create 2: one to call from our test suite and one to call from that keyword.

Now that we're actually calling keywords in our test, we don't need the `No Operation` call
in our test suite anymore.

- Write 2 keywords to your resource file: `Fill All Form Fields` and
`Fill Form With Valid Data`.
- Add a call for `Fill All Form Fields` to your `Fill Form With Valid Data` keyword.
- Add a call for `Fill Form With Valid Data` to your test suite.
- Remove `No Operation` call from your test suite.

We are now able to fill our fields. And think, we're able to do that with just one keyword!
In our other keyword `Fill All Form Fields` we can just call
`Fill Form Field` three times for the different fields and all should fill properly.

- Add `Fill Form Field` keyword calls for `Name`, `E-mail`, and `Message` fields
into your `Fill All Form Fields` keyword.

We could now hard-code our values for the three first fields. However, wouldn't it be cool if we
could give the keyword arguments and still call it from the test suite without arguments? We can do
that by using default values for arguments. Default values are given in a similar fashion to Python, by
using `${argument}=value` in our `[Arguments]`. Default values can be hardcoded or they can be other
variables we've defined in our `Variables` table or set as test/suite variables during our test case.

Let's add some default values for our `Name`, `E-mail`, and `Message` fields by new variables for each.
We'll call them `DEFAULT_<field>` for clarity. After we've created our variables, we can add arguments
to our `Fill All Form Fields` keyword for `name`, `email` and `message` and give them the default values
we just defined.

- Add three variables: `DEFAULT_NAME`, `DEFAULT_EMAIL`, and `DEFAULT_MESSAGE` to your `Variables` table
and give them some values (e.g `John Doe`, `john.doe@example.com`, `Hello, my name is John Doe.`
respectively).
- Add three arguments for your `Fill All Form Fields` named `name`, `email`, and `message` and give them
the default values based on your newly created variables.

---

**Optional: Create an embedded variable version of your keyword.**

We already have a working solution for filling our fields. There is, however, an alternative
solution, that has no other function than changing the keyword semantics a bit and it can
make reading the test case more natural.

Embedded arguments in a keyword allow the test case keywords to be read more fluently. For example,
we can change `Fill Form Field    Name    John Doe` into `Input "John Doe" Into Name Field` and
both will work in exactly the same way. Using embedded arguments in a keyword is only really powerful when
writing them directly in a test suite. Since the only difference for traditional keywords is
semantic, we don't really need to hide our arguments if we're only staying inside our resource files.
Furthermore, using embedded arguments can make it more difficult to jump between keywords in your editor.
We can't search keywords with embedded arguments directly by copy-pasting the keyword and during the
writing of this training, only some editors support jumping to keywords with embedded arguments.

We can define a keyword to use embedded arguments simply by placing the variable into the keyword
definition. So, for example `Input "John Doe" Into Name Field` keyword could be defined as
`Input "${value}" Into ${field} Field`. One thing to note is that keywords with embedded arguments
**cannot** take arguments with `[Arguments]`. If we try to have a keyword use both, we're going to
get an error when running our test case:

```text
[ ERROR ] Error in resource file '/path/to/our/file.robot': Creating keyword 'Input "${value}" Into ${field} Field' failed: Keyword cannot have both normal and embedded arguments.
```

> Embedded arguments are useful when we write our test case in user story format.
> For example, we could define our keyword like this:
> `As A ${user} I Should Be Able To ${do something}`. Then, we could define our test
> case with `As A Regular User I should Be Able To Login With Valid Credentials`,
> `As A Customer I Should Be Able To View My Orders`, etc.

- Add a keyword that takes embedded arguments instead of normal ones to fill your form.
- Modify your `Fill All Form Fields` to use the embedded arguments or call your embedded
arguments form the test case directly (you can modify them back after testing if you want,
it doesn't affect the outcome of the training).
- (Optional) Change your test suite to call the embedded argument keywords directly.

</details>
