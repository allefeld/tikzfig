function tfEllipse(options, xy, a, b, theta)

% draw an circle or ellipse in the current view
%
% tfEllipse(options, xy, r)
% tfEllipse(options, xy, a, b)
% tfEllipse(options, xy, a, b, theta)
%
% xy:       center
% r:        radius
% a, b:     semi-axes
% theta:    angle
%
%
% tfEllipse(options, xy, Sigma)
%
% Draw the ellipse based on a covariance matrix Sigma. The semi-axes of the
% ellipse are given by the eigenvalues of the matrix, its orientation by
% the eigenvectors. If Sigma describes a multivariate normal distribution,
% the ellipse corresponds to its 1σ-line.


if nargin < 5
    theta = 0;
end
if nargin < 4
    b = a;
end

if isscalar(a)
    av = a * [cos(theta) sin(theta)];
    bv = b * [-sin(theta) cos(theta)];
    Sigma = av' * av + bv' * bv;
else
    Sigma = a;
end

f = diff(tf_transform_data2abs([0 0 ; 1 1]));
[V, D] = eig(diag(f) * Sigma * diag(f));
a = sqrt(D(1, 1));
b = sqrt(D(2, 2));
theta = atan2(V(2, 1), V(1, 1))  / pi * 180;

tfPath(['draw,' options], xy, ...
    sprintf('circle [x radius=%.6f,y radius=%.6f,rotate=%.6f]', a, b, theta))
