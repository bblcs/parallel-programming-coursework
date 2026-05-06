type operation_type = Increment | Get

let string_of_op op = match op with Increment -> "Increment" | Get -> "Get"

type counter_type =
  | Unsafe
  | Unfair
  | Fair
  | Split_1
  | Split_2
  | Split_12
  | Split_Alot
  | Split_Pad_1
  | Split_Pad_2
  | Split_Pad_12
  | Split_Pad_Alot
  | NoContentionBaseline

let string_of_ctype ctype =
  match ctype with
  | Unsafe -> "Unsafe"
  | Unfair -> "Unfair"
  | Fair -> "Fair"
  | Split_1 -> "Split-01"
  | Split_2 -> "Split-02"
  | Split_12 -> "Split-12"
  | Split_Alot -> "Split-Alot"
  | Split_Pad_1 -> "Split-Pad-01"
  | Split_Pad_2 -> "Split-Pad-02"
  | Split_Pad_12 -> "Split-Pad-12"
  | Split_Pad_Alot -> "Split-Pad-Alot"
  | NoContentionBaseline -> "NoContentionBaseline"

type benchmark = {
  name : string;
  threads : int;
  score : float;
  score_err : float;
  ctype : counter_type;
  otype : operation_type;
}

let contains s sub =
  let len_s = String.length s in
  let len_sub = String.length sub in
  if len_sub = 0 then true
  else if len_sub > len_s then false
  else
    let rec check pos =
      pos <= len_s - len_sub
      && (String.sub s pos len_sub = sub || check (pos + 1))
    in
    check 0

let parse_row (row : string list) : benchmark option =
  match row with
  | [
   name_str;
   mode;
   threads_str;
   samples_str;
   score_str;
   score_err_str;
   unit_str;
   type_str;
  ] ->
      let name = String.split_on_char '.' name_str |> List.rev |> List.hd in
      let threads = int_of_string threads_str in
      let score = float_of_string score_str in
      let score_err = float_of_string score_err_str in
      let otype = if contains name "inc" then Increment else Get in
      let ctype =
        match type_str with
        | "Unsafe" -> Unsafe
        | "Unfair" -> Unfair
        | "Fair" -> Fair
        | "Split_1" -> Split_1
        | "Split_2" -> Split_2
        | "Split_12" -> Split_12
        | "Split_10000" -> Split_Alot
        | "Split_Pad_1" -> Split_Pad_1
        | "Split_Pad_2" -> Split_Pad_2
        | "Split_Pad_12" -> Split_Pad_12
        | "Split_Pad_10000" -> Split_Pad_Alot
        | "" -> NoContentionBaseline
        | _ -> failwith "Unknown ctype"
      in
      Some { name; threads; score; score_err; ctype; otype }
  | _ -> None

let load_data : benchmark list =
  let raw_csv = Csv.load "../jmh-result.csv" in
  match raw_csv with
  | [] -> []
  | header :: rows -> List.filter_map parse_row rows

let print_benchmark (row : benchmark) =
  Printf.printf
    "operation: %-12s\t  threads: %d\t score: %-14f\t score_err: %-14f\t \
     counter type: %s\t \n"
    (string_of_op row.otype) row.threads row.score row.score_err
    (string_of_ctype row.ctype)

let group_data (op : operation_type) (benches : benchmark list) =
  let fil = List.filter (fun b -> b.otype = op) benches in
  let ctypes = List.map (fun b -> b.ctype) fil |> List.sort_uniq compare in
  List.map
    (fun ct ->
      let bs = List.filter (fun b -> b.ctype = ct) fil in
      let sorted = List.sort (fun a b -> compare a.threads b.threads) bs in
      (ct, sorted))
    ctypes

let xtics (blist : benchmark list) : string =
  blist
  |> List.map (fun b -> b.threads)
  |> List.sort_uniq compare |> List.map string_of_int |> String.concat ", "

let gen_plot_op ~prefix (op : operation_type) (benches : benchmark list) =
  let grouped = group_data op benches in
  let op_str = string_of_op op in
  let plot_name = if prefix = "" then op_str else prefix ^ "-" ^ op_str in
  let dat_file = plot_name ^ ".dat" in
  let gp_file = plot_name ^ ".gp" in
  let oc = open_out dat_file in
  let plot_commands = ref [] in

  List.iteri
    (fun i (ct, pts) ->
      if pts <> [] then begin
        let ct_str = string_of_ctype ct in
        let cmd =
          Printf.sprintf "'%s' index %d title '%s' with yerrorlines linewidth 2"
            dat_file i ct_str
        in
        plot_commands := cmd :: !plot_commands;

        List.iter
          (fun b ->
            Printf.fprintf oc "%d %f %f\n" b.threads b.score b.score_err)
          pts;
        Printf.fprintf oc "\n\n"
      end)
    grouped;
  close_out oc;

  if !plot_commands <> [] then begin
    let gp_oc = open_out gp_file in
    Printf.fprintf gp_oc "set terminal pngcairo size 1920,1080\n";
    Printf.fprintf gp_oc "set output '%s.png'\n" plot_name;
    Printf.fprintf gp_oc "set title '%s'\n" plot_name;
    Printf.fprintf gp_oc "set xlabel 'Number of Threads'\n";
    Printf.fprintf gp_oc "set xtics (%s)\n" (xtics benches);
    Printf.fprintf gp_oc "set ylabel 'Score'\n";
    Printf.fprintf gp_oc "set yrange [0:*]\n";
    Printf.fprintf gp_oc "set grid\n";

    let plot_line = String.concat ", \\\n     " (List.rev !plot_commands) in
    Printf.fprintf gp_oc "plot %s\n" plot_line;
    close_out gp_oc;

    let _ = Sys.command (Printf.sprintf "gnuplot %s" gp_file) in
    Printf.printf "generated %s.png\n" plot_name
  end

