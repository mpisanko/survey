defmodule Survey.Providers.Cli do
  alias Survey.Providers.Provider
  @behaviour Provider

  @flags [survey: :string, response: :string]

  def data(args) do
    args
    |> parse_and_validate!
    |> IO.inspect
  end

  def parse_and_validate!(args) do
    args
    |> OptionParser.parse(strict: @flags)
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
