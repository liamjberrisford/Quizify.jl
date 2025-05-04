module Quizify

using JSON

export show_quiz_from_json

"""
    build_quiz_html(path::AbstractString) -> String

Read quiz data from the JSON file at `path` and return the complete
HTML string (including CSS & JS) for embedding or display.
"""
function build_quiz_html(path::AbstractString)::String
    quiz_data = JSON.parsefile(path)

    # CSS + JS header
    html = """
    <style>
    .quiz-question {
        background-color: #6c63ff;
        color: white;
        padding: 12px;
        border-radius: 10px;
        font-weight: bold;
        font-size: 1.2em;
        margin-bottom: 10px;
    }
    .quiz-form { margin-bottom: 20px; }
    .quiz-answer {
        display: block;
        background-color: #f2f2f2;
        border: none;
        border-radius: 10px;
        padding: 10px;
        margin: 5px 0;
        font-size: 1em;
        cursor: pointer;
        text-align: left;
        transition: background-color 0.3s;
        width: 100%;
    }
    .quiz-answer:hover { background-color: #e0e0e0; }
    .correct { background-color: #4CAF50 !important; color: white !important; border: none; }
    .incorrect { background-color: #D32F2F !important; color: white !important; border: none; }
    .feedback { margin-top: 10px; font-weight: bold; font-size: 1em; }
    </style>

    <script>
    function handleAnswer(qid, aid, feedback, isCorrect) {
        // Reset all buttons for the question
        let buttons = document.querySelectorAll(".answer-" + qid);
        buttons.forEach(btn => {
            btn.classList.remove('correct', 'incorrect');
        });
        // Apply correct/incorrect to selected
        let selected = document.getElementById(aid);
        selected.classList.add(isCorrect ? 'correct' : 'incorrect');
        // Show feedback below the question
        let feedbackBox = document.getElementById('feedback_' + qid);
        feedbackBox.innerHTML = feedback;
        feedbackBox.style.color = isCorrect ? 'green' : 'red';
    }
    </script>

    <div class="quiz">
    """

    # Questions
    for (i, question) in enumerate(quiz_data)
        qid = string(i)
        html *= """
        <div class="quiz-question">$(question["question"])</div>
        <form class="quiz-form">
        """

        for (j, answer) in enumerate(question["answers"])
            aid      = "q$(i)_a$(j)"
            feedback = answer["feedback"]
            correct  = startswith(lowercase(feedback), "correct")
            html *= """
            <button type="button"
                    class="quiz-answer answer-$(qid)"
                    id="$(aid)"
                    onclick="handleAnswer('$(qid)', '$(aid)', '$(feedback)', $(correct))">
                $(answer["answer"])
            </button>
            """
        end

        html *= """
            <div class="feedback" id="feedback_$(qid)"></div>
        </form>
        <hr>
        """
    end

    html *= "</div>\n"
    return html
end

"""
    show_quiz_from_json(path::AbstractString) -> String

Build the HTML for the quiz at `path` and:
- If the frontend supports HTML display (e.g. IJulia/Pluto), show it inline.
- Otherwise (e.g. plain REPL), catch the error, print a warning, and
  print & return the raw HTML string for you to save or inspect.

Returns the HTML string in all cases.
"""
function show_quiz_from_json(path::AbstractString)::String
    html = build_quiz_html(path)
    # Try to display as HTML
    try
        display(MIME("text/html"), html)
    catch e
        @warn "Could not display HTML directly; falling back to plain output." exception=(e, catch_backtrace())
        println(html)
    end
    return html
end

end # module
