defmodule Api.LinkList.Set do
  def set_links(data) do
    {:ok, redisConn} = Redix.start_link("redis://redis:6379")
    Enum.each(data.body_params["links"], fn(s) ->
        dt = DateTime.utc_now() |> DateTime.to_unix(:microsecond)
        link = "#{dt}|#{s}"
        Redix.command(redisConn, ["ZADD", "links", "0", link])
    end)
  end

  def set_ok_json_result() do
      {:ok, result} = Poison.encode(%{status: "ok"})
      result
  end
end