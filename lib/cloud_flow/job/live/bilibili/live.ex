defmodule CloudFlow.Bilibili.Live do
  alias CloudFlow.Req
  @api_url "https://api.live.bilibili.com/room/v1/Room/room_init?id="
  @live_url "https://api.live.bilibili.com/xlive/web-room/v1/playUrl/playUrl"
  def fetch_api(room_id) do
    Req.get!("#{@api_url}#{room_id}")
    |> Req.body()
    |> Jason.decode()
  end

  def parse_live_url(real_room_id) do
    Req.get!(@live_url,
      query: [cid: real_room_id, qn: "20000", platform: "h5", https_url_req: "1", ptype: "16"]
    )
    |> Req.json()
    |> Map.fetch!("data")
    |> Map.fetch!("durl")
    |> fetch_last()
    |> Map.fetch!("url")
  end

  @spec fetch_last([...]) :: any
  def fetch_last([x | []]), do: x

  def fetch_last([_ | x]), do: fetch_last(x)

  defp find_url(0, _), do: ""

  defp find_url(1, data),
    do:
      Map.fetch!(data, "room_id")
      |> parse_live_url()

  def parse(room_id) do
    %{"data" => data} =
      room_id
      |> fetch_api()

    find_url(Map.fetch!(data, "live_status"), data)
  end
end
