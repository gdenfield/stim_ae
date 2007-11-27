function r = computeConditions(r,params)
% Compute condition pool.
% AE 2007-10-05

r.conditions = struct('trialIndex',{}, ...
                      'blockSize',{}, ...
                      'blockType',{}, ...
                      'trialType',{});

% 1 trial regular block
r.conditions(end+1) = struct('trialIndex',1, ...
                             'blockSize',1, ...
                             'blockType',REGULAR_BLOCK(r), ...
                             'trialType',REGULAR_REWARD(r));
                  
for i = 2:r.maxBlockSize
    
    % regular blocks
    for j = 1:i-1
        r.conditions(end+1) = struct('trialIndex',j, ...
                                     'blockSize',i, ...
                                     'blockType',REGULAR_BLOCK(r), ...
                                     'trialType',REGULAR_NO_REWARD(r));
    end
    
    % last trial in regular block (here the monkey gets rewarded)
    r.conditions(end+1) = struct('trialIndex',i, ...
                                 'blockSize',i, ...
                                 'blockType',REGULAR_BLOCK(r), ...
                                 'trialType',REGULAR_REWARD(r));

    % probe blocks
    for j = 1:i-1
        r.conditions(end+1) = struct('trialIndex',j, ...
                                     'blockSize',i, ...
                                     'blockType',PROBE_BLOCK(r), ...
                                     'trialType',REGULAR_NO_REWARD(r));
        r.conditions(end+1) = struct('trialIndex',j, ...
                                     'blockSize',i, ...
                                     'blockType',PROBE_BLOCK(r), ...
                                     'trialType',PROBE(r));
    end

    % last trial in probe block (here the monkey gets rewarded)
    r.conditions(end+1) = struct('trialIndex',i, ...
                                 'blockSize',i, ...
                                 'blockType',PROBE_BLOCK(r), ...
                                 'trialType',REGULAR_REWARD(r));
end
