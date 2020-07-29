classdef xdcr
%xdcr      KLM transducer equivalent circuit transducer model
% T.L.Szabo    Version 2 July 2004          
% this program uses the KLM model to simulate transducer impedance
% and acoustical, electrical and transdcuer loss for
% Chapter 5 in Diagnostic Ultrasound Imaging: Inside Out
% Version 2 KLM transducer equivalent circuit transducer model
%  Note the area should be A=7 e-5 m^2 correcting an error on p. 117
%  Note the caption for fig 5.14 should have the same area A=7 e-5 m^2 
%  and fig 5.14b depicts the aloss, eloss and tloss curves in dB

    %% public properties
    properties  (SetAccess = public)
        % transducer parameters
        element_length         % element length [m]
        element_width          % element width [m]
        element_thickness      % element thickness [m]
        crystal_speed          % crystal velocity [m/s]
        crystal_absorption     % absorption of crystal [nepers/m-Hz]
        crystal_impedance      % crystal impedance [rayl/m2]
        backing_impedance      % backing impedance [rayl/m2]
        medium_impedance       % acoustic medium impedance [rayl/m2]
        akt                    % piezoelectric coupling constant
        epsr                   % clamped relative dielectric constant [unitless]

        % matching layer parameters
        matching_layer;               %set to=1 for matching layer, =0 for none
        matching_absorption;          % matching layer 1 absorption
        matching_thickness;           % matching layer 1 thickness [m] 
        matching_speed;               % matching layer 1 velocity [m/s]
        matching_impedance;           % matching layer 1 impedance [rayl/m2]
    end

    %% constructor
    methods (Access = public)
        function h=xdcr()
            %% transducer parameters
