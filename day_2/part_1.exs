{x, y} =
  "input.txt"
  |> File.stream!()
  |> Enum.reduce({0, 0}, fn
    "forward" <> amount, {x, y} ->
      x = amount |> String.trim() |> Integer.parse() |> elem(0) |> Kernel.+(x)
      {x, y}

    "up" <> amount, {x, y} ->
      y = y |> Kernel.-(amount |> String.trim() |> Integer.parse() |> elem(0))
      {x, y}

    "down" <> amount, {x, y} ->
      y = amount |> String.trim() |> Integer.parse() |> elem(0) |> Kernel.+(y)
      {x, y}
  end)

(x * y) |> IO.inspect()
