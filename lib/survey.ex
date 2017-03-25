defmodule Survey do

  defstruct questions: [], responses: []

  def main(args \\ []) do
    args
    |> Survey.Providers.Cli.data
    |> calculate_results
    |> present_results
    |> IO.puts
  end

  defp calculate_results(survey) do
    [Survey.Calculators.Participation, Survey.Calculators.AverageRating]
    |> Enum.map(fn c -> c.calculate(survey) end)
    |> Enum.reduce(%{}, fn (%{type: t, result: r}, acc) -> Map.put(acc, t, r) end)
  end

  defp present_results(%{participation: p, average_rating: ar}) do
    ["Participation in survey was: #{Float.to_string(p.percent, decimals: 2)}% out of #{p.total}\nRating\t|Theme\t\t|Question"] ++
    (ar |> Enum.map(&present_question/1))
    |> Enum.join("\n")
  end

  defp present_question(%{text: text, theme: theme, average: average}) do
    "#{average}\t|#{theme}\t|#{text}"
  end
end
