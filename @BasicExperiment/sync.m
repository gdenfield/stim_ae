function e = sync(e)
% Do clock synchronization.
%   We use a handshaking mechanism to synchronize the two clocks. 
%   The handshaking is initated by the LabView state system, but the actual
%   timing starts in this function. We take a timestamp, query the state system
%   for its timestamp and then take another timestamp. All three times are
%   stored in a buffer (e.sync). The content of this buffer can be retrieved by
%   [e,sync] = getSyncTimes(e)
%
% AE 2007-02-22

% get current time
e.sync(end).end = GetSecs * 1000;
roundTripTime = e.sync(end).end - e.sync(end).start;

% read state system time
stateSysTime = pnet(e.con,'read',1,'double');

% compute offset or request another timestamp
if roundTripTime < e.maxRoundTripTime
    
    % put state system response timestamp
    e.sync(end).response = stateSysTime;
    
    % append new field to the buffer
    e.sync(end+1).start = -Inf;
    
    % fprintf('* round trip time = %6.2f\n',roundTripTime)
    
    % send acknowledgement (1 = synchronization succeeded)
    pnet(e.con,'write',uint8(1));

else
    % round trip time too long => need another round
    % get new start time
    e.sync(end).start = GetSecs * 1000;
    
    % send failure notice (0 = send another timestamp)
    pnet(e.con,'write',uint8(0));
end
