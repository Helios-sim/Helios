function [M, QM] = createSquareWave(length, rate)
%CREATESQUAREWAVE Summary of this function goes here
%   Detailed explanation goes here
t = (0:(1/rate):(length - 1)/rate)';
QM = [450 500 550 600 650 700 750 820 900 950 1000 1200 1400 1600 1800 2500];
m1 = (1 + square(2*pi*QM(1)*t))./2;
m2 = (1 + square(2*pi*QM(2)*t))./2;
m3 = (1 + square(2*pi*QM(3)*t))./2;
m4 = (1 + square(2*pi*QM(4)*t))./2;
m5 = (1 + square(2*pi*QM(5)*t))./2;
m6 = (1 + square(2*pi*QM(6)*t))./2;
m7 = (1 + square(2*pi*QM(7)*t))./2;
m8 = (1 + square(2*pi*QM(8)*t))./2;
m9 = (1 + square(2*pi*QM(9)*t))./2;
m10 = (1 + square(2*pi*QM(10)*t))./2;
m11 = (1 + square(2*pi*QM(11)*t))./2;
m12 = (1 + square(2*pi*QM(12)*t))./2;
m13 = (1 + square(2*pi*QM(13)*t))./2;
m14 = (1 + square(2*pi*QM(14)*t))./2;
m15 = (1 + square(2*pi*QM(15)*t))./2;
m16 = (1 + square(2*pi*QM(16)*t))./2;

M = [m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15 m16];
end

