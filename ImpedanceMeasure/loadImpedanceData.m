function [Z, s, s1] = loadImpedanceData(filename)
    s = sparameters(filename);
    s1 = squeeze(s.Parameters);
    Z = sParamToZ(s1);
end