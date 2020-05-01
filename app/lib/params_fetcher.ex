defmodule ParamsFetcher do
  def get_from(params) do
    if Map.has_key?(params, "from") and params["from"] > 0 do
      "[#{String.to_integer(params["from"])}"
    else
      "-"
    end
  end

  def get_to(params) do
    if Map.has_key?(params, "to") and params["to"] > 0 do
      "(#{String.to_integer(params["to"]) + 1}"
    else
      "+"
    end
  end
end