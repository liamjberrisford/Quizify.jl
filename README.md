# Quizify.jl

[![CI](https://github.com/berrli/Quizify.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/berrli/Quizify.jl/actions/workflows/ci.yml)  
[![Test Suite](https://github.com/berrli/Quizify.jl/actions/workflows/test.yml/badge.svg)](https://github.com/berrli/Quizify.jl/actions/workflows/test.yml)  
[![Docs](https://github.com/berrli/Quizify.jl/actions/workflows/ci.yml/badge.svg?event=push)](https://berrli.github.io/Quizify.jl/)  
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Quizify.jl is a Julia package that converts quiz questions defined in a JSON file into an interactive HTML snippet, perfect for embedding in web-based course materials. It supports multiple-choice quizzes with styled buttons and immediate feedback—no server or backend required.

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

---
