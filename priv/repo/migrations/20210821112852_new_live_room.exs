defmodule CloudFlow.Repo.Migrations.NewLiveRoom do
  use Ecto.Migration

  def change do

    create table(:live) do
      add :platform, :integer
      add :author, :string
      add :title, :string
      add :member, :integer
      add :room_id, :integer
      add :player, :text
      add :danmu, :binary
    end
  end
end
