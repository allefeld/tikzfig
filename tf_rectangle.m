function tf_rectangle(options, xy)

% draw rectangle
%
% tf_rectangle(options, xy)
%
% xy should be a two-by-two array

tf_path(options, xy(1 : 2, :), {'rectangle', ''});