function [L, C] = LNetworkCalculationLowPass(Z,Rg,w)
    ReZ = real(Z);
    ImZ = imag(Z);
    Q = sqrt(Rg/ReZ - 1);
    Xa = -1*(Rg^2)/(Q*Rg);
    Xb = Q*ReZ-ImZ;
    
    L = Xa/w;
    C = 1/(Xb*w);
    
    L = Rg/w*sqrt(ReZ/Rg-1);
    C = 1/(w*ReZ)*sqrt(ReZ/Rg-1)-4.5514e-10;
end