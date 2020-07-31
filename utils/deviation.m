function [deviation_long, deviation_lat] = deviation(long_grid,lat_grid, heatmap, long_true, lat_true)
%DEVIATION 

[long_grid_, lat_grid_] = meshgrid(long_grid, lat_grid);
deviation_long = sum(heatmap.* ( long_grid_-long_true).^2, 'a') / sum(heatmap, 'a');
deviation_lat = sum(heatmap.* ( lat_grid_-lat_true).^2, 'a') / sum(heatmap, 'a');


end

