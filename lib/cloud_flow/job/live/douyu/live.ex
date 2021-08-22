defmodule Douyu.Live do
  # import Utils
  alias CloudFlow.{Req, Tool.Pattern}
  @prefix "https://playweb.douyucdn.cn/lapi/live/hlsH5Preview/"

  def hash(room_id, ts) do
    data = "#{room_id}#{ts}"

    :crypto.hash(:md5, data)
    |> Base.encode16()
    |> String.downcase()
  end

  def fetch_body(room_id) do
    ts = "#{:os.system_time(:millisecond)}"

    Req.post!("#{@prefix}#{room_id}",
      body: [rid: room_id, did: 10_000_000_000_000_000_000_000_000_001_501],
      headers: [
        rid: room_id,
        time: ts,
        auth: hash(room_id, ts)
      ]
    )
    |> Req.json()
  end

  defp find_url(""), do: ""

  defp find_url(data) do
    rtmp = Map.fetch!(data, "rtmp_live")
    key = Pattern.re_find(~r/(\d{1,7}[0-9a-zA-Z]+)_?\d{0,4}(.m3u8)/, rtmp)
    "#{Application.fetch_env!(:live_parser, :douyu_prefix)}#{key}.flv"
  end

  def parse(room_id) do
    %{"data" => data} =
      room_id
      |> fetch_body()

    data |> find_url()
  end
end