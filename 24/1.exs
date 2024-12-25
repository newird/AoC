import IO, only: [puts: 1]

defmodule Solve do
  @content File.read!("1.in")
  @parts String.split(@content, "\n\n")

  @value  Enum.at(@parts, 0)
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      [key, val] = String.split(line, ": ")
      Map.put(acc, key, val == "1")
    end)

  @exprs  Enum.at(@parts, 1)
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.reduce(%{}, fn line, acc ->
      [exp, v] = String.split(line, " -> ")
      Map.put(acc, v, exp)
    end)

 @to_solve  Enum.at(@parts, 1)
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

  def solve(val) do
    if Map.has_key?(@value, val) do
      Map.get(@value, val)
    else
      expr = Map.get(@exprs, val)
      [arg1, op, arg2] = String.split(expr, " ")
      v1 = solve(arg1)
      v2 = solve(arg2)

      result =
        case op do
          "AND" -> v1 && v2
          "OR" -> v1 || v2
          "XOR" -> (v1 && !v2) || (!v1 && v2)
        end

      Process.put(:lazy_value, Map.put(@value, val, result))
      result
    end
  end

  def calc() do
    result =
      Enum.reduce(@to_solve, 0, fn v, acc ->
        if solve(v) do
          acc * 2 + 1
        else
          acc * 2
        end

      end)
    puts(result)
  end
end

Solve.calc()
