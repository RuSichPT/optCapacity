clc;clear;close all;
%% Задаем параметры
numChan = 100;
numUsers = 100;
seed = 200;
sizeArray = [4 4]; 
power = 1e7;
myArray = '3gpp-mmw';
spacing = [0.5 0.5];
tilt = 0;
fc = 3.5e9;
%% Канал
[aBS,aMS] = generate_aBS_aMS(sizeArray,spacing,power,myArray,fc,tilt);
[H, Ch, l, b] = generate3GPPChannels(aBS,aMS,numUsers,numChan,seed);
%% Пропускная способность
snr_dB = 0;
[C, ~] = calculateData(H,snr_dB,numChan);
%% Save
name = "Capacity/dataBase/data/ant=" + sizeArray(1) + "x" + sizeArray(2) + "_numChan=" + numChan + "_users=" + numUsers ...
    + "_spacing=" + spacing + "_seed=" + seed + "_my=" + myArray + ".mat";
save(name,"H","C","myArray");