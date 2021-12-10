defmodule FloorMapper do
  def find_low_spots(map) do
    map
    |> Enum.filter(fn point -> is_lower_than_neighbors(map, point) end)
  end

  def find_basins(map) do
    low_spots = find_low_spots(map)

    low_spots
    |> Enum.map(fn point ->
      explore_basin(map, [point], MapSet.new())
    end)
  end

  defp explore_basin(_map, [], seen) do
    seen
  end

  defp explore_basin(map, [point | rest], seen) do
    {{x, y}, z} = point

    points =
      [
        {{x + 1, y}, Map.get(map, {x + 1, y})},
        {{x - 1, y}, Map.get(map, {x - 1, y})},
        {{x, y + 1}, Map.get(map, {x, y + 1})},
        {{x, y - 1}, Map.get(map, {x, y - 1})}
      ]
      |> Enum.filter(fn {coords, zt} ->
        zt && zt > z && zt != 9 && !MapSet.member?(seen, coords)
      end)

    explore_basin(map, points ++ rest, seen |> MapSet.put({x, y}))
  end

  defp is_lower_than_neighbors(map, {{x, y}, z}) do
    Map.get(map, {x, y - 1}, z + 1) > z &&
      Map.get(map, {x, y + 1}, z + 1) > z &&
      Map.get(map, {x - 1, y}, z + 1) > z &&
      Map.get(map, {x + 1, y}, z + 1) > z
  end
end

ground_map =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.with_index()
  |> Enum.flat_map(fn {line, y} ->
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.map(fn {z, x} -> {{x, y}, String.to_integer(z)} end)
  end)
  |> Enum.into(Map.new())

ground_map
|> FloorMapper.find_low_spots()
|> Enum.map(fn {_, n} -> n + 1 end)
|> Enum.reduce(0, &Kernel.+/2)
|> IO.inspect(label: "Part 1")

ground_map
|> FloorMapper.find_basins()
|> Enum.map(&MapSet.size(&1))
|> Enum.sort(:desc)
|> Enum.take(3)
|> Enum.reduce(&*/2)
|> IO.inspect(label: "Part 2")
