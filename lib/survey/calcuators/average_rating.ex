defmodule Survey.Calculators.AverageRating do
  alias Survey.Calculators.Calculator
  @behaviour Calculator

  def calculate(%Survey{responses: []}), do: results(:error)
  def calculate(%Survey{questions: qs, responses: rs}) do
    rs
    |> Calculator.submitted
    |> Calculator.questions_with_responses(qs)
    |> Calculator.questions_of_type("ratingquestion")
    |> Enum.map(fn q -> q |> Map.merge(%{average: calculate_average(q)}) end)
    |> results
  end

  def results(res) do
    %{type: :average_rating, result: res}
  end

  def calculate_average(%{responses: rs}) do
    rs
    |> Enum.reduce(&+/2)
    |> Kernel./(Enum.count(rs))
  end

end
