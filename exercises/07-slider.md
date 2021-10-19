# Slider

## Learning Goals

- You know how to use for-loops
- You understand how and why to specify locator type to UI keywords
- You grasp how to implement user behaviour

## Introduction

Having to use a slider in test automation isn't all that common and most often it can be
bypassed. What's more important than the actual slider, is the logic how we will operate it.
They're handled by looping n amount of times until we've reached a value we want.
In this exercise, we're going to move our slider by using Robot Framework's for-loops.

## Exercise

### Overview

- Implement the keyword that moves iteratively the "Important number" slider to any desired value.
  - Find the size of the slider element.
  - Create a loop, iterating through the slider's width from left to right.
  - Use `Exit For Loop If` as soon as the loop reaches the wanted value.
  - Otherwise, keep moving the slider, bit by bit, to the right.
- Add `Change Important Number` call to the keyword filling the form, and set it to go to 15.

### Step-by-step

<details>
  <summary>Begin implementing the <code>Change Important Number</code> keyword to slide the slider</summary>

<br />

In `Change Important Number`, we want to be able
to change our important number to any number we want, so our keyword will need an argument `wanted_value`.
We know we'll call this keyword from the keyword filling the form, so let's just add a call for our
new keyword there straight away. Also, instead of making a detour of hard-coding a value in first use, let's create
a `DEFAULT_IMPORTANT_NUMBER` variable
immediately and give it the value `15`.

- In `Change Important Number`, add an argument called `wanted_value` for your keyword.
- Call `Change Important Number` in your keyword filling the form
- Add an argument called `important_number` to your `Fill All Form Fields`
- Add `DEFAULT_IMPORTANT_NUMBER` variable with the value `15`.
- Give `important_number` a default value of `DEFAULT_IMPORTANT_NUMBER`.

</details> <!-- Begin implementing -->

---

<details>
  <summary>Find element size</summary>

<br />

Before we continue, we should think about our logic for a moment. Usually, when we use a slider
we do at least one of these things: click the slider at some specific point X to move the selector to
that point, and click and hold the selector to drag it left or right to reach some value. This
is pretty easy for a human, but to automate it, we would need to calculate how many pixels we should click in some direction, and if it was wrong, correct it.

When we consider there's different screen resolutions and window
sizes, we realize it's hard or even impossible to write a script that can click the correct pixel on first try, and succeed every time. Also,
handling pixel accuracy is always a trade-off between development speed, accuracy, resilience and support
between different resolutions and window sizes.

<details>
  <summary>SeleniumLibrary</summary>

Instead of clicking a value directly on a slider, we're actually going to slide it. The slider
is at value 0 initially, so let's drag it from left to right. To do that we're going to need our
slider's size. We can get that directly with `Get Element Size` from the SeleniumLibrary. That keyword
returns the width and height of the element and even though we're only going to use the width, we
need to store them both. Storing multiple values from a keyword works in the same way as giving
multiple values as keyword arguments: separate the different variables with at least two spaces.

`Get Element Size` (as pretty much all other SeleniumLibrary keywords) need a locator for our element.
The element doesn't have an `id`, so we're going to need an alternative locator. We can use the `name`
locator (`important_number`), which is almost as good as an `id`. We can also use an XPath as with
previous exercises.

> If we use `name`, we're already using three different types of locators in our
> resource file. SeleniumLibrary can handle `id`, `name`, and `xpath` locators without having to specify
> which type of locator we're using. The library first tries to locate the element with `id`, then by
> `name`, and finally defaults to `xpath`. So we don't need to specify the locator type when using
> one of those three. However, since the other locator types need a specification, it's a good practice
> to always specify the locator type, just to make our files more consistent. We can specify a locator
> by using `<locator_type>:<locator>`. For example, if an element has an `id` and `name` of `myElement`,
> we should use `id:myElement`, `name:myElement`, or `xpath://element[@id='myElement']` as our locators.

- Get the slider `width` and `height` of the `important_number` element with `Get Element Size`.

</details> <!-- SeleniumLibrary -->

<details>
  <summary>Browser</summary>

Instead of clicking a value directly on a slider, we're actually going to slide it. The slider
is at value 0 initially, so let's drag it from left to right. To do that we're going to need our
slider's size. We can get that directly with `Get BoundingBox` keyword from the Browser library.
We can further specify we only want the width of the element by giving it `width` as an additional argument.

`Get BoundingBox` (as pretty much all other Browser keywords) needs a locator for our element.
The element doesn't have an `id`, so we're going to need an alternative locator. We can use the `name`
locator (`important_number`), which is almost as good as an `id`. We can also use an XPath as with
previous exercises.

> If we use `name`, we're already using three different types of locators in our
> resource file. Browser uses `css` as its default locator. All locators that start with `//` or `..`
> are automatically considered to be XPaths and if they start with a double quote `"` they're considered
> to be text. So, we don't need to specify the locator type when using css, XPath, or text, but in case
> case we mix them a lot it might actually be more readable to specify always specify the locator types.
> We can specify a locator
> by using `<locator_type>=<locator>`. For example, if an element has an `id` and `name` of `myElement`,
> we should use `id=myElement`, `name=myElement`, or `xpath=//element[@id='myElement']` as our locators.

