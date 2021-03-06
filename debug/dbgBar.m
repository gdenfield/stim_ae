% Script to test TrialBasedExperiment
% AE 2007-10-08

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial

T = MovingBarExperiment(0);
T = set(T,'debug',true);

% set minimum amount of parameters for TrialBasedExperiment
T = netSetParam(T,struct('name','subject','type',1,'value','DEBUG'));
T = netSetParam(T,struct('name','bgColor','type',1,'value',[64; 64; 64]));
T = netSetParam(T,struct('name','fixSpotColor','type',1,'value',[255; 0; 0]));
T = netSetParam(T,struct('name','rewardProb','type',1,'value',1));

% set some randomized parameters to test randomization
T = netSetParam(T,struct('name','barSize','type',1,'value',[30; 300]));
T = netSetParam(T,struct('name','barColor','type',1,'value',[192; 192; 192]));
T = netSetParam(T,struct('name','speed','type',1,'value',1000));
T = netSetParam(T,struct('name','trajectoryCenter','type',1,'value',[600; 800]));
T = netSetParam(T,struct('name','trajectoryLength','type',1,'value',500));
T = netSetParam(T,struct('name','trajectoryAngle','type',1,'value',30));
T = netSetParam(T,struct('name','prior','type',2,'value',[0.5 0.2]));
T = netSetParam(T,struct('name','mapTime','type',1,'value',1000));
T = netSetParam(T,struct('name','mapFramesPerLoc','type',1,'value',3));
T = netSetParam(T,struct('name','mapTrials','type',1,'value',3));
T = netSetParam(T,struct('name','initMapTrials','type',1,'value',5));
T = netSetParam(T,struct('name','numSubBlocks','type',1,'value',2));
T = netSetParam(T,struct('name','movingTrials','type',1,'value',10));

T = openWindow(T);
T = netStartSession(T);

for i = 1:57
    fprintf('trial #%d\n',i)
    T = netStartTrial(T);
    T = netShowStimulus(T);
    T = netEndTrial(T);
    pause(0.5)
end

T = netEndSession(T);





