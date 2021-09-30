defmodule CloudFlow.Live.Crud do
  import Ecto.Query
  alias CloudFlow.{Model.Live, Repo, Live.Parser}

  def get_platform(platform) do
    from(l in Live,
      where: l.platform == ^platform,
      select: {l.room_id, l.author, l.title}
    )
    |> Repo.all()
  end

  def get_one_room(platform, room_id) do
    from(l in Live,
      where: l.platform == ^platform and l.room_id == ^room_id
    )
    |> Repo.one()
    |> Map.delete(:__meta__)
    |> Map.delete(:__struct__)
  end

  def update_room(platform, room_id) do
    alias CloudFlow.Load.Live

    [Parser.parse_info({platform, room_id})]
    |> Live.bulk_insert()
  end
end
