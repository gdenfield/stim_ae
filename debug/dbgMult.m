% Script to test FlePhysExperiment
% AE 2008-09-02

warning off TrialBasedExperiment:netStartTrial
warning off TrialBasedExperiment:netEndTrial
warning off StimulationData:setTrialParam
warning off StimulationData:setParam

try

T = MultDimExperiment;
T = set(T,'debug',true);
T = openWindow(T);

% PARAMETERS for config file
constants.fixSpotColor = [255; 0; 0];
constants.fixSpotLocation = [0; 0];
constants.fixSpotSize = 10;
constants.bgColor = [128; 128; 128];

constants.location = [50; 50];
constants.diskSize = 400;
constants.stimFrames = 2;

constants.contrast = [50 100];
constants.spatialFreq = [0.05 0.1];
constants.orientation = (0:7) * 22.5;
constants.initialPhase = (0:1) * pi/2;
constants.color = [1 1 1; 1 0 0; 0 1 0; 0 0 1]';

constants.stimulusTime = 1000;
constants.postStimTime = 300;

constants.delayTime = 800;
constants.subject = 'DEBUG';
constants.eyeControl = 0;
constants.rewardProb = 1;
constants.joystickThreshold = 200;
constants.fixationRadius = 50;
constants.passive = 1;
constants.acquireFixation = 1;
constants.allowSaccades = 0;
constants.rewardAmount = 0;
constants.date = datestr(now,'YYYY-mm-dd_HH-MM-SS');

trials = struct;

T = netStartSession(T,constants);

for i = 1:50
    
    fprintf('trial #%d\n',i)

    T = netStartTrial(T,trials);
    T = netSync(T,struct('counter',0));
    T = netSync(T,struct('counter',1));
    T = netInitTrial(T);
    
    T = netShowFixSpot(T,struct);
    pause(0.5)
    
    T = netShowStimulus(T,struct);
    
    T = netTrialOutcome(T,struct('correctResponse',true,'behaviorTimestamp',NaN));
    T = netEndTrial(T);

    pause(0.5)
end

T = netEndSession(T);
T = cleanUp(T);

catch
    sca
    err = lasterror;
    error(err)
end