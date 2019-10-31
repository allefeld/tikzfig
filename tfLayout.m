function tfLayout(boxSpec, params, ~)

% organize the layout of a TikZ figure using boxes arranged over a grid
%
% tfLayout(boxSpec, params)
%
% Each part of the layout is defined by a layout box that spans one or more
% grid rows and columns. Layout boxes are separated by a space of width
% <gap> horizontally and vertically and surrounded by a space of width
% <margin> to fill the full figure. Within each layout box, the smaller view
% box is intended for the display of data. The padding around the view box
% to fill the layout box is specified by the two-vector <hpad> horizontally
% (left / right) and the two-vector <vpad> vertically (top / bottom). The
% function uses these parameters, the given <width> of the figure, as well
% as a series of box specifications to determine the size and position of
% layout and view boxes.
%
% boxSpec:  cell array with one row per box and three columns
%
% The three entries for each box specify
% (1) the indices of the grid rows spanned by the layout box (from the top),
% (2) the indices of the grid columns spanned by the layout box, and
% (3) the aspect ratio of the view box (width : height).
% The function attempts to generate a layout fulfilling these
% specifications and prints a warning if this is not possible. In this
% case, the specified constraint on the grid must be lifted for at least
% one box, so that the function can shrink the corresponding layout box
% below its grid space in order to achieve the ideal aspect ratio of the
% view box. A constraint is lifted by giving the entry (3) as a two-vector
% with the components
% (3a) the ideal aspect ratio and
% (3b) the position of the shrunken layout box within its grid space, as a
% number from 0 to 1 corresponding to its left-to-right or top-to-bottom
% alignment.
%
% Examples:
% - Two landscape boxes on the right, a portrait box on the left.
%     boxSpec = { 1,   1,   1.618;
%                 2,   1,   1.618;
%                 1:2, 2,   0.618  };
% - A 2x2-grid where all boxes except for one have a 4:3 aspect ratio but
% the upper right one is a square; it is centered in its grid space.
%     boxSpec = { 1, 1,   4/3;
%                 2, 1,   4/3;
%                 1, 2,   [1, 0.5];
%                 2, 2,   4/3};
%
% params:   Matlab expression to override the defaults of layout
% parameters,
% width = 16        full width of the figure
% margin = 0.1      width of outer figure margin
% gap = 0.75        width of separation between layout boxes
% hpad = [1.25 0]   horizontal box padding, left / right
% vpad = [0.5 1]    vertical box padding, top / bottom
%
% All measurements are in default TikZ units (cm).

fprintf('tfLayout\n')

if nargin == 0 || isempty(boxSpec)
    boxSpec = { 1, 1, 1.5 };
end

width = 16;
margin = 0.1;
gap = 0.75;
vpad = [0.5 1];
hpad = [1.25 0];
if nargin > 1
    evalc(params);
end

fprintf(' parameters: ''width = %g; margin = %g; gap = %g; vpad = [%g %g]; hpad = [%g %g];''\n', ...
    width, margin, gap, vpad, hpad)

%% determine grid measurements

% number of boxes
nb = size(boxSpec, 1);
% number of rows
nr = max(cellfun(@max, boxSpec(:, 1)));
% number of columns
nc = max(cellfun(@max, boxSpec(:, 2)));

% define and solve linear system
wC = zeros(nb + 1, nc);     % width coefficients
hC = zeros(nb + 1, nr);     % height coefficients
cC = zeros(nb + 1, 1);      % constant coefficients
for bi = 1 : nb
    ri = boxSpec{bi, 1};         % row indices
    ci = boxSpec{bi, 2};         % column indices
    ar = boxSpec{bi, 3};         % aspect ratio
    bnc = size(ci, 2);
    bnr = size(ri, 2);
    % aspect ratio constraints
    if isscalar(ar)
        % width of the box:   wb = sum(wC(i, ci) + (bnc - 1) * (gap + sum(hpad))
        % height of the box:  hb = sum(hC(i, ci) + (bnr - 1) * (gap + sum(vpad))
        % constraint: wb = ar * hb
        wC(bi, ci) = 1;
        hC(bi, ri) = -ar;
        cC(bi, 1) = - (bnc - 1) * (gap + sum(hpad)) ...
            + ar * (bnr - 1) * (gap + sum(vpad));
    end
end
% constraint by figure width
wC(nb + 1, :) = 1;
cC(nb + 1, :) = width - 2 * margin - (nc - 1) * gap - nc * sum(hpad);
% solve
A = [wC hC];
if rank(A) ~= rank([A cC])
    warning('layout constraints can not be fulfilled!')
end
if rank(A) < size(A, 2)
    warning('layout constraints have no unique solution!')
end
wh = pinv(A) * cC;

% column widths
w = wh(1 : nc);
% row heights
h = wh(nc + 1 : end);
% full height of the figure
height = sum(h) + 2 * margin + (nr - 1) * gap + nr * sum(vpad);


%% determine box limits

blim = nan(nb, 4);
olim = nan(nb, 4);
for bi = 1 : nb
    % horizontal
    cil = min(boxSpec{bi, 2});   % column indices lower
    ciu = max(boxSpec{bi, 2});   % column indices upper
    lx = margin + sum(w(1 : cil - 1)) + (cil - 1) * (gap + sum(hpad)) + hpad(1);
    ux = margin + sum(w(1 : ciu)) + (ciu - 1) * (gap + sum(hpad)) + hpad(1);
    % vertical
    ril = min(boxSpec{bi, 1});   % row indices lower
    riu = max(boxSpec{bi, 1});   % row indices upper
    uy = height - (margin + sum(h(1 : ril - 1)) + (ril - 1) * (gap + sum(vpad)) + vpad(1));
    ly = height - (margin + sum(h(1 : riu)) + (riu - 1) * (gap + sum(vpad)) + vpad(1));
    % different aspect ratio: shrink & position box
    if ~isscalar(boxSpec{bi, 3})
        aar = (ux - lx) / (uy - ly);
        tar = boxSpec{bi, 3}(1);
        pos = boxSpec{bi, 3}(2);
        if aar > tar
            lx = lx + pos * ((ux - lx) - (uy - ly) * tar);
            ux = lx + (uy - ly) * tar;
        end
        if aar < tar
            ly = ly + (1 - pos) * ((uy - ly) - (ux - lx) / tar);
            uy = ly + (ux - lx) / tar;
        end
    end
    % store
    blim(bi, :) = [lx ux ly uy];
    olim(bi, :) = blim(bi, :) + [hpad fliplr(vpad)] .* [-1  1 -1 1];
end


%% prepare figure

% set figure size
tf_rectangle('', [0 0 ; width height]);
% "use as bounding box" interferes with "local bounding box"

% save box coordinates
tf_set('blim', blim)
tf_set('olim', olim)


%% debug

if nargin > 2
    olim = tf_get('olim');
    for i = 1 : size(olim, 1)
        tf_rectangle('draw,lightgray,ultra thin', reshape(olim(i, :), 2, 2));
    end
end