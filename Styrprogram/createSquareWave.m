function M = createSquareWave(length)
%CREATESQUAREWAVE Summary of this function goes here
%   Detailed explanation goes here
t = (0:0.00005:(length/20000))';
m1 = (1 + square(2*pi*450*t))./2;
m2 = (1 + square(2*pi*500*t))./2;
m3 = (1 + square(2*pi*550*t))./2;
m4 = (1 + square(2*pi*600*t))./2;
m5 = (1 + square(2*pi*650*t))./2;
m6 = (1 + square(2*pi*700*t))./2;
m7 = (1 + square(2*pi*750*t))./2;
m8 = (1 + square(2*pi*820*t))./2;
m9 = (1 + square(2*pi*900*t))./2;
m10 = (1 + square(2*pi*950*t))./2;
m11 = (1 + square(2*pi*1000*t))./2;
m12 = (1 + square(2*pi*1200*t))./2;
m13 = (1 + square(2*pi*1400*t))./2;
m14 = (1 + square(2*pi*1600*t))./2;
m15 = (1 + square(2*pi*1800*t))./2;
m16 = (1 + square(2*pi*2000*t))./2;

M = [m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15 m16];
end

