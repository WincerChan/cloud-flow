defmodule CloudFlow.Load.Douban do
  defp into(record) do
    for {key, val} <- record, into: %{}, do: {String.to_atom(key), val}
  end

  defp format(records) do
    d = %CloudFlow.Model.Douban{}

    for r <- records do
      r = into(r)
      r = %{r | date: Date.from_iso8601!(r[:date])}
      r = %{r | type: String.to_atom(r[:type])}

      Map.merge(d, r)
      |> Map.from_struct()
      |> Map.drop([:__meta__])
    end
  end

  def bulk_insert(records) do
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
    |> Jason.decode!()
    |> batch_load()
  end
end
