function [R, I, Z] = data2Impedance(U1,U2,theta, Res)
theta = deg2rad(-theta);

RY = 1/Res * (1 - (U1./U2).*sin(theta));

IY = -1/Res * (U1./U2).*sin(theta);

R = 1./RY;
I = 1./IY;
Z = 1./(RY + 1j*IY);
end