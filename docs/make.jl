# docs/make.jl
using Quizify
using Documenter

DocMeta.setdocmeta!(Quizify, :DocTestSetup, :(using Quizify); recursive=true)

makedocs(
  sitename   = "Quizify.jl",
  modules    = [Quizify],
  pages      = [
    "Home"      => "index.md",
  ],
  format     = Documenter.HTML(
    canonical = "https://berrli.github.io/Quizify.jl",
    edit_link = "main",
    assets    = ["assets"],
  ),
  authors    = "Liam J Berrisford",
  # skip_missing_docs = true    # <- you can un-comment this
)

deploydocs(
  repo      = "github.com/berrli/Quizify.jl",
  devbranch = "main",                      # your default branch
  branch    = "gh-pages",                  # where to push the docs
)