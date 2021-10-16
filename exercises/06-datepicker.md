# Datepicker

## Learning Goals

- You know how to handle dates and times
- You know how to handle Python objects in Robot Framework
- You are awareness of different Robot Framework libraries

## Introduction

Robot Framework is constantly growing with new external libraries to help us
with different types of issues. When we face a new issue, there's a good chance someone else
has struggled with the same thing as well and a library might already exist. No need
to reinvent the wheel. The power of open source is that anyone can add keywords to
any library if the library proves to be insufficient.

We're not going to write a new library nor will we modify an existing one, but we will
use another new library in this exercise to show that even though we're testing mostly
with web browsers, we can still utilize many more libraries in our test cases. The library
we're going to use is [Datetime](https://robotframework.org/robotframework/latest/libraries/DateTime.html).

## Exercise

### Overview

- Define a keyword called `Select Date From Future`, which takes the amount of `days` we
want to pick into the future as an argument.
- Have your keyword select a date within 2 weeks and click that element.
  - Use the [Datetime library documentation](https://robotframework.org/robotframework/latest/libraries/DateTime.html)
to find a keyword, which allows you to add a certain amount of days into another date.
  - The keyword should use the current date as a reference point.
  - The keyword should handle the situation that we need to click to next month and/or year.
- Add `Select Date From Future` keyword call to your `Fill All Form Fields` keyword.

### Step-by-step

<details>
  <summary>Create a new keyword.</summary>

<br />

Next, we're going to handle selecting a date for our `Date` field. It's a read-only field,
so we're not able to to simply type in our wanted date. Clicking a date in a datepicker
is very easy to do for a human, but there are several things to consider when automating it.

This time, we're not really typing anything, but we're
selecting from a list of available values. Let's create a keyword that describes what we're
doing, like `Select Date From Future`.

We already know that this keyword will need at least one argument, so without any hard-coding
detour let's add `days` as an argument now.

> You could name it something like `Fill Date Field` or similar, but right now we're making a
> distinction about the differences of the keywords. If you feel like you want `Fill Date` (or similar)
> is more intuitive, go ahead!
>
> You could also implement this with embedded arguments with something like `Select A Date ${days} Days
> In The Future`.

- Create a keyword called `Select Date From Future`.
- Give the keyword the amount of `days` we want to go into the future as an argument.

First things first:
we need to open our datepicker. We can do that by clicking the date field. Lucky for us, the
datepicker has an `id` attribute with the value `datepicker`.

- Make the keyword click the `datepicker` element.

</details> <!-- Define keyword -->

---

<details>
  <summary>Use <code>Datetime</code> library to get a date in the future</summary>

<br />

Bad Flask App requires a date that is within the next two weeks, excluding today (i.e
tomorrow to 14 days into the future).
Therefore, we can't click the first date of the month our app happens to open and we can't press
the next month bunch of times to get our date in distant future, like year 2200.

Taking these things into consideration, we know that we might need to click to the next
month _once_, but never more than that (since a no month lasts less than two weeks).
Also, we're not sure if we have to click the button in the first place.

In order to select a specific date from the future, we're going to need a few extra steps:
first, we need today's date. Second, we need to get the date `days` amount of days into the future.
Third, we need to check if our future date is in the next month or not. These steps can be fairly easily
done with the `DateTime` library. We can get the current date directly with the `Get Current Date`
keyword and we can get a date from the future using the `Add Time To Date` keyword. We also need to
specify that we're adding days with our keyword, so essentially our argument will be `${days} days`.
The only thing we need to note is that both of the `DateTime` library keywords return a string by default.
We need to specify their `result_format` to `datetime` in order to manipulate our dates as dates.

- Inside your `Select Date From Future` keyword, get the current date with `Get Current Date` and store it in a variable.
  - Remember to have `result_format=datetime` as an argument for that keyword call.
- Get a date in the future using `Add Time To Date` using your `days` argument. Store the return value
into a variable.
  - Remember to use `result_format=datetime` again as an argument for the keyword call.

Excellent! We now have two dates, both in `datetime` format. We can now evaluate and parse those as
needed for the purpose of selecting a date.

</details> <!-- Get date from future -->

---

<details>
  <summary>Select date in the form</summary>

<br />

Let's continue by deciding if we need to go to the next month or not. Just like when we closed
the dropdown, we're going to use `Run Keyword If`. The condition for that keyword is evaluated
as Python, so we can give it a Python comparison operator directly. We have two variables: `current_date`
and `future_date`. They are both `datetime` objects, meaning that we can access the `day`, `month`, `year`,
`hour`, `minute`, and  `second` attributes directly. We do that by having using Python-style `.attribute`
syntax _inside_ our variable. For example, we can get the `month` of our `current_date` variable
by calling `${current_date.month}`.

We can check if the month of the current date is _less_ than the month in the future date. However,
that in itself is not enough, since then we'll get in trouble in January when 1 is not more than 12.
That's why we need to check that either the month or the year must be greater in our future date to
have it behave properly. Again, it's a simple Python evaluation so we can use `condition1 or condition2`
just we would use in Python.

- Add a `Run Keyword If` call to your keyword and check if the `month` or `year` of our `current_date`
are less than in our `future_date`.

So far we've opened our datepicker and we've determined if we should go to the next month or not. We
still need to find the locator for our next month button (the little arrow on the top right of the datepicker).
Like just about all datepickers, it doesn't have `id` attributes, so we'll use XPaths once again.
Our arrow is a link (`a`) with a class called `ui-datepicker-next` (or `data-handler='next'` or
`title='Next'`). Let's add that as a variable in the `Variables` table and have our `Run Keyword If`
click that element if it evaluates to `True`.

- Add a variable `DATEPICKER_NEXT_BUTTON` to your `Variables` table and give it the value
  `//a[contains(@class,'ui-datepicker-next')]`.
- Add a `Click Element` call for your newly created variable in your `Run Keyword If`.

Finally, we're all set to click our wanted date. Tables are typically nasty in Robot Framework. Not
necessarily because they're hard to access, but since table cells don't usually have any nice
identifiers, so we're usually forced to evaluate `text()` in a certain cell and then maybe get a
value from another cell using `following-sibling` or by using an index. This is usually tedious to implement,
since it takes some time and the XPath is not pretty by the end of the day.

However, in datepickers we can simply get the cell, which has the correct `text`, so we don't need to
go in too deep into finding the correct cell in our table. We just need to make sure we're
selecting the correct cell. Looking at the source code we notice that the cell is just another `a` with
the date as text. Just like with accessing the year and month, we can select `day` from our
`future_date` to evaluate.

- Add a `Click Element` to your keyword that selects the date which has the same value as
`${future_date.day}`.

> If Bad Flask App was more like a traditional website, our XPath would probably need to specify that
> the `a` is in a `td`, which is inside a `table`, so our XPath would be something more like
> `//table[@class='ui-datepicker-calendar']//td/a[text()='${future_date.day}']`. But since we want
> to keep our XPaths as short as possible, we can ignore everything before `a` in this particular website.

</details> <!-- Select date -->

---

<details>
  <summary>Add your keyword to <code>Fill All Form Fields</code></summary>

<br />

While we're still at it. Let's do one more quick step to get rid of our hard-coded `3` in our
`Fill All Form Fields` keyword. Let's add that as a new `DEFAULT_DAYS` variable and have the keyword
use that as a default value for its own `days` argument.

- Add `DEFAULT_DAYS` variable into your `Variables` table with the value `3`.
- Give `Fill All Form Fields` a new argument `days` and give it `DEFAULT_DAYS` as a default value.
- Add your `Select Date From Future` call to `Fill All Form Fields` keyword with the argument `days`
to make it go 3 days into the future by default.

</details> <!-- Add to fill all form fields -->
