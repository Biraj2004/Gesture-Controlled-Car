# Mini-Project & College Report XeLaTeX Build Guide

This guide describes how to use, adapt, and customize the universal XeLaTeX template to generate professional, academic-grade project reports for **any technical university or college worldwide** (including MAKAUT, Anna University, VTU, Mumbai University, IITs, NITs, MIT, Stanford, etc.).

The template is engineered with a central parameter macro block, automated cross-referencing, full-grid table styling, breakable dynamic code blocks, native image captioning, and target page limit budget controls (e.g., **18–22 pages**).

---

## 1. Setup & Environment

To compile reports, you need a LaTeX distribution supporting **XeLaTeX** (required for system font loading like Times New Roman).

### Windows Setup
1. **LaTeX Distribution**: Install [MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/). Alternatively, install [TinyTeX](https://yihui.org/tinytex/) via command line.
2. **Fonts**: Ensure **Times New Roman** and **Courier New** are available on your OS (installed by default on Windows).
3. **Editor & Automation**: VS Code (with LaTeX Workshop extension) or PowerShell script execution.

---

## 2. Universal Dynamic Configuration for Any College Worldwide

To adapt this template for your specific institution, open [`biraj-xelatex-clg_report-general-specs.tex`](file:///e:/01.%20GitHub%20Repo%20Projects/Gesture-Controlled-Car/biraj-xelatex-clg_report-general-specs.tex) and update the central **Macro Parameter Configuration Block** in the preamble:

```latex
% ==============================================================================
% DYNAMIC UNIVERSAL COLLEGE REPORT CONFIGURATION MACROS
% ==============================================================================
\newcommand{\ReportTitle}{GESTURE CONTROLLED WIRELESS 4WD ROBOTIC CAR}
\newcommand{\ReportType}{Mini Project Report}
\newcommand{\DegreeName}{Bachelor of Technology}
\newcommand{\BranchName}{Electronics and Communication Engineering}
\newcommand{\UniversityName}{Maulana Abul Kalam Azad University of Technology, West Bengal}
\newcommand{\CollegeName}{Cooch Behar Government Engineering College}
\newcommand{\DepartmentName}{Department of Electronics and Communication Engineering}
\newcommand{\CollegeLocation}{Cooch Behar, West Bengal, India}
\newcommand{\AcademicYear}{2026}
\newcommand{\SupervisorName}{Dr. Gautam Das}
\newcommand{\SupervisorDesignation}{Project Supervisor}
\newcommand{\InstitutionLogoPath}{images/CGEC-Logo-colorful.jpg}

% Target Page Limit Constraints
\newcommand{\TargetMinPages}{18}
\newcommand{\TargetMaxPages}{22}
```

When an AI assistant (such as **Antigravity**) or human author updates these variables, the title page, headers, footers, member lists, and metadata update across the document.

---

## 3. Dynamic Student Member & Signature Table

The student member table automatically adjusts to any number of team members (from single-author reports to 5+ members):

```latex
\begin{center}
\begin{tabular}{|C{4.0cm}|C{5.5cm}|C{5.0cm}|}
\hline
\textbf{Student Roll No.} & \textbf{Name of Project Member} & \textbf{Member Signature} \\ \hline
34900323050 & Sohan Ghosh & \rule{0pt}{4ex} \\ \hline
34900323046 & Sarupya Guha & \rule{0pt}{4ex} \\ \hline
\end{tabular}
\end{center}
```
The `\rule{0pt}{4ex}` command creates a standard vertical gap for physical handwritten signatures.

---

## 4. Full-Grid Table & Breakable Code Block Rules

### A. Full-Grid Table Standard
- **Borders**: Full grid on all cells (`|c|c|`).
- **Header Row**: Centered horizontally and vertically in **bold**.
- **Cell Alignment**: Left-aligned by default; use `C{width}` or `L{width}` for fixed column widths.
- **Branding / Row Colors**: NO row background colors or personal/corporate branding.

### B. Breakable Dynamic Code Blocks
Code blocks are framed in a `tcolorbox` with `breakable=true` so multi-page code listings split dynamically across page breaks:

```latex
\begin{tcolorbox}[breakable, colback=codebg, colframe=codeborder, title=Listing Title]
\begin{lstlisting}[language=C++]
// Firmware source code here...
\end{lstlisting}
\end{tcolorbox}
```

---

## 5. Native Image Handling & Dynamic Numbering

1. **Floating Figure**: Standard `\begin{figure}[htbp]` with `\caption{...}` and `\label{fig:...}`.
2. **Non-Floating Image**: Use `\captionof{figure}{...}` inside a `center` block.
3. **Oversized Images**: Wrap in `\makebox[\textwidth][c]{\includegraphics[width=1.05\textwidth,height=9.0cm,keepaspectratio=true]{...}}`.
4. **Dynamic Chapter Numbering**: Automatically rendered as **Figure X.Y** (e.g., Figure 1.1, Figure 2.1) and cataloged in `\listoffigures`.

---

## 6. Managing University Target Page Limits

If your university mandates a specific length (e.g., **18–22 pages**):

- **TOC Depth**: Set `\setcounter{tocdepth}{1}` to keep TOC strictly on **1 page**.
- **Image Bounds**: Restrict height using `height=5.5cm,keepaspectratio=true`.
- **Spacing**: Use `\clearpage` before chapters to guarantee clean page starts.
- **Listings Font Size**: Set code listings to `8.5pt` with `1.0` line height.

---

## 7. How to Compile

Run the PowerShell build script:
```powershell
.\compile_xelatex.ps1
```
This script automatically discovers `.tex` source files, performs a double-pass XeLaTeX compilation, manages viewer file locks, and removes auxiliary build files.
