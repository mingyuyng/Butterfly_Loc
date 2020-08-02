function [long_est,lat_est] = localization(heatmap,long_grid, lat_grid)
%LOCALIZATION 此处显示有关此函数的摘要
%   此处显示详细说明

[max_cor,max_idx] = max(heatmap(:));
    
[lat_idx, long_idx]=ind2sub(size(heatmap),max_idx);
long_est = long_grid(long_idx);
lat_est = lat_grid(lat_idx);


end

