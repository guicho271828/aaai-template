
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
+ NAACL style
+ CVPR style
+ JSAI, a local Japanese non-refereed conference.

Requirements: GNU Make, TexLive, inkscape, perl (see dependency.sh)

**Update:** AAAI Press recently made a significant change to the camera-ready requirements
(such as https://www.aaai.org/Publications/Author/icaps-submit.php).
To address the requirement we changed the file structure --- see below.

# File structure

* `<name>.tex`
  * Toplevel file for the main paper, which immediately calls `\input{main.tex}`.
    This is to satisfy the requirement from AAAI, where
    the submitted tex file must follow a certain naming convention such as `PLT-AsaiM.37`.
    `<name>` defaults to `default`, and can be modified from the `Makefile`.
    The file is autogenerated.
  * → `main.tex`
    * The true toplevel file for the main paper containing the preamble.
    * → `body.tex`
      * The text inside `\begin{document}`--`\end{document}` for `main.tex`.
        This is the file you will spend most of the time editing.
    * → `common-header.sty`
      * Part of the preamble shared by `main.tex` and `supplemental.tex`.
      * This file also contains the specific code for each conference.
        You should uncomment the code for the conference you plan to submit
      * → `common-general.sty`
        * general custom commands
      * → `common-abbrev.sty`
        * custom commands (only for the abbreviation)
* `supplemental.tex`
  * Toplevel file for the supplementary material. Unlike the main paper, there is no separation of preamble.
  * `supplemental.tex` and `main.tex` can cross-reference the figures, tables and sections each other.

# Usage notes

This repository is mainly targeted to core Linux users.
It partially works on OSX, but some features are not available.
Also, due to incompatibility in BSD, some commands e.g. `find` may fail.

* `make` will build the paper.

* `make auto` watches the source files and builds the pdf when they are
  updated. Poor-man's (or wise-man's) Overleaf.
  * Requirements: `inotify-tools` package (available from `apt`, `yum`).
    It uses `inotifywait` for watching files and also sends messages via inotify notification popup window.
  * Only available on Linux.

* We encourage the use of [Inkskape](https://inkscape.org/) to prepare svg
  images in `img` subdirectory, which are automatically compiled into pdf figures.
  Compilation into pdf is highly recommended because
  bitmap formats like png have the risk of resulting in blurry images.
  They also increase the file size significantly compared to the vector data in pdf-based figures.
  
  On OSX, inkscape is available from `brew install inkscape`

* `make submission`, `make archive`, `make arxiv` :
  These `make` targets will create a `submission` directory and prepares the camera-ready
  tex files. There are sometimes extensive instruction for preparing the camera-ready submission,
  such as https://www.aaai.org/Publications/Author/icaps-submit.php .
  
  * These camera-ready submissions do not allow the use of `\input{}` command.
    When you run `make submission`, the results generated in the `submission` directory will have
    * a single, flattened tex file whose `\input` commands are inlined completely
    * All image files referenced by the text are renamed and put in this root directory
      (AAAI Press does not allow putting images in the nested subdirectories)
    * Garbage files (log files etc.) are removed.
  * **Usage note**: all `\input{}` commands must be at the beginning of line, nothing before or
    after it. Otherwise it may remove some necessary text
  * `make archive` compresses the `submission/` directory
    and create a zip file and a tar.gz file containing the same contents.
    AAAI Press receive the zip file only.
    Additional style files are removed because they are not allowed.
  * `make arxiv` is same as `make archive`, but it does not remove the style files.
    This feature is therefore useful when submitting the paper to Arxiv.

* It also checks for the paper length limit and overful/underful hboxes,
  which may be useful in the last-limit optimization for overlength papers.
  * Requirements: `pdftk`.

# If you have enough space in your paper, please cite me

``` bibtex
@article{aaai-template,
    author = {Asai, Masataro},
    title = {{This paper was written using AAAI Template \url{github.com/guicho271828/aaai-template}}},
    year = {2019}
}
```
