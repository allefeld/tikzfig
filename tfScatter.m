function tfScatter(options, xy)

% generate scatter plot in current view
%
% tfScatter(options, xy)
%
% options:  path options
% xy:       data coordinates, matrix with two columns

options = ['mark=*,mark size=0.1bp,line width=0,' options];
tfPlot(options, xy);
