figure; 
Res = 4632;
[R, I, Z] = data2Impedance(A(:,2),A(:,3),A(:,4),Res);
plot(x(:,1), R,'DisplayName','Real Z'); hold on;
plot(x(:,1), I, 'DisplayName', 'Imag Z'); hold on;
plot(x(:,1), abs(Z),'DisplayName', 'abs(Z)'); hold on;

Zx = U2./(U1-U2) * 99;

plot(x(:,1),  abs(Zx), 'DisplayName', 'second Z');
legend