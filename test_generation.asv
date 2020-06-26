function test_generation(data_cell, center_long, center_lat, gap, range, GMT, filename)
%TEST_GENERATION Summary of this function goes here


res = 60/3600;    % Current resolution for neural network input is 60s

% Generate longitude and latitude grid 
long_grid= center_long + (-floor(range/2/gap)*gap : gap : floor(range/2/gap)*gap);
lat_grid = center_lat + (-floor(range/2/gap)*gap : gap : floor(range/2/gap)*gap);

WIN_LEN = 4;   % Hours
WIN_RANGE = [-6-WIN_LEN/2:res:-6+WIN_LEN/2-res, 6-WIN_LEN/2:res:6+WIN_LEN/2-res];
len = length(WIN_RANGE);

intensity = data_cell{1};
time_grid = data_cell{2};
t_valid_start = data_cell{3};
t_valid_end = data_cell{4};

yy = data_cell{5};
dn_s = data_cell{6};
N_days = data_cell{7};
time_unit = 24*N_days/length(intensity);

alt = 0;  % Currently altitude information is not included


for d = 1:N_days-1
    
    test_light = zeros(length(long_grid), length(lat_grid), len);
    light_mask = zeros(length(long_grid), length(lat_grid));
    
    dn = dn_s + d - 1;
    [mm, dd] = day2date(yy, dn);
    [mm_next, dd_next] = day2date(yy, dn+1);
    
    for m = 1:length(long_grid)
        for n = 1:length(lat_grid)    
            long = long_grid(m);
            lat = lat_grid(n);
            
            [sunrise1, sunset1] = get_sun_data_offline(lat, long, alt, yy, mm, dd, GMT);
            [sunrise2, sunset2] = get_sun_data_offline(lat, long, alt, yy, mm_next, dd_next, GMT);
            
            night_center = (sunrise2+24+sunset1)/2;
            night_len    =  sunrise2+24-sunset1;
            
            scale = 12/night_len;
            
            if sunset1 == -1000 || sunrise2 == -1000 
                test_light(m,n,:) = zeros(1,len);
                light_mask(m,n) = 1;
            elseif sunset1+24*(d-1) <  t_valid_start || sunrise2+24*d > t_valid_end
                test_light(m,n,:) = zeros(1,len);
                light_mask(m,n) = 1;
            else
                focus = 24*(d-1)+night_center+WIN_RANGE/scale; 
                if focus(1) < 0 || focus(end) > 24*N_days
                    test_light(m,n,:) = zeros(1,len);
                    light_mask(m,n) = 1;
                else
                    curve_focus = interp1(time_grid, log10(intensity+1), focus, 'linear');
                    test_light(m,n,:) = curve_focus;
                end
            end
        end 
    end
    
    savepath = [filename, '_Month_', num2str(mm), '_Day_', num2str(dd),'.mat'];
    save(savepath, 'light_mask', 'test_light', 'lat_grid', 'long_grid')
end

end

