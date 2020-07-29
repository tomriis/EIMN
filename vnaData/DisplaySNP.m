f = 650000;
lowFCutOff = 0.450;
highFCutOff = 0.85;
baseDir = 'C:\Users\Tom\Documents\MATLAB\EIMN\vnaData\20200724\';
ii = 5;
filenames = {[baseDir,'XDR',num2str(ii),'NOMICROCOAX','.s1p'],
    [baseDir,'XDR',num2str(ii),'WMC','.s1p']};


figure;
for k = 1:length(filenames)
    filename = filenames{k};
    [Z, s]= loadImpedanceData(filename);
    [~,i] = min(abs(s.Frequencies - f));
    ReZ = real(Z(i));
    ImZ = imag(Z(i));
    vnaFreq = s.Frequencies/1e6;
    maskVNA = and(vnaFreq>=lowFCutOff, vnaFreq<=highFCutOff);
    vnaFreq = vnaFreq(maskVNA);
    vnaFreq = 1000*vnaFreq;
    Z = Z(maskVNA);
%     plot(vnaFreq,real(Z),'DisplayName',['Real Z ',num2str(k)]); hold on;
    plot(vnaFreq,imag(Z),'DisplayName',['Imag Z ',num2str(k)]); hold on;
end
    legend;