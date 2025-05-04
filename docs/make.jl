# docs/make.jl
using Quizify
using Documenter

DocMeta.setdocmeta!(Quizify, :DocTestSetup, :(using Quizify); recursive=true)

makedocs(
  sitename   = "Quizify.jl",
  modules    = [Quizify],
  pages      = [
    "Home"      => "index.md",
    "Reference" => "reference.md",
  ],
  format     = Documenter.HTML(
    canonical = "https://<your-username>.github.io/Quizify.jl",
    edit_link = "main",
  ),
  authors    = ["Your Name"],
  # skip_missing_docs = true    # <- you can un-comment this
)
