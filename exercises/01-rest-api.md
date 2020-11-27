# REST API testing

## Learning Goals

- You know how to make basics of making REST API requests with Robot Framework.

## Introduction

REST API based testing or RPA can be done in multiple different ways in Robot Framework.
You can of course do this with your own custom library using `requests`
or similar, but Robot Framework also has a library for this already:
[RESTinstance](https://asyrjasalo.github.io/RESTinstance/). The RESTinstance offers
a simple syntax for your REST API based use cases. Simple keywords like `Get` and `Post` call the
`GET` and `POST` APIs for your website.

In the exercises we'll test the REST API of the Bad Flask App. The endpoints in the Bad Flask App
are:

| Endpoint | Allowed methods |
| --- | --- |
| `/api/auth` | `POST` |
| `/api/forms` | `GET`, `POST`, `PUT` |
| `/api/forms/<id>` | `GET`, `PUT` |

All the responses are mocked, so don't be afraid to play around with the endpoints.

## Exercise

### Overview

- Get authentication token and set it as a header in suite setup.
- Create 3 separate test cases, which use `Get`, `Post`, and `Put`. Your tests
should check the following:
  - The name of the first form submitter (`/api/forms/1`) is `John Doe`.
  - It's possible to submit a new form. Request body needs to be a JSON string. Response code for a
  successful POST is `201`.
  - It's possible to edit an existing form (`/api/forms/1`). Request body needs to be a JSON string.

### Step-by-step

#### SeleniumLibrary

<details>
  <summary>Expand</summary>


**Initialize your test suite with `REST` library.**

In this exercise we're not going to write very sophisticated Robot Framework, meaning
that we're going to do very simple test cases without doing a resource file separately.
In our `tests` folder, we have a file called `api.robot`. Let's open that up.

We're going to use the RESTinstance library, so we need to import `REST` into our `Settings`
table. We'll test the REST API of the Bad Flask App. The server is running in `http://localhost:5000`,
so let's initialize the library import with that URL.

- Add a library import for `REST` in your `Settings` table.
- Add `http://localhost:5000` as an argument for your library import.

> :bulb: If you're running your server with Docker, you might need to use the Docker-machine's
> IP address instead of `localhost`. You can find the docker-machine IP address by using
> `docker inspect <container_name>`.

---

**Authenticate to server and set headers.**

Before we can query any data from Bad Flask App, we need to authenticate to the server.
We only want to authenticate once and use that as the authorization header. This means we
should add this as our `Suite Setup` in our `Settings` table. We'll need a new keyword for this,
so let's create a `Keywords` table and add our keyword there.

- Add `Keywords` table.
- Add a keyword `Authenticate And Set Headers`.
- Add your new keyword as the `Suite Setup`.

The endpoint for authentication is `/api/auth` and it allows only `POST` requests. Inside our
`Authenticate And Set Headers` keyword, we should call the `Post` keyword to the authentication
endpoint to get the authentication token.

- Use `Post` keyword inside your `Authenticate And Set Headers` with the `/api/auth` endpoint.

The response is a JSON and we should be able to get our data from that object. The easiest way
to do this is to use the `Output` keyword, which logs the request and the response JSONs directly
into the terminal. If we use just `Output` we notice that our token is inside the `body` of the
`response`. We can use standard JSONPath notion `$` to match the base of the response body. We can
also match the path by separating each value with a space, so the body of the response would be
`response body` (name inside the body would be `response body name`, etc.).

`Output` also returns the value we search, so if we search for `response body` (or `$`) we'll
get just our token as a string. We should store that into a variable.

- Use `Output` to store `response body` into a variable.

The final thing is to set our headers for the rest of our requests. We'll use `Set Headers` to
set our token as an authorization bearer header. `Set Headers` takes arguments as regular JSON,
se we can just give our token variable as a `Bearer` to an `Authorization` key.

- Use `Set Headers` to give `{ "Authorization": "Bearer ${token}" }` as your headers inside your
`Authenticate And Set Headers` keyword.

> Note, that `Set Headers` sets the headers for the _entire suite_, so you should avoid
> using that inside your test cases directly if you want to affect all requests in other test cases.
> You can add headers directly to request keywords by using `headers=` argument.

---

**Get the first form and verify that its poster's name is `John Doe`.**

Let's create a new test case. We can use the `Get` keyword from the `REST` library directly
on the `/api/forms/1` endpoint to get the data of the first user. We should get a JSON response
with the first user's data.

- Create a new test case named `Get First Form And Verify Poster's Identity`.
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

---

**Create a new form using `POST` and verify it succeeded.**

Again, let's create a new test case. This time, we'll use the `Post` keyword to create a new
form to our website and verify that the form creation was successful.

- Create a new test case named `Post New Form And Verify Creation Succeeded`.
- Use `Post` to the `/api/forms` endpoint.

For our test case, it's enough to specify our form with an `id` and `name`. The data is
regular JSON and it's going to be static, so let's create a variable for that in the
`Variables` table. We can then use that variable as the second argument for our `Post`

- Create a variable `NEW_FORM_DATA` and make it a JSON with an `id` and `name` with values of your choice.
- Add `NEW_FORM_DATA` variable as a second argument to your `Post`.

> :bulb: Make the JSON in a single line.
>
> :bulb: The `id` needs to be unique. The API has 2 forms with ids `1` and `2`.

We still need to verify that our creation was successful. Again, we can use the `Output` to
get our response and check the `response status` to see that it's `201`. However, this time
the response code is an integer, so we need to use the `Should Be Equal As Integers` keyword.
Similar to `String`, we can also directly evaluate the status code with the `Integer` keyword.

> We could also use `${201}` in `Should Be Equal` to verify the response and `201` are equal.

- Use `Output` to get the `response status` and store it in a variable.
- Use `Should Be Equal As Integers` to verify your response is equal to `201`.
- Use `Integer` to verify your `response status` is equal to `201`.

---

**Modify the form form's email address using `PUT` and verify it succeeded.**

It's time for our third test case. From our previous steps we've learned that the REST keywords
are named simply by the method we're using. We're modifying the form's email address, which is
a string. We also want to verify our `Put` keyword response status.

We're modifying the first form, so we can use the `/api/forms/1` endpoint directly in our `Put`
keyword.

> We could also use `/api/forms` and specify an `id` in our payload. Either way we do, `id` is
> mandatory in either of them. If specified in both, the `id` specified by the URL is used.

- Create a new test case named `Modify Form's Email Address And Verify It Succeeded`.
- Use `Put` for endpoint `/api/forms/1`.

First, we need the current email address. Let's use `Get` to get that. Next,
we'll need a JSON payload for our `Put` to change the email address. We should add that as a
variable into our `Variables` table. The email doesn't really matter as long as it's different
from the original email, so we could use for example `firstname.lastname@example.com` as our
new email address.

- Before `Put`, add a `Get` from the same endpoint.
- Use `String` or `Output` to get the `response body email` and store it in `old` variable.
- Create a variable `NEW_EMAIL` and make it a JSON with `firstname.lastname@example.com` as the value.
- Add `NEW_EMAIL` as an argument to `Put`.

Bad Flask App sends the "modified" form as a response. We can use the response directly
to check if the email is different. We need to store the `response body email` again into a
variable and we need to verify the emails are not equal.

- Use `String` our `Output` to get the the `response body email` and store it in `new` variable.
- Use `Should Not Be Equal` to verify that `old` and `new` are not the same.

> :bulb: It doesn't matter if you use `String` or `Output`, but you _must_ use the same
> after `Get` and after `Put`.
>
> If you want to check the `response status` of `Put` as well, it should be `200`.

</details>

#### Browser

<details>
  <summary>Expand</summary>


**Initialize your test suite with `Browser` library.**

---

**Authenticate to server and set headers.**

---

**Get the first form and verify that its poster's name is `John Doe`.**

---

**Create a new form using `POST` and verify it succeeded.**

---

**Modify the form form's email address using `PUT` and verify it succeeded.**

</details>
