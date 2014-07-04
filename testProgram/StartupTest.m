
s=daq.createSession('ni');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao0', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao1', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao2', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao3', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao4', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao5', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao6', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao7', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao8', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao9', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao10', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao11', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao12', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao13', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao14', 'Voltage');
s.addAnalogOutputChannel('cDAQ1Mod1', 'ao15', 'Voltage');
s.outputSingleScan(zeros(1,16));