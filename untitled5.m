fs = 16000; % Sample rate
duration = 10; % Recording duration in seconds

recObj = audiorecorder(fs, 16, 1); % Create an audio recorder object

disp('Start recording...');
record(recObj); % Start recording

startTime = tic; % Start timer

while toc(startTime) < duration
    % Keep recording until the specified duration is reached
end

stop(recObj); % Stop recording
disp('Recording stopped.');

% Get the recorded audio data
voiceData = getaudiodata(recObj);

% Measure the power of the recorded audio
power = sum(voiceData.^2) / length(voiceData);
disp(['Power: ', num2str(power)]);

% Plot the waveform
time = (0:numel(voiceData)-1) / fs;
subplot(2, 1, 1);
plot(time, voiceData);
xlabel('Time (s)');
ylabel('Amplitude');
title('Recorded Audio Waveform');

% Compute and plot the power spectrum
nfft = 2^nextpow2(length(voiceData)); % Next power of 2 for FFT
frequencies = (0:nfft/2-1) * (fs/nfft); % Frequency axis
spectrum = abs(fft(voiceData, nfft)).^2 / (fs * length(voiceData)); % Power spectrum
subplot(2, 1, 2);
plot(frequencies, spectrum(1:nfft/2));
xlabel('Frequency (Hz)');
ylabel('Power');
title('Power Spectrum of Recorded Audio');