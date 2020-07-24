lowFCutOff = 0.450;
highFCutOff = 0.85;
baseDir = '/Users/tomriis/MATLAB/ImpedanceMeasure/vnaData/';

samples = {};
for i = 1:1
    samples{i} = num2str(i);
end
names = samples;

extension = '\cone_none\verasonics\';
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
    impedanceOhms = abs(Z);
    subplot(2,1,1);
    
    if i == 3
        plot(vnaFreq, impedanceOhms,'linewidth',2.5, 'Color',colorOrder(4,:),...
            'DisplayName', names{i}); hold on;
    else
                plot(vnaFreq, impedanceOhms,'linewidth',2.5, 'Color',colorOrder(i,:),...
            'DisplayName', names{i}); hold on;
    end
    ylabel('Impedance (Ohms)', 'FontSize',18);
    legend;
    title('Magnitude', 'FontSize',18);
    grid on
    
    impedanceAngle = rad2deg(angle(Z));
    subplot(2,1,2);
%     plot(vnaFreq, abs(s1(maskVNA)),'linewidth',2.5, 'Color',colorOrder(i,:),...
%       'DisplayName', names{i}); hold on;
    if i == 3
    plot(vnaFreq, impedanceAngle,'linewidth',2.5, 'Color',colorOrder(4,:),...
        'DisplayName', names{i}); hold on;
    else
            plot(vnaFreq, impedanceAngle,'linewidth',2.5, 'Color',colorOrder(i,:),...
        'DisplayName', names{i}); hold on;
    end
    ylim([-90,90])
 
    ylabel('Phase (degrees)', 'FontSize',18);
    title('Phase','FontSize',18);
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