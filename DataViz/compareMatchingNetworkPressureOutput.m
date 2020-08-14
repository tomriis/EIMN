
base = 'F:\20200804\EfficiencyCurves\XDR0NML Series Inductor Matching Network\cone_none\efficiencyCurve\';
filename = 'wv_400mVpp.snq';
filenameSnq = [base,filename];
[t,wv] = readWaveform(filenameSnq);
base = 'F:\20200804\EfficiencyCurves\XDR0NML No Matching Network\cone_none\efficiencyCurve\';
filenameSnq = [base,filename];
[t,wvXdrWMC] = readWaveform(filenameSnq);

base = 'F:\20200804\EfficiencyCurves\XDR1 Series Inductor Matching Network\cone_none\efficiencyCurve\';
% 
filenameSnq = [base,filename];
[t,wv] = readWaveform(filenameSnq);
base = 'F:\20200804\EfficiencyCurves\XDR1 No Matching Network\cone_none\efficiencyCurve\';
filenameSnq = [base,filename];
[t,wvXdrWMC] = readWaveform(filenameSnq);

% 
% base = 'F:\20200804\';
% filenameSnq = [base,'xdr5Matching150uH30mVpp.snq'];
% [t,wv] = readWaveform(filenameSnq);
% filenameSnq = [base,'xdr5NoMatching30mVpp.snq'];
% [t,wvXdrWMC] = readWaveform(filenameSnq);

x= 1:round(length(wv)/1);%350:1000;
t=t(x)-t(x(1));

m=max(max(wv),max(wvXdrWMC));

h= figure;
plot(t,wv(x)/m,'DisplayName','Series Inductor'); hold on;
% plot(t,wvXdr,'DisplayName','Transducer');
plot(t,wvXdrWMC(x)/m,'DisplayName','No Matching Network');
ylim([-1,1]);
xlabel('Time (microseconds)');
ylabel('Normalized Amplitude');
legend;
title('With and Without Matching Network');
makeFigureBig(h);


