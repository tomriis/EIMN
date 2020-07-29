function Lser = seriesInductorNetworkCalculation(Z,w)
    ImZ = imag(Z);
    Lser = ImZ/(w);
end