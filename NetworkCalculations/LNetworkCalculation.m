f = 650000;
w = 2*pi*f;
baseDir = '/Users/tomriis/MATLAB/ImpedanceMeasure/vnaData/';
inductances = zeros(1,9);
capacitances = zeros(1,9);
for ii = 1:9
    filename = [baseDir,num2str(ii),'.s1p'];
    s = sparameters(filename);
    s1 = squeeze(s.Parameters);
    Z = sParamToZ(s1);
    [~,i] = min(abs(s.Frequencies - f));
    ReZ = real(Z(i));
    ImZ = imag(Z(i));
    Rg = 0.5;
    Xs = 0;
    Qswp = sqrt((ReZ/Rg)*(1+(ImZ/ReZ)^2)-1);

    Xa = abs(Z(i))^2/(-Qswp*ReZ+ImZ);

    Xb = -Qswp*Rg;

    La = Xa/(w);
    Cb = 1/(Xb*(w));
    inductances(ii) = La;
    capacitances(ii) = Cb;
    sign= 1;
    RHS = sqrt(ReZ*Rg*(ReZ^2+ImZ^2-ReZ*Rg));
    A  = (-1*ReZ*Xs+sign*RHS)/ReZ;
    B = (-1*ImZ*Rg + sign*RHS)/(Rg-ReZ);
    L = A/w;
    C = 1/(B*w);
end

median(La)
median(Cb)
