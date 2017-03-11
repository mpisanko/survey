defmodule Survey.Calculators.Calculator do
  @callback calculate(s :: %Survey{survey: [%{}], response: [%{}]}) :: %{type: String.t, result: any()}

  def submitted(rs) do
    rs |> Enum.filter(fn e -> e[:submitted_at] != nil end)
  end
end
