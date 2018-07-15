clear; close all; clc; format short g;

x = linspace(0,2*pi,100);
y = sin(x);
z = cos(x);

plot(x,y);
custom_m2t_fcn('sin_x',50, false);
close;
plot(x,z);
custom_m2t_fcn('cos_x',50, false);

close;
x = -2:0.25:2;
y = x;
[X,Y] = meshgrid(x);
F = X.*exp(-X.^2-Y.^2);
surf(X,Y,F)
custom_m2t_fcn('three_d',50, false);