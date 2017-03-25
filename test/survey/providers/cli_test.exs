defmodule Survey.Providers.CliTest do
  use ExUnit.Case
  alias Survey.Providers.Cli
  doctest Survey.Providers.Cli

  describe "data" do
    test "creates struct from CSV files given as arguments" do
      [questions, responses] = read_in_survey(1)
      assert Enum.count(questions) == 5
      assert Enum.count(responses) == 6
    end

    test "makes empty strings nil" do
      [_questions, responses] = read_in_survey(1)
      [first | [second|_]] = responses
      refute Map.get(first, :email) == nil
      assert Map.get(second, :email) == nil
    end

    test "each response is nil or integer if question is :ratingquestion" do
      [1, 2, 3] |> Enum.each(fn i -> 
        [questions, responses] = read_in_survey(i)
        qs = Enum.map(questions, &Map.get(&1, :type))
        rs = Enum.map(responses, &Map.get(&1, :responses))
        rs
        |> Enum.flat_map(&Enum.zip(&1, qs))
        |> Enum.filter(fn {_, t} -> t == :ratingquestion end)
        |> Enum.each(fn {r, _} -> assert is_integer(r) || is_nil(r) end)
      end)
    end
  end

  def read_in_survey(i) do
    %Survey{questions: questions, responses: responses} =  Cli.data([responses: "test/fixtures/survey-#{i}-responses.csv", questions: "test/fixtures/survey-#{i}.csv"])
    [questions, responses]
  end
end
