defmodule Survey.Calculators.Participation do
  alias Survey.Caluculators.Calculator
  @behaviour Calculator

  def calculate(%{response: []}), do: %{type: :participation, result: :error, participants:  0, total: 0}
  def calculate(%{response: rs}) do
    total = Enum.count(rs)
    participants = rs |> Enum.map(&Map.get(&1, :submitted_at)) |> Enum.filter(fn s -> s != nil end) |> Enum.count
    %{type: :participation, result: participants / total, participants: participants, total: total}
  end
end
