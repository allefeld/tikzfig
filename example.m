clear all

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
