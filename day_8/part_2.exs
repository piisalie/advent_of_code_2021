"input.txt"
|> File.stream!()
|> Enum.map(fn line ->
  [signal, output] = line |> String.trim() |> String.split(" | ")

  signal =
    signal
    |> String.split()

  [one, seven, four, eight] =
    signal
    |> Enum.filter(fn n -> (n |> String.length()) in [2, 3, 4, 7] end)
    |> Enum.sort_by(&String.length/1)

  six =
    signal
    |> Enum.find(fn n ->
      n |> String.length() == 6 && length(String.codepoints(n) -- String.codepoints(one)) == 5
    end)

  nine =
    signal
    |> Enum.find(fn n ->
      n |> String.length() == 6 && length(String.codepoints(n) -- String.codepoints(four)) == 2
    end)

  zero =
    signal
    |> Enum.find(fn n ->
      n |> String.length() == 6 && n not in [six, nine]
    end)

  two =
    signal
    |> Enum.find(fn n ->
      n |> String.length() == 5 && length(String.codepoints(n) -- String.codepoints(four)) == 3
    end)

  three =
    signal
    |> Enum.find(fn n ->
      n |> String.length() == 5 && length(String.codepoints(n) -- String.codepoints(six)) == 1 &&
        n not in [two]
    end)

  five =
    signal
    |> Enum.find(fn n ->
      n |> String.length() == 5 && n not in [two, three]
    end)

  output
  |> String.split()
  |> Enum.map(fn o ->
    cond do
      o |> String.codepoints() |> Enum.sort() == zero |> String.codepoints() |> Enum.sort() -> 0
      o |> String.codepoints() |> Enum.sort() == one |> String.codepoints() |> Enum.sort() -> 1
      o |> String.codepoints() |> Enum.sort() == two |> String.codepoints() |> Enum.sort() -> 2
      o |> String.codepoints() |> Enum.sort() == three |> String.codepoints() |> Enum.sort() -> 3
      o |> String.codepoints() |> Enum.sort() == four |> String.codepoints() |> Enum.sort() -> 4
      o |> String.codepoints() |> Enum.sort() == five |> String.codepoints() |> Enum.sort() -> 5
      o |> String.codepoints() |> Enum.sort() == six |> String.codepoints() |> Enum.sort() -> 6
      o |> String.codepoints() |> Enum.sort() == seven |> String.codepoints() |> Enum.sort() -> 7
      o |> String.codepoints() |> Enum.sort() == eight |> String.codepoints() |> Enum.sort() -> 8
      true -> 9
    end
  end)
  |> Enum.join()
end)
|> Enum.reduce(0, fn number, acc -> number |> String.to_integer() |> Kernel.+(acc) end)
|> IO.inspect(label: "Part 2")
