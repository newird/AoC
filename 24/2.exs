defmodule Solve do
  @content File.read!("1.in")
  @parts String.split(@content, "\n\n", parts: 2)

  @exprs @parts
         |> Enum.at(1)
         |> String.split("\n", trim: true)
         |> Enum.reject(&(&1 == ""))
         |> Enum.reduce(%{}, fn line, acc ->
           case String.split(line, " -> ") do
             [exp, wire] ->
               Map.put(acc, wire, exp)
             _ ->
               acc
           end
         end)


 @to_solve  @parts |>Enum.at( 1)
  |> String.split("\n")
  |> Enum.reject(&(&1 == ""))
  |> Enum.reduce(MapSet.new(), fn line, acc ->
    case String.split(line, " -> ") do
      [_, v] ->
        if String.starts_with?(v, "z") do
          MapSet.put(acc, v)
        else
          acc
        end
      _ -> acc
    end
  end)
  |> Enum.sort(:desc)

  defp parse_expr(str) do
    [left, op, right] = String.split(str, " ", parts: 3)
    {op, left, right}
  end

  def part2() do
    expr_map =
      @exprs
      |> Enum.map(fn {wire, exp_str} ->
        {wire, parse_expr(exp_str)}
      end)
      |> Map.new()

    bits = length(@to_solve)
    last_bit =
      (bits - 1)
      |> Integer.to_string()
      |> String.pad_leading(2, "0")

    invalid_wires =
      expr_map
      |> Enum.filter(fn {wire, {op, left, right}} ->
        check_invalid?(wire, {op, left, right}, expr_map, last_bit)
      end)
      |> Enum.map(fn {wire, _expr} -> wire end)
      |> Enum.sort()

    IO.puts(Enum.join(invalid_wires, ","))
  end


  defp check_invalid?(wire, {op, left, right}, expr_map, last_bit) do
    cond do
      # 1. the first 'z' bit should be half adder, so an AND gate is correct
      wire == "z00" and op == "AND" and left == "x00" and right == "y00" ->
        false

      # 2. the last 'z' bit can be a carry bit, so an OR gate is correct
      String.starts_with?(wire, "z") and
        String.slice(wire, 1, 2) == last_bit and
        op == "OR" ->
        false

      # 3. all other 'z' bits not produced by XOR gates are invalid
      String.starts_with?(wire, "z") and op in ["AND", "OR"] ->
        true

      # 4. output from XOR gates taking an 'x' bit and a 'y' bit should be
      #    an operand to an AND gate
      op == "XOR" and String.starts_with?(left, "x") and String.starts_with?(right, "y") and
          String.slice(left, 1, 2) != "00" and String.slice(right, 1, 2) != "00" ->
        if used_as_operand_in?(wire, "AND", expr_map) do
          false
        else
          true
        end

      # 5. XOR gates can take an 'x' bit and a 'y' bit to produce a sum intermediate => None
      op == "XOR" and String.starts_with?(left, "x") and String.starts_with?(right, "y") ->
        false

      # 6. XOR gates can take intermediate bits to produce a 'z' bit => None
      String.starts_with?(wire, "z") and op == "XOR" ->
        false

      # 7. all other XOR gates are invalid
      op == "XOR" ->
        true

      # 8. output from AND gates taking an 'x' bit and a 'y' bit should be an operand to an OR gate
      op == "AND" and String.starts_with?(left, "x") and String.starts_with?(right, "y") and
          String.slice(left, 1, 2) != "00" and String.slice(right, 1, 2) != "00" ->
        if used_as_operand_in?(wire, "OR", expr_map) do
          false
        else
          true
        end

      true ->
        false
    end
  end

  defp used_as_operand_in?(wire, op, expr_map) do
    expr_map
    |> Enum.any?(fn {_w, {inner_op, left, right}} ->
      inner_op == op and (left == wire or right == wire)
    end)
  end
end

Solve.part2()
