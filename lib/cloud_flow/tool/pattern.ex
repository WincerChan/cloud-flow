defmodule CloudFlow.Tool.Pattern do
  def re_find(pat, body), do: Regex.run(pat, body) |> fetch_last()

  def fetch_last([_ | [ele]]), do: ele

  def fetch_last([_ | body]), do: body |> hd()

  def fetch_last(_), do: ""
end
