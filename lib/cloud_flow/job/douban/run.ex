defmodule CloudFlow.Douban.Run do
  require Logger
  use GenServer
  alias CloudFlow.{Load.Douban, Douban.Page}

  @day 26 * 3_600
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
    Process.send_after(self(), :run, @day * 1_000)
    spawn(__MODULE__, :fetch_all, [])
  end

  def log(num, type) do
    Logger.warn("Adding #{num} Douban #{type}(s).")
    num
  end

  def last_fetch(15, type, offset) do
    type
    |> Page.fetch_page(offset * @paginate)
    |> Douban.bulk_insert()
    |> elem(0)
    |> log(type)
    |> last_fetch(type, offset + 1)
  end

  def last_fetch(_, _, _), do: nil

  def fetch_all() do
    for type <- [:book, :movie] do
      last_fetch(15, type, 0)
    end
  end
end
