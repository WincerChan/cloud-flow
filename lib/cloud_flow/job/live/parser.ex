defmodule CloudFlow.Live.Parser do
  @args [:author, :title, :member, :danmu]
  def parse_info(module, room_id) do
    info_module = Module.concat(module, Info)
    live_module = Module.concat(module, Live)
    {init, body} = apply(info_module, :parse, [room_id])

    Enum.reduce(
      @args,
      init,
      fn r, live ->
        Map.put(live, r, apply(info_module, r, [body]))
      end
    )
    |> Map.put(:player, parse_live(live_module, room_id) |> IO.inspect())
  end

  def parse_live(module, room_id), do: apply(module, :parse, [room_id])
end
