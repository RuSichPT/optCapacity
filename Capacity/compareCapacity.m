clc;clear;close all;
%% Задаем параметры
snr = 20;             % SNR в дБ
numChan = 100;
numRx = 100;
Nz = [4 5 6 7 8 9];
Ny = [8 10 12 14]; % 16 18 20
dz = [2 1.5 1.2 1 0.857 0.75];
dy = [0.514 0.4 0.33 0.277];% 0.24 0.212 0.19];
[resY,resZ] = checkAperture(Ny,dy,3.6,Nz,dz,6);
%%
C = zeros(length(Ny),length(Nz));
antennaType = 'patch';
BW(1) = 90;
BW(2) = 20;
ro_int = initRtx(antennaType,BW);
for i = 1:length(Ny)
    for j = 1:length(Nz)
        R = calculateRtx(dy(i),dz(j),Ny(i),Nz(j),ro_int);
%         R = 1; 
        numTx = Ny(i)*Nz(j);
        H = createKroneckerChannels(numTx,numRx,numChan,R,1);
        [tmpC, lambda_r] = calculateData(H,snr,numChan);
        C(i,j) = mean(tmpC);
        disp("calculated " + i + " " + j);
    end
end
%%
figure();
str = cell(1,length(Nz));
for j = 1:length(Nz)
    plot(Ny,C(:,j));
    hold on;
    str{j} = "Nz = " + num2str(Nz(j));
end
grid on;
xlabel("Ny " + antennaType);
ylabel('Mean Capacity');
legend(str{:})