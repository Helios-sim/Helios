function set_up_daq

daq.getDevices
session=daq.createSession('ni')
session.Rate = 100000;
session.DurationInSeconds = 1;

% Analog input
ai0 = session.addAnalogInputChannel('cDAQ1Mod3','ai0','Voltage')
ai1 = session.addAnalogInputChannel('cDAQ1Mod3','ai1','Voltage')
ai2 = session.addAnalogInputChannel('cDAQ1Mod3','ai2','Voltage')

ai0.TerminalConfig = 'SingleEnded'
ai1.TerminalConfig = 'SingleEnded'
ai2.TerminalConfig = 'SingleEnded'

%Digital output
do0 = session.addDigitalChannel('cDAQ1Mod2','port0/line0','OutputOnly');
do1 = session.addDigitalChannel('cDAQ1Mod2','port0/line1','OutputOnly');
do2 = session.addDigitalChannel('cDAQ1Mod2','port0/line2','OutputOnly');
do3 = session.addDigitalChannel('cDAQ1Mod2','port0/line3','OutputOnly');
do4 = session.addDigitalChannel('cDAQ1Mod2','port0/line4','OutputOnly');
do5 = session.addDigitalChannel('cDAQ1Mod2','port0/line5','OutputOnly');
do6 = session.addDigitalChannel('cDAQ1Mod2','port0/line6','OutputOnly');
do7 = session.addDigitalChannel('cDAQ1Mod2','port0/line7','OutputOnly');
do8 = session.addDigitalChannel('cDAQ1Mod2','port0/line8','OutputOnly');
do9 = session.addDigitalChannel('cDAQ1Mod2','port0/line9','OutputOnly');
do10 = session.addDigitalChannel('cDAQ1Mod2','port0/line10','OutputOnly');
do11 = session.addDigitalChannel('cDAQ1Mod2','port0/line11','OutputOnly');
do12 = session.addDigitalChannel('cDAQ1Mod2','port0/line12','OutputOnly');
do13 = session.addDigitalChannel('cDAQ1Mod2','port0/line13','OutputOnly');
do14 = session.addDigitalChannel('cDAQ1Mod2','port0/line14','OutputOnly');
do15 = session.addDigitalChannel('cDAQ1Mod2','port0/line15','OutputOnly');
%Ytterst tveksam till om det funkar så här
do16 = session.addDigitalChannel('cDAQ1Mod2','port0/line16:32','OutputOnly');

% Analog output
ao0 = session.addAnalogOutputChannel('cDAQ1Mod1','ao0','Voltage');
ao1 = session.addAnalogOutputChannel('cDAQ1Mod1','ao1','Voltage');
ao2 = session.addAnalogOutputChannel('cDAQ1Mod1','ao2','Voltage');
ao3 = session.addAnalogOutputChannel('cDAQ1Mod1','ao3','Voltage');
ao4 = session.addAnalogOutputChannel('cDAQ1Mod1','ao4','Voltage');
ao5 = session.addAnalogOutputChannel('cDAQ1Mod1','ao5','Voltage');
ao6 = session.addAnalogOutputChannel('cDAQ1Mod1','ao6','Voltage');
ao7 = session.addAnalogOutputChannel('cDAQ1Mod1','ao7','Voltage');
ao8 = session.addAnalogOutputChannel('cDAQ1Mod1','ao8','Voltage');
ao9 = session.addAnalogOutputChannel('cDAQ1Mod1','ao9','Voltage');
ao10 = session.addAnalogOutputChannel('cDAQ1Mod1','ao10','Voltage');
ao11 = session.addAnalogOutputChannel('cDAQ1Mod1','ao11','Voltage');
ao12 = session.addAnalogOutputChannel('cDAQ1Mod1','ao12','Voltage');
ao13 = session.addAnalogOutputChannel('cDAQ1Mod1','ao13','Voltage');
ao14 = session.addAnalogOutputChannel('cDAQ1Mod1','ao14','Voltage');
ao15 = session.addAnalogOutputChannel('cDAQ1Mod1','ao15','Voltage');

end



