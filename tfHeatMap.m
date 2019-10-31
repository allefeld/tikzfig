function tfHeatMap(options, A, clim, xval, yval)

% display matrix as a heat map
% 
% tfHeatMap(options, A, clim, xval, yval)
%
% A is visualized as an array of colored rectangles. Values are mapped from
% the interval specified by the two-vector clim onto the current colormap.
% The two two-element vectors xval and yval specify the coordinates of the
% centers of the rectangles corresponding to A(1, 1) and A(end, end),
% respectively.
%
% options are passed on as-is to tfImage.

[m, n] = size(A);

if (nargin < 3) || isempty(clim)
    clim = [min(A(:)), max(A(:))];
end
if (nargin < 4) || isempty(xval)
    xval = [1 m];
end
if (nargin < 5) || isempty(yval)
    yval = [1 n];
end

% transform data into colors according to current colormap
% The interval between clim(1) and clim(2) is divided into ncol equal
% segments, which are assigned to color indices 1 to ncol.
map = colormap;
ncol = size(map, 1);
ind = round((A - clim(1)) / diff(clim) * ncol + 0.5);
ind(ind < 1) = 1;
ind(ind > ncol) = ncol;
ind = uint64(ind - 1);

% determine position and dimensions of heatmap image
xlim = tfLimits(xval, m);
ylim = tfLimits(yval, n);
wh = [diff(xlim), diff(ylim)];
xy = [mean(xlim), mean(ylim)];

tfImage(options, xy, {rot90(ind), map}, wh)
