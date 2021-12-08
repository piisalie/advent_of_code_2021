numbers =
  "input.txt"
  |> File.read!()
  |> String.trim()
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)


{min, max} = numbers |> Enum.min_max()

min..max
|> Enum.map(fn mid ->
  numbers
  |> Enum.reduce(0, fn n, acc ->
    distance = abs(mid - n)
    fuel_needed = distance * (distance + 1) / 2

    acc + fuel_needed
  end)
end)
|> Enum.min()
|> IO.inspect(label: "Part 2")
