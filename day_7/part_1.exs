numbers =
  "input.txt"
  |> File.read!()
  |> String.trim()
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

median = numbers |> Enum.sort() |> Enum.at(numbers |> length() |> div(2))

numbers
|> Enum.reduce(0, fn n, acc -> abs(n - median) + acc end)
|> IO.inspect(label: "Part 1")
