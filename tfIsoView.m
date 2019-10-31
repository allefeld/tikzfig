function tfIsoView

% impose isoscaling on the current view
%
% tfIsoView
%
% To achieve isoscaling, the range of values of one view axis is enlarged.
% This command should be used immediately after tfView

v = tf_get('currentview', 'No current view!');
blim = v(1 : 4);
alim = v(5 : 8);

alim = reshape(alim, 2, 2);
blim = reshape(blim, 2, 2);

arange = diff(alim);
amid = mean(alim);
brange = diff(blim);
scale = brange ./ arange;

scale = sign(scale) * min(abs(scale));

arange = brange ./ scale;
alim = [1 1]' * amid + [-1 1]' * arange / 2;

tfView(blim(:)', alim(:, 1)', alim(:, 2)', v(9 : 12))
