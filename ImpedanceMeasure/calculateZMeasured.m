function [R, I, Z, U1, U2, phi, scopeFreq] = calculateZMeasured(filename, Res, varargin)
    if ~isempty(varargin)
        lowFCutOff = varargin{1}(1);
        highFCutOff = varargin{1}(2);
    end
    A = csvread(filename);
    scopeFreq = A(:,1);
    maskScope = and(scopeFreq>=lowFCutOff, scopeFreq<=highFCutOff);
    U1 = A(maskScope,2); U2 = A(maskScope,3); phi = A(maskScope,4);
    scopeFreq = scopeFreq(maskScope);
    [R, I, Z] = data2Impedance(U1, U2, phi, Res);

end