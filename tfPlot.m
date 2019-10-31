function tfPlot(options, xy)

% plot data in current view
%
% tfPlot(options, xy)
%
% options:  path options
% xy:       data coordinates, matrix with two columns
%
% Common options:
%   draw            draw line between points
%   mark=           draw mark at points
%     *               dot
%     +               plus sign
%     x               cross sign
%     ball            colored 3d ball
%     -               horizontal bar
%     |               vertical bar
%     o               circle
%     asterisk        six-pointed star
%     star            five-pointed star
%     square          square
%     triangle        triangle
%     ... see Plot Mark library
%   mark size=      radius of the mark
%   mark options=   apply options to each mark
%
% See Sec. 22 of the TikZ/PGF manual.

xy = tf_transform_data2rel(xy);

tf_plot(options, xy)
