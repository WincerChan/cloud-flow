defmodule CloudFlow.Huya.Data.Head do
  use Bitwise

  def write_head(buf, tag, vtype) when tag < 15 do
    helper = tag <<< 4 ||| vtype
    buf <> <<helper::8>>
  end

  def write_head(buf, tag, vtype) do
    helper = (240 ||| vtype) <<< 8 ||| tag
    buf <> <<helper::16>>
  end
end

defmodule CloudFlow.Huya.Data.IntegerToBit do
  use Bitwise
  @int8 0
  @int16 1
  @int32 2
  @int64 3
  # @float 4
  # @double 5
  # @map 8
  # @list 9
  # @structbegin 10
  # @structend 11
  @zero 12
  import CloudFlow.Huya.Data.Head

  def writeInteger(buff, tag, 0),
    do: buff |> write_head(tag, @zero)

  def writeInteger(buff, tag, value)
      when value >= -Bitwise.bsl(1, 7) and value < Bitwise.bsl(1, 7),
      do: (buff |> write_head(tag, @int8)) <> <<value::8>>

  def writeInteger(buff, tag, value)
      when value >= -Bitwise.bsl(1, 15) and value < Bitwise.bsl(1, 15),
      do: (buff |> write_head(tag, @int16)) <> <<value::16>>

  def writeInteger(buff, tag, value)
      when value >= -Bitwise.bsl(1, 31) and value < Bitwise.bsl(1, 31),
      do: (buff |> write_head(tag, @int32)) <> <<value::32>>

  def writeInteger(buff, tag, value),
    do: (buff |> write_head(tag, @int64)) <> <<value::64>>
end

defmodule CloudFlow.Huya.Data.BoolToBit do
  alias CloudFlow.Huya.Data.IntegerToBit
  def writeBool(buff, tag, true), do: buff |> IntegerToBit.writeInteger(tag, 1)

  def writeBool(buff, tag, false), do: buff |> IntegerToBit.writeInteger(tag, 0)
end

defmodule CloudFlow.Huya.Data.StringToBit do
  @string1 6
  @string4 7
  import CloudFlow.Huya.Data.Head

  def writeString(buff, tag, value) do
    len = String.length(value)

    case len <= 255 do
      true ->
        write_head(buff, tag, @string1) <> <<len>>

      _ ->
        write_head(buff, tag, @string4) <> <<len::64>>
    end <> <<value::binary>>
  end
end

defmodule CloudFlow.Huya.Data.ByteToBit do
  import CloudFlow.Huya.Data.{Head, IntegerToBit}
  @bytes 13
  def writeBytes(buff, tag, value) do
    len = String.length(value)

    (buff
     |> write_head(tag, @bytes)
     |> write_head(0, 0)
     |> writeInteger(0, len)) <>
      value
  end
end
