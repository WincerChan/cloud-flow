defmodule CloudFlow.Douban.Page do
  require Logger
  alias CloudFlow.Req
  @douban_id Application.get_env(:cloud_flow, :douban_id)

  @default_args [:id, :tags, :date, :comment, :poster, :rating]
  @special_args [:title]

  def make_url_by_type(type, offset \\ 0) do
    url = "https://#{type}.douban.com/people/#{@douban_id}/collect?start=#{offset}"
    Logger.warning("Current URL: #{url}")
    url
  end

  def fetch_parse(url) do
    url
    |> Req.get!(headers: [{"cookie", "bid=jKc6sadczmE"}])
    |> Req.body()
    |> Floki.parse_document!()
  end

  def parse(item, type) do
    alias CloudFlow.{Model.Douban, Douban.Parser}

    (Enum.map(@default_args, fn x -> [x] end) ++
       Enum.map(@special_args, fn x -> [x, type] end))
    |> Enum.reduce(
      %Douban{type: type},
      fn r, book ->
        t = hd(r)
        Map.put(book, t, apply(Parser, t, [item | tl(r)]))
      end
    )
  end

  defp find_item(pre, :book), do: Floki.find(pre, ".subject-item")

  defp find_item(pre, :movie), do: Floki.find(pre, ".item")

  def fetch_page(type, offset \\ 0) do
    make_url_by_type(type, offset)
    |> fetch_parse()
    |> find_item(type)
    |> Enum.map(fn item -> parse(item, type) end)
  end
end
