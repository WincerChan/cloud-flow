defmodule CloudFlow.Crawler.Template do
  alias CloudFlow.Req

  def get_doc(url) do
    Req.get!(url)
    |> Req.body()
    |> Floki.parse_document!()
  end

  def find_pattern(doc, pat) do
    doc
    |> Floki.find(pat)
  end

  def match?(plain, keywords) do
    plain
    |> String.downcase()
    |> String.contains?(keywords)
  end
end
