defmodule CloudFlow.Tool.Cast do
  def to_integer(ill) when ill in [nil, ""], do: 0

  def to_integer(str), do: String.to_integer(str)

  def significant_digits(x, digits) when is_number(x), do: significant_digits("#{x}", digits)

  def significant_digits(_, digits) when digits <= 0,
    do: raise(ArgumentError, "digits must be greater than 0")

  def significant_digits(num_str, digits) when is_binary(num_str),
    do: partition_digits(to_charlist(num_str), digits, [])

  defp partition_digits([x | _] = raw, values) when x != ?0 and x != ?., do: {raw, values}

  defp partition_digits([x | rest], values), do: partition_digits(rest, [x | values])

  defp partition_digits(nums, digits, []) do
    {rest, values} = partition_digits(nums, [])

    significant_digits_transfer(rest, digits, values)
  end

  defp significant_digits_transfer(_, 0, values),
    do: values |> Enum.reverse() |> to_string()

  defp significant_digits_transfer([], digits, values),
    do: significant_digits_transfer([], digits - 1, [?0 | values])

  defp significant_digits_transfer([x | rest], digits, values) when x == ?.,
    do: significant_digits_transfer(rest, digits, [x | values])

  defp significant_digits_transfer([x | rest], digits, values),
    do: significant_digits_transfer(rest, digits - 1, [x | values])
end
