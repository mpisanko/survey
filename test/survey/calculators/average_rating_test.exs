defmodule Survey.Calculators.AverageRatingTest do
  use ExUnit.Case
  alias Survey.Calculators.AverageRating
  doctest Survey.Calculators.AverageRating

  describe "calculate" do
    test "returns a map with type of calculation and results" do
      questions = [%{type: :ratingquestion},
                   %{type: :singleselect},
                   %{type: :ratingquestion},
                   %{type: :singleselect},
                   %{type: :otherquestion}]
      responses = [%{submitted_at: "abc", responses: [1, "Sally", 2, "Melbourne", "foo"]},
                   %{submitted_at: "abc", responses: [3, "John", 4, "Sydney", "bar"]},
                   %{submitted_at: "abc", responses: [5, "Bob", 6, "Brissy", "baz"]},
                   %{submitted_at: "abc", responses: [7, "Kate", 8, "Perth", "fizz"]},
                  ]
      assert AverageRating.calculate(%Survey{response: responses, survey: questions}) ==
        %{type: :average_rating, result: [%{average: 4.0, responses: [1, 3, 5, 7], type: :ratingquestion},
                                          %{average: 5.0, responses: [2, 4, 6, 8], type: :ratingquestion}]}
    end

    test "ignores responses which are nil or :error" do
      questions = [%{type: :ratingquestion},
                   %{type: :ratingquestion},
                   %{type: :otherquestion}]
      responses = [%{submitted_at: "abc", responses: [1, :error, "foo"]},
                   %{submitted_at: "abc", responses: [:error, 4, "bar"]},
                   %{submitted_at: nil, responses: [5, 6, nil]},
                   %{submitted_at: "abc", responses: [7, 8, "fizz"]},
                  ]
      assert AverageRating.calculate(%Survey{response: responses, survey: questions}) ==
        %{type: :average_rating, result: [%{average: 4.0, responses: [1, 7], type: :ratingquestion},
                                          %{average: 6.0, responses: [4, 8], type: :ratingquestion}]}
    end

    test "handles no submitted responses case gracefully" do
      questions = [%{type: :ratingquestion},
                   %{type: :ratingquestion},
                   %{type: :otherquestion}]
      responses = [%{responses: [1, :error, "foo"]},
                   %{responses: [:error, 4, "bar"]},
                   %{responses: [5, 6, nil]},
                   %{responses: [7, 8, "fizz"]},
                  ]
      assert AverageRating.calculate(%Survey{response: responses, survey: questions}) ==
        %{type: :average_rating, result: []}
    end
  end

end
