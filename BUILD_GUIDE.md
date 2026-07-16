# Mini-Project LaTeX Report Build Guide

This guide describes how to use and customize the XeLaTeX template to generate professional, academic-grade mini-project reports for MAKAUT and other technical universities. The template is designed to automatically format the report, manage citations, and maintain a target length of **18–22 pages**.

---

## 1. Setup & Environment

To compile this report, you need a LaTeX distribution that supports **XeLaTeX** (required for system font loading like Times New Roman).

### Windows Setup
1. **LaTeX Distribution**: Install [MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/). Alternatively, install [TinyTeX](https://yihui.org/tinytex/) via command-line.
2. **Fonts**: Ensure **Times New Roman** is installed on your operating system (default on Windows).
3. **Editor**: You can use VS Code (with LaTeX Workshop extension), TeXstudio, or any text editor.

---

## 2. File Naming Convention

Keep the project organized by matching the file names for the `.tex` and `.pdf` files.
- **TeX Source**: `<Project-Name>-MiniProject.tex`
- **Output PDF**: `<Project-Name>-MiniProject.pdf`

Our dynamic compilation script will automatically discover your `.tex` file and compile it into a PDF of the matching name.

---

## 3. Customizing the Template (Dynamic Elements)

### A. Title Page Configuration
Open the `.tex` file and locate the `% ==================== PAGE 1: TITLE PAGE ====================` block. Update the following fields:
* **Project Title**: Replace the text in `{\fontsize{28}{34}\selectfont\bfseries YOUR TITLE HERE\par}`.
* **Student Name & Roll Number**: Update the line:
  ```latex
  {\fontsize{18}{22}\selectfont\bfseries Student Name \\ (Roll No. XXXXXXXXXXX)\par}
  ```
* **Project Supervisor**: Change the guidance section:
  ```latex
  {\fontsize{16}{20}\selectfont Project Supervisor: Dr. Name Here\par}
  ```
* **Department, College & Year**: Update the text at the bottom of the title page.

### B. Acknowledgement & Project Members (Page 2)
This template consolidates both the Acknowledgement and the Project Members table onto a single page to maintain page efficiency.
1. **Acknowledgement Text**: Edit the paragraphs under `\chapter*{Acknowledgement}`.
   * *Drafting Tip*: Keep it to **exactly 2 paragraphs** to ensure it fits on one page. Include the supervisor's name in the first paragraph.
2. **Project Members Table**: Edit the `tabular` block under `\section*{Project Members}`:
   * Replace the placeholder roll numbers and names.
   * The signature column utilizes `\rule{0pt}{4ex}` to create a clean vertical height for handwritten signatures.

### C. Publications & Acronyms (Page 3)
* If you have no publications, leave the default text stating the prototype was created for educational requirements.
* Customize the abbreviations and symbols table in the `tabular` block. Add or remove rows using:
  ```latex
  Acronym & Description \\ \hline
  ```

### D. Table of Contents Styling (Preamble)
To make your report stand out, the template implements custom TOC formatting rules:
1. **TOC Title ("Contents")**: Programmatically formatted to **Times New Roman, 22pt, Bold, Italic, Left-Aligned** using the following preamble helper:
   ```latex
   \begingroup
   \titleformat{\chapter}[block]
     {\normalfont\fontsize{22}{26}\selectfont\bfseries\itshape\raggedright}
     {}{0pt}{}
   \tableofcontents
   \endgroup
   ```
2. **TOC Entries**: Only the chapter-level entries are set in **Bold + Italic** to emphasize sections, while sub-points (sections) remain in normal font to preserve hierarchy:
   ```latex
   \usepackage[titles]{tocloft}
   \renewcommand{\cftchapfont}{\normalfont\bfseries\itshape}
   \renewcommand{\cftchappagefont}{\normalfont\bfseries\itshape}
   ```

---

## 4. Managing the 18–22 Page Limit

If your report is too short (under 18 pages) or too long (over 22 pages), use these layout controls:

* **TOC Depth**: Set `\setcounter{tocdepth}{1}` in the preamble to show only chapters and main sections. This keeps the TOC to exactly **1 page**.
* **Spacing Adjustments**: Use `\vspace{<size>}` (e.g., `\vspace{0.1in}` or `\vspace{-0.05in}`) to adjust the gap above/below tables and figures to prevent headings from spilling over to empty pages.
* **Control Page Breaks**: Use `\clearpage` to force an element to start on a new page, ensuring a clean flow where chapters start on fresh pages.
* **Image Bounds**: Restrict image sizes using both width and height limits:
  ```latex
  \makebox[\textwidth][c]{\includegraphics[width=1.05\textwidth,height=9.2cm,keepaspectratio=true]{images/image.png}}
  ```
  Adjust the `height` parameter to push or pull headings around the images to avoid trailing headings.
* **Code Blocks**: Display code listings with single line spacing to save space. Adjust the font size of listings in `\lstset` under the `basicstyle` property:
  ```latex
  basicstyle=\ttfamily\fontsize{7.5}{9.0}\selectfont\linespread{1.0}\selectfont
  ```

---

## 5. Report Structure Guide (Chapters 1–5)

To maintain academic quality, structural flow must follow this hierarchy:
* **Chapter 1: Introduction**
  * Project Overview
  * Review of Previous Works (Literature Survey with `\cite` references)
  * Objective & Motivation
  * Scope of Present Work
* **Chapter 2: Hardware Architecture and Component Details**
  * Descriptions of microcontrollers, sensors, communication modules, and actuators.
* **Chapter 3: System Design and Circuit Integration**
  * Schematic connections, pin mapping tables, kinematics, and power schemes.
* **Chapter 4: Software Implementation and Control Algorithms**
  * Firmware structures, flowchart descriptions, and source code listings.
* **Chapter 5: Experimental Results, Conclusions, and Future Scope**
  * Calibration tables, prototype test results, summary conclusions, and future scope.
* **References**
  * IEEE format bibliography references.

---

## 6. How to Compile

Run the dynamic compilation script `compile_xelatex.ps1` from your terminal:
```powershell
.\compile_xelatex.ps1
```
This script is directory-agnostic and will compile whatever report you are currently working on!
