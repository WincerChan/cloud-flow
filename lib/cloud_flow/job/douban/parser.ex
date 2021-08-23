defmodule CloudFlow.Douban.Parser do
  import Meeseeks.CSS
  alias CloudFlow.Tool.Cast

  def date(book_item) do
    book_item
    |> Meeseeks.one(css(".date"))
    |> Meeseeks.own_text()
    |> String.split(" ")
    |> hd
    |> Date.from_iso8601!()
  end

  def url(item) do
    item
    |> Meeseeks.one(css(".nbg"))
    |> Meeseeks.attr("href")
  end

  def rating(item) do
    item
    |> Meeseeks.one(css("span[class^=rating]"))
    |> Meeseeks.attr("class")
    |> to_string()
    |> String.at(6)
    |> Cast.to_integer()
  end

  def title(item, :book) do
    item
    |> Meeseeks.one(css("h2 > a"))
    |> Meeseeks.attr("title")
  end

  def title(item, :movie) do
    item
    |> Meeseeks.one(css(".title em"))
    |> Meeseeks.own_text()
    |> String.split(" / ")
    |> hd
  end

  def tags(item) do
    item
    |> Meeseeks.one(css(".tags"))
    |> Meeseeks.own_text()
    |> to_string()
    |> String.split(" ")
    |> tl
  end

  def poster(item) do
    item
    |> Meeseeks.one(css("img"))
    |> Meeseeks.attr("src")
  end

  def comment(item) do
    item
    |> Meeseeks.one(css(".comment"))
    |> Meeseeks.own_text()
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
