defmodule Survey do
  alias Survey.Providers.Cli

  defstruct survey: [], response: []

  def main(args \\ []) do
    args
    |> Cli.data
    |> IO.inspect
  end

end
