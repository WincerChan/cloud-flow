defmodule CloudFlow.Load.Douban do
  @drops [:__meta__]

  @spec into(map) :: map
  defp into(record) do
    for {key, val} <- record, into: %{}, do: {String.to_atom(key), val}
  end

  @spec struct_to_map(CloudFlow.Model.Douban) :: map
  defp struct_to_map(record) do
    record
    |> Map.from_struct()
    |> Map.drop(@drops)
  end

  defp format(records) do
    d = %CloudFlow.Model.Douban{}

    for r <- records do
      r = into(r)
      r = %{r | date: Date.from_iso8601!(r[:date])}
      r = %{r | type: String.to_atom(r[:type])}

      Map.merge(d, r)
      |> struct_to_map()
    end
  end

  def bulk_insert(records) do
    records = Enum.map(records, &struct_to_map/1)

    CloudFlow.Model.Douban
    |> CloudFlow.Repo.insert_all(records, on_conflict: :nothing)
  end

  def batch_load(records) do
    format(records)
    |> bulk_insert()
  end

  def load_file(file) do
    file
    |> File.read!()
    |> :jiffy.decode()
    |> batch_load()
  end
end
