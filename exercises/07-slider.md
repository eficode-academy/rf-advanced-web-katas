# Slider

## Learning Goals

- You know how to use for-loops
- You understand how and why to specify locator type to UI keywords
- You have understanding how to implement user behaviour

## Introduction

Having to use a slider in test automation isn't all that common and most often it can be
bypassed. What's more important than the actual slider, is the logic how we will operate it.
They're handled by looping n amount of times until we've reached a value we want.
In this exercise, we're going to move our slider by using Robot Framework's for-loops.

## Exercise

### Overview

- Implement a keyword that loops to slide the "Important number" slider to a value 15.
  - Find the size of the slider element.
  - Loop through the slider's width from left to right.
  - Use `Exit For Loop If` when it has found the wanted value.
  - Move the slider slightly to the right otherwise.
- Add `Change Important Number` call to your `Fill All Form Fields` keyword.

### Step-by-step

<details>
  <summary>SeleniumLibrary</summary>

**Write a keyword that moves the slider of "Important number" to a wanted value.**

Once again, let's begin by defining ourselves a new keyword `Change Important Number`. We want to be able
to change our important number to any number we want, so our keyword will need an argument `wanted_value`.
Instead of making a detour of hard-coding a value first, let's create our `DEFAULT_IMPORTANT_NUMBER` variable
immediately and give it the value `15`.

- Create a new keyword `Change Important Number`.
- Add an argument called `wanted_value` for your keyword.
- Add `DEFAULT_IMPORTANT_NUMBER` variable with the value `15`.
- Give `wanted_value` a default value of `DEFAULT_IMPORTANT_NUMBER`.

**Find the size of the element.**

Before we continue, we should think about our logic for a moment. Essentially, when we handle a slider
we typically do one of two things: click the slider at some specific point X to move the selector to
that point or click and hold the selector and drag it left or right to some value. Clicking left of right
is pretty easy for a person, but in order to calculate how many pixels we should click in some direction
programmatically is difficult. Especially when it comes to different screen resolutions and window
sizes it's often almost impossible to write a script that can click the correct pixel immediately. Also,
handling pixel accuracy is always a tradeoff between development speed, accuracy, resilience and support
between different resolutions and window sizes.

Right, so instead of clicking a value directly on a slider, we're actually going to slide it. The slider
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

**Loop through the width of the element.**

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

- Get the `current_value` from `id:number` using `Get Text`.

When we have our text value, we should check if we're already at the wanted value (our `wanted_value` argument)
and come out of the loop if so. We can break out of a loop early by using `Exit For Loop If`. The evaluation
is standard Python evaluation so you can use `value1 == value2` to check if the two values are the same.

- Use `Exit For Loop If` to break out of the loop if `current_value` is equal to `wanted_value`.

Great, we will now exit the for-loop once we reach our `wanted_value`. Now, we still need to do the
actual slider handling. We're dragging the slider from left to right. The coordinates `(0, 0)` are at
the center of the element and positive axis are right and up. So, the left edge is at `-width/2`.
From there, we want to move right a certain amount of pixels. The value doesn't change every pixel so we
don't need to move only one pixel per loop, but we can loop something like every third pixel. This way
our full calculation will be `position = -(width/2) + 3 * current pixel`.

> This part is slightly specific to this particular slider as well, since the ball selector is not its
> own element, but a part of the slider as a whole. That's why we always need to count the pixel we want to
> move as the absolute amount of pixels from the left border by using the formula above. If the selector
> was its own element, we could simply just move the selector a few pixels right each iteration without
> having to worry about the width of the element.

Now that we know our formula, we still need to make it Robot Framework and we need to drag our element.
We can get that by using the `Evaluate` keyword from the BuiltIn library.

- Store `position` by using the `Evaluate` keyword using the formula `-(${width}/2) + 3 * ${pixel}`.

> If you find every third pixel too slow, you're free to try another formula. We're going to keep
> using `3*pixel`, just to demonstrate how the loop works. This solution is by no means the most optimal
> way to move the slider.

Finally, we have everything we need to move the slider. We can use the SeleniumLibrary keyword
`Drag And Drop By Offset` to drag our slider. The keyword takes three arguments: locator, offset in x-axis,
and offset in y-axis. Our locator is the same as we used for getting the element size, our x-axis is our
`position` we calculated by using the formula, and since we only want to move along the x-axis, our last
argument will be `0`.

- Use `Drag And Drop By Offset` to move the slider right by using `position` and `0` as the directional
arguments.

> :bulb: Using `3*pixel` already skips some numbers on some resolutions. It should hit `15`, but if
> it doesn't, change your parameter value to something it does hit. The suitable value range is 10-90.
>
> When you run this in your test, you should see weird jagged spikes to the center of the element
> every now and then. That's because `Drag And Drop By Offset` grabs the element from its center
> and moves it to the pixels we determined. However, our slider element doesn't actually move at all, but
> the selector moves inside the element. This is why the selector always goes to the middle of the element
> when the keyword grabs it from the center in a new iteration of our loop.