- Get the slider `width` of the `important_number` element with `Get BoundingBox` and store it in a variable.

Before we loop over the width of the slider, we should place our mouse at the correct position and press
our mouse button. We can do these directly with the `Hover` and `Mouse Button` keywords.

- Use `Hover` to put your cursor on the slider element.
- Use `Mouse Button` with the argument `down` to press the mouse button down without releasing it.

</details> <!-- Browser -->

> :bulb: Remember that the form is inside an iframe.

</details> <!-- Find element size -->

---

<details>
  <summary>Loop through the width of the element</summary>

<br />

Now we have the width of our slider, we're going to need a for-loop. As of Robot Framework 3.1, the
for-loop syntax is

```robot
FOR     ${index}    IN RANGE    ${length}
    # Do stuff
END
```

We're going to move our slider from left to right, so basically our loop is going to go through all the
pixels in the slider's width. At every pixel, we're going to check if we've hit our wanted value. The
value shouldn't change on every pixel, so we're able to use some acceleration in our loop.

- Create an empty for-loop running through every `pixel` in your element's `width`.

Inside our loop, we're going to need the current value of our "Important number". The value can be
seen in a `span` element, which luckily has `id="number"`. We can get the number directly by using
the `Get Text` keyword from the SeleniumLibrary.

- Get the `current_value` from `id=number` using `Get Text`.

When we have our text value, we should check if we're already at the wanted value (our `wanted_value` argument)
and come out of the loop if so. We can break out of a loop early by using `Exit For Loop If`. The evaluation
is standard Python evaluation, so you can use `value1 == value2` to check if the two values are the same.

- Use `Exit For Loop If` to break out of the loop if `current_value` is equal to `wanted_value`.

Great, we will now exit the for-loop once we reach our `wanted_value`. Now, we still need to do the
actual slider handling. We're dragging the slider from left to right. The coordinates `(0, 0)` are at
the center of the element and positive axis are right and up. So, the left edge is at `-width/2`.
From there, we want to move right a certain amount of pixels. Browser library is actually pretty fast,
so we can loop every pixel, and it still doesn't take too long.

> This part is slightly specific to this particular slider as well, since the ball-shaped selector is not
> a separate element, but rather a part of the slider. That's why we always need to count the pixel we want to
> move as the absolute amount of pixels from the left border by using the formula above. If the selector
> was its own element, we could just move the selector a few pixels right each iteration without
> having to worry about the width of the element.

Now that we know our formula, we still need to convert it to Robot Framework code.
We can get that by using the `Evaluate` keyword from the BuiltIn library.

- Store `position` by using the `Evaluate` keyword using the formula `-(${width}/2) + ${pixel}`.

> :bulb: With `SeleniumLibrary` this operation will be _extremely_ slow, so you might want to add a multiplier like
> `-(width/2) + 3 * current pixel` to step a few pixels at a time.

<details>
  <summary>SeleniumLibrary</summary>

Finally, we have everything we need to move the slider. We can use the SeleniumLibrary keyword
`Drag And Drop By Offset` to drag our slider. The keyword takes three arguments: locator, offset in x-axis,
and offset in y-axis. Our locator is the same as we used for getting the element size, our x-axis is our
`position` we calculated by using the formula, and since we only want to move along the x-axis, our last
argument will be `0`.

- Use `Drag And Drop By Offset` to move the slider right by using `position` and `0` as the directional
arguments.

> :bulb: Using `3*pixel` already skips some numbers on some resolutions. It should hit `15`, but if
> it doesn't, either lower the skip, or change 15 to something it does hit. The new value must be in 10-90.
>
> When you run this in your test, you can see the slider make weird lurching jumps to the center of the element
> sometimes. That's because `Drag And Drop By Offset` grabs the element from its center
> and moves it to the position we give it. The slider itself doesn't actually move at all, just
> the selector moves inside it. This grabbing is why the selector always moves to the middle of the element, each iteration of our loop.

</details> <!-- SeleniumLibrary -->

<details>
  <summary>Browser</summary>

Finally, we have everything we need to move the slider. We can use the Browser keyword
`Mouse Move Relative To` to move our cursor on the slider.
The keyword takes three arguments: locator, offset in x-axis,
and offset in y-axis. Our locator is the same as we used for getting the element size, our x-axis is our
`position` we calculated by using the formula, and since we only want to move along the x-axis, our last
argument will be `0`.

- Use `Mouse Move Relative To` to move the slider right by using `position` and `0` as the directional
arguments.

We're already exiting the for-loop when our mouse is over the correct value. We used `Mouse Button    down`
earlier to press and hold the left mouse button. Now that we're at the correct element, we need to release
our mouse button. We can do it with the same keyword, but giving `up` as an argument.

- Use `Mouse Button` with the argument `up` to release your mouse after the loop has finished.

</details> <!-- Browser -->

</details> <!-- Loop through element width -->
