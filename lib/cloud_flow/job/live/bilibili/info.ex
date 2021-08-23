defmodule CloudFlow.Live.Bilibili.Info do
  alias CloudFlow.Req
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
      |> :jiffy.encode()

    (<<byte_size(data) + 16::32>> <> <<0, 16, 0, 1, 7::32, 1::32>> <> data)
    |> :binary.bin_to_list()
  end

  def parse(room_id) do
    room = fetch_info(@prefix, room_id)
    avatar = room |> Map.fetch!("anchor_info") |> Map.fetch!("base_info") |> Map.fetch!("face")
    title = room |> Map.fetch!("room_info") |> Map.fetch!("title")
    users = room |> Map.fetch!("room_info") |> Map.fetch!("online")
    author = room |> Map.fetch!("anchor_info") |> Map.fetch!("base_info") |> Map.fetch!("uname")

    %{
      avatar: avatar,
      title: title,
      users: users,
      author: author,
      init_danmu: danmu(room)
    }
  end
end
