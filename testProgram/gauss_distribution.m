function f = gauss_distribution(max,mu)

x = 0:1:1000;
p1 = -.5 * ((x - mu)/20) .^ 2;
p2 = (20 * sqrt(2*pi));
f = max*exp(p1) ./ p2;


