function tfContour(options, A, levels, xval, yval)

% display matrix as a contour plot
% 
% tfContour(options, A, levels, xval, yval)
%
% A is visualized as a set of contour lines at the given levels.
% The two two-element vectors xval and yval specify the coordinates
% corresponding to A(1, 1) and A(end, end), respectively.
%
% options are passed on as-is to tfPath.

[m, n] = size(A);

if (nargin < 3) || isempty(levels)
    levels = quantile(A(:), [0.25 0.5 0.75]);
end
if (nargin < 4) || isempty(xval)
    xval = [1 m];
end
if (nargin < 5) || isempty(yval)
    yval = [1 n];
end

% determine coordinate grid
xs = linspace(xval(1), xval(end), m);
ys = linspace(yval(1), yval(end), n);

% determine contour lines
if numel(levels) == 1
    % accomodate quirk of contourc interface
    levels = [levels, levels];
end
C = contourc(xs, ys, A .', levels);

% extract contour lines from contourc output and plot them
j = 1;
while j < size(C, 2)
    nc = C(2, j);
    tfPath(options, C(:, j + (1 :2: nc))')
    j = j + nc + 1;
end
