function [month, day] = day2date(year, day_num)
%DAY2DATE Summary of this function goes here
%   Detailed explanation goes here

if mod(year,4)
    day_dic = [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
else
    day_dic = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
end

day_dic = cumsum(day_dic);

diff = day_num-day_dic;
ind = find(diff<0);

month = ind(1)-1;
day = diff(month);
end

