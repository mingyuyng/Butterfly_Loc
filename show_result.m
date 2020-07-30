
% This script is used to show the test result of neural networks

clear all;

DISPLAY = 1;

load('./Testdata/20305333_HOBO_Month_11_Day_5.mat');
load('./results/result_20305333_HOBO_Month_11_Day_5.mat')

lat_fine = interp(lat_grid, 2);
long_fine = interp(long_grid, 2);

lat_fine = lat_fine(1:end-1);
long_fine = long_fine(1:end-1);

[long_cor_grid, lat_cor_grid] = meshgrid(long_grid, lat_grid);
[long_fine_grid, lat_fine_grid] = meshgrid(long_fine, lat_fine);

light_coarse = results';
light_intp = interp2(long_cor_grid,lat_cor_grid,light_coarse,long_fine_grid,lat_fine_grid, 'cubic', 0);
light_intp(light_intp<0) = 0;
   
if DISPLAY == 1
    
    figure
    subplot(1,3,1)
    title('Coarse grid')
    surface(long_grid,lat_grid,light_coarse, 'edgecolor', 'None');
    xlabel('longitude')
    ylabel('latitude')
    xlim([long_grid(1), long_grid(end)]);
    ylim([lat_grid(1), lat_grid(end)]);
      
    subplot(1,3,2)
    title('Fine grid')
    surface(long_fine,lat_fine,light_intp, 'edgecolor', 'None')
    xlabel('longitude')
    ylabel('latitude')
    xlim([long_fine(1), long_fine(end)]);
    ylim([lat_fine(1), lat_fine(end)]);
    
    lights = [];
    for j = 1:size(test_light,1)
        mm = light_coarse(:,j) > 0.1;
        if sum(mm)>1
            lights = [lights; squeeze(test_light(j,mm,:))];
        elseif sum(mm)==1
            lights = [lights; squeeze(test_light(j,mm,:))'];
        end
    end
    
    subplot(1,3,3)
    title('Good curves')
    plot(lights');hold on
    plot(120*ones(1,100), linspace(0,2,100), 'linewidth',2);hold on
    plot(360*ones(1,100), linspace(0,2,100), 'linewidth',2);hold on
   
    
end

%%%%%%%%%%%%%%%%% Evaluating the Heat Map %%%%%%%%%%%%%%%%%%

% Part 1: Weighted squared deviation 

fprintf('Good Estimation: \n')
long_true = -68;
lat_true = 41;

[long_grid_2, lat_grid_2] = meshgrid(long_grid, lat_grid);

deviation = sum(light_coarse.* ( (long_grid-long_true).^2 + (lat_grid-lat_true).^2), 'a') / sum(light_coarse, 'a');

fprintf('Deviation: %f \n', deviation);


fprintf('Bad Estimation: \n')
long_true = -68;
lat_true = 35;

[long_grid_2, lat_grid_2] = meshgrid(long_grid, lat_grid);

deviation = sum(light_coarse.* ( (long_grid-long_true).^2 + (lat_grid-lat_true).^2), 'a') / sum(light_coarse, 'a');

fprintf('Deviation: %f \n', deviation);


% Part 2: Compare two heatmaps


% Move the heatmap north by 5 degrees
light_coarse_1 = [light_coarse(37:41, :); light_coarse(1:36, :)];
% Move the heatmap north by 10 degrees
light_coarse_2 = [light_coarse(32:41, :); light_coarse(1:31, :)];

% Visualization
figure;
subplot(1,3,1)
title('Coarse grid')
surface(long_grid,lat_grid,light_coarse, 'edgecolor', 'None');
xlabel('longitude')
ylabel('latitude')
xlim([long_grid(1), long_grid(end)]);
ylim([lat_grid(1), lat_grid(end)]);

subplot(1,3,2)
title('Coarse grid')
surface(long_grid,lat_grid,light_coarse_1, 'edgecolor', 'None');
xlabel('longitude')
ylabel('latitude')
xlim([long_grid(1), long_grid(end)]);
ylim([lat_grid(1), lat_grid(end)]);

subplot(1,3,3)
title('Coarse grid')
surface(long_grid,lat_grid,light_coarse_2, 'edgecolor', 'None');
xlabel('longitude')
ylabel('latitude')
xlim([long_grid(1), long_grid(end)]);
ylim([lat_grid(1), lat_grid(end)]);

% Algorithm #1
% Treat two heatmaps as two distributions and compute the discrete Jenson-Shannon
% Divergence (KL divergence is not symmetric, lower the better)
% https://en.wikipedia.org/wiki/Jensen%E2%80%93Shannon_divergence

% Next possible algorithm: Earth mover's distance

% Normalize
light_coarse_dist = light_coarse/sum(light_coarse, 'a');
light_coarse_dist_1 = light_coarse_1/sum(light_coarse_1, 'a');
light_coarse_dist_2 = light_coarse_2/sum(light_coarse_2, 'a');

average = (light_coarse_dist + light_coarse_dist_1) / 2;

KL1 = sum(light_coarse_dist .* (log2(light_coarse_dist)-log2(average)), 'a');
KL2 = sum(light_coarse_dist_1 .* (log2(light_coarse_dist_1)-log2(average)), 'a');
JS = (KL1+KL2)/2;

fprintf('JS divergence #1: %f \n', JS);

average = (light_coarse_dist + light_coarse_dist_2) / 2;

KL1 = sum(light_coarse_dist .* (log2(light_coarse_dist)-log2(average)), 'a');
KL2 = sum(light_coarse_dist_2 .* (log2(light_coarse_dist_2)-log2(average)), 'a');
JS = (KL1+KL2)/2;

fprintf('JS divergence #2: %f \n', JS);

% Algorithm #2
% Overlapped area (larger the better)

overlap_location = abs(light_coarse_dist-light_coarse_dist_1)>1e-5;
area = sum(min(light_coarse_dist(overlap_location), light_coarse_dist_1(overlap_location)));
fprintf('Overlapped area #1: %f \n', area);

overlap_location = abs(light_coarse_dist-light_coarse_dist_2)>1e-5;
area = sum(min(light_coarse_dist(overlap_location), light_coarse_dist_2(overlap_location)));
fprintf('Overlapped area #2: %f \n', area);