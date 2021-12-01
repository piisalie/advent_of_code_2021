list =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn n ->
    n
    |> Integer.parse()
    |> elem(0)
  end)

[list, Enum.slice(list, 1..-1)]
|> Enum.zip_reduce(0, fn pairs, total ->
  case pairs do
    [x, y] when x < y -> total + 1
    _ -> total
  end
end)
|> IO.inspect
