function userInput = helperSpectralAnalysisUserInput
%helperSpectralAnalysisUserInput Spectral analysis example inputs
%   UIN = helperSpectralAnalysisUserInput displays questions on the
%   MATLAB command window and collects user input, UIN.
%
%   Captured Signal (comm.BasebandFileReader)
%   RTL-SDR Radio (comm.SDRRTLReceiver, requires RTL-SDR Support Package
%                  from Communications Systems Toolbox)
%   ADLAM-Pluto Radio (comm.SDRRxPluto, requires ADALM-Pluto Support Package
%                  from Communications Systems Toolbox)
%   USRP Radio (comm.SDRuReceiver, requires Communications Toolbox Support
%                   Package for USRP(TM) Radio)
%
%   UIN is a structure of user inputs with following fields:
%
%   * Duration:          Run time of example
%   * SourceType:        Source type
%   * RadioAddress:      Address string for radio (if radio is selected)
%   * ExpectedFrequency: Expected frequency of received tone
%
%   See also SpectralAnalysisExample.

%   Copyright 2022 The MathWorks, Inc.

controller = helperSpectralAnalysisController;

userInput = getUserInput(controller);
