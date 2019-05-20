open Unix;;


let pdf = ref ""
let name = ref ""
let test = ref false
let uncomp = ref false
let print = ref false
let directory = ref ""
let jsondir = ref ""


(** 
    @edited:  22-FEB-2012
    @author:  Josef Baker
    @input:   input PDF file and directory in which to decompress it, if compressed
    @effects: creates specified directory, and copies (uncompressed) PDF there
    @output:  name of directory created or jsondir if that is specified by user
 *)
let prepFile file directory=
  name :=  Filename.basename file;
  name :=  Filename.chop_extension (!name);
  if (!jsondir) ="" then (
    system ("mkdir "^directory); 
    let dir = directory in
      if (!uncomp = false)then( 
	system ("pdftk "^(!pdf)^" output "^dir^"/"^(!name)^".pdf uncompress"))
      else(
	system ("cp "^(!pdf)^" "^dir^"/"));
      (dir^"/")
  )
  else (!jsondir)
;;


(** 
    @edited:  06-MAR-2011
    @author:  Josef Baker
    @input:   an integer
    @effects: 
    @output:  string representation of integer , 3 digits long
 *)
let stringInt i =
  if i < 10 then ("00"^(string_of_int i))
  else if i < 100 then ("0"^(string_of_int i))
  else (string_of_int i)


(** 
    @edited:  22-FEB-2012
    @author:  Josef Baker
    @input:  name of "directory" under which to create "count" subdirectories
    @effects: use ccl to generate json from tif of every page and move to 
        <directory>/000-<filename>.json, 
        <directory>/001-<filename>.json, 
        <directory>/002-<filename>.json ... 
    @output:  
 *)
let rec makeJson dir count =
  if count < 0 then ()
  else (let subdir = (dir^(stringInt count)) in
	  system ("./ccl "^dir^(!name)^".tif "^(string_of_int count));
	  system ("mkdir "^subdir);
	  system ("mv "^dir^"*.json "^subdir);
	makeJson dir (count-1))
;;

(** 
    @edited:  06-MAR-2011
    @author:  Josef Baker
    @input:   list of lines, list of pdf chars, empty list
    @effects: 
    @output:  a list of lines of matched glyphs and pdf chars
 *)
let rec matchLines lines chars matchedLines =
  match lines with
     h::t -> (let matched = Matcher.makeSymbols h chars in
		if matched = [] then matchLines t chars matchedLines
		else  matchLines t (Matcher.removeDupChars chars matched [])
		   ((Matcher.convert matched [])::matchedLines))
    | _ -> (List.rev matchedLines)
;;


(** 
    @edited:  06-MAR-2011
    @author:  Josef Baker
    @input:   json clip, matched chars,  pdf file name, page number, directory
    to be saved in
    @effects: creates jsonf file
    @output:  none
 *)
let rec saveClips clip matched count dir=
  match matched with
      h::t -> ( 
SaveCharClip.saveNewFClip clip h (!name) (dir^(stringInt count)^".jsonf");
		saveClips clip t (count+1) dir;)
    | _ -> ()
;;

let rec extractPages dir count pageList elementList=
  match pageList,elementList with
    pageHd::pageTl,[]::elemTl -> (extractPages dir (count+1) pageTl elemTl)
  | pageHd::pageTl,elemHd::elemTl -> (
             (* open the json created by ccl *)
	     let jsondir = (dir^(stringInt count)^"/"^(!name)^"-"^(string_of_int count)^".json") in
	     let clip = LoadClip.getClip jsondir in
	     let aligned = Align.alignElems clip pageHd elemHd in
	     let glyphs = Align.convertGlyphs clip.LoadClip.glyphs [] in
	     let lines = LineFinder.findLines glyphs in
	     let matched = matchLines lines aligned [] in
 	       saveClips clip matched 0 (dir^(stringInt count)^"/");
	       extractPages dir (count+1) pageTl elemTl 
	   )
  | _,_ -> () 
;;

let extractFile inFile inDirectory=
  
  let dir = ref "" in
  let file = ref "" in
    
  try(
      dir := prepFile inFile inDirectory;
      file := (!dir)^(!name)^".pdf";
    
      let inCh = open_in_bin (!file) in
	let pageTree = Pdfextractor.getPageTree inCh !test in
	  let pageList = Pdfextractor.extractPDF inCh pageTree [] in
	    close_in inCh;
	    let elements = Contentparser.parse pageList [] !print in
	      
	      (* run pdf2tiff followed by ccl to get json from pdf's image *)
	      if (!jsondir) = "" then(	    
		system ("./pdf2tiff "^(!file));
		makeJson !dir ((List.length pageTree)-1););
	  
	  (* compare the json's *)
	  extractPages !dir 0 (List.rev pageList) elements;
	  
	  ();
    )
    with error -> (print_string (Printexc.to_string error); ();)
;;


let usage = "usage: " ^ Sys.argv.(0) ^ " [-f file] [-t] [-u] [-p] [-d dir] [-j dir]" in
let speclist = [
  ("-d", Arg.Set_string directory, ": -d Name of directory");
  ("-f", Arg.Set_string pdf, ": -f Name of PDF file");
  ("-u", Arg.Set uncomp, ": -u If file is uncompressed");
  ("-t", Arg.Set test, ": -t Set verbose mode on");
  ("-p", Arg.Set print, ": -p Print output to sdout");
  ("-j", Arg.Set_string jsondir, ": -j Name of json directory");
]
in
  (* Read the arguments *)
  Arg.parse
    speclist
    (fun x -> raise (Arg.Bad ("Bad argument : " ^ x)))
    usage;
  ignore(extractFile (!pdf) (!directory))
