defmodule Api.LinkList.SetTest do
  use ExUnit.Case

  @save_links_url "http://localhost:8080/visited_links"

  @body "{
      \"links\": [
      \"https://ya.ru\",
      \"https://ya.ru?q=123\",
      \"funbox.ru\",
      \"https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor\"
    ]
  }"

  @headers [{"Content-Type", "application/json"}]

  @response_body "{\"status\":\"ok\"}"
  @response_status_code 201

  test "test saving links in Redis" do
    {:ok, response} = HTTPoison.post(@save_links_url, @body, @headers)
    assert response.body == @response_body
    assert response.status_code == @response_status_code
  end
end