defmodule CloudFlow.Douban.Parser do
  alias CloudFlow.Tool.Cast

  def date(book_item) do
    book_item
    |> Floki.find(".date")
    |> Floki.text(deep: false)
    |> String.split("\n")
    |> hd
    |> Date.from_iso8601!()
  end

  def url(item) do
    item
    |> Floki.find(".nbg")
    |> Floki.attribute("href")
    |> Floki.text(deep: false)
  end

  def rating(item, :book), do: rating(item, ".short-note span:nth-child(1)")

  def rating(item, :movie), do: rating(item, "li:nth-child(3)>span:nth-child(1)")

  def rating(item, selector) do
    item
    |> Floki.find(selector)
    |> Floki.attribute("class")
    |> Floki.text(deep: false)
    |> String.at(6)
    |> Cast.to_integer()
  end

  def title(item, :book) do
    item
    |> Floki.find("h2 > a")
    |> Floki.attribute("title")
    |> Floki.text(deep: false)
  end

  def title(item, :movie) do
    item
    |> Floki.find("li:nth-child(1)>a>em")
    |> Floki.text(deep: false)
    |> String.split(" / ")
    |> hd
  end

  def tags(item) do
    item
    |> Floki.find(".tags")
    |> Floki.text(deep: false)
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
