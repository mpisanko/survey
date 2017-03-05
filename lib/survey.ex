defmodule Survey do

  def main(args \\ []) do
    args
    |> OptionParser.parse(strict: [survey: :string, response: :string])
    |> IO.inspect
    |> validate!
  end

  defp validate!({flags, _, _}) do
    if (flags |> Keyword.keys |> Enum.sort == [survey: :string, response: :string] |> Keyword.keys |> Enum.sort) do
      flags
    else
      raise ArgumentError, "Please specify --survey and --response with paths pointing to respective files."
    end
  end
end
