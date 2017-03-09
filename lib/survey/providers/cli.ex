defmodule Survey.Providers.Cli do
  alias Survey.Providers.Provider
  @behaviour Provider

  @flags [survey: :string, response: :string]

  def data(args) do
    args
    |> parse_and_validate!
    |> read_from_csv
    |> create_struct
  end

  def parse_and_validate!(args) do
    args
    |> OptionParser.parse(strict: @flags)
    |> validate!
  end

  defp read_from_csv(inputs) do
    inputs
    |> Enum.map(fn({k, v}) -> {k, v |> File.stream! |> CSV.decode |> Enum.to_list} end)
    |> Enum.into(%{})
  end

  defp create_struct(%{survey: [h | qs], response: rs}) do
    headers = Enum.map(h, &String.to_atom/1)
    questions = qs |> Enum.map(&create_question(&1, headers))
    q_types = Enum.map(questions, &Map.get(&1, :type))
    responses = Enum.map(rs, &create_response(&1, q_types))
    %Survey{survey: questions, response: responses}
  end

  def create_question(q, headers) do
    Enum.zip(headers, q) |> Enum.into(%{}) |> Map.update(:type, :missing, &String.to_atom/1)
  end

  @response_fields [:email, :employee_id, :submitted_at]

  def create_response(r, qs) do
    r = Enum.map(r, &nilify/1)
    fixed_fields = Enum.zip(@response_fields, Enum.take(r, 3)) |> Enum.into(%{})
    responses =
      r
      |> Enum.drop(3)
      |> Enum.zip(qs)
      |> Enum.map(&eval_question/1)
    Map.merge(fixed_fields, %{responses: responses})
  end

  defp nilify(""), do: nil
  defp nilify(o), do: o

  defp eval_question({nil, _}), do: nil
  defp eval_question({num, :ratingquestion}) do
    case Integer.parse(num) do
      :error -> :error
      {n, _} -> n
    end
  end
  defp eval_question({v, _}), do: v

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
