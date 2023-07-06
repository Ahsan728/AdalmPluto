function FunctionCode(duration, sampleRate)
    recObj = audiorecorder(sampleRate, 16, 1); % Create an audio recorder object

    disp('Start recording...');
    recordblocking(recObj, duration); % Start and block until recording is complete

    disp('Recording stopped.');

    % Get the recorded audio data
    voiceData = getaudiodata(recObj);

    % Measure the power of the recorded audio
    power = sum(voiceData.^2) / length(voiceData);
    disp(['Power: ', num2str(power)]);

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
end