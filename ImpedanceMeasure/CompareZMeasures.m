fontSize = 18;
axisFontSize = fontSize;
bgColor = 'w';
lowFCutOff = 0.4;
highFCutOff = 1.5;
filenames = ["MLCURED2_1.s1p", "MLCURED2_2.s1p", "MLCURED2_3.s1p"];

for i = 1 : length(filenames)
h = figure; 
s = sparameters(filenames(i));
s1 = squeeze(s.Parameters);
Z = sParamToZ(s1);
vnaFreq = s.Frequencies/1e6;
maskVNA = and(vnaFreq>=lowFCutOff, vnaFreq<=highFCutOff);
vnaFreq = vnaFreq(maskVNA);
vnaFreq = 1000*vnaFreq;
Z = Z(maskVNA);
yyaxis left
impedanceOhms = abs(Z);
plot(vnaFreq, impedanceOhms,'k', 'DisplayName', 'Z'); hold on;
% ylim([0,750]);

ylabel('Z (Ohms)');
title('Impedance real VNA');
xlim([lowFCutOff, highFCutOff]*1000)
% set(findall(h,'type','text'),'fontSize',fontSize)
set(gcf,'color',bgColor)
% set(gca,'fontsize',axisFontSize)


yyaxis right
impedanceAngle = rad2deg(angle(Z));
plot(vnaFreq, impedanceAngle,'b', 'DisplayName', 'Phase'); hold on;
ylim([-90,90])
title('Electrical Impedance VNA');
ylabel('Phase (degrees)');
legend;
freq = 650;
[~,i] = min(abs(vnaFreq-freq));
resOhms = impedanceOhms(i);
resAngle = impedanceAngle(i);
xlabel({'Frequency (kHz)';[num2str(resOhms),' Ohms / ',num2str(resAngle),' at ',...
num2str(vnaFreq(i)),' kHz']});
yyaxis left
h = plot([vnaFreq(i),vnaFreq(i)],[0,1000],'r--','DisplayName','')
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% set(findall(h,'type','text'),'fontSize',fontSize)
% set(findall(h,'type','text'),'color','k')
% set(gcf,'color',bgColor)
% % set(gca,'fontsize',axisFontSize)

% legend
end
