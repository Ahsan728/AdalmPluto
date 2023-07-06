classdef helperSpectralAnalysisController < ExampleController

%   Copyright 2016-2022 The MathWorks, Inc.

  properties (SetObservable, AbortSet)
    %CenterFrequency Spectrum Analysis channel frequency (Hz)
    CenterFrequency = 98e6
    %SDRuPlatform Default USRP platform
    SDRuPlatform = 'N200/N210/USRP2';
  end

  properties (Access=protected, Constant)
    ExampleName = 'SpectralAnalysisExample'
    ModelName = 'SpectralAnalysisExample'
    CodeGenCallback = @generateCodeCallback;
    
    MinContainerWidth = 290
    MinContainerHeight = 370

    Column1Width = 120
    Column2Width = 130
  end

  properties (Access=protected)
    HTMLFilename
    RunFunction = 'runSpectralAnalysis'
  end
  
  methods
    function obj = helperSpectralAnalysisController(varargin)
      obj@ExampleController(varargin{:});
      obj.HTMLFilename = 'comm/SpectralAnalysisExample';
      obj.SignalFilename = 'spectrum_capture.bb';
      obj.ExampleTitle = 'Spectral Analysis';
    end
    
    function set.CenterFrequency(obj, aFrequency)
        try
            validateattributes(aFrequency,{'numeric'},...
                {'scalar','real','finite','nonnan','positive'},...
                '', 'CenterFrequency');
            obj.CenterFrequency = aFrequency;
        catch me
            handleErrorsInApp(obj.SignalSourceController,me)
        end
    end
  end
  
  methods
      function flag = isInactiveProperty(obj,prop)
          switch prop
              case 'CenterFrequency'
                  if strcmp(obj.SignalSourceController.SignalSource, 'File')
                      flag = true;
                  else
                      flag = false;
                  end
              otherwise
                  flag = isInactiveProperty@ExampleController(obj, prop);
          end
      end
  end
  
  methods (Access = protected)
    
    function addWidgets(obj)
      obj.addRow('Duration', 'Duration (s)', 'edit', 'numeric');
      obj.addRow('SignalSource', 'Signal source', 'popupmenu');
      obj.addRow('RadioAddress', 'Radio address', 'popupmenu');
      obj.addRow('SignalFilename', 'Signal file name', 'edit', 'text');
      obj.addRow('CenterFrequency', 'Center frequency', 'edit', 'numeric');
    end
    
    function getUserInputImpl(obj)
        getCenterFrequency(obj);
    end
        
    function getCenterFrequency(obj)
      if ~isInactiveProperty(obj, 'CenterFrequency')
        freq = input(...
          sprintf('\n> Enter center frequency of spectrum (Hz) [%e]: ',...
          obj.CenterFrequency));
        if isempty(freq)
          freq = obj.CenterFrequency;
        end
        obj.CenterFrequency = freq;
      end
    end
  end
end

function generateCodeCallback(userInput)
  % CODEGEN COMMANDS NEED TO BE ADDED  
end
