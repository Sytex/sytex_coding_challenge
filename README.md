# Sytex coding challenge 🎯

This repository holds a coding challenge for devs applying for a job @ [Sytex](https://sytex.io).

## Context

In this coding challenge, we will provide you with a (really scuffed :p) simulated backend. You can find it inside of `server/`

You can run it using dart:

```bash
$ dart server/bin/server.dart
```

Or docker:

```bash
$ cd server/

# Using plain docker
$ docker build -t sytex_server .
$ docker run -d -p 8080:8080 sytex_server

# Using docker-compose
$ docker-compose up -d
```

It has some REST endpoints to GET and PATCH a `Form`. 

### `GET /form`

**Query example:**

```bash
$ curl -i 'http://localhost:8080/form'
``` 

**Response:**

```
HTTP/1.1 200 OK
...
```

```json
{
  "name": "A fancy form",
  "description": "This is a mocked form for Sytex's coding challenge",
  "created_at": "2023-01-01T00:00:00.000Z",
  "content": [
    {
      "id": "1c3aa377-1d51-4118-a6d0-e86318d0cae5",
      "index": "1.1",
      "type": "entry",
      "input_type": 3,
      "label": "Are you excited for this challenge?",
      "answer": null
    },
    {
      "id": "28eb1717-e2a7-4510-9ff0-b130238cccee",
      "index": "1.2",
      "type": "group",
      "name": "A few questions about you"
    },
    {
      "id": "0f929619-01c8-42fc-8df4-d0eb42d0699f",
      "index": "1.2.1",
      "type": "entry",
      "input_type": 1,
      "label": "What's your name?",
      "answer": null
    },
    {
      "id": "1ffd9db6-1dfb-4b1d-b611-a0396830825a",
      "index": "1.2.2",
      "type": "entry",
      "input_type": 2,
      "label": "How long have you been coding?",
      "options": [
        { "label": "Less than a year", "value": "less_than_a_year" },
        { "label": "1-3 years", "value": "1_3_years" },
        { "label": "3-5 years", "value": "3_5_years" },
        { "label": "5-10 years", "value": "5_10_years" },
        { "label": "More than 10 years", "value": "more_than_10_years" }
      ],
      "answer": null
    },
    {
      "id": "e2638a49-53a2-4942-b70b-f906b357c7d9",
      "index": "1.3",
      "type": "entry",
      "input_type": 1,
      "label": "Anything else you want to tell us?",
      "answer": null
    }
  ]
}
```

### `PATCH /form/content/<entry_id>`

**Query example:**

```bash
$ curl -iX PATCH 'http://localhost:8080/form/content/e2638a49-53a2-4942-b70b-f906b357c7d9' -d '{"answer": "A wonderful answer!"}'
``` 

**Response:**

```
HTTP/1.1 200 OK
...
```

```json
{
    "id": "e2638a49-53a2-4942-b70b-f906b357c7d9",
    "index": "1.3",
    "type": "entry",
    "input_type": 1,
    "label": "Anything else you want to tell us?",
    "answer": "A wonderful answer!"
}
```

> **Warning**
> If `<entry_id>` is not found, the API will respond with status `404`.

---

A `Form` (think Google Forms) contains a set of entries and groups. Each `Entry` has some metadata, an `input_type` and an `answer`.

Their `input_type` represents the action the user needs to do to answer ("fill") them:

**input_type:** `1`
- This is a "Text Input" `Entry`. 
- It should be answered using a text field. 
- `answer` is a `String`.

**input_type:** `2`
- This is an "Options" `Entry`. 
- It should be answered using a set of radio buttons. 
- `answer` is a `String` with the value of the selected option.

**input_type:** `3`
- This is a "Yes/No" `Entry`. 
- It should be answered pressing a button with either a "Yes" or a "No" label. 
- `answer` is a `boolean`.

---

You will implement an application which consumes this backend to display the `Form` and accepts the appropriate input from the user in each `Entry` to update their `answer`s. 

We are purposefully leaving the user flow for you to design! Here are some contemplations:

1. An `Entry`'s answer can be empty/`null`.
2. Although the `content` structure is flat, do note that the groups and indexes provide hierarchy/order.

## What you'll need to do

1. Clone (do not fork) the repository.
2. Understand the provided code.
3. Implement a user flow to browse and fill the `Form`'s entries.
4. Upload your code to a new repository 
    - do not create a fork
    - do not create a pull request
5. [Send us the link](mailto:francisco@sytex.io) to your repository with the solution
    - if you don't like the idea of your solution to be publicly available make sure to create a private repository and invite [pitriq](https://github.com/pitriq).


## What we expect

You can go for whatever you think it's the best solution for this assignment, both code and UI/UX-wise! We'll check for these things in order of importance:

- Whether the solution embraces standard software development patterns and practices. 
- UX decisions contemplated in the user flow.
- Interface design.

As you'll be subject to time constrains while doing this assignment, we expect you to choose what to prioritize accordingly.

## Additional information

> **Note**
> The `app/` has been created with `flutter 3.7.0-1.4.pre` (`dart 2.19.0`).

- You can use any package/tooling available on [pub.dev](https://pub.dev).
- You are allowed to create as many `Widget`s and classes as you need.
- Please do not modify the code in `server/`.

## Questions?

If you have any questions regarding this assignment or need to review some ideas, let us know within an issue in your repository and we'll answer promptly! Alternatively you can [send us an email](mailto:francisco@sytex.io).
  