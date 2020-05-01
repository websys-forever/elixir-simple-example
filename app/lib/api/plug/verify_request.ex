defmodule Api.Plug.VerifyRequest do
  defmodule IncompleteRequestError do
    defexception message: "Bad request", plug_status: 400
  end

  def init(options), do: options

  def valid_new_links?(%Plug.Conn{} = conn) do
    if not Map.has_key?(conn.body_params, "links"), do: raise(IncompleteRequestError)
  end
end