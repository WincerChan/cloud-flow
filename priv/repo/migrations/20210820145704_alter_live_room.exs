defmodule CloudFlow.Repo.Migrations.AlterLiveRoom do
  use Ecto.Migration

  def change do
    alter table(:live_room) do
      add :room_id, :integer
    end
  end
end
