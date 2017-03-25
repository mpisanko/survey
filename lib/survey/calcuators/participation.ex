defmodule Survey.Calculators.Participation do
  alias Survey.Calculators.Calculator
  @behaviour Calculator

  def calculate(%{responses: []}), do: %{type: :participation, result: %{percent: 0, participants:  0, total: 0}}
  def calculate(%{responses: rs}) do
    total = Enum.count(rs)
    participants = rs |> Calculator.submitted |> Enum.count
    %{type: :participation, result: %{percent: 100 * participants / total , participants: participants, total: total}}
  end
end
