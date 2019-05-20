open Pdfextractor;;
open Contentparser;;
open LoadClip;;

(**
    @edited:  02-JUN-2010
    @author:  Josef Baker
    @input:   x and y ratio of pdf file to clip image height of pdf file and list of pdf elements
    @effects: scales the pdf coordinates to match those of the clip
    @output:  list of pdf elements scaled andin correct coordinate system
 *)
let rec alignChars xRatio yRatio pHeight inList outList =
        match inList with
        h::t ->(
                match h with
                Ln ln -> alignChars xRatio yRatio pHeight t (
                        Ln {
                                Contentparser.stx=(ln.Contentparser.stx /. xRatio);
                                Contentparser.sty=((pHeight -. ln.Contentparser.sty) /.yRatio);
                                Contentparser.enx=(ln.Contentparser.enx /. xRatio);
                                Contentparser.eny=((pHeight -. ln.Contentparser.eny) /.yRatio);
                                Contentparser.lnw=((ln.Contentparser.lnw) /. xRatio);
                        }::outList)
                | Chr chr -> alignChars xRatio yRatio pHeight t (
                        Chr {
                                Contentparser.chname = chr.Contentparser.chname;
                                Contentparser.chfont = chr.Contentparser.chfont;
                                Contentparser.chsize = chr.Contentparser.chsize;
                                Contentparser.chx=(chr.Contentparser.chx /. xRatio);
                                Contentparser.chy=((pHeight -. chr.Contentparser.chy) /.yRatio);
                                Contentparser.chw=((chr.Contentparser.chw)/. xRatio);
                        }::outList)
	        )
    |	[] -> outList
;;


(**
    @edited:  08-MAR-2009
    @author:  Josef Baker
    @input:   List of Loadclip glyphs
    @effects:
    @output:  List of jsonf glyphs
 *)
let rec convertGlyphs inList outList =
  match inList with
      h::t -> convertGlyphs t ({Jsonfio.JsonfIO.x = (h.LoadClip.x*2);
				Jsonfio.JsonfIO.y = (h.LoadClip.y*2);
				Jsonfio.JsonfIO.w = (h.LoadClip.w*2);
				Jsonfio.JsonfIO.h = (h.LoadClip.h*2);}::outList)
    | _ -> outList
;;


(**
    @edited:  08-MAY-2012
    @author:  Josef Baker
    @input:
    @effects:
    @output:
 *)
let alignElems clip page elems =
        let mediaBox   = page.Pdfextractor.dimensions in
        let pageWidth  = clip.LoadClip.pageWidth*2 in
        let pageHeight = clip.LoadClip.pageHeight*2 in
        let xRatio = (mediaBox.mwidth)/.(float_of_int pageWidth) in
        let yRatio = (mediaBox.mheight)/.(float_of_int pageHeight) in

        alignChars xRatio yRatio mediaBox.mheight elems []
;;
