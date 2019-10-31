function tf_image(options, xy, image, wh)

% low-level version of tfImage
%
% tf_image(options, xy, image, wh)
% tf_image(options, xy, image)
%
% xy and wh are given in cm, xy with respect to the lower left corner

if nargin < 4
    wh = [0 0];
end

% possibly flip dimensions
swh = sign(wh);
swh(swh == 0) = 1;
options = sprintf('xscale=%d,yscale=%d,%s', swh, options);
wh = abs(wh);

icopt = '';
if wh(1) > 1e-12
    icopt = sprintf('width=%.6fcm', wh(1));
end
if wh(2) > 1e-12
    if ~isempty(icopt)
        icopt = [icopt ','];
    end
    icopt = [icopt, sprintf('height=%.6fcm', wh(2))];
end
if ~isempty(icopt)
    icopt = ['[' icopt ']'];
end

if ischar(image)
    [~, name, ext] = fileparts(image);
    name = [tempname(tf_get('temp')) '_' name ext];
    copyfile(image, name)
else
    name = [tempname(tf_get('temp')) '.png'];
    if isnumeric(image)                     % truecolor or grayscale
        imwrite(image, name)
    elseif iscell(image)
        im2 = image{2};
        image = image{1};
        if isinteger(image)                 % indexed with map
            if size(im2, 1) < 256
                imwrite(uint8(image), im2, name);
            else
                % convert indexed to truecolor to overcome png limitation
                % of a maximum of 256 palette entries
                image = reshape(im2(image + 1, :), [size(image), 3]);
                imwrite(image, name)
            end
        else                                % truecolor or grayscale with alpha
            imwrite(image, name, 'Alpha', im2)
        end
    end
       
end
    
tf_path('', xy, ...
    sprintf('node[%s] {\\includegraphics%s{%s}}', options, icopt, name))
