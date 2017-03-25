defmodule Survey.Calculators.Calculator do
  @callback calculate(s :: %Survey{questions: [%{}], responses: [%{}]}) :: %{type: String.t, result: any()}

  def submitted(rs) do
    rs |> Enum.filter(fn e -> e[:submitted_at] != nil end)
  end

  def questions_with_responses(rs, qs) do
    rs
    |> Enum.map(&Map.get(&1, :responses))
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.zip(qs)
    |> Enum.reduce([], fn ({rs, q}, acc) ->
      acc ++ [Map.merge(q, %{responses: rs |> Enum.filter(&valid_response?/1)})] end)
  end

  def questions_of_type(qs, type) do
    qs
    |> Enum.filter(fn q -> q[:type] == type end)
  end

  defp valid_response?(nil), do: false
  defp valid_response?(:error), do: false
  defp valid_response?(_), do: true
end
