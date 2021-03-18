# Robot Framework advanced training

## Prerequisites for the training

- Python 3.x, `pip`, and Robot Framework installed on your machine
- Knowledge of how to write Robot Framework and Python ([Fundamentals training](https://github.com/eficode-academy/rf-katas))

It's possible to take 2 routes for this training: SeleniumLibrary and Browser Library.
For SeleniumLibrary you need

- A working browser + driver combination (e.g. Chrome and
[chromedriver](https://chromedriver.chromium.org/downloads))

For Browser you need Python 3.7 or newer

- See detailed installation instructions for Browser from the [official installation instructions](https://github.com/MarketSquare/robotframework-browser#installation-instructions)

## Learning Goals

After this training, you should

1. Know the basics of using RESTInstance library
2. Understand good test architecture
3. Know how to navigate and avoid common pitfalls with XPaths
4. Know how to handle iframes
5. Understand how to create modular keywords
6. Understand to create and import your own custom libraries
7. Know how to use for-loops
8. Understand when it's better to **not** follow human behaviour
9. How to create meaningful documentation
10. Understand and troubleshoot different errors in web testing

## Exercise topics

All exercise files are in the [exercises](./exercises) directory.

Before starting your exercises, be sure to have your environment fully working by following
[00-getting-started.md](exercises/00-getting-started.md).

- All API tests are combined in a single file ([01-rest-api.md](exercises/01-rest-api.md))
- Introduction to Bad Flask App ([02-bad-flask-app-intro.md](exercises/02-bad-flask-app.md))
- Introduction to XPaths ([03-xpath-intro.md](exercises/03-xpath-intro.md))
- Handling iframes ([04-iframes.md](exercises/04-iframes.md))
- More difficult XPaths ([05-filling-fields.md](exercises/05-filling-fields.md))
- Extend your libraries with Python ([06-datepicker.md](exercises/06-datepicker.md))
- Handling for-loops ([07-slider.md](exercises/07-slider.md))
- Make life easier with `Execute Javascript` ([08-execute-javascript.md](exercises/08-execute-javascript.md))
- Writing meaningful documentation ([09-documentation.md](exercises/09-documentation.md))
