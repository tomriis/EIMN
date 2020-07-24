lowFCutOff = 0.450;
highFCutOff = 0.85;
baseDir = '/Users/tomriis/MATLAB/ImpedanceMeasure/vnaData/';

samples = {};
for i = 1:1
    samples{i} = num2str(i);
end
names = samples;

h= figure;

for i = 1:length(samples)
    if i == 1
        figure;
        ax = gca;
        colorOrder = ax.ColorOrder;
        h = figure(103);
        clf
    end
    
    filename = [baseDir,samples{i},'.s1p'];
    s = sparameters(filename);
    s1 = squeeze(s.Parameters);
    Z = sParamToZ(s1);
    vnaFreq = s.Frequencies/1e6;
    maskVNA = and(vnaFreq>=lowFCutOff, vnaFreq<=highFCutOff);
    vnaFreq = vnaFreq(maskVNA);
    vnaFreq = 1000*vnaFreq;
    Z = Z(maskVNA);
    impedanceOhms = real(Z);
    
    if i == 3
        plot(vnaFreq, impedanceOhms,'linewidth',2.5, 'Color',colorOrder(4,:),...
            'DisplayName', names{i}); hold on;
    else
                plot(vnaFreq, impedanceOhms,'linewidth',2.5, 'Color',colorOrder(i,:),...
            'DisplayName', ['Re(' names{i},')']); hold on;
    end
    ylabel('Impedance (Ohms)', 'FontSize',18);
    legend;
    title('Magnitude', 'FontSize',18);
    grid on
    
    impedanceImag = imag(Z);
    hold on;
    plot(vnaFreq, impedanceImag,'linewidth',2.5, 'Color',colorOrder(i,:),...
        'DisplayName', ['Im(',names{i},')']); hold on;
    grid on
    
    
end
 

legend;
% xlabel('Frequency (KHz)','FontSize',18)
% ylabel('Impedance (Ohms)','FontSize',18)
% title('Transducer Impedance Measure','FontSize',18)
set(gcf,'color','w');
axT = gca;
% set(axT,'fontcolor',colorOrder(1,:));
axis('tight')
grid on