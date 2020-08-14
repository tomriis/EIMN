lowFCutOff = 0.500;
highFCutOff = 0.800;
i = 1;
baseDir = 'C:\Users\Tom\Documents\MATLAB\EIMN\vnaData\20200805\';
% filenames = {[baseDir,'XDR',num2str(i),'WMC','.s1p'],[baseDir,'XDR',num2str(i),'WMATCH','.s1p']};
filenames = {[baseDir,'XDR',num2str(i),'MATCHING','.s1p'],[baseDir,'XDR',num2str(i),'NOMATCHING','.s1p']};
names={'Series Inductor','Non Matching'};
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
s11 = abs(s1);

plot(vnaFreq, s11,'linewidth',2.5,...
        'DisplayName', ['s11(' names{i},')']); hold on;
end

plot(Y(:,1)/1000,Y(:,2),'-','linewidth',2.5,'DisplayName','Simulated 155 uH');
plot(X(:,1)/1000,X(:,2),'-','linewidth',2.5,'DisplayName','Simulated 150 uH');

ylabel('Reflection Coefficient', 'FontSize',18);
xlabel('Frequency (KHz)','FontSize',18);
title('Reflection With and Without Matching');
legend;
set(gcf,'color','w');
axis('tight')
% ylim([0,1]);
plot([650,650],[0,1],'k-','DisplayName','fc');
grid on
makeFigureBig(h);