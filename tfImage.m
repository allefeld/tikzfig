function tfImage(options, xy, image, wh)

% insert image into the current view
%
% tfImage(options, xy, image, wh)
% tfImage(options, xy, image)
%
% The image is inserted with its center at the coordinates given in xy;
% this alignment can be overridden using the node options. wh specifies
% width and height of the image as a two-vector in units of the current
% view; if it is omitted, the image is shown at its natural size. If wh is
% used, the specification of either width or height can be omitted by
% setting the corresponding entry to 0; in that case, the other dimension
% is set according to the original aspect ratio of the image.
%
% image can be a file name for an image file in the format png, jpg, or
% pdf, or directly specify image data. In the latter case it can be
% – an array of image data A, which is interpreted as truecolor (m x n x 3)
% or grayscale (m x n)
% – a two-element cell array {A, map}, where A is interpreted as indexed
% image data pointing into map (0-based); A must be of type uint8
% – a two-element cell array {A, Alpha}, where A is interpreted as
% truecolor or grayscale image data and Alpha as transparency data [0…1].
% The first array dimension corresponds to rows from top to bottom, the
% second to columns from left to right.
% Image data are written to a temporary file in the format png, using imwrite.
%
% Example:
%
%     im = imread('ngc6543a.jpg');
%     [height, width, ~] = size(im);
%     xlim = tfLimits(1 : width);
%     ylim = tfLimits(1 : height);
% 
%     tfInit
%     tfLayout({1, 1, 1})
%     tfView(1, xlim, ylim)
%     tfImage('', [mean(xlim), mean(ylim)], im, [width, height])
%     tfDeco
%     tfRender


if nargin < 4
    wh = [0 0];
end

xy = tf_transform_data2rel(xy);
wh = diff(tf_transform_data2abs([0 0 ; wh]));

tf_image(options, xy, image, wh)
