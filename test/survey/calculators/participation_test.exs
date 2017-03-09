defmodule Survey.Calculators.ParticipationTest do
  use ExUnit.Case
  alias Survey.Calculators.Participation
  doctest Survey.Calculators.Participation

  describe "calculate" do
    test "calculates participation percentage for legit input" do
      resp = [%{submitted_at: "2014-07-28T20:35:41+00:00"},
              %{submitted_at: nil},
              %{submitted_at: "2014-07-29T23:35:41+00:00"},
              %{submitted_at: nil}]
      assert Participation.calculate(%Survey{survey: [], response: resp}) == %{type: :participation, result: 0.5, participants: 2, total: 4}
    end

    test "handles invalid input" do
      resp = []
      assert Participation.calculate(%Survey{survey: [], response: resp}) == %{type: :participation, result: :error, participants: 0, total: 0}
    end
  end

end