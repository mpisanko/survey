defmodule Survey.Parsers.Cli do

  @flags [survey: :string, response: :string]

  def parse_and_validate(args) do
    with {:ok, flags} <- (args |> parse_options |> validate_options) do
      flags
    else
      {:error, :badarg} ->
        error("Please specify --survey and --response with paths pointing to respective files")
      {:error, :missing_files, files} ->
        error("The following files do not exist: #{files}")
    end
  end

  defp parse_options(args) do
    args
    |> OptionParser.parse(strict: @flags)
  end

  defp validate_options({options, _, _}) do
    options |> validate_flags |> validate_files
  end

  defp validate_flags(flags) do
    if (flags |> Keyword.keys |> Enum.sort == @flags |> Keyword.keys |> Enum.sort) do
      {:ok, flags}
    else
      {:error, :badarg}
    end
  end

  defp validate_files({:ok, flags}) do
    missing_files = flags |> Keyword.values |> Enum.reject(&File.exists?/1)
    case missing_files do
      [] -> {:ok, flags}
      missing -> {:error, :missing_files, missing |> Enum.join(", ")}
    end
  end

  defp validate_files({:error, reason}) do
    {:error, reason}
  end

  defp error(message) do
    IO.ANSI.format([:red, message], true)
    exit({:shutdown, message})
  end
end
