open Jsonfio;;
open Preprocessor;;
open Linearize;;

let indir = ref "" 
let infile = ref ""  
let extension = ref "lin" 
let bbox = ref true
let sdout = ref false
let rest = ref false

let pages = ref 0
let lines = ref 0

  
let rec fileInt count = Printf.sprintf "%03d.jsonf" count

let rec dirInt count =  Printf.sprintf "%03d/" count

let linearizeFile file =

    let symbols = JsonfIO.getSymbols file in
    let synts =  Preprocessor.preprocess symbols  in


    let outBB = ((String.sub file 0 ((String.length file)-5))^"bb") in
    let outBBCh = open_out outBB in
    let outStr = ((Linearize.lineariseLine synts outBBCh)^"\n") in
      close_out outBBCh;
 

    let outFile = ((String.sub file 0 ((String.length file)-5))^(!extension)) in
    let outCh = open_out outFile in
      output_string outCh outStr;
      close_out outCh;
      if (!sdout) then(  
	print_newline ();
	print_string outStr;
	print_newline ();)
    
;;


let usage = "usage: " ^ Sys.argv.(0) ^ " [-d string] [-e string] [-f string]
[-b] [-s]"
  
let speclist = [
    ("-f", Arg.Set_string infile,    ": Name of the input file (obsolete)!");
    ("-e", Arg.Set_string extension, ": Output file extension. Default is "^(!extension)^".");
    ("-b", Arg.Clear bbox,           ": Sets BBox file off");
    ("-s", Arg.Set sdout,            ": Outputs linearised file to stdout");
]
  
let linearizer () =
  Arg.parse
    speclist
    (* (fun x -> raise (Arg.Bad ("Bad argument : " ^ x))) *)
    (fun f -> rest := true; 
       linearizeFile f 
)
    usage;
  
  match !infile with
    | "" when !rest -> exit 0
    | ""        -> print_string "input file must be specified\n"; exit(0)
    | file      -> linearizeFile file
    | _         -> print_string "Specify an input file only\n"; exit(0)
let _ = linearizer ()
;;  
