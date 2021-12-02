{x, y, _a} =
  "input.txt"
  |> File.stream!()
  |> Enum.reduce({0, 0, 0}, fn
    "forward" <> amount, {x, y, a} ->
      amount = amount |> String.trim() |> Integer.parse() |> elem(0)

      x = amount |> Kernel.+(x)
      y = y + a * amount
      {x, y, a}

    "up" <> amount, {x, y, a} ->
      a = a |> Kernel.-(amount |> String.trim() |> Integer.parse() |> elem(0))
      {x, y, a}

    "down" <> amount, {x, y, a} ->
      a = amount |> String.trim() |> Integer.parse() |> elem(0) |> Kernel.+(a)
      {x, y, a}
  end)

(x * y) |> IO.inspect()
