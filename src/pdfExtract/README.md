# PDF Extractor Source Files


## Description

A command line tool that reads a pdf, transforms it into a tiff and returns
jsonf files, each one contains characters of a page line. The Tool is written
in Ocaml and uses the Libtiff library and the PDF toolkit.


# Requirements
  
- Libtiff can be obtained from http://www.linuxfromscratch.org/blfs/view/svn/general/libtiff.html

Under a Debian distribution install using

      apt-get install libtiff5


- pdftk can be obtained from http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/

Under a Debian distribution install using

      apt-get install pdftk


- Make sure pdf2tiff is executable.

- json-wheel and its dependencies including netstring that comes from package ocamlnet. json-wheel must be downloaded and installed manually. If it fails looking for netstring install ocamlnet using opam install ocamlnet.

# Build

Make the executable by running

    make all

or

    make opt


# Running

Make sure the files extractElements(.opt), ccl, pdf2tiff are in the same directory.
Then run

    ./extractElements -f input.pdf -d output_directory


For example the following produces the json files in samples/json/gpu:

    ./extractElements.opt -f ../../samples/pdf/gpu.pdf -d ../../samples/json/gpu

