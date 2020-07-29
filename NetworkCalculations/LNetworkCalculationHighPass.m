function [La, Cb] = LNetworkCalculationHighPass(Z,Rg,w)
    ReZ = real(Z);
    ImZ = imag(Z);
    Qswp = sqrt((ReZ/Rg)*(1+(ImZ/ReZ)^2)-1);

    Xa = abs(Z)^2/(-Qswp*ReZ+ImZ);

    Xb = -Qswp*Rg;

    La = Xa/(w);
    Cb = 1/(Xb*(w));

end
    