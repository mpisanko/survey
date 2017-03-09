defmodule Survey.Caluculators.Calculator do
  @callback calculate(s :: %Survey{survey: [%{}], response: [%{}]}) :: %{type: String.t, result: any()}
end
