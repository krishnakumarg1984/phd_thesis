function custom_m2t_fcn(filename,figsize_mm,ppi,standalone_flag)

if length(figsize_mm) > 1
    figwidth_mm = figsize_mm(1);
    figheight_mm = figsize_mm(2);
else
    figwidth_mm = figsize_mm;
    figheight_mm = figwidth_mm/1.618; % mm
end

if isempty(ppi)
    cleanfigure;
else
    if length(ppi)>1
        ppi(2) = ppi(1)/1.618;
    end
    cleanfigure('targetResolution',ppi);
end

if standalone_flag == false
    filename = [filename, '.tikz'];
else
    filename = [filename, '.tex'];
end

matlab2tikz(filename,                              ...
    'showInfo'   , false,                          ...
    'width'      , [num2str(figwidth_mm),  'mm'],  ...
    'height'     , [num2str(figheight_mm), 'mm'],  ...
    'floatFormat', '%.6g',                         ...
    'extraAxisOptions',{'scaled ticks=false,','xticklabel style={/pgf/number format/1000 sep=, /pgf/number format/precision=0,/pgf/number format/fixed,/pgf/number format/fixed zerofill,},'}, ...
    'standalone' , standalone_flag);