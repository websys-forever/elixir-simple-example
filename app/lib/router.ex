defmodule Router do
  import Plug.Conn
  use Plug.Router
  use Plug.ErrorHandler

  alias Api.Plug.VerifyRequest

  @save_links_path "/visited_links"
  @get_links_path "/visited_domains"
  @request_content_type ["application/json"]

  plug Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: @request_content_type,
    json_decoder: Poison

  plug(:match)
  plug(:dispatch)

  post @save_links_path do
    VerifyRequest.valid_new_links?(conn)
    Api.LinkList.Set.set_links(conn)
    result = Api.LinkList.Set.set_ok_json_result()
    send_resp(conn, 201, result)
  end

  get @get_links_path do
    result = Api.LinkList.Get.get_domains(conn) |> Api.LinkList.Get.get_links_json_result()
    send_resp(conn, 200, result)
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, Poison.decode!(%{status: "#{kind}: #{reason}"}))
  end
end