let gen_plot_ctype ~prefix (ct : counter_type) (benches : benchmark list) =
  let ct_str = string_of_ctype ct in
  let plot_name = if prefix = "" then ct_str else prefix in
  let dat_file = plot_name ^ ".dat" in
  let gp_file = plot_name ^ ".gp" in
  let oc = open_out dat_file in
  let plot_commands = ref [] in

  let ops = [ Increment; Get ] in
  List.iteri
    (fun i op ->
      let op_str = string_of_op op in
      let pts =
        benches
        |> List.filter (fun b -> b.ctype = ct && b.otype = op)
        |> List.sort (fun a b -> compare a.threads b.threads)
      in

      if pts <> [] then begin
        let cmd =
          Printf.sprintf "'%s' index %d title '%s' with yerrorlines linewidth 2"
            dat_file i op_str
        in
        plot_commands := cmd :: !plot_commands;

        List.iter
          (fun b ->
            Printf.fprintf oc "%d %f %f\n" b.threads b.score b.score_err)
          pts;
        Printf.fprintf oc "\n\n"
      end)
    ops;
  close_out oc;

  if !plot_commands <> [] then begin
    let gp_oc = open_out gp_file in
    Printf.fprintf gp_oc "set terminal pngcairo size 1920,1080\n";
    Printf.fprintf gp_oc "set output '%s.png'\n" ct_str;
    Printf.fprintf gp_oc "set title '%s'\n" plot_name;
    Printf.fprintf gp_oc "set xlabel 'Number of Threads'\n";
    Printf.fprintf gp_oc "set xtics (%s)\n" (xtics benches);
    Printf.fprintf gp_oc "set ylabel 'Score'\n";
    Printf.fprintf gp_oc "set yrange [0:*]\n";
    Printf.fprintf gp_oc "set grid\n";

    let plot_line = String.concat ", \\\n     " (List.rev !plot_commands) in
    Printf.fprintf gp_oc "plot %s\n" plot_line;
    close_out gp_oc;

    let _ = Sys.command (Printf.sprintf "gnuplot %s" gp_file) in
    Printf.printf "generated %s.png\n" ct_str
  end

let () =
  let data = load_data in
  gen_plot_op ~prefix:"all" Increment data;
  gen_plot_op ~prefix:"all" Get data;

  let ctypes = data |> List.map (fun b -> b.ctype) |> List.sort_uniq compare in
  let valid_ctypes = List.filter (fun c -> c <> NoContentionBaseline) ctypes in
  List.iter (fun ct -> gen_plot_ctype ~prefix:"" ct data) valid_ctypes;

  let filtered_data =
    List.filter
      (fun b -> b.ctype <> NoContentionBaseline && b.ctype <> Unsafe)
      data
  in
  gen_plot_op ~prefix:"nuanced" Increment filtered_data;
  gen_plot_op ~prefix:"nuanced" Get filtered_data;

  let splits_1 =
    List.filter (fun b -> b.ctype = Split_1 || b.ctype = Split_Pad_1) data
  in
  gen_plot_op ~prefix:"padding-Split-01" Increment splits_1;
  gen_plot_op ~prefix:"padding-Split-01" Get splits_1;

  let splits_2 =
    List.filter (fun b -> b.ctype = Split_2 || b.ctype = Split_Pad_2) data
  in
  gen_plot_op ~prefix:"padding-Split-02" Increment splits_2;
  gen_plot_op ~prefix:"padding-Split-02" Get splits_2;

  let splits_12 =
    List.filter (fun b -> b.ctype = Split_12 || b.ctype = Split_Pad_12) data
  in
  gen_plot_op ~prefix:"padding-Split-12" Increment splits_12;
  gen_plot_op ~prefix:"padding-Split-12" Get splits_12;

  let splits_Alot =
    List.filter (fun b -> b.ctype = Split_Alot || b.ctype = Split_Pad_Alot) data
  in
  gen_plot_op ~prefix:"padding-Split-Alot" Increment splits_Alot;
  gen_plot_op ~prefix:"padding-Split-Alot" Get splits_Alot
