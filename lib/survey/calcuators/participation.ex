defmodule Survey.Calculators.Participation do
  alias Survey.Calculators.Calculator
  @behaviour Calculator

  def calculate(%{response: []}), do: %{type: :participation, result: :error, participants:  0, total: 0}
  def calculate(%{response: rs}) do
    total = Enum.count(rs)
    participants = rs |> Calculator.submitted |> Enum.count
    %{type: :participation, result: participants / total, participants: participants, total: total}
  end
end
