
# aaai-template

[![Build Status](https://travis-ci.org/guicho271828/aaai-template.svg?branch=master)](https://travis-ci.org/guicho271828/aaai-template)

For the frequent attendants of top-tier AI conferences!

This repository includes templates and makefiles for:

+ AAAI style
+ ECAI style
+ IJCAI style
+ JAIR style
+ NIPS style
+ ICML style
+ ICLR style
+ CVPR style

Requirements: GNU Make, TexLive, inkscape, perl (see dependency.sh)

**Update:** AAAI Press recently made a significant change to the camera-ready requirements
(such as https://www.aaai.org/Publications/Author/icaps-submit.php).
To address the requirement we changed the file structure --- see below.

# File structure

+ `main.tex`
  + toplevel file for the main paper, only containing the preamble.
+ `body.tex`
  + the text inside `\begin{document}`--`\end{document}` for `main.tex`.
+ `supplemental.tex`
  + toplevel text file for the supplementary material. Unlike the main paper,
    the text should be in this file too.
  + `supplemental.tex` and `main.tex` can cross-reference the figures, tables and sections each other.
+ `common-header.sty`
  + Part of the preamble shared by `main.tex` and `supplemental.tex`.
  + This file also contains the specific code for each conference.
    You should uncomment the code for the conference you plan to submit
+ `commands-general.sty`
  + general custom commands
+ `commands-abbrev.sty`
  + custom commands (only for the abbreviation)

# Usage notes

* It encourages the use of [Inkskape](https://inkscape.org/) to prepare svg
  images in `img` subdirectory, which are automatically compiled into pdf
  figures. (This is a recommended way, since pngs are bitmaps and doesnt print
  nicely.)
  
  On OSX, inkscape is available from `brew install inkscape`

* `make submission` and `make archive` :
  These `make` targets will create a `submission` directory and prepares the camera-ready
  tex files. There are sometimes extensive instruction for preparing the camera-ready submission,
  such as https://www.aaai.org/Publications/Author/icaps-submit.php .
  
  * These camera-ready submissions do not allow the use of `\input{}` command.
    When you run `make submission`, the results generated in the directory will have
    * a single, flattened tex file whose `\input` commands are inlined completely
    * All image files referenced by the text are renamed and put in this root directory
      (AAAI Press does not allow putting images in the nested subdirectories)
    * Garbage files and style files are removed (they are not allowed)
  * **Usage note**: all `\input{}` commands must be at the beginning of line, nothing before or
    after it. Otherwise it may remove some necessary text
  * `make archive` compresses the `submission/` directory and create a zip or a tar.gz file.
    AAAI Press receive the zip file only, but this feature is also useful when submitting to Arxiv.

* `make auto` watches the source files and builds the pdf when they are
  updated. Requirements: `inotify-tools` package (it uses `inotifywait` for
  watching files and also sends messages via inotify notification popup window)

* It also checks for the paper length limit and overful/underful hboxes, very useful in the last-limit optimization for overlength papers.

* This template also supports JSAI, a local Japanese non-refereed confernece.

