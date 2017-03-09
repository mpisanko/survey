defmodule Survey.Providers.CliTest do
  use ExUnit.Case
  alias Survey.Providers.Cli
  doctest Survey.Providers.Cli

  describe "parse_and_validate!" do
    test "it requires precisely two arguments - flags specifying input files" do
      assert Cli.parse_and_validate!(~w[--response ./README.md --survey ./mix.exs]) == [response: "./README.md", survey: "./mix.exs"]
    end

    test "it requires precisely two arguments - in any order" do
      assert Cli.parse_and_validate!(~w[--survey ./mix.exs --response ./mix.exs]) == [survey: "./mix.exs", response: "./mix.exs"]
    end

    test "it raises if required flags are not present" do
      assert_raise ArgumentError, fn ->
        Cli.parse_and_validate!(~w[foo bar])
      end
    end

    test "it raises when flags are present but files do not exist" do
      assert_raise ArgumentError, fn ->
        Cli.parse_and_validate!(~w[--survey foo --response bar])
      end
    end

    test "when any other arguments are given it ignoes them" do
      assert Cli.parse_and_validate!(~w[--response ./README.md --survey ./mix.exs --extra-args not-welcome]) == [response: "./README.md", survey: "./mix.exs"]
    end
  end

  describe "data" do
    test "creates struct from CSV files given as arguments" do
      [survey, response] = read_in_survey(1)
      assert Enum.count(survey) == 5
      assert Enum.count(response) == 6
    end

    test "converts question types to symbols" do
      [survey, _response] = read_in_survey(1)
      survey
      |> Enum.each(fn q -> assert is_atom(Map.get(q, :type)) end)
    end

    test "makes empty strings nil" do
      [_survey, response] = read_in_survey(1)
      [first | [second|_]] = response
      refute Map.get(first, :email) == nil
      assert Map.get(second, :email) == nil
    end

    test "each response is nil or integer if question is :ratingquestion" do
      [1, 2, 3] |> Enum.each(fn i -> 
        [survey, response] = read_in_survey(i)
        qs = Enum.map(survey, &Map.get(&1, :type))
        rs = Enum.map(response, &Map.get(&1, :responses))
        rs
        |> Enum.flat_map(&Enum.zip(&1, qs))
        |> Enum.filter(fn {_, t} -> t == :ratingquestion end)
        |> Enum.each(fn {r, _} -> assert is_integer(r) || is_nil(r) end)
      end)
    end
  end

  def read_in_survey(i) do
    %Survey{survey: survey, response: response} =  Cli.data(~w[--response test/fixtures/survey-#{i}-responses.csv --survey test/fixtures/survey-#{i}.csv])
    [survey, response]
  end
end
