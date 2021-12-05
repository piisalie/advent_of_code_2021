defmodule Board do
  def check_number(%{winner: true} = board, _number), do: board

  def check_number(board, number) do
    board.squares
    |> Enum.map(fn row -> row |> Enum.find_index(fn n -> n == number end) end)
    |> compute_hit()
    |> case do
      nil ->
        board

      {x, y} ->
        %{
          squares: board.squares,
          hits: [{x, y} | board.hits],
          winner: win?({x, y}, board.hits)
        }
    end
  end

  def sum_unmarked_numbers(board) do
    do_sum(board.hits, board.squares)
  end

  defp do_sum([], squares) do
    squares
    |> Enum.reduce(0, fn row, acc ->
      acc + (row |> Enum.reduce(0, fn i, acc -> acc + String.to_integer(i) end))
    end)
  end

  defp do_sum([{x, y} | hits], squares) do
    squares =
      squares
      |> Enum.with_index()
      |> Enum.map(fn
        {row, idx} when idx == x -> row |> List.replace_at(y, "0")
        {row, _} -> row
      end)

    do_sum(hits, squares)
  end

  defp win?({x, y}, hits) do
    hits |> Enum.count(fn {xb, _} -> xb == x end) == 4 ||
      hits |> Enum.count(fn {_, yb} -> yb == y end) == 4
  end

  defp compute_hit([idx, nil, nil, nil, nil]) when not is_nil(idx), do: {0, idx}
  defp compute_hit([nil, idx, nil, nil, nil]) when not is_nil(idx), do: {1, idx}
  defp compute_hit([nil, nil, idx, nil, nil]) when not is_nil(idx), do: {2, idx}
  defp compute_hit([nil, nil, nil, idx, nil]) when not is_nil(idx), do: {3, idx}
  defp compute_hit([nil, nil, nil, nil, idx]) when not is_nil(idx), do: {4, idx}
  defp compute_hit(_), do: nil
end

[numbers | boards] =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

numbers = numbers |> String.split(",")

boards =
  boards
  |> Enum.chunk_every(5)
  |> Enum.map(fn b ->
    squares = b |> Enum.map(fn row -> row |> String.split(~r/\s/, trim: true) end)
    %{squares: squares, winner: false, hits: []}
  end)

# Part 1
numbers
|> Enum.reduce_while(boards, fn number, last_boards ->
  boards =
    last_boards
    |> Enum.map(fn board -> board |> Board.check_number(number) end)

  boards
  |> Enum.find(fn board -> board.winner end)
  |> case do
    nil ->
      {:cont, boards}

    winner ->
      unmarked = Board.sum_unmarked_numbers(winner)
      {:halt, unmarked * (number |> String.to_integer())}
  end
end)
|> IO.inspect(label: "part 1 total")

# Part 2
{_boards, [{last_winner, number} | _]} =
  numbers
  |> Enum.reduce({boards, []}, fn number, {last_boards, winners} ->
    boards =
      last_boards
      |> Enum.map(fn board -> board |> Board.check_number(number) end)

    boards
    |> Enum.find(fn board -> board.winner end)
    |> case do
      nil ->
        {boards, winners}

      winner ->
        {boards |> Enum.reject(fn b -> b.winner end), [{winner, number} | winners]}
    end
  end)

unmarked = Board.sum_unmarked_numbers(last_winner)
(unmarked * (number |> String.to_integer())) |> IO.inspect(label: "part 2 total")
