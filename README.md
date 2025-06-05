# Quizify.jl

[![CI](https://github.com/berrli/Quizify.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/berrli/Quizify.jl/actions/workflows/ci.yml)  
[![Test Suite](https://github.com/berrli/Quizify.jl/actions/workflows/test.yml/badge.svg)](https://github.com/berrli/Quizify.jl/actions/workflows/test.yml)  
[![Docs](https://github.com/berrli/Quizify.jl/actions/workflows/ci.yml/badge.svg?event=push)](https://berrli.github.io/Quizify.jl/)  
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Quizify.jl is a Julia package that converts quiz questions defined in a JSON file into an interactive HTML snippet, perfect for embedding in web-based course materials. It now supports several common quiz formats with styled widgets and immediate feedback—no server or backend required.

This project was initially started to provide some basic functionality for another project. However due to its small size and lack of need in that project, I (@liamjberrisford) am now using it as a test bed for exploring the use of OpenAIs codex software engineering agent, and so you will notice that the PRs are now authored by codex and have the appropriate tag!

---

## Features

- **Simple JSON format**  
  Define your quiz as an array of question objects (see example below).
- **Self-contained HTML**  
  Includes built-in CSS and JavaScript so you can embed the output directly.
- **Immediate feedback**
  Highlights correct answers in green and incorrect ones in red, and displays feedback text.
- **Zero dependencies** beyond JSON.jl
  No frameworks or web servers—just Julia and a browser or notebook.
- **Multiple question types**
  Support for single choice, true/false, short-answer, and multiple-select questions out of the box.
- **Score summary & chart**
  Displays a progress bar and bar chart of correct answers once all questions are completed.

---

## Installation

Install the package using Julia's package manager:

```julia
julia> using Pkg
julia> Pkg.add(url="https://github.com/berrli/Quizify.jl")
```

(If the package is registered you can simply run `Pkg.add("Quizify")`.)

## Defining a Quiz

Create a JSON file where each object represents a question and its possible answers. A minimal example `myquiz.json` might look like

```json
[
  {
    "question": "What is 2 + 2?",
    "answers": [
      {"answer": "3", "correct": false, "feedback": "Try again"},
      {"answer": "4", "correct": true,  "feedback": "Correct!"}
    ]
  }
]
```

## Using Quizify

Rendering the quiz is a single call to `show_quiz_from_json`:

```julia
using Quizify

html = show_quiz_from_json("myquiz.json")
```

In a notebook environment the HTML quiz appears inline. In a plain REPL the
HTML is printed and also returned so you can write it to a file:

```julia
write("quiz.html", html)
```

If you only need the HTML string without displaying it, use the lower level
`build_quiz_html` function:

```julia
html = build_quiz_html("myquiz.json")
```

You can then embed that HTML snippet into any webpage.
