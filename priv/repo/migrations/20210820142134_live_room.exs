defmodule CloudFlow.Repo.Migrations.LiveRoom do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE live_platform AS ENUM ('huya','douyu','bilibili')"
    drop_query = "DROP TYPE live_platform"
    execute(create_query, drop_query)
    create table(:live_room) do
      add :platform, :live_platform
      add :author, :string
      add :title, :string
      add :member, :integer
    end
  end
end
