function [ channel_order ] = WaveToCha( wave_order )
%WaveToCha takes a vector containing values in wavelength order, and
%rearranges it and gives as output a vector containing values in channel
%order. The wavelengths in the output vector is: 590, 720, 980, 830...


channel_order= zeros(1,16);
channel_order(1) = wave_order(10);
channel_order(2) = wave_order(16);
channel_order(3) = wave_order(13);
channel_order(4) = wave_order(6);
channel_order(5) = wave_order(5);
channel_order(6) = wave_order(3);
channel_order(7) = wave_order(11);
channel_order(8) = wave_order(8);
channel_order(9) = wave_order(7);
channel_order(10) = wave_order(12);
channel_order(11) = wave_order(2);
channel_order(12) = wave_order(1);
channel_order(13) = wave_order(14);
channel_order(14) = wave_order(15);
channel_order(15) = wave_order(9);
channel_order(16) = wave_order(4);


end

