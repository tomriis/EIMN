lowFCutOff = 0.450;
highFCutOff = 0.85;
i = 1;
baseDir = 'C:\Users\Tom\Documents\MATLAB\EIMN\vnaData\20200805\';
% filenames = {[baseDir,'XDR',num2str(i),'WMC','.s1p'],[baseDir,'XDR',num2str(i),'WMATCH','.s1p']};
filenames = {[baseDir,'XDR',num2str(i),'NOMATCHING','.s1p'],[baseDir,'XDR',num2str(i),'MATCHING','.s1p']};
names={'Non Matching','Series Inductor'};
colors = {[0, 0.4470, 0.7410],[0.8500, 0.3250, 0.0980]};
h = figure;
for i = 1:length(filenames)
    
[Z, s, s1] = loadImpedanceData(filenames{i});
vnaFreq = s.Frequencies/1e6;
maskVNA = and(vnaFreq>=lowFCutOff, vnaFreq<=highFCutOff);
vnaFreq = vnaFreq(maskVNA);
vnaFreq = 1000*vnaFreq;
Z = Z(maskVNA);
s1 = s1(maskVNA);
impedanceOhms = real(Z);

plot(vnaFreq, impedanceOhms,'linewidth',2.5,'Color',colors{i},...
        'DisplayName', ['Re(' names{i},')']); hold on;



impedanceImag = imag(Z);

plot(vnaFreq, impedanceImag,'--','linewidth',2.5,'Color',colors{i},...
    'DisplayName', ['Im(',names{i},')']); hold on;
end
ylabel('Impedance (Ohms)', 'FontSize',18);
xlabel('Frequency (KHz)','FontSize',18);
title('Impedance With and Without Matching');
legend;
set(gcf,'color','w');
axis('tight')
grid on
makeFigureBig(h);