function [r,lastTrial] = trialCompleted(r,valid,correct)

% Indicates whether this was the last trial
lastTrial = false;

% trial successfully completed -> remove condition from pool
if correct
    r.curRep = r.curRep + 1;
    r.numTrials = r.numTrials - 1;
    
    % last trial?
    if r.numTrials == 0
        lastTrial = true;
    end
end


% fprintf('BlockRandomization: %d trials remaining\n',r.numTrials)
