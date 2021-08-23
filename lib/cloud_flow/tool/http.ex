defmodule CloudFlow.Req do
  @finch_name Application.fetch_env!(:cloud_flow, :finch_name)

  defp enforce({:error, _reason}), do: raise(RuntimeError)
  defp enforce({:ok, body}), do: body

  def get!(url, params \\ []), do: get(url, params) |> enforce

  def post!(url, params \\ []), do: post(url, params) |> enforce

  def get(url, params \\ []), do: make(:get, url, params)

  def post(url, params \\ []), do: make(:post, url, params)

  defp make(method, url, params) do
    Finch.build(method, url)
    |> build_req(Map.new(params))
    |> Finch.request(@finch_name)
  end

  @spec json(%{:body => binary(), optional(any) => any}) :: binary
  def json(%{body: b}) do
    :jiffy.decode(b)
  end

  @spec build_req(Finch.Request.t(), map()) :: Finch.Request.t()
  defp build_req(rq, %{headers: h} = params),
    do: build_req(%{rq | headers: h}, Map.delete(params, :headers))

  defp build_req(rq, %{form: b} = params),
    do: build_req(%{rq | body: URI.encode_query(b)}, Map.delete(params, :form))

  defp build_req(rq, %{json: j} = params),
    do: build_req(%{rq | body: :jiffy.encode(j)}, Map.delete(params, :json))

  defp build_req(rq, %{query: q} = params),
    do: build_req(%{rq | query: URI.encode_query(q)}, Map.delete(params, :query))

  defp build_req(rq, _), do: rq

  def body(%{body: body}), do: body
end
