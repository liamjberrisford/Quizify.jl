using Test
using Quizify

# Path to the test JSON fixture
const TEST_JSON = joinpath(@__DIR__, "test_quiz.json")
const TEST_JSON_ALT = joinpath(@__DIR__, "test_quiz_alt.json")

@testset "Quizify core functionality" begin

    # 1) Build the HTML and ensure it’s a String
    html = Quizify.build_quiz_html(TEST_JSON)
    @test typeof(html) == String

    # 2) Check that both questions appear
    @test occursin("Question 1", html)
    @test occursin("Question 2", html)

    # 3) Verify the correct-answer buttons have the right IDs
    #    (Q1’s correct answer is at j=2 → id="q1_a2"; Q2’s at j=3 → id="q2_a3")
    @test occursin("id=\"q1_a2\"", html)
    @test occursin("id=\"q2_a3\"", html)

    # 4) Make sure the CSS and JS blocks are present
    @test occursin("<style>",  html)
    @test occursin("<script>", html)

    # 5) show_quiz_from_json should return exactly the same HTML string
    html2 = Quizify.show_quiz_from_json(TEST_JSON)
    @test html2 == html

end

@testset "Correct flag handling" begin
    html = Quizify.build_quiz_html(TEST_JSON_ALT)
    @test occursin("Well done", html) # feedback is present
    # The second answer is marked correct via the `correct` flag even though the feedback doesn't start with "correct".
    @test occursin("onclick=\"handleAnswer('1', 'q1_a2', 'Well done', true)\"", html)
end
