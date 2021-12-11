defmodule LexLuther do
  def is_valid?([], _) do
    true
  end

  def is_valid?(["}" | rest], ["{" | seen]) do
    is_valid?(rest, seen)
  end

  def is_valid?(["]" | rest], ["[" | seen]) do
    is_valid?(rest, seen)
  end

  def is_valid?([">" | rest], ["<" | seen]) do
    is_valid?(rest, seen)
  end

  def is_valid?([")" | rest], ["(" | seen]) do
    is_valid?(rest, seen)
  end

  def is_valid?([char | rest], seen) when char in ["(", "[", "{", "<"] do
    seen = [char | seen]

    is_valid?(rest, seen)
  end

  def is_valid?([char | _rest], _seen) do
    char
  end

  def autocomplete([], seen) do
    seen
    |> Enum.reduce(0, fn completion, acc ->
      score =
        case completion do
          "(" -> 1
          "[" -> 2
          "{" -> 3
          "<" -> 4
        end

      acc * 5 + score
    end)
  end

  def autocomplete(["}" | rest], ["{" | seen]) do
    autocomplete(rest, seen)
  end

  def autocomplete(["]" | rest], ["[" | seen]) do
    autocomplete(rest, seen)
  end

  def autocomplete([">" | rest], ["<" | seen]) do
    autocomplete(rest, seen)
  end

  def autocomplete([")" | rest], ["(" | seen]) do
    autocomplete(rest, seen)
  end

  def autocomplete([char | rest], seen) when char in ["(", "[", "{", "<"] do
    seen = [char | seen]

    autocomplete(rest, seen)
  end
end

_test_input = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""

"input.txt"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(fn input ->
  input |> String.codepoints() |> LexLuther.is_valid?([])
end)
|> Enum.reject(fn result -> result == true end)
|> Enum.reduce(0, fn
  ")", acc -> acc + 3
  "]", acc -> acc + 57
  "}", acc -> acc + 1197
  ">", acc -> acc + 25137
end)
|> IO.inspect(label: "Part 1")

scores =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn input -> input |> String.codepoints() end)
  |> Enum.filter(fn input ->
    input |> LexLuther.is_valid?([]) == true
  end)
  |> Enum.map(fn input -> input |> LexLuther.autocomplete([]) end)
  |> Enum.sort()

middle =
  scores
  |> length()
  |> div(2)

scores
|> Enum.at(middle)
|> IO.inspect(label: "Part 2")
