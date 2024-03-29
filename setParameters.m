 % (C) Copyright 2020 CPP visual motion localizer developpers

function [cfg] = setParameters()

    % 

    % Initialize the parameters and general configuration variables
    cfg = struct();
    cfg.subject.askGrpSess = [false true];% this stops the GUI input for subject group. comment it if you want to ask for subject group

    % by default the data will be stored in an output folder created where the
    % setParamters.m file is
    % change that if you want the data to be saved somewhere else
    cfg.dir.output = fullfile( ...
                              fileparts(mfilename('fullpath')),'output');

    %% Debug mode settings

    cfg.debug.do = false; % To test the script out of the scanner, skip PTB sync
    cfg.debug.smallWin = false; % To test on a part of the screen, change to 1
    cfg.debug.transpWin = false; % To test with trasparent full size screen

    cfg.skipSyncTests = 1;

    cfg.verbose = 1;

    %% Engine parameters

    cfg.testingDevice = 'mri';
    cfg.eyeTracker.do = false;
    cfg.audio.do = true;

    cfg = setMonitor(cfg);

    % Keyboards
    cfg = setKeyboards(cfg);

    % MRI settings
    cfg = setMRI(cfg);
    cfg.suffix.acquisition = '';% '0p75mmEvTr2p18';

    cfg.pacedByTriggers.do = false;

    %% Experiment Design

    % switching this on to MT or MT/MST with use:
    % - MT: translational motion on the whole screen
    %   - alternates static and motion (left or right) blocks
    % - MST: radial motion centered in a circle aperture that is on the opposite
    % side of the screen relative to the fixation
    %   - alternates fixaton left and fixation right
    cfg.design.localizer = 'MT';
    % cfg.design.localizer = 'MT_MST';

    cfg.design.motionType = 'translation';
%     cfg.design.motionDirections = [0 180 90 270];
    cfg.design.motionDirectionsHorizontal = [180 0];%auditory cue says right for 180 but it is left for participantsts, visual stim is left for 180
    cfg.design.motionDirectionsVertical = [90 270];
    cfg.design.names = {'horizontal';'vertical'};
    cfg.design.nbRepetitions = 4;% X2 = number of blocks
    cfg.design.nbEventsPerBlock = 14; % number of events 
    
    %Randomising in chunks/ runs so that easy to separate
    cfg.design.blockOrder = [shuffle(1:cfg.design.nbRepetitions), shuffle(1:cfg.design.nbRepetitions)];%[randperm(cfg.design.nbRepetitions), randperm(cfg.design.nbRepetitions)];
%     cfg.task.name = 'visual';%, 'handUp', 'handDown'};
    cfg.taskList = {'handDown', 'handUp', 'visual'};
%     cfg.taskList(randperm(3));
    

    %% Timing

    % FOR 7T: if you want to create localizers on the fly, the following must be
    % multiples of the scanneryour sequence TR
    %
    % IBI
    % block length = (cfg.eventDuration + cfg.ISI) * cfg.design.nbEventsPerBlock
    cfg.timing.instructions = 2;
    cfg.timing.eventDuration = 0.5; % second -for visual stim it becomes 1s 
    
    % Time between blocs in secs
    cfg.timing.IBI = [5.7800    5.3419    6.8000    6.5483    5.4044    5.4333    5.7721    0];%5;
    % Time between events in secs
    cfg.timing.ISI.vis = 0.5;
    cfg.timing.ISI.tac = 2;
    % Number of seconds before the motion stimuli are presented
%     cfg.timing.onsetDelay = 5.25;
    
    % Number of seconds before the motion stimuli are presented: different
    % for visual and tactile blocks
%     if strcmp(cfg.task.name,'visual')==1
%         cfg.timing.onsetDelay = 5.25;
%     elseif strcmp(cfg.task.name,'handUp')==1
%         cfg.timing.onsetDelay = 4.75;%5.25; - 0.5 from the auditory cue script to compensate for tactile stimulation, this keeps 5.25s for tactile localizer
%     elseif strcmp(cfg.task.name,'handDown')==1
%         cfg.timing.onsetDelay = 4.75;%5.25; - 0.5 from the auditory cue script to compensate for tactile stimulation, this keeps 5.25s for tactile localizer
%     end
    
    % Number of seconds after the end all the stimuli before ending the run
    cfg.timing.endDelay = 14;

    % reexpress those in terms of repetition time
    if cfg.pacedByTriggers.do

        cfg.pacedByTriggers.quietMode = true;
        cfg.pacedByTriggers.nbTriggers = 5;

        cfg.timing.eventDuration = cfg.mri.repetitionTime / 2 - 0.04; % second

        % Time between blocs in secs
        cfg.timing.IBI = 0;
        % Time between events in secs
        cfg.timing.ISI = 0;
        % Number of seconds before the motion stimuli are presented
        cfg.timing.onsetDelay = 0;
        % Number of seconds after the end all the stimuli before ending the run
        cfg.timing.endDelay = 2;

    end
    
     %% Auditory Stimulation

    cfg.audio.channels = 1;

    %% Visual Stimulation

    % Speed in visual angles / second
    cfg.dot.speed = 15;
    % Coherence Level (0-1)
    cfg.dot.coherence = 1;
    % Number of dots per visual angle square.
    cfg.dot.density = 1;
    % Dot life time in seconds
    cfg.dot.lifeTime = 0.4;
    % proportion of dots killed per frame
    cfg.dot.proportionKilledPerFrame = 0;
    % Dot Size (dot width) in visual angles.
    cfg.dot.size = .25;
    cfg.dot.color = cfg.color.white;

    % Diameter/length of side of aperture in Visual angles
    cfg.aperture.type = 'circle';
    cfg.aperture.width = []; % if left empty it will take the screen height
    cfg.aperture.xPos = 0;

    %% Task(s)

    

    % Instruction
