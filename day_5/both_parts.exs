# for each line, create a map with the coords as keys and the count as values
# 3,4 -> 5,4 should result in
# %{{3,4} => 1, {4,4} => 1, {5,4} => 1}
#
# merge this with the accumulator, using a function to increment the number
# if the key existed previously
#
# map |> values where count > 1

defmodule Venture do
  def parse(line, diagonals \\ false) do
    line
    |> String.trim()
    |> String.split(" -> ")
    |> Enum.map(fn v ->
      v |> String.split(",") |> Enum.map(fn s -> s |> String.to_integer() end)
    end)
    |> build_point_map(diagonals)
  end

  defp build_point_map([[x1, y1], [x2, y2]], _) when x1 == x2 do
    y1..y2 |> Enum.into(Map.new(), fn y -> {{x1, y}, 1} end)
  end

  defp build_point_map([[x1, y1], [x2, y2]], _) when y1 == y2 do
    x1..x2 |> Enum.into(Map.new(), fn x -> {{x, y1}, 1} end)
  end

  defp build_point_map(_, false) do
    %{}
  end

  defp build_point_map([[x1, y1], [x2, y2]], true) do
    x1..x2 |> Enum.zip(y1..y2) |> Enum.into(Map.new(), fn point -> {point, 1} end)
  end
end

file_reducer = fn label, function ->
  "input.txt"
  |> File.stream!()
  |> Enum.reduce(Map.new(), fn line, previous_map ->
    function.(line, previous_map)
  end)
  |> Map.values()
  |> Enum.filter(fn v -> v > 1 end)
  |> length()
  |> IO.inspect(label: label)
end

file_reducer.("Part 1", fn line, previous_map ->
  map = line |> Venture.parse()

  previous_map |> Map.merge(map, fn _k, v1, _v2 -> v1 + 1 end)
end)

file_reducer.("Part 2", fn line, previous_map ->
  map = line |> Venture.parse(true)

  previous_map |> Map.merge(map, fn _k, v1, _v2 -> v1 + 1 end)
end)
