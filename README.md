
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

+ main.tex
  + toplevel file for the main paper, only containing the preamble.
+ body.tex
  + the text inside `\begin{document}`--`\end{document}` for `main.tex`.
+ supplemental.tex
  + toplevel text file for the supplementary material. Unlike the main paper,
    the text should be in this file too.
+ common-header.sty
  + Part of the preamble shared by `main.tex` and `supplemental.tex`
+ commands-general.sty
  + general custom commands
+ commands-abbrev.sty
  + custom commands (only for the abbreviation)

# Usage notes

* It encourages the use of [Inkskape](https://inkscape.org/) to prepare svg
  images in `img` subdirectory, which are automatically compiled into pdf
  figures. (This is a recommended way, since pngs are bitmaps and doesnt print
  nicely.)
  
  On OSX, inkscape is available from `brew install inkscape`

* One thing that bugs me every time my paper is accepted to these conferences is
  how to prepare the **camera-ready submission** archive, which does not allow
  the use of `\\input{}` command. This repo also has a complete automated script
  for doing this, via `make submission`. There are a few things that should be
  kept in mind while using this:
  * all `\input{}` commands must be at the beginning of line, nothing before or
    after it. Otherwise it may remove some necessary text

* `make auto` watches the source files and builds the pdf when they are
  updated. Requirements: `inotify-tools` package (it uses `inotifywait` for
  watching files and also sends messages via inotify notification popup window)

* It also checks for the paper length limit and overful/underful hboxes, very useful in the last-limit optimization for overlength papers.

* This template also supports JSAI, a local Japanese non-refereed confernece.

