defmodule CloudFlow.Live.Run do
  require Logger
  import Ecto.Query
  use GenServer
  alias CloudFlow.{Load.Live, Live.Parser}

  @hour 3600
  @paginate 15

  def init(state) do
    run()
    {:ok, state}
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def handle_info(:run, state) do
    run()
    {:noreply, state}
  end

  defp run() do
    Process.send_after(self(), :run, @hour * 1_000)
    spawn(__MODULE__, :fetch_all, [])
  end

  def log(num, type) do
    Logger.warn("Adding #{num} Douban #{type}(s).")
    num
  end

  def fetch_last(number, _) when number < @paginate, do: nil

  def fetch_last(_, page) do
    from(l in CloudFlow.Model.Live,
      select: {l.platform, l.room_id},
      limit: @paginate,
      offset: @paginate * ^page
    )
    |> CloudFlow.Repo.all()
    |> Enum.map(&Task.async(fn -> Parser.parse_info(&1) end))
    |> Enum.map(&Task.await/1)
    |> Live.bulk_insert()
    |> elem(0)
    |> fetch_last(page + 1)
  end

  def fetch_all() do
    fetch_last(@paginate, 0)
  end
end
