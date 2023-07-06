% Import necessary functions and objects
import comm.*

% Set center frequency and sampling rate
centerFrequency = 2.4e9; % Set to your desired frequency in Hz
samplingRate = 5e6; % Set to your desired sampling rate in Hz

% Create the PlutoSDR System object
pluto = sdrrx('Pluto');

% Set the PlutoSDR properties
pluto.CenterFrequency = centerFrequency;
pluto.BasebandSampleRate = samplingRate;

% Set receiver properties
pluto.GainSource = 'Manual';
pluto.Gain = 70; % Set to your desired gain value in dB

% Start the receiver
pluto();

% Capture samples
numSamples = 10000; % Specify the number of samples to capture
samples = pluto(); % Capture samples from the PlutoSDR

% Stop the receiver
release(pluto);

% Convert samples to double
samples = double(samples);

% Calculate power spectral density
[psd, freq] = pwelch(samples, rectwin(length(samples)), [], [], samplingRate);

% Find the frequency index closest to the Wi-Fi signal frequency
[~, freqIndex] = min(abs(freq - centerFrequency));

% Calculate the power at the Wi-Fi signal frequency
power = 10 * log10(psd(freqIndex));

% Display the power value
disp(['Power: ' num2str(power) ' dBm']);

% Plot the frequency spectrum
plot(freq, 10 * log10(psd));
xlabel('Frequency (Hz)');
ylabel('Power Spectral Density (dB/Hz)');
title('Frequency Spectrum');
grid on;