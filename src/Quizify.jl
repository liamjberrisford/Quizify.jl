module Quizify

using JSON

export show_quiz_from_json

"""
    escapejs(s::AbstractString) -> String

Escape a Julia string for safe interpolation inside JavaScript single quotes.
"""
escapejs(s::AbstractString) = replace(replace(s, "\\" => "\\\\"), "'" => "\\'")

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
    .quiz-text { width: 100%; padding: 10px; margin: 5px 0; border-radius: 10px; border: 1px solid #ccc; }
    .results-container { margin-top: 20px; font-weight: bold; }
    .score-bar-bg { background-color: #f2f2f2; border-radius: 10px; height: 20px; width: 100%; }
    .score-bar-fill { background-color: #6c63ff; height: 100%; border-radius: 10px; width: 0%; transition: width 0.5s; }
    </style>

    <script>
    var quizResults = {};
    var totalQuestions = $(length(quiz_data));

    function updateResults(qid, isCorrect) {
        quizResults[qid] = isCorrect;
        if (Object.keys(quizResults).length === totalQuestions) {
            showFinalResults();
        }
    }

    function showFinalResults() {
        let correct = Object.values(quizResults).filter(x => x).length;
        document.getElementById('score-text').innerHTML =
            `Score: \${correct} / \${totalQuestions}`;
        document.getElementById('score-fill').style.width =
            (100 * correct / totalQuestions) + '%';
        document.getElementById('quiz-results').style.display = 'block';
        drawChart();
    }

    function drawChart() {
        let canvas = document.getElementById('result-chart');
        if (!canvas) return;
        let ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        let barWidth = 20;
        let gap = 10;
        let maxHeight = canvas.height - 20;
        Object.keys(quizResults).forEach((qid, idx) => {
            ctx.fillStyle = quizResults[qid] ? '#4CAF50' : '#D32F2F';
            let x = idx * (barWidth + gap);
            let height = maxHeight;
            ctx.fillRect(x, canvas.height - height, barWidth, height);
        });
    }
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
        updateResults(qid, isCorrect);
    }

    function handleTextAnswer(qid, correctAnswer, fbCorrect, fbIncorrect) {
        let input = document.getElementById('input_' + qid);
        let ans = input.value.trim();
        let feedbackBox = document.getElementById('feedback_' + qid);
        if(ans.toLowerCase() === correctAnswer.toLowerCase()) {
            feedbackBox.innerHTML = fbCorrect;
            feedbackBox.style.color = 'green';
            input.classList.add('correct');
            input.classList.remove('incorrect');
        } else {
            feedbackBox.innerHTML = fbIncorrect;
            feedbackBox.style.color = 'red';
            input.classList.add('incorrect');
            input.classList.remove('correct');
        }
        updateResults(qid, ans.toLowerCase() === correctAnswer.toLowerCase());
    }
    </script>

    <div class="quiz">
    """

    # Questions
    for (i, question) in enumerate(quiz_data)
        qid   = string(i)
        qtype = get(question, "type", "many_choice")

        html *= """
        <div class="quiz-question">$(question["question"])</div>
        <form class="quiz-form">
        """
        if qtype == "many_choice" || qtype == "single_choice"
            for (j, answer) in enumerate(question["answers"])
                aid      = "q$(i)_a$(j)"
                feedback = answer["feedback"]
                correct  = get(answer, "correct", false)
                html *= """
                <button type="button"
                        class="quiz-answer answer-$(qid)"
                        id="$(aid)"
                        onclick="handleAnswer('$(qid)', '$(aid)', '$(escapejs(feedback))', $(correct))">
                    $(answer["answer"])
                </button>
                """
            end
        elseif qtype == "true_false"
            correct = question["correct"]
            fb_true = question["feedback_true"]
            fb_false = question["feedback_false"]
            html *= """
            <button type="button"
                    class="quiz-answer answer-$(qid)"
                    id="q$(i)_true"
                    onclick="handleAnswer('$(qid)', 'q$(i)_true', '$(escapejs(fb_true))', $(correct==true))">
                True
            </button>
            <button type="button"
                    class="quiz-answer answer-$(qid)"
                    id="q$(i)_false"
                    onclick="handleAnswer('$(qid)', 'q$(i)_false', '$(escapejs(fb_false))', $(correct==false))">
                False
            </button>
            """
        elseif qtype == "short_answer"
            correct_answer = question["correct_answer"]
            fb_correct = question["feedback_correct"]
            fb_incorrect = question["feedback_incorrect"]
            html *= """
            <input type="text" class="quiz-text" id="input_$(qid)" />
            <button type="button" class="quiz-answer" onclick="handleTextAnswer('$(qid)', '$(escapejs(correct_answer))', '$(escapejs(fb_correct))', '$(escapejs(fb_incorrect))')">Submit</button>
            """
        else
            error("Unknown question type: $(qtype)")
        end

        html *= """
            <div class="feedback" id="feedback_$(qid)"></div>
        </form>
        <hr>
        """
    end

    html *= """
        <div class="results-container" id="quiz-results" style="display:none;">
            <div class="score-bar-bg">
                <div class="score-bar-fill" id="score-fill"></div>
            </div>
            <div id="score-text"></div>
            <canvas id="result-chart" width="300" height="100"></canvas>
        </div>
    </div>\n"""
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
