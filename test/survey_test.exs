defmodule SurveyTest do
  use ExUnit.Case
  doctest Survey

  describe "main" do
    test "it requires precisely two arguments - flags specifying input files" do
      assert Survey.main(~w[--response ./README.md --survey ./mix.exs]) == [response: "./README.md", survey: "./mix.exs"]
    end

    test "it requires precisely two arguments - in any order" do
      assert Survey.main(~w[--survey ./mix.exs --response ./mix.exs]) == [survey: "./mix.exs", response: "./mix.exs"]
    end

    test "it raises if required flags are not present" do
      assert_raise ArgumentError, fn ->
        Survey.main(~w[foo bar])
      end
    end

    test "it raises when flags are present but files do not exist" do
      assert_raise ArgumentError, fn ->
        Survey.main(~w[--survey foo --response bar])
      end
    end

    test "when any other arguments are given it ignoes them" do
      assert Survey.main(~w[--response ./README.md --survey ./mix.exs --extra-args not-welcome]) == [response: "./README.md", survey: "./mix.exs"]
    end
  end
end
