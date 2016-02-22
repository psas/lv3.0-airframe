%%
%% This is file `aiaa.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% aiaa.dtx  (with options: `class')
%% 
%% The "aiaa" distribution by bil kleb <w.l.kleb@larc.nasa.gov>.
%% Please see the file `aiaa.ins' for information on how you may
%% (re-)distribute the `aiaa' bundle of files.
%% 
%% Description: a bundle of LaTeX and BibTeX files to produce
%%              AIAA papers and simulated journal articles/notes
%% Keywords: LaTeX, class, AIAA, BibTeX, bibliographic-style, 9pt-option
%% Author: Bil Kleb <w.l.kleb@larc.nasa.gov>
%% Maintainer: same
%% Version: 2.4 <22 feb 1999>
%%
%% Please see the information in file `aiaa.ins' on how you
%% may use and (re-)distribute this file.  Run LaTeX on the file
%% `aiaa.ins' to get the main aiaa class and other auxilary packages.
%% Also run LaTeX on `aiaa.dtx' (this file) to obtain a users manual
%% and code documentation.
%%
%% NOTE: This file may NOT be distributed if not accompanied
%%       by 'aiaa.ins' and `aiaalgo.eps'.
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{aiaa}[1999/02/22 v2.4 AIAA document class]
\newif\if@submit
\newif\if@paper
\newif\if@article
\newif\if@note
\newif\if@cover
\@submitfalse
\@papertrue
\@articlefalse
\@notefalse
\@coverfalse
\DeclareOption{note}{\@notetrue\@articlefalse\@submitfalse\@paperfalse}
\DeclareOption{article}{\@articletrue\@notefalse\@paperfalse\@submitfalse}
\DeclareOption{paper}{\@papertrue\@articlefalse\@notefalse\@submitfalse}
\DeclareOption{submit}{\@submittrue\@paperfalse\@articlefalse}
\DeclareOption{cover}{\@covertrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}%
                \typeout{NOTE: Passing ``\CurrentOption" option on to the
                         standard LaTeX article class}}
\ProcessOptions
\typeout{}
\if@submit%
  \typeout{NOTE: aiaa journal submission mode
          - all other aiaa options ignored}
\else% paper, article, or note
  \if@paper%
    \typeout{TYPESETTING in AIAA conference PAPER format ...}
  \else% article or note
    \if@article%
      \typeout{TYPESETTING in AIAA journal ARTICLE simulation format ...}
    \else% note
      \typeout{TYPESETTING in AIAA journal NOTE simulation ...}
    \fi
  \fi
\fi
\typeout{}
\if@submit%
  \LoadClass[12pt]{article}%
  \RequirePackage[noheads,tablesfirst,nomarkers]{endfloat}%
  \RequirePackage{setspace}%
  \RequirePackage{lastpage}%
\else% paper, article or note
  \LoadClass[twoside,twocolumn]{article}%
  \RequirePackage[dvips]{dropping}% dvips set to make compatible with pdflatex
  \RequirePackage{lastpage}%
  \if@paper%
    \relax%
  \else% article or note
    \RequirePackage{aiaa9pt}%
  \fi%
