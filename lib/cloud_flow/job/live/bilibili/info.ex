defmodule CloudFlow.Bilibili.Info do
  alias CloudFlow.{Req, Model.Live}
  @prefix "https://api.live.bilibili.com/xlive/web-room/v1/index/getInfoByRoom?room_id="

  def fetch_info(base, room_id) do
    Req.get!("#{base}#{room_id}")
    |> Req.json()
    |> Map.fetch!("data")
  end

  def danmu(room) do
    room_id =
      room
      |> Map.fetch!("room_info")
      |> Map.fetch!("room_id")

    data =
      %{
        roomid: room_id,
        uid: trunc(1.0e14 + 2.0e14 * :rand.uniform()),
        protover: 1
      }
      |> Jason.encode!()

    <<byte_size(data) + 16::32>> <> <<0, 16, 0, 1, 7::32, 1::32>> <> data
  end

  def avatar(room),
    do: room |> Map.fetch!("anchor_info") |> Map.fetch!("base_info") |> Map.fetch!("face")

  def title(room), do: room |> Map.fetch!("room_info") |> Map.fetch!("title")
  def member(room), do: room |> Map.fetch!("room_info") |> Map.fetch!("online")

  def author(room),
    do: room |> Map.fetch!("anchor_info") |> Map.fetch!("base_info") |> Map.fetch!("uname")

  def parse(room_id) do
    room = fetch_info(@prefix, room_id)
    {%Live{platform: :bilibili, room_id: room_id}, room}
  end
end
