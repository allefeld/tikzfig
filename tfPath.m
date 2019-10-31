function tfPath(options, xy, ops)

% insert path in current view
%
% tfPath(options, xy)
% tfPath(options, xy, ops)
%
% options:  initial path options
% xy:       coordinates defining the path, matrix with two columns
% ops:      path operations
%
% To completely specify path operations, ops has to be a cell array with
% as many elements as there are coordinates; each operation is inserted
% after the corresponding coordinate pair.
% If ops is omitted, the line-to operation '--' is inserted between
% coordinate pairs.
% If ops is a string, the line-to operation is inserted as before, but with
% ops as an additional operation after the last coordinate.
%
% The last syntax is meant to facilitate the following uses:
% – put text a a given position
% tfPath('', [0.1 0.9], 'node {Hello, Kitty!}')
% – draw an arrow with a label
% tfPath('draw,-latex', [0.1 0.5 ; 0.9 0.9], 'node[midway,sloped,above] {arrow}')
% – draw a closed shape
% tfPath('draw,line width=1cm', [0.2 0.1 ; 0.5 0.6 ; 0.8 0.2], '--cycle')
% - fill a circle
% tfPath('fill=blue', [0.8 0.5], 'circle [radius=1]')
%
% Anchors:
% – north east south west, and combinations
%
% See Sec. 14 of the TikZ/PGF manual.


xy = tf_transform_data2rel(xy);

if nargin < 3
    tf_path(options, xy)
else
    tf_path(options, xy, ops)
end
