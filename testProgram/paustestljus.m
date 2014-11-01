
light = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
lambdas = [720 980 830 590 520 490 750 660 630 780 450 420 880 945 680 515];
session.outputSingleScan(light)
disp('No light')
pause;
for i = 1:16
    if i == 2
        light(i) = 5;
    else
        light(i) = 1;
    end
    if i>1
        light(i-1) = 0;
    end
    
    
    session.outputSingleScan(light)
    disp([num2str(i) ', ' num2str(lambdas(i))])
    
    pause;
end

light = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
session.outputSingleScan(light)
disp('No light')