%     cfg.task.instruction = 'Detect the repeated direction\n \n\n';

    % Fixation cross (in pixels)
    cfg.fixation.type = 'cross';
    cfg.fixation.colorTarget = cfg.color.white;
    cfg.fixation.color = cfg.color.white;
    cfg.fixation.width = .25;
    cfg.fixation.lineWidthPix = 3;
    cfg.fixation.xDisplacement = 0;
    cfg.fixation.yDisplacement = 0;

    % target
    cfg.target.maxNbPerBlock = 2;
    cfg.target.duration = 0.1; % In secs
    cfg.target.type = 'fixation_cross';  
    % 'fixation_cross' : the fixation cross changes color
    % 'static_repeat' : dots are in the same position

    cfg.extraColumns = { ...
                        'modality_type',...
                        'anat_dir',...
                        'ext_dir',...
                        'direction', ...
                        'speedDegVA', ...
                        'target', ...
                        'event', ...
                        'block', ...
                        'keyName', ...
                        'fixationPosition', ...
                        'aperturePosition'};
                    
    %% orverrireds the relevant fields in case we use the MT / MST localizer
    cfg = setParametersMtMst(cfg);

end

function cfg = setKeyboards(cfg)
    cfg.keyboard.escapeKey = 'ESCAPE';
    cfg.keyboard.responseKey = { 'a', 'b', 'c', 'd'};
    cfg.keyboard.keyboard = [];
    cfg.keyboard.responseBox = [];

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.keyboard.keyboard = [];
        cfg.keyboard.responseBox = [];
    end
end

function cfg = setMRI(cfg)
    % letter sent by the trigger to sync stimulation and volume acquisition
    cfg.mri.triggerKey = 's';
    cfg.mri.triggerNb = 1;

    cfg.mri.repetitionTime = 1.75;

    cfg.bids.MRI.Instructions = 'Detect the repeated direction';
    cfg.bids.MRI.TaskDescription = [];
    cfg.bids.mri.SliceTiming = [0, 0.875, 0.0673, 0.9423, 0.1346, 1.0096, 0.2019, 1.0769, 0.2692, 1.1442,...
        0.3365, 1.2115, 0.4038, 1.2788, 0.4711, 1.3461, 0.5384, 1.4134, 0.6057, 1.4807,...
        0.673, 1.548, 0.7403, 1.6826, 0.8076, 1.6153, 0, 0.875, 0.0673, 0.9423, ...
        0.1346, 1.0096, 0.2019, 1.0769, 0.2692, 1.1442, 0.3365, 1.2115, 0.4038, 1.2788,...
        0.4711, 1.3461, 0.5384, 1.4134, 0.6057, 1.4807, 0.673, 1.548, 0.7403, 1.6826,...
        0.8076, 1.6153];

end

function cfg = setMonitor(cfg)
    % text size
    cfg.text.size = 48;
    
    % Monitor parameters for PTB
    cfg.color.white = [255 255 255];
    cfg.color.black = [0 0 0];
    cfg.color.red = [255 0 0];
    cfg.color.grey = mean([cfg.color.black; cfg.color.white]);
    cfg.color.background = cfg.color.black;
    cfg.text.color = cfg.color.white;

    % Monitor parameters
    cfg.screen.monitorWidth = 50; % in cm
    cfg.screen.monitorDistance = 40; % distance from the screen in cm

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.screen.monitorWidth = 69.8; % 25;
        cfg.screen.monitorDistance = 170; %95;
    end

end

function cfg = setParametersMtMst(cfg)

    if isfield(cfg.design, 'localizer') && strcmpi(cfg.design.localizer, 'MT_MST')

        cfg.task.name = 'mt mst localizer';

        cfg.design.motionType = 'radial';
        cfg.design.motionDirections = [666 666 -666 -666];
        cfg.design.names = {'fixation_right'; 'fixation_left'};
        cfg.design.xDisplacementFixation = 7;
        cfg.design.xDisplacementAperture = 3;

        cfg.timing.IBI = 3.6;

        % reexpress those in terms of repetition time
        if cfg.pacedByTriggers.do

            cfg.timing.IBI = 2;

        end

        cfg.aperture.type = 'circle';
        cfg.aperture.width = 7; % if left empty it will take the screen height
        cfg.aperture.xPos = cfg.design.xDisplacementAperture;

    end

end
