# For part 2 we're gonna try to group fish in a certain state to save memory
# / list length.
#
# eg instead of "[3,2,2,1]" for children, more like "%{3 => 1, 2 => 2 ...}"

defmodule Replicator do
  def resolve_children(days_left, children) when days_left == 0 do
    children |> Map.values() |> Enum.reduce(fn v, acc -> acc + v end)
  end

  def resolve_children(days_left, children) do
    resolve_children(days_left - 1, children |> handle_reproduction)
  end

  defp handle_reproduction(children) do
    children
    |> Enum.reduce(Map.new(), fn
      {0, count}, acc -> acc |> Map.merge(%{6 => count, 8 => count}, fn _k, v1, v2 -> v1 + v2 end)
      {day, count}, acc -> acc |> Map.merge(%{(day - 1) => count}, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end
end

"input.txt"
|> File.read!()
|> String.split(",")
|> Enum.map(fn starting_day ->
  starting_day = starting_day |> String.trim() |> String.to_integer()

  256
  |> Replicator.resolve_children(%{starting_day => 1})
end)
|> Enum.reduce(0, fn x, acc -> acc + x end)
|> IO.inspect(label: "Part 2")
