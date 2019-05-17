open Unix;;


let pdf = ref ""
let test = ref false
let uncomp = ref false


(** 
    @edited:  22-FEB-2012
    @author:  Josef Baker
    @input:   input PDF file
    @effects: creates random temp directory in /tmp with uncompressed PDF
    @output:  dir name of new file
 *)
let uncompress file =
    Random.self_init ();
    let dir = ("/tmp/"^(string_of_int (Random.int 10000))) in
      system ("mkdir "^dir);
      system ("pdftk "^file^" output "^dir^"/uncompressed.pdf uncompress");
      (dir^"/")
;;


let extractFile inFile=
  let dir = ref "" in
  let file = ref "" in
  let fail = ref false in    

    try(
      if (!uncomp = false)then( 
	dir := uncompress inFile;
	file := (!dir)^"uncompressed.pdf";
      )
      else(
	file := inFile;
      );
      let inCh = open_in_bin (!file) in
	
      let pageTree = List.tl (Pdfextractor.getPageTree inCh !test) in
	if  (List.length pageTree)<1 then (
	  fail := true;
	)
	else(	 
	  let pageList = Pdfextractor.extractPDF inCh pageTree [] in
	    if (List.length pageList) < 1 then ( 
	      fail := true;
	    )
	    else(
	      let symbols = Contentparser.parse pageList [] in
		fail :=false;
	    )
	);
	if (!uncomp = false)then (
	  system ("rm -fR "^(!dir));
	  if (!fail = true) then 0 else 2
	)
	else(
	  if (!fail = true) then 0 else 2
	)
	
    )
    with error -> (
      if (!uncomp = false)then (
	system ("rm -fR "^(!dir));
	0
      )
      else
	0
    )  
;;

let main inFile =
pdf:= inFile;
extractFile (!pdf);
;;
