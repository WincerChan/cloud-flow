defmodule CloudFlow.Model.Douban do
  use Ecto.Schema

  @primary_key {:id, :integer, autogenerate: false}
  schema "douban" do
    field(:type, Ecto.Enum, values: [book: 1, movie: 2])
    field(:tags, {:array, :string})
    field(:date, :date)
    field(:comment)
    field(:rating, :integer)
    field(:title)
    field(:poster)
  end
end
