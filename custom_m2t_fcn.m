function custom_m2t_fcn(filename,figwidth_mm,ppi,standalone_flag)

figheight_mm = figwidth_mm/1.618; % mm

if isempty(ppi)
    cleanfigure;
else
    if length(ppi)>1
        ppi(2) = ppi(1)/1.618;
    end
    cleanfigure('targetResolution',ppi);
end
matlab2tikz([filename, '.tikz'],                   ...
    'showInfo'   , false,                          ...
    'width'      , [num2str(figwidth_mm),  'mm'],  ...
    'height'     , [num2str(figheight_mm), 'mm'],  ...
    'floatFormat', '%.6g',                         ...
    'standalone' , standalone_flag);