defmodule Survey.Providers.CliTest do
  use ExUnit.Case
  alias Survey.Providers.Cli
  doctest Survey.Providers.Cli

  describe "validate!" do
    test "it requires precisely two arguments - flags specifying input files" do
      assert Cli.validate!(~w[--response ./README.md --survey ./mix.exs] |> Cli.parser) == [response: "./README.md", survey: "./mix.exs"]
    end

    test "it requires precisely two arguments - in any order" do
      assert Cli.validate!(~w[--survey ./mix.exs --response ./mix.exs] |> Cli.parser) == [survey: "./mix.exs", response: "./mix.exs"]
    end

    test "it raises if required flags are not present" do
      assert_raise ArgumentError, fn ->
        Cli.validate!(~w[foo bar] |> Cli.parser)
      end
    end

    test "it raises when flags are present but files do not exist" do
      assert_raise ArgumentError, fn ->
        Cli.validate!(~w[--survey foo --response bar] |> Cli.parser)
      end
    end

    test "when any other arguments are given it ignoes them" do
      assert Cli.validate!(~w[--response ./README.md --survey ./mix.exs --extra-args not-welcome] |> Cli.parser) == [response: "./README.md", survey: "./mix.exs"]
    end
  end
end
