clear all
close all
clc
load handel.mat

[y, fs] = audioread('sample.wav');
y = y(:,2);
%two channel right and left
%depend on the input device you use
time = (1:length(y))/fs;

figure('Name','waveform');
plot(time,y);
xlabel('Time(s)');
ylabel('magnitude');

%====================================================================
%zero crossing rate
%ref:
%https://www.itread01.com/content/1549721349.html
frameSize=256;
overlap=0;
ylen = length(y);
step = frameSize - overlap;
frameNum = fix(ylen/step);
zcr = zeros(frameNum, 1);
for i=1:frameNum
    curFrame = y(i*step:min(i*step+frameSize,ylen));
    curFrame = curFrame-round(mean(curFrame)); %zero-justified
    zcr(i) = sum(curFrame(1:end-1).*curFrame(2:end)<0);
end
zcr = zcr.'; %transpose
time_zcr = (1:length(zcr))*frameSize/fs;
figure('Name','Zero-crossing rate')
plot(time_zcr, zcr); %zero crossing rate
xlabel('Time(s)');
ylabel('ZCR');
%===============================================================
%Energy
clearvars curFrame %clear variable 
en = zeros(frameNum, 1);
for i=1:frameNum
    curFrame = y(i*step:min(i*step+frameSize, ylen));
    en(i) = sum(curFrame(1:end-1).*curFrame(2:end));
end
time_en = (1:length(en))*(length(y)/length(en)/fs);
figure('Name','Enegy');
plot(time_en, en);
xlabel('Time(s)');
ylabel('Energy');
%===========================================================
%ref:
%https://www.mathworks.com/help/audio/ref/pitch.html
[f0, idx_p] = pitch(y,fs); %Audio tool box required
figure('Name','Pitch');
time_p = idx_p/fs;
plot(time_p, f0);
xlabel('Time(s)')
ylabel('Frequecy(Hz)');
%========================================================
%ref:
%https://www.mathworks.com/help/audio/ref/detectspeech.html
figure('Name','end point');
detectSpeech(y,fs);

p = audioplayer(y, fs);
%play(p)


