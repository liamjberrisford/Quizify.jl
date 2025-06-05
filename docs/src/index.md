# Quizify.jl

Quizify.jl renders static HTML quizzes from JSON files, for easy embedding in course webpages.

## Interactive Example

Below is a sample quiz rendered at build time using `Quizify.build_quiz_html`.

```@raw html
$(Quizify.build_quiz_html(joinpath(@__DIR__, "sample_quiz.json")))
```

```@autodocs
Modules = [Quizify]
```