function tfRender(~)

% render TikZ figure to pdf file and show a preview
%
% tfRender

fprintf('tfRender\n')

tf_close_view

% get TikZ-LaTeX code
d = tf_get('code');
if (nargin > 0)
    fprintf('%s\n', d{:})
end

% figure name
name = get(gcf, 'Name');


%% write TikZ-LaTeX file and generate pdf

temp = tf_get('temp');
delete([temp '/' name '*'])     % clean up LaTeX input and output files

prefix = {
    '\documentclass[11pt]{article}'
    '\usepackage{tikz}'
    '\usetikzlibrary{external}'
    '\tikzexternalize'
    '\usetikzlibrary{plotmarks}'
    '\usetikzlibrary{arrows}'
    '\usetikzlibrary{arrows.meta}'
%     '\usetikzlibrary{decorations.pathreplacing}'
    '\usepgflibrary{shapes.multipart}'
    '\pagestyle{empty}'
    '\usepackage[utf8]{inputenc}'
    '\usepackage[T1]{fontenc}'
    '\usepackage{cmbright}'
    '\usepackage{amsmath}'
    '\begin{document}'
    '\setlength{\dimen0}{\fontcharht\font`T}'
    '\pgfmathsetmacro{\capheightfactor}{\the\dimen0 / 1em}'
    '\setlength{\dimen0}{\fontcharht\font`x}'
    '\pgfmathsetmacro{\xheightfactor}{\the\dimen0 / 1em}'
    '\setlength{\dimen0}{\fontchardp\font`q}'
    '\pgfmathsetmacro{\descenderfactor}{\the\dimen0 / 1em}'
    '\newcommand{\verysmall}{\footnotesize}'
    '\newcommand{\ultrasmall}{\scriptsize}'
    '\newcommand{\verylarge}{\Large}'
    '\newcommand{\ultralarge}{\LARGE}'
    '\newlength{\boxwidth}'
    '\newlength{\boxheight}'
    '\newlength{\xu}'
    '\newlength{\yu}'
    '\makeatletter'
    '\newcommand\typewidth[2]{%'
    '    \pgfextractx{\boxwidth}{\pgfpointanchor{#2}{east}}%'
    '    \pgfextractx{\pgf@xa}{\pgfpointanchor{#2}{west}}'
    '    \addtolength{\boxwidth}{-\pgf@xa}%'
    '    \typeout{#1=max(#1,\strip@pt\boxwidth);}}'
    '\newcommand\typeheight[2]{%'
    '    \pgfextracty{\boxheight}{\pgfpointanchor{#2}{north}}%'
    '    \pgfextracty{\pgf@xa}{\pgfpointanchor{#2}{south}}'
    '    \addtolength{\boxheight}{-\pgf@xa}%'
    '    \typeout{#1=max(#1,\strip@pt\boxheight);}}'
    '\def\setfont{\tikz@textfont}'
    '\makeatother'
    '\newcommand{\uneg}{\ensuremath{\begin{tikzpicture}'
    '    \path[use as bounding box] (0,0) -- (0.535em,0);'  % orig 0.765em
    '    \node[xscale=0.7,anchor=base west,inner sep=0,outer sep=0] (0,0) {$-$};'
    '    \end{tikzpicture}}}'
    '\begin{tikzpicture}'
    '\tikzstyle{clipstyle}=[clip]'
    '\tikzstyle{viewbackgroundstyle}=[]'
    '\tikzstyle{axislabelstyle}=[]'
    '\tikzstyle{ticklabelstyle}=[]'
    '\tikzstyle{tickinstyle}=[]'
    '\tikzstyle{tickoutstyle}=[]'
    '\tikzstyle{viewboxstyle}=[]'
    '\tikzstyle{titlestyle}=[]'
    '\tikzstyle{viewlabelstyle}=[]'
    '\pgfdeclareplotmark{tick}{%'
    '  \pgfpathmoveto{\pgfqpoint{0pt}{0pt}}'
    '  \pgfpathlineto{\pgfqpoint{0pt}{\pgfplotmarksize}}'
    '  \pgfusepathqstroke}'
    };
postfix = {
    '\end{tikzpicture}'
    '\end{document}'
    };

fprintf('  writing %s/%s.tex\n', temp, name)
fid = fopen([temp '/' name '.tex'], 'w');
fprintf(fid, '%s\n', prefix{:});
fprintf(fid, '%s\n', d{:});
fprintf(fid, '%s\n', postfix{:});
fclose(fid);

fprintf('  running pdflatex\n')
[status, ~] = system(['cd ' temp ' ; ' ...
    'pdflatex -interaction=batchmode -halt-on-error' ...
    ' -jobname "' name '-figure0"' ...
    ' "\def\tikzexternalrealjob{' name '}\input{' name '}"']);
if status ~= 0
    system(['grep -A 3 "^\!" ' temp '/"' name '-figure0.log"'])
    error('Failed running pdflatex!');
end

movefile([temp '/' name '-figure0.pdf'], [name '.pdf'])


%% display result in figure window

fprintf('  generating preview\n')
% sRes = get(0, 'ScreenPixelsPerInch');
sRes = 95.78;
rRes = sRes * 2;
[status, cmdout] = system(['gs -r' num2str(rRes) ' -sDEVICE=png16m -q -dNOPAUSE ' ...
    '-dBATCH -dEPSCrop -dTextAlphaBits=4 -dGraphicsAlphaBits=4 ' ...
    '-sOutputFile=' temp '/"' name '.png" "' name '.pdf"']);
if status ~= 0
    fprintf('%s\n', cmdout)
    error('Failed running gs!');
end

im = imread([temp '/' name '.png']);
[m, n, ~] = size(im);
set(gcf, 'Units', 'pixels')
p = get(gcf, 'Position');
p(3 : 4) = [n m];
set(gcf, 'Position', p)
set(gcf, 'Resize', 'off')
set(gca, 'Position', [0 0 1 1])
ih = image(im);
axis off image

set(ih, 'ButtonDownFcn', ['open(''' pwd '/' name '.pdf'')'])


%% process box measurements logged by LaTeX

padinner = zeros(1, 4);
padouter = zeros(1, 4);
[~, result] = system(['grep "pad" ' temp '/"' name '-figure0.log"']);
evalc(result);
padinner = padinner / 72.27 * 2.54;
padouter = padouter / 72.27 * 2.54;

pad = padinner + padouter + 0.03;
str = sprintf('''vpad = [%.3g %.3g]; hpad = [%.3g %.3g];''', pad);
fprintf('  recommended tfLayout parameters: %s\n', str);
