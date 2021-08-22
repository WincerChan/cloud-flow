defmodule CloudFlow.Model.Live do
  use Ecto.Schema

  # @primary_key {:id, :integer, autogenerate: false}
  schema "live" do
    field(:platform, Ecto.Enum, values: [:huya, :douyu, :bilibili])
    field(:author)
    field(:title)
    field(:room_id, :integer)
    field(:member, :integer)
    field(:player)
    field(:danmu, :binary)
  end
end
