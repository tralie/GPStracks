function gnss_datevec=gnss_datevec(gnss_time)
% gnss_datevec=gnss_datevec(gnss_time)
%
% Convert GNSS timestamp (seconds) into a 6-column date vector (in UTC)
% of the format [yyyy mm dd HH MM SS].
%
% INPUT:
%
% gnss_time             Number of seconds elapsed since the GPS date
%                       Jan 6, 1980. If data is given in form of
%                       number of weeks since GPS date Jan 6, 1980 and the
%                       number of milliseconds elapsed since the beginning
%                       of the week (Sunday), these two values can be 
%                       passed to timeconv(weeknums,timeofweeks) to
%                       obtain the GNSS timestamp (seconds).
%
%
% OUTPUT:
% 
% gnss_datevec          6-column date vector of the format (in UTC)
%                       [yyyy mm dd HH MM SS].
%
% 
% EXAMPLE:
% This example first uses timeconv(weeknums,timeofweeks) to obtain
% a GNSS timestamp (seconds) for gnss_datevec.
% weeknums = 1754;
% timeofweeks = 3600;
% gnss_times = timeconv(weeknums,timeofweeks);
% this will return the GNSS timestamp of 1.0608e+09 (s).
%
% Next, send this result to gnss_datevec:
% gnss_datevec = gnss_datevec(gnss_times)
% this will return [2013 8 18 1 0 0].
% This time is at 01:00:00 on August 18, 2013 (UTC). 
%
% Last modified by jtralie@princeton.edu on 07/26/2017.

gnss_datevec = datevec(gnss_time/86400 + 6) + [1980 0 0 0 0 0]; 
