defmodule CloudFlow.Tool.Cast do
  def to_integer(ill) when ill in [nil, ""], do: 0

  def to_integer(str), do: String.to_integer(str)
end
