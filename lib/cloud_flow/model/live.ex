defmodule CloudFlow.Model.Live do
  use Ecto.Schema

  # @primary_key {:id, :integer, autogenerate: false}
  @primary_key false
  schema "live" do
    field(:platform, Ecto.Enum, values: [huya: 1, douyu: 2, bilibili: 3], primary_key: true)
    field(:author)
    field(:title)
    field(:room_id, :integer, primary_key: true)
    field(:member, :integer)
    field(:player)
    field(:danmu, :binary)
  end
end
