defmodule Survey.Providers.Cli do

  def data(flags) do
    flags
    |> read_from_csv
    |> create_struct
  end

  defp read_from_csv(inputs) do
    inputs
    |> IO.inspect
    |> Enum.map(fn({k, v}) -> {k, v |> File.stream! |> CSV.decode |> Enum.to_list} end)
    |> Enum.into(%{})
  end

  defp create_struct(%{questions: [h | qs], responses: rs}) do
    headers = Enum.map(h, &String.to_atom/1)
    questions = qs |> Enum.map(&create_question(&1, headers))
    q_types = Enum.map(questions, &Map.get(&1, :type))
    responses = Enum.map(rs, &create_response(&1, q_types))
    %Survey{questions: questions, responses: responses}
  end

  def create_question(q, headers) do
    Enum.zip(headers, q) |> Enum.into(%{})
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

end
