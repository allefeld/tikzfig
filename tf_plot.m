function tf_plot(options, xy)

% inserts "\path plot" command into TikZ figure
%
% tf_plot(options, xy)
%
% options:  path options
% xy:       coordinates defining the path, matrix with two columns
%
% xy is in default TikZ units (cm).

n = size(xy, 1);

if n <= 1000
    s = ['\path[' options '] plot coordinates {', ...
        sprintf(' (%.6f,%.6f)', xy'), '};'];
else
    warning('More than 1000 data points!')
    fn = [tempname(tf_get('temp')) '.dat'];
    fid = fopen(fn, 'w');
    fprintf(fid, '%.6f\t%.6f\n', xy');
    fclose(fid);
    s = ['\path[' options '] plot file {' fn '};'];
end

tf_append(s);
