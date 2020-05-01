defmodule Api.LinkList.Get do
  def get_domains(data) do
    {:ok, links} = get_links(data)
    pattern = ~r"\|(?:https?://)?([a-z0-9\-\.]*\.(?:[a-z]{2,10}))"

    Enum.reduce(links, [], fn item, domains ->
      domain = Regex.run(pattern, item, capture: :all_but_first)
      if domain, do: Enum.concat(domains, domain), else: domains
    end)
    |> Enum.uniq()
  end

  def get_links(data) do
    from = ParamsFetcher.get_from(data.query_params)
    to = ParamsFetcher.get_to(data.query_params)
    {:ok, redisConn} = Redix.start_link("redis://redis:6379")
    Redix.command(redisConn, ["ZRANGEBYLEX", "links", from, to])
  end

  def get_links_json_result(data) do
    {:ok, result} = Poison.encode(%{status: "ok", domains: data})
    result
  end
end