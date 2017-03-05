defmodule Survey do

  def main(args \\ []) do
    args
    |> OptionParser.parse(strict: [survey: :string, response: :string])
    |> IO.inspect
    |> validate!
  end

  defp validate!({flags, _, _}) do
    case flags do
      [response: r, survey: s] -> flags
      _ -> raise ArgumentError, "Please specify --survey and --response with paths pointing to respective files."
    end
  end

  defp validate!({[], _, _err}) do
    raise ArgumentError, "Please specify --survey and --response with paths pointing to respective files."
  end
end