\fi
\RequirePackage{graphicx}
\RequirePackage{overcite}
\RequirePackage{caption2}
\RequirePackage{fancyhdr}
\RequirePackage{subfigure}[1995/03/06]
\if@submit
  \setlength{\topmargin}{-0.25in}
  \setlength{\headsep}{9.5pt}
  \setlength{\textheight}{9in}
  \setlength{\textwidth}{6.5in}
  \setlength{\oddsidemargin}{0.0in}
  \AtBeginDocument{\onehalfspacing}% turn on `doublespacing'
\else% paper, article, or note
  \setlength{\topmargin}{-0.75in}
  \if@paper
    \setlength{\headsep}{9.5pt}
    \setlength{\textheight}{9.5in}
    \setlength{\textwidth}{6.75in}
    \setlength{\columnsep}{0.25in}
    \setlength{\footskip}{0.25in}
  \else% article or note
    \setlength{\topmargin}{-0.75in}
    \setlength{\headsep}{10pt}
    \setlength{\footskip}{16pt}
    \setlength{\textheight}{10in}
    \setlength{\textwidth}{7in}
    \setlength{\columnsep}{0.375in}
    \setlength{\oddsidemargin}{-0.25in}
    \renewcommand{\baselinestretch}{0.9}
  \fi
  \setlength{\evensidemargin}{\oddsidemargin}
\fi
\newcommand*{\SubmitName}[1]%
            {\def\AA@submitname{#1}}
\newcommand*{\PaperNumber}[1]%
            {\def\AA@papernumber{#1}}
\newcommand*{\ArticleHeader}[1]%
            {\def\AA@articleheader{#1}}
\newcommand*{\ArticleIssue}[1]%
            {\def\AA@articleissue{#1}}
\newcommand*{\JournalName}[1]%
            {\def\AA@journalname{#1}}
\newcommand*{\JournalIssue}[1]%
            {\def\AA@journalissue{#1}}
\newcounter{AA@journalpage}
\newcommand*{\JournalPage}[1]%
            {\setcounter{AA@journalpage}{#1}}
\newcommand*{\NoteHeader}[1]%
            {\def\AA@noteheader{#1}}
\SubmitName{}
\PaperNumber{}
\ArticleHeader{}
\ArticleIssue{}
\JournalName{}
\JournalIssue{}
\NoteHeader{}
\setcounter{AA@journalpage}{1}
\pagestyle{fancy}% note: must be issued after any \textwidth command
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyhf{} % clear all footers and headers
\if@submit
  \rfoot{\footnotesize\scshape\thepage\ of \pageref{LastPage}}
  \lfoot{\footnotesize\scshape\AA@submitname}
\else% paper, article, or note
  \if@paper
    \cfoot{\footnotesize\scshape\thepage\ of \pageref{LastPage}
           \ifx\AA@papernumber\@empty\relax\else\\
           \rule[.2\baselineskip]{0.5in}{0.2pt}\\
           American Institute of Aeronautics
           and Astronautics Paper \AA@papernumber\fi}
  \else% article or note
    \if@article
      \chead{\footnotesize\scshape\MakeUppercase{\AA@articleheader}}
      \fancyhead[RO,LE]{\footnotesize\thepage}
      \fancypagestyle{plain}{%
        \fancyhf{}
        \lhead{\ifx\AA@journalname\@empty\relax\else
               \footnotesize{\scshape\AA@journalname}\\
               \AA@articleissue\fi}
        \cfoot{\footnotesize\thepage}}
    \else% note
      \chead[\footnotesize\scshape\AA@noteheader]%
            {\footnotesize\scshape\AA@noteheader}
      \rhead[]{\footnotesize \thepage}
      \lhead[\footnotesize \thepage]{}
    \fi
  \fi
\fi
\renewcommand{\abstract}[1]%
             {\def\@abstract{#1}}
\abstract{}
\let\@date\@empty
\if@submit%
  \def\dropword{}
\else
  \def\dropword#1#2 {\dropping{2}{\bfseries{} #1}\MakeUppercase{#2} }% spaces important!
\fi
\doublehyphendemerits=100000
\setlength\hfuzz{3pt}% reduce the quantity of overfull warnings
\newcommand{\Conference}[1]{\def\AA@conference{#1}}
\Conference{}
\newcommand{\CoverFigure}[1]{\def\AA@coverfigure{#1}}
\CoverFigure{}
\if@submit%
  \newcommand{\makecover}{}
\else% paper, article, or note
  \newcommand{\makecover}{%
  \begin{titlepage}
  \let\AA@sfdefault\sfdefault% save normal fonts
  \let\AA@rmdefault\rmdefault
  \let\AA@ttdefault\ttdefault
  \renewcommand{\sfdefault}{phv}% change to new fonts
  \renewcommand{\rmdefault}{ptm}
  \renewcommand{\ttdefault}{pcr}
  \enlargethispage{1in}
  \setcounter{page}{0}
  \renewcommand\thanks[1]{}% locally kill the \thanks{} command
  \renewcommand\thanksibid[1]{}% kill the ibid version too
  \setlength{\unitlength}{1in}% unit of measure for the picture
  \begin{picture}(7.5,9)(0.45,0.495)%  start a 7-1/2'' x 9'' picture:
  \if@paper%
    \linethickness{4pt}
    \put(0,0){\framebox(7.45,8.95){}}% make a framed box accounting
                                     % for line thickness
    \linethickness{0.5pt}
    \renewcommand{\and}{\relax}
    \put(-0.07,8.7){\incfig[width=3in]{aiaalgo}}% aiaa logo at top left
    \put(1.2,8.0)% paper number, title, author/location
        {\makebox(0,0)[tl]{\parbox{5in}
            {\raggedright\sffamily\bfseries
          \Huge AIAA \AA@papernumber% paper number
          \\[5pt]
          \huge\@title%                title
          \\[5pt]
          \Large\mdseries\@author}}}%   author/location
    \ifx\AA@coverfigure\@empty% optional figure
      \relax
    \else
      \put(3.725,1.7){\makebox(0,0)[b]{%
          \includegraphics[width=5in,height=4in]%
          {\AA@coverfigure}}}%
    \fi
    \put(3.725,0.05){\makebox(0,0)[b]{\parbox{7.45in}%  meeting, location, and date
        {\centering\Huge\bfseries\sffamily%
        \AA@conference}}}
    \put(-0.055,-0.36){\parbox[t]{7.5in}% notice
      {\normalsize\sffamily\bfseries
      For permission to copy or republish, contact the
      American Institute of Aeronautics and Astronautics\\
      1801 Alexander Bell Drive, Suite 500, Reston, VA 20191--4344}}
  \else% article, or note
    \put(0.7,7.75)% title and authors
        {\makebox(0,0)[tl]{\parbox{6.5in}
         {\raggedright\sffamily\bfseries
          \huge\@title%
          \\[5pt]
          \Large\mdseries\@author}}}
    \ifx\AA@journalname\@empty\relax\else
      \put(0.7,1.9){\makebox(0,0)[tl]{\parbox{7.5in}%  journal/issue
        {\raggedright\bfseries\sffamily
         Simulated Reprint for\\
        \Huge%
        \AA@journalname\\
        \small\mdseries
\ifx\AA@journalissue\@empty%
           \relax
        \else%
           \AA@journalissue,
        \fi
        Pages \theAA@journalpage--\pageref{LastPage}}}}\fi
    \put(0.5,0.45){\incfig[width=1in]{aiaalgo}}% aiaa logo at bottom left
    \put(0.7,0.3)% notice
        {\makebox(0,0)[tl]{\parbox{6.5in}
         {\sffamily
          \slshape A publication of the\\
          \upshape American Institute of Aeronautics and Astronautics, Inc.\\
         1801 Alexander Bell Drive, Suite 500\\
         Reston, VA 20191--4344}}}
  \fi
  \end{picture}
  \renewcommand\sfdefault{\AA@sfdefault}
  \renewcommand\rmdefault{\AA@rmdefault}
  \renewcommand\ttdefault{\AA@ttdefault}
  \end{titlepage}}
\fi
\newcommand{\PaperNotice}[1]{\def\AA@papernotice{\scriptsize #1}}
\PaperNotice{}
\newcommand{\JournalNotice}[1]{\def\AA@journalnotice{\scriptsize #1}}
\JournalNotice{}
\if@submit%
  \newcommand\makenotice{}%
\else% paper, article, or note
  \newcommand\makenotice{%
    \begingroup
    \renewcommand\thefootnote{}
      \if@paper%
        \ifx\AA@papernotice\@empty\else\footnotetext{\AA@papernotice}\fi
      \else% article or note
        \ifx\AA@journalnotice\@empty\else\footnotetext{\AA@journalnotice}\fi
      \fi%
    \endgroup
  }
\fi
\newcommand{\CopyrightA}[1]{Copyright \copyright\ #1 by the
  American Institute of Aeronautics and Astronautics, Inc. All
  rights reserved.}
\newcommand{\CopyrightB}[2]{Copyright \copyright\ #1 by
  #2. Published by the American Institute of Aeronautics
  and Astronautics, Inc.\ with permission.}
\newcommand{\CopyrightC}{This paper is a work of the U.S.
  Government and is not subject to copyright protection in the
  United States.}
\newcommand{\CopyrightD}[1]{Copyright \copyright\ #1 by the
  American Institute of Aeronautics and Astronautics, Inc. No
  copyright is asserted in the United States under Title 17,
  U.S. Code.  The U.S. Government has a royalty-free license to
  exercise all rights under the copyright claimed herein for
  Governmental Purposes.  All other rights are reserved by the
  copyright owner.}
\if@submit
  \renewcommand\figurename{Figure}
  \renewcommand\captionlabeldelim{:\hspace{1em}}
\else% paper, article, or note
  \renewcommand\figurename{Fig.}% change to the ugly, silly
                                % abbreviatation as per aiaa---saves
                                % all of two characters !?
  \renewcommand\captionlabeldelim{~~}
\fi
\renewcommand\captionfont{\small\bfseries}
\renewcommand\p@subfigure{\thefigure(}
\renewcommand\thesubfigure{\alph{subfigure})}
\renewcommand\subcaplabelfont{\captionfont}
\renewcommand{\subfigcapmargin}{2pt}
\if@submit
  \relax
\else
  \setlength{\abovecaptionskip}{ 6pt plus 2pt minus 2pt}
  \setlength{\belowcaptionskip}{ 3pt plus 1pt minus 1pt}% note good for tables!
  \renewcommand{\subfigcapskip}{.2\abovecaptionskip}%    seem to
  \renewcommand{\subfigbottomskip}{.7\belowcaptionskip}% have no effect?
\fi
\if@submit% modify endfloat behaviour
  \InputIfFileExists{aiaaenf.cfg}{\typeout{loading aiaaenf.cfg}}%
                    {\typeout{WARNING: endfloat behavior will not
                              be as advertised since aiaaenf.cfg
                                                   was not found.}}
\else% modify float spacing
  \renewcommand{\topfraction}{0.9}
  \renewcommand{\bottomfraction}{0.9}
  \renewcommand{\textfraction}{0.1}
  \renewcommand{\floatpagefraction}{0.8}% 0.5 is the default
  \renewcommand{\dbltopfraction}{\floatpagefraction}
  \renewcommand{\dblfloatpagefraction}{\floatpagefraction}
  \setcounter{topnumber}{10}
  \setcounter{dbltopnumber}{\value{topnumber}}
  \setcounter{bottomnumber}{\value{topnumber}}
  \setcounter{totalnumber}{\value{topnumber}}
  \addtocounter{totalnumber}{\value{bottomnumber}}
  \setlength{\floatsep}        { 5pt plus 2pt minus 2pt}
  \setlength{\textfloatsep}    { 5pt plus 2pt minus 3pt}
  \setlength{\intextsep}       { 5pt plus 2pt minus 2pt}
  \setlength{\dblfloatsep}     {\floatsep}
  \setlength{\dbltextfloatsep} {\textfloatsep}
\fi
\renewcommand{\@biblabel}[1]{$^{#1}$}
\renewenvironment{thebibliography}[1]%
     {\section*{\refname\@mkboth{\MakeUppercase\refname}%
                                 {\MakeUppercase\refname}}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\setlength{\leftmargin}{0pt}%
            \settowidth{\labelwidth}{\@biblabel{#1}}%
            \setlength{\itemindent}{\parindent}%
            \advance\itemindent by \labelwidth%
            \setlength{\labelsep}{0.0em}%
            \setlength{\itemsep}{-\smallskipamount}%
            \@openbib@code%
            \usecounter{enumiv}%
            \let\p@enumiv\@empty%
            \renewcommand\theenumiv{\@arabic\c@enumiv}%
            \if@submit%
              \normalsize%
            \else%
              \footnotesize%
            \fi}
      \sloppy\clubpenalty4000\widowpenalty4000%
      \sfcode`\.\@m}
      {\def\@noitemerr
        {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcounter{ibid}
\newcounter{tempcnt}
\newcommand{\thanksibid}[1]{%
    \begingroup
    \setcounter{tempcnt}{\value{footnote}}%
    \setcounter{ibid}{#1}%
    \def\thefootnote{\fnsymbol{ibid}}%
    \footnotemark%
    \setcounter{footnote}{\value{tempcnt}}%
    \endgroup
}
\newcommand{\incfig}{\centering\includegraphics}
\setkeys{Gin}{width=\linewidth,keepaspectratio}
\if@submit%
   \setkeys{Gin}{totalheight=0.35\textheight}
\else% paper, article, or note
   \relax
\fi
\newlength{\sfm@width}%               Subfigure width
\newlength{\sfm@colsep}%              Subfigure column separation
\setlength{\sfm@colsep}{2\tabcolsep}% Use twice tabular column separation
\newcounter{sfm@count}%               Item count
\newenvironment{subfigmatrix}[1]{%
  \begingroup%
  \centering%
  \vspace*{-\subfigtopskip}% remove the vertical spacing inserted
                           % by the subfigure package
    %
    % Save the "real" subfigure macro and start the item counter off
    % at -1 to detect the first item.
    % Set the \sfm@width to the single element size.
    %
    \let\sfm@subfigure\subfigure%
    \setcounter{sfm@count}{-1}%
    \setlength{\sfm@width}{\linewidth}%
    \addtolength{\sfm@width}{\sfm@colsep}%
    \addtolength{\sfm@width}{-#1\sfm@colsep}%
    \divide\sfm@width by#1
    \setkeys{Gin}{width=\sfm@width,keepaspectratio}%
    %
    % Redefine the \subfigure and \subtable macros locally to this
    % environment so that we can wrap them with minipages.
    %
    \def\subfigure{% try the transpose
      \ifnum \value{sfm@count} = -1
      % very first item
        \setcounter{sfm@count}{1}%
      \else% Not very first item
        \addtocounter{sfm@count}{1}%
        \ifnum \value{sfm@count} = 1
          % Beginning of next column, finish the last column.
          \\%
        \else%
          % middle or last item
          \hfill%
          \ifnum #1 = \value{sfm@count}%
            % Reset the counter of at the end of the row.
            \setcounter{sfm@count}{0}%
          \fi%
        \fi%
      \fi%
      \sfm@subfigure}%
    \let\subtable\subfigure%
  }{%
    \\%
  \endgroup}%
\if@paper
  \renewcommand{\and}{\\[-.9\baselineskip]}
\else
  \renewcommand{\and}{\\*[-8pt]}
\fi
\renewcommand{\maketitle}{%
  \if@cover
    \makecover
  \else
    \relax
  \fi
  \par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
  \global\@topnum\z@   % Prevents figures from going at top of page.
  \if@submit%
    \@maketitle%
  \else% paper, article, or note
    \if@note%
      \@maketitle%
    \else% paper article -- should already be in twocolumn mode
      \ifnum \col@number=\@ne% if in column one, good:
         \@maketitle
      \else% not in column one, so start new page:
        \twocolumn[\@maketitle]
      \fi
      \if@article%
        \thispagestyle{plain}
      \fi
    \fi
  \fi
  \@thanks
  \endgroup
  \suppressfloats
  \setcounter{footnote}{0}%
  \if@submit% submission
    \relax
  \else% paper, article, or note:
    \if@paper
      \relax
    \else% article or note:
       \setcounter{page}{\theAA@journalpage}
    \fi
  \fi
  \makenotice
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@abstract\@empty
  \global\let\@thanks\@empty
  \global\let\thanks\relax
  \global\let\@author\@empty
  \global\let\author\relax
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\@date\@empty
  \global\let\abstract\relax
  \global\let\date\relax
}
\def\@maketitle{%
  \newpage
  \begin{center}%
  \let \footnote \thanks
    {\huge\bf \@title \par}%
    \vskip 1.5em%
    {\lineskip .5em%
      \large%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
    \vskip 1em%
    \if@submit
      \relax
    \else% paper, article, or note
      \if@note
        \relax
      \else% paper or article
        \newenvironment{AA@abstract}
        {\list{}{\listparindent 1.5em%
                \itemindent \listparindent
                \leftmargin 0.75in%
                \rightmargin \leftmargin
                \parsep \z@ \@plus \p@}%
                \item\relax}
         {\endlist}
         \ifx\@abstract\@empty
           \relax
         \else
           \begin{AA@abstract}
              \footnotesize\textbf\@abstract
           \end{AA@abstract}
         \fi
      \fi
    \fi
  \end{center}%
  \if@submit%
    \ifx\@abstract\@empty
      \relax
    \else%
      \section{Abstract} \@abstract%
    \fi
  \else% paper, article, or note
    \par%
    \if@note%
      \vskip -\medskipamount%
    \else%
      \vskip 1em%
    \fi%
  \fi%
}
\setcounter{secnumdepth}{-2}% instead of having to use the *'d
                            % section commands
\renewcommand\section{\@startsection
  {section}%                    % section name
  {1}%                          % level
  {\z@}%                        % indentation of heading
  {1.8ex}%                      % before skip (neg, no parindent)
  {0.5ex}%                      % after skip (neg, run-on heading space)
  {\normalfont\center\large\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}%
  {\z@}%
  {1.5ex}%
  {0.5ex}%
  {\normalfont\small\bfseries\raggedright}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}%
  {\z@}%
  {1.5ex}%
  {0.5ex}%
  {\normalfont\normalsize\itshape\raggedright}}
\renewcommand\paragraph{\@startsection{paragraph}{4}%
  {\parindent}%
  {0.3ex}%
  {-1em}%
  {\normalfont\normalsize\sffamily}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}%
  {\parindent}%
  {0.3ex}%
  {-1em}%
  {\normalfont\normalsize\itshape}}
\listfiles
\endinput
%%
%% End of file `aiaa.cls'.
