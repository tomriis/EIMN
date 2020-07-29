function Lpar = parallelInductorNetworkCalculation(Z,w)
    ReZ = real(Z);
    ImZ = imag(Z);
    Xpar = ImZ*(1+(ImZ/ReZ)^2)/((ImZ/ReZ)^2);
    
    Lpar = -Xpar/(w);
end