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
      assert %Survey{survey: survey, response: response} =  Cli.data(~w[--response test/fixtures/survey-1-responses.csv --survey test/fixtures/survey-1.csv])
      # assert Enum.count(survey)  == System.cmd("wc", ~w[-l test/fixtures/survey-1.csv]) |> elem(0) |> String.strip |> String.split |> hd |> Integer.parse |> elem(0)
      assert Enum.count(survey) == 5
      assert Enum.count(response) == 6
    end
  end
end
