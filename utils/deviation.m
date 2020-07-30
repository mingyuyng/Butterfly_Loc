function [deviation] = deviation(long_grid,lat_grid, heatmap, long_true, lat_true)
%DEVIATION 

[long_grid_, lat_grid_] = meshgrid(long_grid, lat_grid);
deviation = sum(heatmap.* ( (long_grid_-long_true).^2 + (lat_grid_-lat_true).^2), 'a') / sum(heatmap, 'a');


end

