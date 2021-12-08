"input.txt"
|> File.stream!()
|> Enum.reduce(0, fn line, acc ->
  [_, output] = line |> String.trim() |> String.split(" | ")

  output
  |> String.split()
  |> Enum.filter(fn n -> (n |> String.length()) in [2, 3, 4, 7] end)
  |> length()
  |> Kernel.+(acc)
end)
|> IO.inspect(label: "Part 1")
