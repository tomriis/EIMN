f = 650000;
w = 2*pi*f;
if 0
baseDir = 'C:\Users\Tom\Documents\MATLAB\EIMN\vnaData\';
N = 9;
formatSpec = '%d';
elseif 1
        baseDir = 'C:\Users\Tom\Documents\MATLAB\EIMN\vnaData\20200724\';
        N = 1;
        formatSpec= 'XDR%dWMC';
%          formatSpec = 'XDR%dNOMICROCOAX';
%          formatSpec = 'XDR%dNOMATCHING';
end

inductances = zeros(N,2);
capacitances = zeros(N,1);

for ii = 1:N
    filename = [baseDir,sprintf(formatSpec,ii),'.s1p'];
    s = sparameters(filename);
    s1 = squeeze(s.Parameters);
    Z = sParamToZ(s1);
    [~,i] = min(abs(s.Frequencies - f));
    Rg = 50;
    Xs = 0;
    
    [La, Cb] = LNetworkCalculationHighPass(Z(i), Rg, w);
    Ls = seriesInductorNetworkCalculation(Z(i), w);
    Lp = parallelInductorNetworkCalculation(Z(i), w);
    [LLowp, CLowp] = LNetworkCalculationLowPass(Z(i), Rg, w);
    inductances(ii,:) = [Ls,Lp];
    capacitances(ii) = CLowp;
end

disp('Inductances: ');
disp('Series : Parallel : L');
median(inductances,1)
disp('Capacitances');
median(Cb)
