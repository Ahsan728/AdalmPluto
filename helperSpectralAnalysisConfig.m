function [SAParams,sigSrc] = helperSpectralAnalysisConfig(varargin)
%helperSpectralAnalysisConfig Spectral Analysis system parameters
%   P = helperSpectralAnalysisConfig(UIN) returns Spectral Analysis system
%   parameters, P. UIN is the user input structure returned by the
%   helperSpectralAnalysisUserInput function.
%
%   See also SpectralAnalysisExample.

%   Copyright 2015-2023 The MathWorks, Inc.

if nargin == 0
  % Set defaults
  userInput.Duration = 10;
  userInput.SignalSourceType = ExampleSourceType.Captured;
  userInput.SignalFilename = 'spectrum_capture.bb';
  userInput.RadioAddress = '0';
  userInput.SDRuPlatform = 'N200/N210/USRP2';
  userInput.CenterFrequency = 98e6;
else
  tmp = varargin{1};
  if isstruct(tmp)
    userInput = varargin{1};
  else
    % Set defaults
    userInput.Duration = 10;
    userInput.SignalSourceType = ExampleSourceType.Captured;
    userInput.SignalFilename = 'spectrum_capture.bb';
    userInput.RadioAddress = '0';
    userInput.SDRuPlatform = tmp; % USRP Platform input for Simulink
    userInput.CenterFrequency = 98e6;
  end
end

% For Simulink
switch userInput.SDRuPlatform
  case {'B200','B210'}
    SAParams.SDRuMasterClockRate = 20e6; %Hz
  case {'X300','X310'}
    SAParams.SDRuMasterClockRate = 200e6; %Hz
  case {'N200/N210/USRP2'}
    SAParams.SDRuMasterClockRate = 100e6; %Hz
  case {'N300','N310'}
    SAParams.SDRuMasterClockRate = 125e6; %Hz
  case {'N320/N321'}
    SAParams.SDRuMasterClockRate = 200e6; %Hz
  otherwise
    error(message('sdru:examples:UnsupportedPlatform', userInput.SDRuPlatform))
end

SAParams.SDRufrontEndSampleRate = 5e6;
SAParams.DecimationFactor = SAParams.SDRuMasterClockRate/SAParams.SDRufrontEndSampleRate;
SAParams.RadioGain = 30;

% Create signal source
switch userInput.SignalSourceType
  case ExampleSourceType.Captured
    sigSrc = comm.BasebandFileReader(userInput.SignalFilename, 'CyclicRepetition', true);
    sigSrc.SamplesPerFrame = 1e4;
    frontEndSampleRate = sigSrc.SampleRate;
    SAParams.isSourcePlutoSDR = false;
    SAParams.isSourceRadio = false;
  case ExampleSourceType.RTLSDRRadio
    frontEndSampleRate = 1e6;
    FrameLength        = 256*20;  % Frame length
    sigSrc = comm.SDRRTLReceiver(userInput.RadioAddress,...
      'CenterFrequency',userInput.CenterFrequency,...
      'EnableTunerAGC',true,...
      'SampleRate',frontEndSampleRate,...
      'SamplesPerFrame', FrameLength, ...
      'OutputDataType','single');
    SAParams.isSourceRadio = true;
    SAParams.isSourcePlutoSDR = false;
    SAParams.isSourceUsrpRadio = false;
  case ExampleSourceType.PlutoSDRRadio
      frontEndSampleRate = 1e6;
      FrameLength = 10000;
      sigSrc = sdrrx('Pluto', ...
      'CenterFrequency', userInput.CenterFrequency, ...
      'GainSource', 'AGC Slow Attack', ...
      'BasebandSampleRate', frontEndSampleRate,...
      'SamplesPerFrame', FrameLength, ...
      'OutputDataType','single');
      SAParams.isSourceRadio = true;
      SAParams.isSourcePlutoSDR = true;
  case ExampleSourceType.USRPRadio
        frontEndSampleRate = 5e6;
        FrameLength = 10000;
        connectedRadios = findsdru(userInput.RadioAddress);
        if strncmp(connectedRadios(1).Status, 'Success', 7)
            platform = connectedRadios(1).Platform;
            switch connectedRadios(1).Platform
                case {'B200','B210'}
                    address = connectedRadios(1).SerialNum;
                case {'N200/N210/USRP2','X300','X310','N300','N310','N320/N321'}
                    address = connectedRadios(1).IPAddress;
            end
        else
            address = '192.168.10.2';
            platform = 'N200/N210/USRP2';
        end
        switch platform
            case {'B200','B210'}
                sigSrc = comm.SDRuReceiver(...
                    'Platform', platform, ...
                    'SerialNum', address, ...
                    'MasterClockRate', 20e6);
            case {'X300','X310','N320/N321'}
                sigSrc = comm.SDRuReceiver(...
                    'Platform', platform, ...
                    'IPAddress', address, ...
                    'MasterClockRate', 200e6);
            case {'N300','N310'}
                sigSrc = comm.SDRuReceiver(...
                    'Platform', platform, ...
                    'IPAddress', address, ...
                    'MasterClockRate', 125e6);
            case {'N200/N210/USRP2'}
                sigSrc = comm.SDRuReceiver(...
                    'Platform', platform, ...
                    'IPAddress', address, ...
                    'MasterClockRate', 100e6);
        end
        sigSrc.DecimationFactor = sigSrc.MasterClockRate/frontEndSampleRate;
        sigSrc.Gain = 31;
        sigSrc.CenterFrequency = userInput.CenterFrequency;
        sigSrc.SamplesPerFrame = FrameLength;
        sigSrc.OutputDataType = 'single';
        SAParams.isSourceRadio = true;
        SAParams.isSourcePlutoSDR = false;
        SAParams.isSourceUsrpRadio = true;
  otherwise
    error('comm_demos:common:Exit', 'Aborted.');
end

SAParams.CenterFrequency = sigSrc.CenterFrequency;
SAParams.FrontEndSampleRate = frontEndSampleRate;

frontEndSamplesPerFrame = sigSrc.SamplesPerFrame;
SAParams.FrontEndFrameTime = ...
    frontEndSamplesPerFrame / frontEndSampleRate;

SAParams.SamplesPerFrame = frontEndSamplesPerFrame;

SAParams.FrontEndSampleRate = frontEndSampleRate;
SAParams.FrontEndSamplesPerFrame = frontEndSamplesPerFrame;