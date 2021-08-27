defmodule CloudFlow.Huya.Info do
  alias CloudFlow.{Tool.Pattern, Model.Live, Huya.Data, Req}
  @prefix "https://m.huya.com/"

  def title(body), do: Pattern.re_find(~r/sIntroduction":"(.*?)"/, body)

  def author(body), do: Pattern.re_find(~r/sNick":"(.*?)"/, body)

  def avatar(body), do: Pattern.re_find(~r/sAvatar180":"http[s]?:(.*?)"/, body)

  def member(body), do: Pattern.re_find(~r/lTotalCount":(.*?),/, body) |> String.to_integer()

  def danmu(body) do
    ayyuid = Pattern.re_find(~r/lYyid":([0-9]+),/, body)
    tid = Pattern.re_find(~r/lChannelId":([0-9]+),/, body)
    sid = Pattern.re_find(~r/lChannelId":([0-9]+),/, body)

    buf =
      <<>>
      |> Data.IntegerToBit.writeInteger(0, String.to_integer(ayyuid))
      |> Data.BoolToBit.writeBool(1, true)
      |> Data.StringToBit.writeString(2, "")
      |> Data.StringToBit.writeString(3, "")
      |> Data.IntegerToBit.writeInteger(4, String.to_integer(tid))
      |> Data.IntegerToBit.writeInteger(5, String.to_integer(sid))
      |> Data.IntegerToBit.writeInteger(6, 0)
      |> Data.IntegerToBit.writeInteger(7, 0)

    <<>>
    |> Data.IntegerToBit.writeInteger(0, 1)
    |> Data.ByteToBit.writeBytes(1, buf)
  end

  def parse(room_id) do
    body = Req.get!("#{@prefix}#{room_id}") |> Req.body()
    {%Live{platform: :huya, room_id: room_id}, body}
  end
end
