defmodule CloudFlow.Douban.Parser do
  alias CloudFlow.Tool.Cast

  def date(book_item) do
    book_item
    |> Floki.find(".date")
    |> Floki.text(deep: false)
    |> String.split(" ")
    |> hd
    |> String.trim()
    |> Date.from_iso8601!()
  end

  def url(item) do
    item
    |> Floki.find(".nbg")
    |> Floki.attribute("href")
    |> hd
  end

  def rating(item) do
    item
    |> Floki.find("span[class^=rating]")
    |> Floki.attribute("class")
    |> to_string()
    |> String.at(6)
    |> Cast.to_integer()
  end

  def title(item, :book) do
    item
    |> Floki.find("h2 > a")
    |> Floki.attribute("title")
  end

  def title(item, :movie) do
    item
    |> Floki.find(".title em")
    |> Floki.text(deep: false)
    |> String.split("/")
    |> hd
    |> String.trim()
  end

  def tags(item) do
    item
    |> Floki.find(".tags")
    |> Floki.text(deep: false)
    |> to_string()
    |> String.split(" ")
    |> tl
  end

  def poster(item) do
    item
    |> Floki.find("img")
    |> Floki.attribute("src")
    |> hd
  end

  def comment(item) do
    item
    |> Floki.find(".comment")
    |> Floki.text(deep: false)
  end

  def id(item) do
    item
    |> url()
    |> URI.parse()
    |> Map.fetch!(:path)
    |> String.split("/")
    |> Enum.at(2)
    |> Cast.to_integer()
  end
end
