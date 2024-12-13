open Printf

let det (a, b, c, d) : int =
    a * d - b * c

let cost extra (ax, ay, bx, by, x, y) : int =
    let x' = extra + x in
    let y' = extra + y in

    let dx = float_of_int( det (x', y', bx, by) )
    in
    let dy = float_of_int (det (ax, ay, x', y') )
    in
    let m = float_of_int (det (ax, ay, bx, by))
    in

    if m = 0.0 then 0
    else
      let t_float = dx /. m in
      let u_float = dy /. m in
      let t = int_of_float (t_float +. 0.5) in
      let u = int_of_float (u_float +. 0.5) in
      if (t * ax + u * bx = x') && (t * ay + u * by = y')
      then 3 * t + u
      else 0

let process_input filename =
    let chan = open_in filename in
    let rec read_and_parse acc =
        try
            let a_line = input_line chan in
            let b_line = input_line chan in
            let prize_line = input_line chan in

            let a_x, a_y = Scanf.sscanf a_line "Button A: X+%d, Y+%d" (fun x y -> x, y) in
            let b_x, b_y = Scanf.sscanf b_line "Button B: X+%d, Y+%d" (fun x y -> x, y) in
            let prize_x, prize_y = Scanf.sscanf prize_line "Prize: X=%d, Y=%d" (fun x y -> x, y) in

            (try let _ = input_line chan in () with End_of_file -> ());

            read_and_parse ((a_x, a_y, b_x, b_y, prize_x, prize_y) :: acc)
        with
        | End_of_file -> close_in chan; List.rev acc
        | exn ->
            close_in chan;
            raise exn
    in
    let machines = read_and_parse [] in
    let cost0 = List.fold_left (fun acc machine -> acc + cost 0 machine) 0 machines in
    let costBig = List.fold_left (fun acc machine -> acc + cost 10000000000000 machine) 0 machines in
    printf "%d\n" cost0;
    printf "%d\n" costBig

let () =
  process_input "1.in"
