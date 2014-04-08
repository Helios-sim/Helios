function set_up_daq

daq.getDevices
session=daq.createSession('ni')
ai0 = session.addAnalogInputChannel('cDAQ1Mod3','ai0','Voltage')
ai1 = session.addAnalogInputChannel('cDAQ1Mod3','ai1','Voltage')
ai2 = session.addAnalogInputChannel('cDAQ1Mod3','ai2','Voltage')

ai0.TerminalConfig = 'SingleEnded'
ai1.TerminalConfig = 'SingleEnded'
ai2.TerminalConfig = 'SingleEnded'

end



