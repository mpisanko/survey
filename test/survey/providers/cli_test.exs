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
end
