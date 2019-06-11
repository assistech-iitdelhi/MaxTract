# MaxTract

Old implementation of the MaxTract system for re-engineering mathematical PDF
documents.

## Directory Structure

- src:  Source files.
    * ccl-tiff: Connected component labelling for TIFF files
    * pdfExtract: PDF extraction
    * linearize: Linearization grammar
    * drivers: Output drivers (not yet uploaded)
    * main: Maxtract main file to pull it all together (not yet uploaded)

- samples: Some sample files.
    * pdf: Sample PDF documents.
    * tif: Sample Tiff files for testing ccl-tiff. Some are multipage tiffs.
    * json: Sample json output files.

## Installation
- Subdirectories of src contain sources for submodules and contain Makefiles that compile the code. They also have README files with additional details.
- Descend into each subdirectory and run 'make' after installing the pre-requisites noted below:-
    * ccl-tiff has a dependency on libtiff for tiff image processing. Install libtiff5-dev using 'apt-get install libtiff5-dev'
    * pdfExtract has a dependency on json-wheel for processing json files and on pdftk for decompressing pdf files. Install pdftk using 'apt-get install pdftk'. Install json-wheel from the tar file in this directory. In case of errors run 'opam install netstring'. opam is package manager for ocmal i.e. the equivalent of pip for python.
    * linearize module has no additional pre-requisites
