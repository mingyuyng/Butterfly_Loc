function [datacell] = data_preprocessing(light, time_light, time_unit)
%DATA_PREPROCESSING Summary of this function goes here

% Start date
yy = year(time_light(1));
mm_s = month(time_light(1));
dd_s = day(time_light(1));
dn_s = date2day(yy, mm_s, dd_s); 

% End date
mm_e = month(time_light(end));
dd_e = day(time_light(end));
dn_e = date2day(yy, mm_e, dd_e); 

[mm_b, dd_b] = day2date(yy, dn_s-1);

% Balance the time zone
date_s = datetime(yy, mm_s, dd_s, 0, 0, 0);
time_stemp = seconds(time_light - date_s);

%Checkpoint1
% plot(time_stemp, light);
% keyboard;

% Interpolate and Extrapolation
N_days = dn_e-dn_s+1;

t_start = ceil(time_stemp(1)/time_unit)*time_unit;
t_end = floor(time_stemp(end)/time_unit)*time_unit;
t_grid = t_start:time_unit:t_end;
light_intp_inside = interp1(time_stemp, light, t_grid, 'linear');

time_grid_before = 0:time_unit:t_grid(1)-time_unit;
time_grid_after = t_grid(end)+time_unit:time_unit:N_days*24*60*60-time_unit;

time_grid = [time_grid_before, t_grid, time_grid_after];
intensity = [light_intp_inside(1)*ones(size(time_grid_before)),...
             light_intp_inside,...
             light_intp_inside(end)*ones(size(time_grid_after))];

% Thresholding (throw away low density light measurements)
thre = log10(2+1);  % Default threshold: 2 lux
intensity = intensity - thre;
intensity(intensity<0) = 0;

t_valid_start = t_start/3600;
t_valid_end = t_end/3600;

% Checkpoint2
% plot(time_grid/3600, log10(intensity+1)); hold on
% plot(ones(100,1)*t_valid_start/3600, linspace(0,5,100));hold on
% plot(ones(100,1)*t_valid_end/3600, linspace(0,5,100));hold on
% keyboard;


datacell = {intensity, time_grid/3600, t_valid_start, t_valid_end,...
        yy, dn_s, N_days};
end

