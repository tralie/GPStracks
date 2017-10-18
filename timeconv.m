function gnss_times=timeconv(weeknums,timeofweeks)
% gnss_times=timeconv(weeknums,timeofweeks)
% 
% Time conversion for GPS data from number of weeks since Jan 6, 1980 
% and time elapsed (s) since the beginning of the week (Sunday 00:00:00). 
% The output is in a GNSS timestamp (seconds) format. 
%
% This output can then be given to gnss_datevec.m to convert to a 
% [yyyy mm dd HH MM SS] format. 
%
% INPUT:
%
% weeknums          number of weeks since Jan 6, 1980
% timeofweeks       time elapsed (s) since beginning of week (Sunday)
%
% OUTPUT:
%
% gnss_times         GNSS timestamp (s) 
%
% EXAMPLE: 
%
% weeknums = 1754; 
% timeofweeks = 3600;
% gnss_times_example = timeconv(weeknums,timeofweeks);
%
% The above will return 1.0608e+09 (in seconds)
% This is the number of seconds elapsed since the GPS date, Jan 6, 1980.
%
% Last modified by jtralie@princeton.edu on 07/26/2017

gnss_times = gadd(timeofweeks,gmultiply(weeknums,604800)); 
