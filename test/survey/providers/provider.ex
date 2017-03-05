defmodule Survey.Providers.Provider do
  @callback data(args :: [String.t]) :: [survey: [%{}], response: [%{}]]
end
