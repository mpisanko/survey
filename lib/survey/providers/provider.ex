defmodule Survey.Providers.Provider do
  @callback data(args :: [String.t]) :: %Survey{survey: [%{}], response: [%{}]}
end
