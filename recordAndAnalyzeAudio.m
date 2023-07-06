function recordAndAnalyzeAudio(duration, sampleRate)
    recObj = audiorecorder(sampleRate, 16, 1); % Create an audio recorder object

    disp('Start recording...');
    record(recObj);

    % Initialize figure and plot
    figure;
    hPlot = plot(NaN, 'LineWidth', 1.5);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Live Audio Recording');
    axis tight;

    startTime = tic; % Start timer
    while toc(startTime) < duration
        % Update plot with current audio data
        voiceData = getaudiodata(recObj);
        set(hPlot, 'YData', voiceData);

        drawnow; % Force immediate plot update
    end

    stop(recObj); % Stop recording
    disp('Recording stopped.');

    % Get the recorded audio data
    voiceData = getaudiodata(recObj);
    
    % Compute power and energy
    power = sum(voiceData.^2) / length(voiceData);
    energy = sum(voiceData.^2) / sampleRate;

    disp(['Power: ', num2str(power) , ' W']);
    disp(['Energy: ', num2str(energy), ' J']);

    % Plot the waveform
    time = (0:numel(voiceData)-1) / sampleRate;
    subplot(2, 1, 1);
    plot(time, voiceData);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Recorded Audio Waveform');

    % Compute and plot the power spectrum
    nfft = 2^nextpow2(length(voiceData)); % Next power of 2 for FFT
    frequencies = (0:nfft/2-1) * (sampleRate/nfft); % Frequency axis
    spectrum = abs(fft(voiceData, nfft)).^2 / (sampleRate * length(voiceData)); % Power spectrum
    subplot(2, 1, 2);
    plot(frequencies, spectrum(1:nfft/2));
    xlabel('Frequency (Hz)');
    ylabel('Power');
    title('Power Spectrum of Recorded Audio');
    % Set custom axis limits
    xlim([0, max(frequencies)]);
    ylim([0, max(spectrum)]);
end