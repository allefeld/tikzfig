# Create pdf figures using the TikZ/pgf LaTeX package

`tikzfig` is a toolbox to programmatically create figure files in pdf format using the [TikZ/pgf LaTeX package](https://ctan.org/pkg/pgf?lang=en). It exposes part of the TikZ interface to pgf as a Matlab API, so that graphics statements lead to the construction of a LaTeX file which is transparently processed into pdf, including a simple preview mechanism. Additionally, functionality to easily create multi-panel figure layouts is provided.


## Example

```matlab
% create a figure named "hello" (associated with a Matlab figure window)
tfInit('hello')
% define a color to be used later
tfColor('kitty', 'rgb', [1 0 0])
% define a style to be used later
tfStyle('pretty', 'mark=+,draw=orange')
% define a layout with two boxes side-by-side,
% the first with a 4:3 aspect ratio and the second one square
tfLayout({1 1 4/3; 1 2 1})

% select layout box #1 and define coordinate system
tfView(1, [0 3], [0 3])
tfIsoView
% draw an arrow from (1, 2) to (2, 1)
tfPath('green,thick,draw,->', [1 2 ; 2 1])
% make a text label
tfPath('', [0.1 0.1], ...
    'node [kitty,anchor=south west,draw,fill=yellow] {Hello Kitty! $E = mc^2$}')
% close layout box and show standard decorations: viewbox and scales
tfDeco

% select layout box #2 and define coordinate system
tfView(2, [0.5 9.5], [-0.1 1.1])
% plot some random data
tfPlot('pretty', [1 : 9 ; rand(1, 9)]')
% close layout box and use scales and a title as decorations
tfDeco scales
tfDeco title graph

% generate pdf and show a preview in the associated figure window
tfRender
```

![result](example-figure.png)

![result](example-pdf.png)


## Usage

The basic structure of a `tikzfig` script is
-   `tfInit`: initialize TikZ figure
-   style commands
-   `tfLayout`: organize the layout of a TikZ figure using boxes arranged over a grid
-   for each view:
    -   `tfView`: prepare layout box as current view
    -   optionally `tfIsoView`: impose isoscaling on the current view
    -   plot commands
    -   optionally `tfDeco`: draw decorations for the current view
-   `tfRender`: render TikZ figure to pdf file and show a preview

Style commands:
-   `tfColor`: define color for later use in drawing or filling
-   `tfStyle`: define TikZ style for later use in options

Plot commands:
               tfPath - insert path in current view
               tfPlot - plot data in current view
            tfScatter - generate scatter plot in current view
            tfHeatMap - display matrix as a heat map
              tfImage - insert image into the current view
            tfContour - display matrix as a contour plot
            tfEllipse - draw an circle or ellipse in the current view
              tfArrow - draw arrow
           tfColorBar - fill pre-defined layout box with colorbar
               tfGrid - draw a coordinate grid into the current view
             
Helper functions:
          tfPrintCode - print TikZ code
             tfLimits - compute fitting view limits for discretely sampled data (e.g. images)

