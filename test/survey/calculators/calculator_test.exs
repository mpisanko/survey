defmodule Survey.Calculators.CalculatorTest do
  use ExUnit.Case, async: true
  alias Survey.Calculators.Calculator
  doctest Survey.Calculators.Calculator

  describe "questions_of_type" do
    test "returns  questions of requested type" do
      questions = [%{type: :ratingquestion},
                   %{type: :singleselect},
                   %{type: :ratingquestion},
                   %{type: :singleselect},
                   %{type: :otherquestion}]
      assert Calculator.questions_of_type(questions, :ratingquestion) |> Enum.count == 2
      assert Calculator.questions_of_type(questions, :singleselect) |> Enum.count == 2
      assert Calculator.questions_of_type(questions, :otherquestion) |> Enum.count == 1
    end
  end

  describe "questions_with_responses" do
    test "creates a list of maps where questions have all responses merged into them" do
      questions = [%{type: :ratingquestion},
                   %{type: :singleselect},
                   %{type: :ratingquestion},
                   %{type: :singleselect},
                   %{type: :otherquestion}]
      responses = [%{responses: [1, "Sally", 2, "Melbourne", "foo"]},
                   %{responses: [3, "John", 4, "Sydney", "bar"]},
                   %{responses: [5, "Bob", 6, "Brissy", "baz"]},
                   %{responses: [7, "Kate", 8, "Perth", "fizz"]},
                  ]
      assert Calculator.questions_with_responses(responses, questions) ==
        [%{type: :ratingquestion, responses: [1, 3, 5, 7]},
         %{type: :singleselect, responses: ~w[Sally John Bob Kate]},
         %{type: :ratingquestion, responses: [2, 4, 6, 8]},
         %{type: :singleselect, responses: ~w[Melbourne Sydney Brissy Perth]},
         %{type: :otherquestion, responses: ~w[foo bar baz fizz]}]
    end

    test "ignores responses which are nil or :error" do
      questions = [%{type: :ratingquestion},
                   %{type: :ratingquestion},
                   %{type: :otherquestion}]
      responses = [%{responses: [1, :error, "foo"]},
                   %{responses: [:error, 4, "bar"]},
                   %{responses: [5, 6, nil]},
                   %{responses: [7, 8, "fizz"]},
                  ]
      assert Calculator.questions_with_responses(responses, questions) ==
        [%{type: :ratingquestion, responses: [1, 5, 7]},
         %{type: :ratingquestion, responses: [4, 6, 8]},
         %{type: :otherquestion, responses: ~w[foo bar fizz]}]
    end
  end

end
