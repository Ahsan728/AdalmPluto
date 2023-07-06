fs = 16000;  % Sample rate
duration = 5;  % Duration in seconds
recObj = audiorecorder(fs, 16, 1);  % Create audio recorder object
disp('Start recording...');
recordblocking(recObj, duration);  % Start recording and wait for completion
disp('Recording complete.');

% Get the recorded audio data
audioData = getaudiodata(recObj);

% Measure the power of the recorded audio
power = sum(audioData.^2) / length(audioData);
disp(['Power: ', num2str(power)]);

% Plot the waveform and power spectrum
plot(audioData);
title('Recorded Audio');
xlabel('Time (s)');
ylabel('Amplitude');
figure;
spectrogram(audioData, hann(256), 128, 1024, fs, 'yaxis');
title('Power Spectrum');