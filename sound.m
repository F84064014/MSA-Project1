clear all
close all
clc
load handel.mat

[y, fs] = audioread('sample.m4a');
%[y, fs] = audioread('house_lo.mp3')
time = (1:length(y))/fs;

subplot(2,1,1); %waveform
plot(time,y);
xlabel('second');
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
time_zcr = (1:length(zcr))*(length(y)/length(zcr)/frameSize);
subplot(2,1,2); %Energy
plot(time_zcr, zcr); %zero crossing rate
xlabel('second');
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
figure();
plot(time_en, en);
xlabel('second');
ylabel('Energy');
%===========================================================
%end point
f0 = pitch(y,fs); %Audio tool box required
figure();
plot(f0);

idx=detectSpeech(y,fs)
figure()
plot(y)
hold on
xline(idx(1))
xline(idx(2))
hold off

p = audioplayer(y, fs);
%play(p)


