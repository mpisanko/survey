defmodule Survey.Parsers.CliTest do
  use ExUnit.Case
  alias Survey.Parsers.Cli
  doctest Survey.Parsers.Cli

  describe "parse_and_validate" do
    test "it requires precisely two arguments - flags specifying input files" do
      assert Cli.parse_and_validate(~w[--response ./README.md --survey ./mix.exs]) == [response: "./README.md", survey: "./mix.exs"]
    end

    test "it requires precisely two arguments - in any order" do
      assert Cli.parse_and_validate(~w[--survey ./mix.exs --response ./mix.exs]) == [survey: "./mix.exs", response: "./mix.exs"]
    end

    test "it raises if required flags are not present" do
      {:shutdown, error} = catch_exit(Cli.parse_and_validate(~w[foo bar]))
      assert error == "Please specify --survey and --response with paths pointing to respective files"
    end

    test "it raises when flags are present but files do not exist" do
      {:shutdown, error} = catch_exit(Cli.parse_and_validate(~w[--survey foo --response bar]))
      assert error == "The following files do not exist: foo, bar"
    end

    test "when any other arguments are given it ignores them" do
      assert Cli.parse_and_validate(~w[--response ./README.md --survey ./mix.exs --extra-args not-welcome]) == [response: "./README.md", survey: "./mix.exs"]
    end
  end
end
