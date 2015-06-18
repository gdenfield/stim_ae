function [e, retInt32, retStruct, returned] = netShowStimulus(e, params)
% Show a sequence of windowed image stimuli. The sequence is carefully
% constructed to avoid repeat in filteration condition (e.g. phase
% scrambled, white noised, etc) for two adjacent substimuli (images)
% presentation. Refer to the randomization code for details on teh process.
% 
% authors: eywalker, gdenfield, leon

win = get(e,'win');
refreshRate = get(e,'refreshRate');


% load experiment params
nIm = getParam(e,'imPerTrial');                                 % number of images to be shown per trial; the total image number must be divisible by this
imTime = getParam(e,'imTime');                                  % duration of each image presentation in milliseconds
blankTime = getParam(e,'blankTime');                            % duration between each image presentation in millseconds
bgColor = getParam(e,'bgColor');                                % stimulus background color: RGB with each in range [0, 255]
stimTime = nIm * (imTime + blankTime);                          % total duration of the stimulus in milliseconds
postStimTime = getParam(e, 'postStimulusTime');                 % duration between stimuli presentation in milliseconds

%write delayTime
params.delayTime = stimTime + postStimTime;                     % delay time is the duration between fixation and release

% frame duration in milliseconds
% typically ~= 10 msec
flipInterval = 1000 / refreshRate; 

% show one randomly drawn sequence of nIm images
conditions = getConditions(get(e, 'randomization'));
cond = getParam(e, 'condition');

% get sequence of substimuli
imNums = conditions(cond).imNums;
% get sequence of image condition indices
statIdx = conditions(cond).statIndex;

%return function call
tcpReturnFunctionCall(e, int32(0), params, 'netShowStimulus');


% initialization for the loop
cIm = 1; 
t = -Inf;
blank = true;

while cIm <= nIm
    
    % was there an abort during stimulus presentation?
    [e, abort] = tcpMiniListener(e, {'netAbortTrial', 'netTrialOutcome'});
    if abort
        fprintf('Abort during stimulus\n')
        break
    end
    
    if blank && (GetSecs - t > (blankTime - flipInterval) / 1000)
        % if blank is shown for blankTime - (time of one frame), show image in
        % the next frame
        
        Screen('DrawTexture', win, e.textures(statIdx(cIm),imNums(cIm)), [], e.destRect);
        Screen('DrawTexture', win, e.alphaMask);
        drawFixSpot(e);
        blank = false;
        
        e = swap(e);
        t = getLastSwap(e);
                
        if cIm == 1
            % add 'showStimulus' event after first substimulus is on
            e = addEvent(e,'showStimulus', t);
        end
        
        % add 'showSubStimulus' event for each substimulus presentation
        e = addEvent(e,'showSubStimulus', t);
        
    elseif GetSecs-t > (imTime-flipInterval)/1000
        % if image is shown for imTime - (time of one frame), show blank 
        % screen in the next frame
        Screen('FillRect', win, bgColor, e.destRect);
        drawFixSpot(e);
        blank = true;
        
        e = swap(e);
        
        cIm = cIm + 1;
        if cIm == nIm + 1
            % if this is the last substimulus, add 'endStimulus' event
            endTime = getLastSwap(e);
            e = addEvent(e, 'endStimulus', endTime);
        end
    end
    
    % wait a little to relax the cpu
    WaitSecs(flipInterval/10000)
    
end

% wait for postStimTime duration (minus one frame duration)
WaitSecs((postStimTime-flipInterval)/1000);

% remove fixation spot
if ~abort
    e = clearScreen(e);
end


% return values
retInt32 = int32(0);
retStruct = struct;
returned = true;
