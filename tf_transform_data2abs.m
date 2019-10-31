function xy = tf_transform_data2abs(xy)

% transform from view coordinates to absolute coordinates
%
% xy = tf_transform_data2abs(xy)
%
% Absolute coordinates are in default TikZ units (cm) and with respect to
% the normal origin (lower left corner of the plot). They can be used with
% TikZ commands outside of a view's scope.

a = tf_get('currentview', 'No current view!');

% data to normalized coordinates
alim = a(5 : 8);
alim = reshape(alim, 2, 2);
xy = bsxfun(@rdivide, bsxfun(@minus, xy, alim(1, :)), diff(alim));

% normalized coordinates to absolute coordinates
blim = a(1 : 4);
blim = reshape(blim, 2, 2);
xy = bsxfun(@plus, bsxfun(@times, xy, diff(blim)), blim(1, :));
