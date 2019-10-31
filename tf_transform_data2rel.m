function xy = tf_transform_data2rel(xy)

% transform from view coordinates to relative coordinates
%
% xy = tf_transform_data2rel(xy)
%
% Relative coordinates are in default TikZ units (cm) but with respect to
% the origin of the current view. They can only be used with TikZ commands
% inside of a view's scope.

xy = bsxfun(@minus, tf_transform_data2abs(xy), tf_get('origin'));

