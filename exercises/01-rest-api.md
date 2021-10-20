# REST API testing

## Learning Goals

- You know the basics of making REST API requests with Robot Framework.

## Introduction

REST API based testing or RPA can be done in multiple different ways in Robot Framework.
You can of course do this with your own custom Robot Framework library using 3rd-party [`requests`](https://docs.python-requests.org/en/latest/) library
or similar, but Robot Framework also has a library for this already:
[RESTinstance](https://asyrjasalo.github.io/RESTinstance/). It offers
a simple syntax for your REST API based use cases. For example keywords like `Get` and `Post` call the API of your choice with
`GET` and `POST` requests.

> Although in these exercises we'll just validate requests
> and responses directly, please bear in mind that RESTinstance can be also used to validate and store the JSON
> schema, making it powerful when you don't need to validate exact response, but rather the _properties_
> of the response.

Another way to do it by using the [`Http`](https://marketsquare.github.io/robotframework-browser/Browser.html#Http) keyword from the Browser library.
While the Browser library API handling is much more limited than RESTinstance, if you only have some basic
requests you want to make, it works just fine.

In the exercises we'll test the REST API of the Bad Flask App. The endpoints in the Bad Flask App
are:

| Endpoint | Allowed methods |
| --- | --- |
| `/api/auth` | `POST` |
| `/api/forms` | `GET`, `POST`, `PUT` |
| `/api/forms/<id>` | `GET`, `PUT` |

All the responses are mocked (no data is really changed), so feel free to play around with the endpoints.

> :bulb: You can use `curl` commandline tool to test that the endpoints answer and return something.
> For example, the command to interact with first endpoint is `curl -X POST http://localhost:5000/api/auth`.

## Exercise

### Overview

- Get the authentication token and set it as a header in suite setup.
- Create 3 separate test cases, which use `Get`, `Post`, and `Put`. Those tests
should be implemented to check the following functions, one per test:
  - The name of the first form submitter (`/api/forms/1`) is `John Doe`.
  - It's possible to submit a new form. Request body needs to be a JSON string. Response code for a
  successful POST is `201`.
  - It's possible to edit an existing form (`/api/forms/1`). Request body needs to be a JSON string.

### Step-by-step

<details>
  <summary>Initialize you test suite</summary>

<br/>

In this exercise we're not going to write very sophisticated Robot Framework code, meaning
that we're going to do very simple test cases without putting keywords in a separate resource file.
In our `tests` folder, we have a file called `api.robot`. Let's open that up.

> The file resources `../resources/bad_flask_app.robot`. That import is only used with `Browser`
> library. If you're doing the exercises with `RESTinstance`, the import can be safely ignored. Running the
> suite with an empty resource file will log a warning, but will not affect the outcome of the exercise.

<details>
  <summary>RESTinstance</summary>

We're going to use the RESTinstance library, so we need to import `REST` into our `Settings`
table. RESTinstance sends requests directly into the target server, so it
requires a URL with the library import to initialize the library to do
queries against that server. We'll test the REST API of the Bad Flask App.
The server is running at `http://localhost:5000`, so let's initialize the library import with that URL.

- Add a library import for `REST` in your `Settings` table.
- Add `http://localhost:5000` as an argument for your library import.

</details> <!-- RESTinstance -->

<details>
  <summary>Browser</summary>

We're going to use the Browser library, so we need to import it into our `Settings` table in our resource file.
We'll test the REST API of the Bad Flask App. In order to do that, we're going to need a new browser, because
this library uses the browser instance to execute API calls.
From the Browser library documentation we see that there's two possible keywords for this: `New Browser` and
`New Page`. `New Browser` allows us to specify a browser and whether we want to use headless or headful
along with a bunch of other configurations. `New Page` just opens a new tab in our browser (or calls
`New Browser` with default parameters if no browser is open) to a URL we
specify. Since we're just using REST API backend, we don't need to see a browser, so we can call `New Page`
directly.

> There's also `Open Browser`, but that's only intended to be used for quick debugging and not for production
> use, so we're not going to use that here. `Open Browser` (by default) leaves the browser open on failure
> and opens in headful mode, but it doesn't support really any configurations whereas `New Browser` supports
> a wide variety of different configuration options.

- Add a library import for `Browser` in your `Settings` table to `bad_flask_app.robot` resource file.
  - (Optional) Also add the import to your `api.robot` test suite file.

Let's create ourselves our first keyword and let's call it `Open Browser To Our Application`. In here, we want
to open our browser to Bad Flask App and verify the page is opened before continuing. We'll use `New Page` to
open our browser in headless mode. The server is running in `http://localhost:5000`, so we'll give that
as a parameter to our `New Page` call.

- Create a new keyword `Open Browser To Our Application` to your resource file.
- Add `New Page` with the parameter `http://localhost:5000` to your keyword.

To verify the page load is complete, we can use `Get Title` to assert
the website title is `Bad Flask App`. Browser library has builtin waiting for all its keywords, so we don't
need to wait for the page elements to load before asserting the title. Browser library support Python-like validations,
so we can use syntax like `Get Title    ==    Bad Flask App` directly.

> As we're also going to use keywords from Browser library directly in our test suite file, it might
> be useful to
> also import `Browser` there. It's not strictly necessary and the tests will work just as fine without it.
> However, it allows you to see the dependencies of your file directly, instead of having to rely on a potentially
> very long dependency trail. Also, it helps prevent breaking
> in case of refactoring where resource files and libraries are placed elsewhere.

- Verify that the title is `Bad Flask App`.

As we have no other actions to be done before our tests begin
we want our browser to open immediately, let's add it as our suite setup in our
test suite.

- Add `Open Browser To Our Application` as your `Suite Setup` in your test suite file.

</details> <!-- Browser -->

> :bulb: If you're running your server with Docker, you might need to use the Docker-machine's
> IP address instead of `localhost`. You can find the docker-machine IP address by using
> `docker inspect <container_name>`.

</details> <!-- Initialize your test suite -->

---

<details>
  <summary>Authenticate and set headers</summary>

<br/>

Before we can query any data from Bad Flask App, we need a way to authenticate to the server.
We only want to authenticate once and use that as the authorization header. This means we
should add this as our `Suite Setup` in our `Settings` table.

- Add a keyword `Authenticate And Set Headers`.
- Add your new keyword as the `Suite Setup`.

> :bulb: Suite setup supports only running a single keyword.
> When doing exercises with `BROWSER` library, you need to use `Run keywords` as
> your suite setup to run multiple keywords together. Combine multiple keywords using
> `AND` (full upper-case, e.g. `Run Keywords    Log    1    AND    Log    2`).

The endpoint for authentication is `/api/auth` and it allows only `POST` requests.

<details>
  <summary>RESTinstance</summary>

Inside our `Authenticate And Set Headers` keyword, we should call the `Post` keyword to
the authentication endpoint to get the authentication token.

- Use `Post` keyword inside your `Authenticate And Set Headers` with the `/api/auth` endpoint.

The response is a JSON, and we should be able to get our data from that object. The easiest way
to do this is to use the `Output` keyword, which logs the request and the response JSONs directly
into the terminal. If we use just `Output` we notice that our token is inside the `body` of the
`response`. We can use standard JSONPath notion `$` to match the base of the response body. We can
also match the path by separating each value with a space, so the body of the response would be
`response body` (name inside the body would be `response body name`, etc.).

`Output` also returns the value we search, so if we search for `response body` (or `$`) we'll
get just our token as a string. We should store that into a variable. Storing return values into variables
works very much the same way as in any programming language, meaning `<variable name>= <variable value>`.
Although we need to follow proper Robot Framework syntax for setting variables as well, so setting a variable
requires `${}` around the variable name and proper usage of whitespace. For example

```robot
${status}=    Output    response status
```

- Use `Output` to store `response body` into a variable.

The final thing is to set our headers for the rest of our requests. We'll use `Set Headers` to
set our token as an authorization bearer header. `Set Headers` takes as argument a regular JSON string,
se we can just give our token variable as a `Bearer` to an `Authorization` key.

- Use `Set Headers` to give `{ "Authorization": "Bearer ${token}" }` as your headers inside your
`Authenticate And Set Headers` keyword.

> Note, that `Set Headers` sets the headers for the _entire suite_, so you should avoid
> using that inside your test cases directly if you want to affect all requests in other test cases.
> You can add headers directly to request keywords by using `headers=` argument.

</details> <!-- RESTinstance -->

<details>
  <summary>Browser</summary>

Browser library has
a `Http` keyword, which allows us to do basic API calls with a body and some headers. Inside our
`Authenticate And Set Headers` keyword, we should call the `Http` keyword to the authentication endpoint
by using `POST` as the method.

- Use `Http` to call `/api/auth` and make a `POST` request without a body or headers. Store the return
value as a dictionary variable (`&{response}`).

`Http` returns JSON as a Python dictionary. The authentication token is the `body` of our response.
By storing the return value directly as a dictionary object, we can use the much simpler dot notation
for our dictionary `${dict.key.key.key.value}` instead of `${dict["key"]["key"]["key"]["value"]}`. We can
store our headers as a suite variable, which we can then later use when making other `Http` requests for
our other exercises. Set a suite variable `HEADERS` (upper case, since it's a suite variable) and give it the
value `{"Authorization": "Bearer ${response.body}"}`.

- Use the stored response to set a suite variable with the value `{"Authorization": "Bearer ${response.body}"}`.

> :bulb: If you're getting an error`Resolving variable '${response.body}' failed: AttributeError: 'dict' object has no attribute 'body'`
> make sure you're storing our response as `&{response}` and **not** as `${response}`.

</details> <!-- Browser -->

> :bulb: The correct access token is indeed `NotAGoodToken`, so don't worry if your token looks "funny"
> \- it is intentional.

</details> <!-- Authenticate and set headers -->

---

<details>
  <summary>Get the first form and verify that its poster's name is <code>John Doe</code>.</summary>

<br/>

Now we're ready to create our first test case. We need to use a `GET` request to get the first form.
We can get it from the endpoint `/api/forms/1` and the response is a JSON with the first user's data.

> :bulb: It is possible to test this endpoint with `curl`, but since it requires authorization,
> you will have to add the header to the command too: `curl -X GET -H "Authorization: Bearer NotAGoodToken" http://localhost:5000/api/forms/1`.

- Create a new test case named `Get First Form And Verify Poster's Identity`.

<details>
  <summary>RESTinstance</summary>

RESTinstance library keywords are named exactly like the HTTP request methods. This means you can use `Get`
to make a `GET` request.

- Use `Get` to get the user from the endpoint `/api/forms/1`.

We can now assert that the queried data is what we expect it to be. We'll use the `Output`
keyword again to verify our result. `Output` doesn't verify anything automatically, but
we can query the `response body name` (or `$.name`) to get the name of the poster. When we store it in a
variable, we can simply call `Should Be Equal` to verify that our response is what we expect it
to be. In this case, it's `John Doe`.

- Use `Output` to store `response body name` into a variable.
- Use `Should Be Equal` to verify that your variable is equal to `John Doe`.

We've already verified that our user is what we expect it to be. If we didn't want `Output`
to flood our terminal we could redirect it to a file. Or, we could use `String` to compare
our result without having to use a variable.

> The assertion keywords are always effective on the _last_ query, so you don't need to
> store the result in a variable nor do we need to query the user again to do our assertion.

- Use `String` to verify `response body name` equals to `John Doe`.

> You can also store the return value of `String` into a variable. In this case you need to
> remember that it returns a _list_, and not a string. So for example the following snippet
> would resolve in a test failure:
>
> ```robot
> Get       /api/forms/1
> ${a}=     Output      response body name
> ${b}=     String      response body name
> Should Be Equal         ${a}      ${b}
> ```
>
> The output of the test would be
>
> ```text
> Get First Form And Verify Poster's Identity                           .
> "John Doe"
> Get First Form And Verify Poster's Identity                           | FAIL |
> John Doe != ['John Doe']
> ```

</details> <!-- RESTinstance -->

<details>
  <summary>Browser</summary>

Browser uses the `Http` keyword for all HTTP request methods. As the first argument we need the URL and as the second
argument we need the HTTP request method (`GET`). We need to
remember to add our headers separately to our `Http` call.

- Use `Http` to get the user from the endpoint `/api/forms/1` with the `GET` method.
- Use the `${HEADERS}` test variable as the request headers.
- Store the response into a dictionary variable (`&{response}`).

We can now assert that the queried data is what we expect it to be. We can simply use the built in
`Should Be Equal` keyword to verify our `response.body` is `John Doe`.

- Use `Should Be Equal` to verify that your `response.body` equals `John Doe`.

</details>

</details> <!-- Get first form and verify John Doe -->

---

<details>
  <summary>Create a new form using <code>POST</code> and verify it succeeded.</summary>

<br/>

Again, let's create a new test case. This time, need to make a `POST` request to create a new
form to our website and verify the form creation was successful. The endpoint to create a new form
is `/api/forms`.

- Create a new test case named `Post New Form And Verify Creation Succeeded`.

For our test case, it's enough to specify our form with an `id` and `name`. The data is
regular JSON, and it's going to be static, so let's create a variable for that in the
`Variables` table.

- Create a variable `NEW_FORM_DATA` and make it a JSON with an `id` and `name` with values of your choice.

<details>
  <summary>RESTinstance</summary>

As with `GET`, the RESTinstance keyword for `POST` is simply `Post`. We can use our `NEW_FORM_DATA` variable
as the body for our `Post`.

> The keywords are not case-sensitive, so `post`, `Post`, and `POST` work equally well.

- Use `Post` to the `/api/forms` endpoint.
- Add `NEW_FORM_DATA` variable as a second argument to your `Post`.

We still need to verify that our creation was successful. Again, we can use the `Output` to
get our response and check the `response status` to see that it's `201`. However, this time
the response code is an integer, so we need to use the `Should Be Equal As Integers` keyword.
Similar to `String`, we can also directly evaluate the status code with the `Integer` keyword.

> We could also use `${201}` in `Should Be Equal` to verify the response and `201` are equal integer values.

- Use `Output` to get the `response status` and store it in a variable.
- Use `Should Be Equal As Integers` to verify your response is equal to `201`.
- Use `Integer` to verify your `response status` is equal to `201`.

</details> <!-- RESTinstance -->

<details>
  <summary>Browser</summary>

As with `GET`, we'll use `Http` as our keyword, but this time we'll just use `POST` as
the request method. We can add a body to our `Http` keyword the same way we add headers.
Let's use our `NEW_FORM_DATA` as the body for our `POST` request.

- Use `Http` to the `/api/forms` endpoint and use the `POST` method.
- Use `HEADERS` test variable to set the headers for your request.
- Add a `body` parameter for your `Http` keyword call and give it the value `NEW_FORM_DATA`.
- Store the response into a dictionary variable (`&{response}`).

We still need to verify that our creation was successful. Again, we've stored the response value
to a dictionary. A successful post has the return code of `201`. The response also has an `ok` key,
which is true if the status code is `200`-`299`. We can use either `Should Be Equal As Integers`
to verify our response code is `201` or we can use `Should Be True` to verify `response.ok` is true.

> We could also use `${201}` in `Should Be Equal` to verify the response and `201` are equal.

- Use `Should Be Equal As Integers` to verify your response is equal to `201` or use
`Should Be True` to verify `response.ok`.

</details> <!-- Browser -->

> :bulb: Make the JSON in a single line.
>
> :bulb: The `id` needs to be unique. The API has 2 forms with ids `1` and `2`.

</details> <!-- POST exercise -->

---

<details>
  <summary>Modify the form form's email address using <code>PUT</code> and verify it succeeded.</summary>

<br/>

It's time for our third test case. This time we're using the `PUT` method to modify the first form
in the `/api/forms/1` endpoint.

> We could also use `/api/forms` and specify an `id` in our payload. Either way we do, `id` is
> mandatory in either of them. If specified in both, the `id` specified by the URL is used.

- Create a new test case named `Modify Form's Email Address And Verify It Succeeded`.

We'll only modify the user's email address, so let's create a variable called `NEW_EMAIL` into our `Variables`
table. It doesn't really matter what the new email is as long as it's different from the old email. So for example
`firstname.lastname@example.com` works in this situation.

- Create a variable `NEW_EMAIL` and make it a JSON with `firstname.lastname@example.com` as the value.

<details>
  <summary>RESTinstance</summary>

As with the previous exercises, we'll just use `Put` as our keyword.

- Use `Put` for endpoint `/api/forms/1`.

First, we need the current email address, so we can compare it to the changed one. Let's use `Get` to get that. Next,
we'll need a JSON payload for our `Put` to change the email address.

- Before `Put`, add a `Get` from the same endpoint.
- Use `String` or `Output` to get the `response body email` and store it in `old` variable.
- Add `NEW_EMAIL` as an argument to `Put`.

Bad Flask App sends the "modified" form as a response. We can use the response directly
to check if the email is different. We need to store the `response body email` again into a
variable, and we need to verify the emails are not equal.

- Use `String` our `Output` to get the the `response body email` and store it in `new` variable.
- Use `Should Not Be Equal` to verify that `old` and `new` are not the same.

> :bulb: It doesn't matter if you use `String` or `Output`, but you _must_ use the same
> after `Get` and after `Put`.

</details> <!-- RESTinstance -->

<details>
  <summary>Browser</summary>

It's time for our third test case. This time we're using the `PUT` method to modify the first form
in the `/api/forms/1` endpoint.

- Use `Http` to the `/api/forms/1` endpoint and use the `PUT` method.
- Use `HEADERS` test variable to set the headers for your request.
- Store the response into a dictionary variable (`&{response}`).

First, we need the current email address, so we can compare it to the changed one.
Let's use `GET` to get that.

Since we're using `GET` before our actual `PUT` and we only want the email from that, we can use a
variable with the same name and just overwrite it when we get the `PUT` response.

- Before `PUT`, add a `GET` from the same endpoint.
- Use `HEADERS` test variable to set the headers for your request.
- Store the response into a dictionary variable (`&{response}`).
- Use `Set Variable` to store `response.body.email` into a variable called `old`.
- Add `NEW_EMAIL` as the body to `PUT`.
- Store the response into a dictionary variable (`&{response}`).

Bad Flask App sends the "modified" form as a response. We can use the response directly
to check if the email is different. We need to store the `response.body.email` again into a
variable, and we need to verify the emails are not equal.

- Use `Set Variable` to store `response.body.email` into a variable calle `new`.
- Use `Should Not Be Equal` to verify that `old` and `new` are not the same.

</details> <!-- Browser -->

> If you want to check the response status of your `PUT`  request as well, it should be `200`.

</details> <!-- PUT exercise -->