%             h.element_length=0.7;          % element length [m]
%             h.element_width=0.1e-3;        % element width [m]
%             h.element_thickness=0.662e-3;  % element thickness [m]
%             h.crystal_speed=3970;          % crystal velocity [m/s]
%             h.crystal_absorption=0.0;      % absorption of crystal [nepers/m-Hz]
%             h.crystal_impedance=29.78e6;   % crystal impedance [rayl/m2]
%             h.backing_impedance= 1.22*340; %6e6;       % backing impedance [rayl/m2]
%             h.medium_impedance=1.5e6;      % acoustic medium impedance [rayl/m2]
% 
%             h.akt=0.698;                   % piezoelectric coupling constant
%             h.epsr=1475;                   % clamped relative dielectric constant [unitless]
            
            h.element_length=0.06;          % element length [m]
            h.element_width=0.06;        % element width [m]
            h.element_thickness=0.0035;  % element thickness [m]
            h.crystal_speed=4610;          % crystal velocity [m/s]
            h.crystal_absorption=0.0;      % absorption of crystal [nepers/m-Hz]
            h.crystal_impedance=37.1e6;   % crystal impedance [rayl/m2]
            h.backing_impedance=1.225*340;       % backing impedance [rayl/m2]
            h.medium_impedance=1.5e6;      % acoustic medium impedance [rayl/m2]

            h.akt=0.9;                   % piezoelectric coupling constant
            h.epsr=5000;                   % clamped relative dielectric constant [unitless]

            %% matching layer parameters
            h.matching_layer=1;                 % set to=1 for matching layer, =0 for none
            h.matching_absorption=0.0;          % matching layer 1 absorption
            h.matching_thickness=0.001;      % matching layer 1 thickness [m] 
            h.matching_speed=2720;              % matching layer 1 velocity [m/s]
            h.matching_impedance=7.8e6;        % matching layer 1 impedance [rayl/m2]
        end
    end

    %% compute
    methods
        function compute(h)
            %  INPUT VARIABLES
            % figures set f parameter = 1 to see figure or =0 for no figure

            % for displaying a figure, set the corresponding f parameter below to 1
            % to see figure & set f parameter to =0 for no figure
            fzinr=0; % plot real zinr(+) and imag zinr(*) [Rayls-m^2]vs f(Hz)
            fzinl=0; % plot real zinl(+) and imag zinl(*) [Rayls-m^2]vs f(Hz)
            fjunct=0; % plot real zin56(+) and imag zin56(*)[Rayls-m^2] vs f(Hz)
            fza=0;  % plot real zin45(+) and imag zin45(*)[ohms]vs f(Hz)
            fzt=1;  % plot Ra=real (ZT)(+) and Xa+X0=imag (ZT)(*)[ohms] vs f(Hz)
            fztune=1;% plot tuned real (ZT+Xs)(+) and tuned imag (ZT+Xs)(*)[ohms] vs f(Hz)
            feloss=0; % plot eloss(*) & eloss2 (+) in dB vs f (Hz)
            floss=1;  % plot aloss(+) and eloss(*) and tloss(x) in dB vs f(Hz)

            eps0=8.85e-12;               % vacuum permittivity [F/m] 


            % input variables
            pi2=2*pi;
            pid2=pi/2;

            % electric impedance
            zg=50;  % source electrical impedance (ohms)
            zf=50;  % receive electrical impedance (ohms)

            %% tuning parameters
            series_inductor=0;%47.84/2/pi/1e6;    % no tuning series inductor (Henries)
            series_resistor=0.0;    % series inductor resistance [Ohms]

            % geometric
            ed2=h.element_thickness/2;
            area=h.element_width*h.element_length;
            akt2=h.akt*h.akt;

            % impedances
            z0=h.crystal_impedance*area;
            zb=h.backing_impedance*area;
            zw=h.medium_impedance*area;
            zml1=h.matching_impedance*area;

            %frequency parameters
            nmax=511;
            nup=49;
            f0=h.crystal_speed/(2*h.element_thickness);           % resonance frequency (Hz)
            f1=.01e6;
            dltaf=.1e6;
            dltafn=dltaf/f0;
            f1n=f1/f0;
            w0=pi2*f0;
            f=f1*[1:nmax];         % sets frequency range
            fsize=ones(size(f));    % size of frequency array
            w=pi2*f;                % omega angular frequency
            fn=f/f0;                % normalized frequency parameter
            fend=100;                % sets range for freq. plots:100 is 10 MHz,50 is 5MHz,etc

            % Capacitance
            C0=h.epsr*eps0*area/h.element_thickness;   % clamped capacitance
            x0=1/(w0*C0);                              % clamped cap. reactance
              series_inductor=0.1e-6; %1/(w0^2*C0);
            disp(series_inductor)
            
            %  tissue or water side (right)
            % half thickness crystal layer propagation factor gamma
            gamd2=complex(-h.crystal_absorption*f*ed2,pid2*f/f0);

            % right side

            if h.matching_layer==0
            [vr,zinr] = h.tloss(gamd2,h.crystal_speed,ed2,z0,zw);    % call tl function

            elseif h.matching_layer==1
                gamr1=complex(-h.matching_absorption*f*h.matching_thickness,pi2*f*h.matching_thickness/h.matching_speed);
                [vr1,zinr1] = h.tloss(gamr1,h.matching_speed,h.matching_thickness,zml1,zw);    % call tl function
                [vr,zinr] = h.tloss(gamd2,h.crystal_speed,ed2,z0,zinr1);    % call tl function
            else
               noise=input('error! only values of ml=0 or 1 allowed')
            end

            %  left side
            [vl,zinl] = h.tloss(gamd2,h.crystal_speed,ed2,z0,zb);    % call tl function

            % Acoustic Loss (acoustic power to the right div. by total ac. power
            % calc. ratio of absolute right to left impedances squared as intermediate param.

            rzrzl=(abs(zinr).*abs(zinr))./(abs(zinl).*abs(zinl)); 
            aloss=1*fsize./(1*fsize+(real(zinl).*rzrzl./real(zinr)));

            if fzinr==1
               figure;
               plot(f(1:fend),real(zinr(1:fend)),'b+-',f(1:fend),imag(zinr(1:fend)),'r*--');
               title('real zinr(+) and imag zinr(*) [Rayls-m^2]vs f(Hz)');
               xlabel('Frequency (Hz)');ylabel('Impedance (ohms)');
               legend('real(zinr)','imag(zinr)');
            end

            if fzinl==1
               figure;
               plot(f(1:fend),real(zinl(1:fend)),'b+-',f(1:fend),imag(zinl(1:fend)),'g*--');
               title('real zinl(+) and imag zinl(*)[Rayls-m^2] vs f(Hz)');
               xlabel('Frequency (Hz)');ylabel('Impedance (ohms)');
               legend('real(zinl)','imag(zinl)');
            end

            % acoustic junction matrix56
            a56=1.0;
            b56=0.0;
            c56=1./zinl;
            d56=1.0;
            zin56=(a56*zinr+b56*fsize)./(c56.*zinr+d56*fsize);
            v56=zinr./(a56*zinr+b56*fsize);

            if fjunct==1
               figure;
               plot(f(1:fend),real(zin56(1:fend)),'b+-',f(1:fend),imag(zin56(1:fend)),'g*--');
               title('real zin56(+) and imag zin56(*)[Rayls-m^2] vs f(Hz)');
               xlabel('Frequency (Hz)');ylabel('Impedance (ohms)');
               legend('real(zin56)','imag(zin56)');
            end

            % electro-acoustic transformer matrix 45
            phi=h.akt*sqrt(pi/(w0*C0*z0))*sin(pid2*fn+eps)./(pid2*fn+eps);
            a45=phi;
            b45=0.0;
            c45=0.0;
            d45=1./phi;
            zin45=(a45.*zin56+b45*fsize)./(c45*zin56+d45);
            v45=zin56./(a45.*zin56+b45*fsize);

            if fza==1
               figure;
               plot(f(1:fend),real(zin45(1:fend)),'b+-',f(1:fend),imag(zin45(1:fend)),'g*--');
               title('real zin45(+) and imag zin45(*)[ohms]vs f(Hz)');
               xlabel('Frequency (Hz)');ylabel('Impedance (ohms)');
               legend('real(zin45)','imag(zin45)');
            end

            % double capacitor matrix 34
            cp=-C0*fsize./(akt2*sin(pi*fn+eps*fsize)./(pi*fn+eps*fsize));
            c0cp=complex(0.*fsize,w*C0.*cp);
            a34=1.0;
            b34=(C0+cp)./c0cp;
            c34=0.0;
            d34=1.0;
            zin34=(a34*zin45+b34)./(c34*zin45+d34*fsize);  % transducer impedance
            zt=zin34;                                      %  transducer impedance
            v34=zin45./(a34*zin45+b34);

            % compute Q
            [pks locs wids]=findpeaks(real(zin34),f,'Widthreference','halfheight');
            Q=locs(1)/wids(1);
            xpks=interp1(f,imag(zin34),locs);

            % figure;
            % plot(f,abs(zin34)/pks(1)); hold on; grid on;
            % plot(locs(1),1,'ro');
            % plot(locs(1)+wids(1)/2,0.5,'r+');
            % plot(locs(1)-wids(1)/2,0.5,'r+');
            % ylim([0 1])

            if fzt==1
               figure();
               subplot(1,2,1);
               plot(f(1:fend)/1e6,real(zin34(1:fend)),'-'); hold on; grid on;
               plot(f(1:fend)/1e6,imag(zin34(1:fend)),'-');
               %plot(locs(1)/1e6*[1 1],[0 pks(1)],'r--');
               text(locs(1)*1.1/1e6,pks(1),sprintf('Q=%0.2f\nR=%0.2f Ohms\nX=%0.2f Ohms',Q,pks(1),xpks(1)));
               legend('Ra','Xa+X0','Location','SouthEast')
               title('Electrical impedance [Ohms]');
               xlabel('Frequency (MHz)');ylabel('Impedance (Ohms)');
               ylim([-max(abs(zin34(50:fend))) max(abs(zin34(50:fend)))]);
            end

            % electrical input
            xs=pi2*f*series_inductor;

            %  series tuning
            a23=1;
            b23=complex(series_resistor,xs)+zg;
            c23=0.0;
            d23=1.0;
            zin23=(a23*zin34+b23)./(c23*zin34+d23*fsize);
            zts=zin23-zg*fsize;         % tuned transducer impedance
            v23=zin34./(a23*zin34+b23);

            if fztune==1
               subplot(1,2,1);
               plot(f(1:fend)/1e6,real(zts(1:fend)),'--'); hold on; grid on;
               plot(f(1:fend)/1e6,imag(zts(1:fend)),'--');
               %plot(locs(1)/1e6*[1 1],[0 pks(1)],'r--');
               %text(locs(1)*1.1/1e6,pks(1),sprintf('Q=%0.2f, R=%0.2f Ohms, X=%0.2f Ohms',Q,pks(1),xpks(1)));
               legend('Ra','Xa+X0','Tunned Ra','Tunned Xa+X0','Location','SouthEast')
               xlabel('Frequency (MHz)');ylabel('Impedance (Ohms)');
               %ylim([-max(abs(zts(50:fend))) max(abs(zts(50:fend)))]);
            end

            % electrical loss
            eloss=abs(v23).*abs(v23)*4.*real(zt)*zg./(abs(zt).*abs(zt));
            rdenom=real(zt)+zg*fsize+series_resistor*fsize;
            idenom=imag(zt)+xs.*fsize;
            eloss2=4*zg*real(zt)./((rdenom).*(rdenom)+(idenom.*idenom));

            if feloss==1
               figure;
               plot(f(1:fend),eloss(1:fend),'m*--',f(1:fend),eloss2(1:fend),'c+-');
               title('eloss(*) & eloss2 (+) in dB vs f (Hz)');
               xlabel('Frequency (Hz)');ylabel('Loss (dB)');
               legend('eloss','eloss2');
            end

            alossdb=10*log10(aloss);
            elossdb=10*log10(eloss);
            tlossdb=alossdb+elossdb;

            if floss==1
               subplot(1,2,2);
               plot(f(1:fend)/1e6,alossdb(1:fend),'-'); hold on; grid on;
               plot(f(1:fend)/1e6,elossdb(1:fend),'--');
               plot(f(1:fend)/1e6,tlossdb(1:fend),'-');
               title('Losses [dB]');
               %title('aloss(+) and eloss(*) and tloss(x) in dB vs f(Hz)');xlabel('Frequency (Hz)');ylabel('Loss (dB)');
               legend('Acoustic','Electrical','Total','Location','SouthEast');
               xlabel('Frequency (Hz)');ylabel('Loss (dB)');
               ylim([-25 0])
            end
        end
        
        function [r,zin] = tloss(h,gam,c1,d1,z1,zm)
            % tloss(gam,c1,d1,z1,zm) is transmission line function w. loss
            % returns a pressure or voltage ratio r and input impedance zin
            % from inputs f (frequency Hz),c1 (line sound speed m/s),
            % d1 (line length meters),z1 line impedance (MRayl or ohms)
            % zm load impedance (MRayl or ohms)
            % gam= gamma, a complex wavenumber as a function of frequency 
            % T. L. Szabo July 2004 Diagnostic Ultrasound Imaging: Inside Out
            ng=size(gam);      % determine size of array gam
            if ng(2) ~=1
                zmarray=zm;
            else
                zmarray=zm*ones(ng); % create zm array
            end
            % calculate ratio:pressure p2/p1 or voltage v2/v1
            r=zmarray./(zmarray.*cosh(gam)+z1*sinh(gam));
            % calculate zin
            zin=z1*(zmarray.*cosh(gam)+z1*sinh(gam))./(zmarray.*sinh(gam)+z1*cosh(gam)); 
        end
    end
end