---

**Add a call to `Fill All Form Fields`.**

Now that our slider, although very slowly, works, we should add a call to that in our `Fill All Form Fields`
keyword. Also, that keyword should use the `DEFAULT_IMPORTANT_NUMBER` by default.

- Add your `Change Important Number` call to your `Fill All Form Fields` keyword.
- Add `important_number` argument to your `Fill All Form Fields` keyword and give it your newly
created `DEFAULT_IMPORTANT_NUMBER` variable as a default value.
- Add `important_number` as an argument to your `Change Important Number` call.

</details>

<details>
  <summary>Browser</summary>

**Write a keyword that moves the slider of "Important number" to a wanted value.**

Once again, let's begin by defining ourselves a new keyword `Change Important Number`. We want to be able
to change our important number to any number we want, so our keyword will need an argument `wanted_value`.
Instead of making a detour of hard-coding a value first, let's create our `DEFAULT_IMPORTANT_NUMBER` variable
immediately and give it the value `15`.

- Create a new keyword `Change Important Number`.
- Add an argument called `wanted_value` for your keyword.
- Add `DEFAULT_IMPORTANT_NUMBER` variable with the value `15`.
- Give `wanted_value` a default value of `DEFAULT_IMPORTANT_NUMBER`.

**Find the size of the element.**

Before we continue, we should think about our logic for a moment. Essentially, when we handle a slider
we typically do one of two things: click the slider at some specific point X to move the selector to
that point or click and hold the selector and drag it left or right to some value. Clicking left of right
is pretty easy for a person, but in order to calculate how many pixels we should click in some direction
programmatically is difficult. Especially when it comes to different screen resolutions and window
sizes it's often almost impossible to write a script that can click the correct pixel immediately. Also,
handling pixel accuracy is always a tradeoff between development speed, accuracy, resilience and support
between different resolutions and window sizes.

Right, so instead of clicking a value directly on a slider, we're actually going to slide it. The slider
is at value 0 initially, so let's drag it from left to right. To do that we're going to need our
slider's size. We can get that directly with `Get BoundingBox` keyword from the Browser library.
We can further specify we only want the width of the element by giving it `width` as an additional argument.

`Get BoundingBox` (as pretty much all other Browser keywords) need a locator for our element.
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

**Loop through the width of the element.**

Now we have the width of our slider, we're going to need a for-loop. As of Robot Framework 3.1, the
for-loop syntax is

```robot
FOR     ${index}    IN RANGE    ${length}
    # Do stuff
END
```

We're going to move our slider from left to right, so basically our loop is going to go through all the
pixels in the slider's width. At every pixel, we're going to check if we've hit our wanted value.

- Create an empty for-loop running through every `pixel` in your element's `width`.

Inside our loop, we're going to need the current value of our "Important number". The value can be
seen in a `span` element, which luckily has `id="number"`. We can get the number directly by using
the `Get Text` keyword.

- Get the `current_value` from `id=number` using `Get Text`.

> :bulb: Remember that the form is inside an iframe.

When we have our text value, we should check if we're already at the wanted value (our `wanted_value` argument)
and come out of the loop if so. We can break out of a loop early by using `Exit For Loop If`. The evaluation
is standard Python evaluation so you can use `value1 == value2` to check if the two values are the same.

- Use `Exit For Loop If` to break out of the loop if `current_value` is equal to `wanted_value`.

Great, we will now exit the for-loop once we reach our `wanted_value`. Now, we still need to do the
actual slider handling. We're dragging the slider from left to right. The coordinates `(0, 0)` are at
the center of the element and positive axis are right and up. So, the left edge is at `-width/2`.
From there, we want to move right a certain amount of pixels. Browser library is actually pretty fast,
so we can loop every pixel and it still doesn't take too long.

> This part is slightly specific to this particular slider as well, since the ball selector is not its
> own element, but a part of the slider as a whole. That's why we always need to count the pixel we want to
> move as the absolute amount of pixels from the left border by using the formula above. If the selector
> was its own element, we could simply just move the selector a few pixels right each iteration without
> having to worry about the width of the element.

Now that we know our formula, we still need to make it Robot Framework and we need to drag our element.
We can get that by using the `Evaluate` keyword from the BuiltIn library.

- Store `position` by using the `Evaluate` keyword using the formula `-(${width}/2) + ${pixel}`.

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

---

**Add a call to `Fill All Form Fields`.**

Now that our slider works, we should add a call to that in our `Fill All Form Fields`
keyword. Also, that keyword should use the `DEFAULT_IMPORTANT_NUMBER` by default.

- Add your `Change Important Number` call to your `Fill All Form Fields` keyword.
- Add `important_number` argument to your `Fill All Form Fields` keyword and give it your newly
created `DEFAULT_IMPORTANT_NUMBER` variable as a default value.
- Add `important_number` as an argument to your `Change Important Number` call.

</details>
