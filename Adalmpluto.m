% Importing necessary functions and objects
import comm.*

% Seting center frequency and sampling rate
centerFrequency = 90e6; 
samplingRate = 5e6; 

% Creating the PlutoSDR System object
pluto = sdrrx('Pluto');

% Setting the PlutoSDR properties
pluto.CenterFrequency = centerFrequency;
pluto.BasebandSampleRate = samplingRate;

% Setting receiver properties
pluto.GainSource = 'Manual';
pluto.Gain = 70;

% Start the receiver
pluto();

% Capture samples
numSamples = 10000; 
samples = pluto(); 

% Stop the receiver
release(pluto);

% Convert samples to double
samples = double(samples);

% Calculate power spectral density
[psd, freq] = pwelch(samples, rectwin(length(samples)), [], [], samplingRate);

% Finding the frequency index closest to the Wi-Fi signal frequency
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