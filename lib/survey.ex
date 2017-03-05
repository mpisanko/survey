defmodule Survey do

  @flags [survey: :string, response: :string]
  def main(args \\ []) do
    args
    |> OptionParser.parse(strict: @flags)
    |> IO.inspect
    |> validate!
  end

  defp validate!({flags, _, _}) do
      flags |> validate_flags! |> validate_files!
  end

  defp validate_flags!(flags) do
    if (flags |> Keyword.keys |> Enum.sort == @flags |> Keyword.keys |> Enum.sort) do
      flags
    else
      raise ArgumentError, "Please specify --survey and --response with paths pointing to respective files."
    end
  end

  defp validate_files!(flags) do
    if (flags |> Keyword.values |> Enum.all?(&match?({:ok,_}, File.stat(&1)))) do
      flags
    else
      raise ArgumentError, ~s[File(s) do not exist: #{flags|>Keyword.values|>Enum.reject(&match?({:ok,_},File.stat(&1)))}]
    end
    
  end
end
