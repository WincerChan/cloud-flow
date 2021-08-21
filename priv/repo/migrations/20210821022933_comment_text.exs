defmodule CloudFlow.Repo.Migrations.CommentText do
  use Ecto.Migration

  def change do

    create table(:douban) do
      add :tags, {:array, :string}
      add :date, :date
      add :comment, :text
      add :rating, :integer
      add :title, :string
      add :type, :integer
      add :poster, :string
    end
  end
end
