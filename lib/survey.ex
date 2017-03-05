defmodule Survey do
  alias Survey.Providers.Cli

  def main(args \\ []) do
    args
    |> Cli.parse_and_validate!
    |> IO.inspect
  end

end
