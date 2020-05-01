defmodule Api.LinkList.GetTest do
  use ExUnit.Case

  @save_links_url "http://localhost:8080/visited_links"
  @get_links_url "http://localhost:8080/visited_domains"

  @body1 "{
      \"links\": [
      \"https://ya.ru\",
      \"https://ya.ru?q=123\",
      \"funbox.ru\",
      \"https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor\"
    ]
  }"

  @body2 "{
      \"links\": [
      \"https://google.com\",
      \"https://mail.ru?q=123\",
      \"http://toster.ru\"
    ]
  }"

  @body3_will_not_receive "{
      \"links\": [
      \"https://qwerty.com\",
      \"https://asdfg.com?q=123\"
    ]
  }"

  @headers [{"Content-Type", "application/json"}]

  @response1_body "{\"status\":\"ok\",\"domains\":[\"ya.ru\",\"funbox.ru\",\"stackoverflow.com\"]}"
  @response2_body "{\"status\":\"ok\",\"domains\":[\"google.com\",\"mail.ru\",\"toster.ru\"]}"
  @response_status_code 200

  test "test saving and getting links in Redis" do
    date_time_1_before = DateTime.utc_now() |> DateTime.to_unix(:microsecond)

    HTTPoison.post(@save_links_url, @body1, @headers)
    {:ok, response} = HTTPoison.get(@get_links_url, @headers)
    assert response.status_code == @response_status_code
    assert response.body == @response1_body

    {:ok, response} = HTTPoison.get("#{@get_links_url}/?from=#{date_time_1_before}", @headers)
    assert response.status_code == @response_status_code
    assert response.body == @response1_body

    date_time_1_after = DateTime.utc_now() |> DateTime.to_unix(:microsecond)
    {:ok, response} = HTTPoison.get("#{@get_links_url}/?to=#{date_time_1_after}", @headers)
    assert response.status_code == @response_status_code
    assert response.body == @response1_body

    Process.sleep(2000)
    date_time_2_before = DateTime.utc_now() |> DateTime.to_unix(:microsecond)
    HTTPoison.post(@save_links_url, @body2, @headers)
    date_time_2_after = DateTime.utc_now() |> DateTime.to_unix(:microsecond)
    HTTPoison.post(@save_links_url, @body3_will_not_receive, @headers)
    {:ok, response} = HTTPoison.get("#{@get_links_url}/?from=#{date_time_2_before}&to=#{date_time_2_after}", @headers)
    assert response.status_code == @response_status_code
    assert response.body == @response2_body
  end
end