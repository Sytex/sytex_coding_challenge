# Sytex coding challenge 🎯

This repository holds a coding challenge for devs applying for a job @ [Sytex](https://sytex.io) mobile team.

## Context

In Sytex, a `Form` (think Google Forms) is used to gather information in the field. Our users would go to (sometimes _very_) remote locations to do some type of installation, improvements, upgrades or maintenance in the field. You can picture someone driving to the middle of the Atacama desert to repair a solar panel, or to a Brazilian morro in Rio to install a new 5G cell.

During and after the work is done, data must be gathered to make sure the job was done correctly, and to inform the rest of the organization about the status and results.

Along with this repo, we will provide you with the url to a backend with some REST endpoints to **GET** and **PATCH** a `Form`.

## Methods

### **GET** /form

Lists all forms.

**Query example:**

```bash
$ curl -i 'https://API_URL/form/
``` 

**Response:**

```
HTTP/1.1 200 OK
...
```

```json
[
  {
    "elements": [ ... ],
    "name": "A fancy Form",
    "description": "This is a form with a few questions about you",
    "uuid": "34d94484-9f84-4e73-910f-678a5670c6ee",
    "scheduled_finish_date": "2023-01-07T00:00:00.000Z",
    "created_at": "2023-01-01T00:00:00.000Z",
    "assigned_to": {
      "name": "John Doe",
      "avatar_url": "https://ui-avatars.com/api/?name=John+Doe&background=random"
    }
  },
  ...
]
```

### **GET** /form/\<uuid\>

Get a single form by its uuid.

**Query example:**

```bash
$ curl -i 'https://API_URL/form/6fa6791e-8718-4a88-93fe-f0879fe158dd/'
``` 

**Response:**

```
HTTP/1.1 200 OK
...
```

```json
{
  "elements": [
    {
      "index": "1",
      "label": "Your work setup",
      "uuid": "2ec797ba-29df-412f-a2dd-8c8d7928058b",
      "element_type": "group"
    },
    {
      "index": "1.1",
      "label": "Start by telling us how many monitors you have",
      "answer": null,
      "uuid": "59ea1462-d184-4aae-8cc4-db4255f7dda6",
      "element_type": "entry",
      "input_type": "number"
    },
    {
      "index": "1.2",
      "label": "Do you use a mouse?",
      "answer": null,
      "uuid": "8b6e1e07-33ed-443a-a188-f007d0d42620",
      "element_type": "entry",
      "input_type": "yes_no"
    },
    ...
  ],
  "name": "Another form",
  "description": "This one has some questions about your work setup",
  "uuid": "6fa6791e-8718-4a88-93fe-f0879fe158dd",
  "scheduled_finish_date": "2023-01-03T00:00:00.000Z",
  "created_at": "2023-01-01T00:00:00.000Z",
  "assigned_to": {
    "name": "John Doe",
    "avatar_url": "https://ui-avatars.com/api/?name=John+Doe&background=random"
  }
}
```

> **Warning**
> If `<uuid>` is not found, the API will respond with status `404`.

### **PATCH** /form-element/\<uuid\>

Update form element (an entry or a group) using its uuid.

**Query example:**

```bash
$ curl -iX PATCH 'https://API_URL/form-element/11bca26d-1e24-490f-a145-7ba0350aec46' -d '{"answer": true}'
``` 

**Response:**

```
HTTP/1.1 200 OK
...
```

```json
{
  "index": "1.1.2",
  "label": "Are you exited about this challenge?",
  "answer": true,
  "uuid": "11bca26d-1e24-490f-a145-7ba0350aec46",
  "element_type": "entry",
  "input_type": "yes_no"
}
```

> **Warning**
> If `<uuid>` is not found, the API will respond with status `404`.

<br />

---

<br />

A `Form` contains a set of `elements`. These can be either entries or groups. Each `Entry` has some metadata, an `input_type` and an `answer`.

Their `input_type` represents the action the user needs to do to answer ("fill") them:

**input_type:** `"text"`
- This is a "Text Input" `Entry`. 
- It should be answered using a text field. 
- `answer` is a `String`.

**input_type:** `"number"`
- This is also a "Text Input" `Entry`. 
- It should be answered using a text field, filled exclusively with numbers. 
- `answer` is still a `String`.

**input_type:** `"options"`
- This is an "Options" `Entry`. 
- It should be answered by picking an item from a set of options. 
- `answer` is a `String` with the value of the selected option.
  
**input_type:** `"multiple_options"`
- This is also an "Options" `Entry`. 
- It should be answered by picking one or more items from a set of options. 
- `answer` is a `String` with the value of the selected option(s), comma-separated.

**input_type:** `"yes_no"`
- This is a "Yes/No" `Entry`. 
- It should be answered by selecting between two values: yes and no. 
- `answer` is a `boolean`.

**input_type:** `"date"`
- This is a "Date" `Entry`. 
- It should be answered by picking a date. 
- `answer` is a `String` with the ISO 8601 formatted value of the selected date.

<br />

---

<br />

You will implement an application which consumes this backend to display these `Form`s and accepts the appropriate input from the user in each `Entry` to update their `answer`s. 

We are purposefully leaving the user flow for you to design! Here are some contemplations:

1. An `Entry`'s answer can be empty/`null`.
2. Although the `elements` structure is flat, **do** note that the groups and indexes provide hierarchy/order.

## What you'll need to do

1. Clone (do not fork) the repository.
2. Understand the provided context/task.
3. Implement a user flow to browse and fill each `Form`'s entries.
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

## Questions?

If you have any questions regarding this assignment or need to review some ideas, let us know within an issue in your repository and we'll answer promptly! Alternatively you can [send us an email](mailto:francisco@sytex.io).
  