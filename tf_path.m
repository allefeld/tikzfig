function tf_path(options, xy, ops)

% insert path
%
% tf_path(options, xy)
% tf_path(options, xy, ops)
%
% For details see tfPath.

n = size(xy, 1);

if (nargin < 3)
    ops = [repmat({'--'}, n - 1, 1) ; {''}];
end
if ischar(ops)
    ops = [repmat({'--'}, n - 1, 1) ; {ops}];
end

s = ['\path[' options ']'];
for i = 1 : n
    s = [s sprintf(' (%.6f,%.6f) %s', xy(i, :), ops{i})];
end
s = [s ';'];

tf_append(s);
