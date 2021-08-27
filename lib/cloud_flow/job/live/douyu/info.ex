defmodule CloudFlow.Douyu.Info do
  @prefix "https://m.douyu.com/"
  alias CloudFlow.{Tool.Pattern, Req, Model.Live}

  defp danmu_init_info(data) do
    s = <<9 + byte_size(data)::32-little>>

    (s <> s <> <<689::32-little>> <> data <> <<0>>)
    |> :binary.bin_to_list()
  end

  def danmu(room_id) do
    danmu_init_info("type@=loginreq/roomid@=#{room_id}/") ++
      danmu_init_info("type@=joingroup/rid@=#{room_id}/gid@=-9999/")
  end

  def author(body), do: Pattern.re_find(~r/nickname":"(.*?)"/, body)

  def title(body), do: Pattern.re_find(~r/roomName":"(.*?)"/, body)

  def member(body), do: Pattern.re_find(~r/hn":"(.*?)"/, body)

  def avator(body), do: Pattern.re_find(~r/avatar":"(.*?)"/, body)

  def parse(room_id) do
    body = Req.get!("#{@prefix}#{room_id}") |> Req.body()
    {%Live{platform: :douyu, room_id: room_id}, body}
  end
end
