defmodule SurveyTest do
  use ExUnit.Case
  doctest Survey

  describe "main" do
    test "it requires precisely two arguments - flags specifying input files" do
      assert Survey.main(["--response", "foo", "--survey", "bar"]) == [response: "foo", survey: "bar"]
    end

    test "it requires precisely two arguments - in any order" do
      assert Survey.main(["--survey", "bar", "--response", "foo"]) == [survey: "bar", response: "foo"]
    end

    test "it raises if required flags are not present" do
      assert_raise ArgumentError, fn ->
        Survey.main(["foo", "bar"])
      end
    end

    test "when any other arguments are given it ignoes them" do
      assert Survey.main(["--response", "foo", "--survey", "bar", "--extra-args", "not-welcome"]) == [response: "foo", survey: "bar"]
    end
  end
end
