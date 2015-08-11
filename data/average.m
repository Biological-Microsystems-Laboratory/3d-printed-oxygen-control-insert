clear
%N1 = csvread('analyzed-oxygen-values-150805.csv');
%N2 = csvread('analyzed-oxygen-values-150807.csv');
%N3 = csvread('analyzed-oxygen-values-150808.csv');

A = zeros(73,24,2);
A(:,:,1)= csvread('analyzed-oxygen-values-150805.csv');
A(:,:,2)= csvread('analyzed-oxygen-values-150807.csv');
%A(:,:,2)= csvread('analyzed-oxygen-values-150808.csv');
ave = mean(A,3);
csvwrite('average.csv',ave)
S = std(A,0,3);
csvwrite('std.csv',S)
%plot(ave)
errorbar(ave,S)