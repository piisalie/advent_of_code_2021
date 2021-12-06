# Recurse building a larger and larger list of states for
# each starting fish.
#
# Works fine, but will not scale (tm) because it builds exceedingly large
# lists.

defmodule Replicator do
  def resolve_children(days_left, children) when days_left == 0 do
    children
  end

  def resolve_children(days_left, children) do
    resolve_children(days_left - 1, children |> handle_reproduction)
  end

  defp handle_reproduction(children) do
    children
    |> Enum.flat_map(fn
      0 -> [6, 8]
      child -> [child - 1]
    end)
  end
end

"input.txt"
|> File.read!()
|> String.split(",")
|> Enum.map(fn starting_day ->
  80
  |> Replicator.resolve_children([starting_day |> String.trim() |> String.to_integer()])
  |> length()
end)
|> Enum.reduce(0, fn x, acc -> acc + x end)
|> IO.inspect(label: "Part 1")
