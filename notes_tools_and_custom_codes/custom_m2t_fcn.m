function custom_m2t_fcn(filename,figsize_mm,ppi,standalone_flag,extra_axis_options)

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

if isempty(extra_axis_options)
    matlab2tikz(filename,                              ...
    'showInfo'   , false,                          ...
    'width'      , [num2str(figwidth_mm),  'mm'],  ...
    'height'     , [num2str(figheight_mm), 'mm'],  ...
    'floatFormat', '%.6g',                         ...
    'standalone' , standalone_flag);
else
    matlab2tikz(filename,                              ...
    'showInfo'   , false,                          ...
    'width'      , [num2str(figwidth_mm),  'mm'],  ...
    'height'     , [num2str(figheight_mm), 'mm'],  ...
    'floatFormat', '%.6g',                         ...
    'extraAxisOptions',{extra_axis_options}, ...
    'standalone' , standalone_flag);
end 

% 'scaled ticks=false,'