defmodule CloudFlow.Crawler.LowEndTalk do
  @token Application.fetch_env!(:cloud_flow, :telegram_token)
  @chat_id Application.fetch_env!(:cloud_flow, :chat_id)
  @tabfile 'lowendtalk_ids.tab'
  use GenServer
  require Logger
  alias CloudFlow.{Crawler.Template, Req}
  alias :ets, as: ETS

  def init(state) do
    case File.exists?(@tabfile) do
      true -> ETS.file2tab(@tabfile)
      _ -> ETS.new(:lowendtalk_ids, [:named_table, :ordered_set, :public])
    end

    run(state)
    {:ok, state}
  end

  def start_link(opts) do
    with {:ok, url} <- Keyword.fetch(opts, :url),
         {:ok, words} <- Keyword.fetch(opts, :words) do
      GenServer.start_link(__MODULE__, {url, words})
    end
  end

  def run(state) do
    Process.send_after(self(), :first_page, 3_600_000)
    ETS.tab2file(:lowendtalk_ids, @tabfile)
    spawn(__MODULE__, :titles, [state])
  end

  def titles({url, words}) do
    Logger.warning("Get First Page")

    items =
      Template.get_doc(url)
      |> Template.find_pattern(".ItemContent")

    for item <- items do
      match? =
        Floki.find(item, ".Title a")
        |> Floki.text(deep: false)
        |> String.downcase()
        |> Template.match?(words)

      case match? do
        true -> trigger(item)
        _ -> nil
      end
    end
    |> Enum.reject(&is_nil/1)
    |> Enum.filter(&filter_exists/1)
    |> send()
  end

  def send(datas) do
    data =
      for data <- datas do
        "
-----------------------

LowEndTalk 订阅提醒！！！

[#{data["title"]}](#{data["link"]})

Posted by [#{data["author"]}](https://www.lowendtalk/profile/#{data["author"]}), Last commented at #{data["updated"]}

"
      end
      |> Enum.join("\n")

    Req.post("https://api.telegram.org/bot#{@token}/sendMessage",
      form: [{"chat_id", @chat_id}, {"parse_mode", "Markdown"}, {"text", data}]
    )
  end

  def trigger(item) do
    discuss = Floki.find(item, ".Title > a")
    title = Floki.text(discuss, deep: false)
    link = Floki.attribute(discuss, "href") |> hd
    meta = Floki.find(item, ".Meta")
    author = Floki.find(meta, ".DiscussionAuthor a") |> Floki.text(deep: false)
    updated = Floki.find(meta, ".LastCommentDate time") |> Floki.attribute("title") |> hd

    %{
      "link" => link,
      "title" => title,
      "author" => author,
      "updated" => updated
    }
  end

  def filter_exists(%{"link" => link}) do
    u = URI.parse(link)
    id = String.split(u.path, "/") |> Enum.at(2) |> String.to_integer()
    ETS.insert_new(:lowendtalk_ids, {id})
  end

  def handle_info(:first_page, state) do
    run(state)
    {:noreply, state}
  end
end
