function [day_num] = date2day(year, month, day)
%DATE2DAY Summary of this function goes here
%   Transfer from date to day number

if mod(year,4)
    day_dic = [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
else
    day_dic = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
end

day_dic = cumsum(day_dic);

day_num = day_dic(month) + day;

end

