defmodule CloudFlow.Huya.Live do
  alias CloudFlow.{Req, Tool.Pattern}
  @prefix "https://m.huya.com/"

  def live_url(body) do
    s =
      ~r/liveLineUrl":"(.*?)"/
      |> Pattern.re_find(body)
      |> Base.decode64!()
      |> URI.parse()
      |> Map.fetch!(:path)
      |> String.trim(".m3u8")

    case s do
      nil -> ""
      _ -> "#{Application.fetch_env!(:cloud_flow, :huya_prefix)}#{s}.xs"
    end
  end

  def parse(room_id) do
    Req.get!("#{@prefix}#{room_id}")
    |> Req.body()
    |> live_url()
  end
end
