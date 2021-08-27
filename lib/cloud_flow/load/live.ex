defmodule CloudFlow.Load.Live do
  alias CloudFlow.Load.Douban

  defp format(records) do
    d = %CloudFlow.Model.Live{}

    for r <- records do
      r = Douban.into(r)
      r = %{r | type: String.to_atom(r[:platform])}

      Map.merge(d, r)
      |> Douban.struct_to_map()
    end
  end

  def bulk_insert(records) do
    records = Enum.map(records, &Douban.struct_to_map/1)

    CloudFlow.Model.Live
    |> CloudFlow.Repo.insert_all(records, on_conflict: :nothing)
  end

  def batch_load(records) do
    format(records)
    |> bulk_insert()
  end
end
