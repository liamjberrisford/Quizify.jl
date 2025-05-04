# docs/make.jl
using Documenter
using Quizify

makedocs(
  sitename   = "Quizify.jl",
  modules    = [Quizify],
  format     = Documenter.HTML(),
  pages = [
    "Home" => "index.md",
  ],
)
