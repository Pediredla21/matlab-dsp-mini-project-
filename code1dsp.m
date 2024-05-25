% Set the parameters
duration = 5; % Recording duration in seconds
fs = 44100; % Common Sampling frequency

% Adjust the cutoff frequency based on the background sound frequency
cutoffFrequency = 2000; % Set to a value higher than the background sound frequency

% Record voice
recObj = audiorecorder(fs, 16, 1);
disp('Press any key to start recording.');
pause;
disp('Start recording.');
recordblocking(recObj, duration);
disp('End of recording.');

% Get the recorded data
voiceData = getaudiodata(recObj);

% Display the original voice signal
figure;
subplot(3, 1, 1);
plot((0:length(voiceData)-1)/fs, voiceData);
title('Original Voice Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Apply a simple high-pass filter using 'highpass' function
voiceData_filtered = highpass(voiceData, cutoffFrequency, fs);

% Display the filtered voice signal
subplot(3, 1, 2);
plot((0:length(voiceData_filtered)-1)/fs, voiceData_filtered);
title('Filtered Voice Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Play the original and filtered voice signals
sound(voiceData, fs);
pause(duration + 1); % Pause to ensure the first sound is completed before the next
sound(voiceData_filtered, fs);

% Save the filtered voice signal (optional)
audiowrite('filtered_voice_highpass_background.wav', voiceData_filtered, fs);

% Apply FFT to the original signal
N_original = length(voiceData);
f_original = (0:N_original/2) * (fs/N_original);
Axk_original = 2 * abs(fft(voiceData) / N_original);
Axk_original(1) = Axk_original(1) / 2;

% Plot frequency domain of original signal
subplot(3, 1, 3);
plot(f_original, Axk_original(1:N_original/2+1));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Domain - Original Signal');

% Create a new figure for the frequency domain of the filtered signal
figure;
subplot(2, 1, 1);
plot(f_original, Axk_original(1:N_original/2+1));
title('Frequency Domain - Original Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% Apply FFT to the filtered signal
N_filtered = length(voiceData_filtered);
f_filtered = (0:N_filtered/2) * (fs/N_filtered);
Axk_filtered = 2 * abs(fft(voiceData_filtered) / N_filtered);
Axk_filtered(1) = Axk_filtered(1) / 2;

% Plot frequency domain of filtered signal
subplot(2, 1, 2);
plot(f_filtered, Axk_filtered(1:N_filtered/2+1));
title('Frequency Domain - Filtered Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');