% CREO LA FIGURA
fig = figure('Name','Series de Fourier','NumberTitle','off',...
    'Position',[100 100 1200 600],'Resize','Off',...
    'MenuBar','none','ToolBar','figure');

% CREO LOS PANELES/GRUPOS
SenalBG = uibuttongroup(fig,'Title','Señal','Visible','On',...
    'Units','pixels','Position',[10 380 300 220]);
ParametrosBG = uibuttongroup(fig,'Title','Parámetros','Visible','On',...
    'Units','pixels','Position',[10 160 300 220]);
AccionesP = uipanel(fig,'Title','Acciones',...
    'Units','pixels','Position',[10 10 300 150]);
ResultadosP = uipanel(fig,'Title','Resultados',...
    'Units','pixels','Position',[313 10 882 150]);
GraficosP = uipanel(fig,...
    'Units','pixels','Position',[313 160 882 433]);

% BOTONES SEÑAL
SierraBT = uicontrol(SenalBG,'Style','radiobutton',...
    'Position',[75 145 150 60],...
    'String','Diente de Sierra');
PulsoBT = uicontrol(SenalBG,'Style','radiobutton',...
    'Position',[75 85 150 60],...
    'String','Tren de Pulsos');
SenoBT = uicontrol(SenalBG,'Style','radiobutton',...
    'Position',[75 25 150 60],...
    'String','Seno Rectificado');
% TriangleBT = uicontrol(SenalBG,'Style','radiobutton',...
%     'Position',[10 40 155 30],...
%     'String','Pulso Triangular');

% BOTONES ARMÓNICOS
ArmonicosBT = uicontrol(ParametrosBG,'Style','radiobutton',...
    'Position',[75 160 200 30],...
    'String','Armónicos');
ArmonicosBTV = uicontrol(ParametrosBG,'Style','edit',...
    'Position',[75 120 150 30]);
ErrBT = uicontrol(ParametrosBG,'Style','radiobutton',...
    'Position',[75 80 200 30],...
    'String','ECM');
ErrBTV = uicontrol(ParametrosBG,'Style','edit',...
    'Position',[75 40 150 30]);
% DiezBT = uicontrol(ArmonicosBG,'Style','radiobutton',...
%     'Position',[10 150 155 70],...
%     'String','10');
% VeinteBT = uicontrol(ArmonicosBG,'Style','radiobutton',...
%     'Position',[10 80 155 70],...
%     'String','20');
% CincuentaBT = uicontrol(ArmonicosBG,'Style','radiobutton',...
%     'Position',[10 10 155 70],...
%     'String','50');

% BOTONES ACCIONES
CalcularBT = uicontrol(AccionesP,'Style','pushbutton',...
    'Position',[80 40 125 60],...
    'String','Calcular');

% BOTONES CÁLCULOS
ECMTxt = uicontrol(ResultadosP,'Style','text',...
    'Position',[90 45 60 30],...
    'String','ECM:');
ECMBT = uicontrol(ResultadosP,'Style','edit',...
    'Position',[150 51 150 30]);
GibbsTxt = uicontrol(ResultadosP,'Style','text',...
    'Position',[520 45 60 30],...
    'String','Gibbs(%):');
GibbsBT = uicontrol(ResultadosP,'Style','edit',...
    'Position',[580 51 150 30]);
% ErrorTxt = uicontrol(ResultadosP,'Style','text',...
%     'Position',[380 24 60 30],...
%     'String','Error:');
% ErrorBT = uicontrol(ResultadosP,'Style','edit',...
%     'Position',[450 30 70 30]);

% GRÁFICOS
GraficosAX = axes(GraficosP,...
    'Units', 'pixels', 'OuterPosition',[0 0 882 443],...
    'Position',[60 60 800 340], 'XLim',[-3*pi 3*pi],...
    'XGrid','on','YGrid','on','GridLineStyle','--',...
    'XMinorTick','off','Color', [0.85 0.85 1]);
title(GraficosAX,'Señales');
xlabel(GraficosAX,'Frecuencia');
ylabel(GraficosAX,'Amplitud');

% CALLBACKS
CalcularBT.Callback = {@calcular, GraficosAX, SierraBT, PulsoBT,...
    SenoBT, ArmonicosBT, ArmonicosBTV, ErrBT, ErrBTV, ECMBT, GibbsBT};


function calcular(~, ~, GraficosAX, SierraBT, PulsoBT,...
    SenoBT, ArmonicosBT, ArmonicosBTV, ErrBT, ErrBTV, ECMBT, GibbsBT)

    if(strcmp('Rick',ArmonicosBTV.String)&&strcmp('Astley',ErrBTV.String))
        
        web('https://www.youtube.com/watch?v=dQw4w9WgXcQ','-browser');
%         msgbox('You have been rickrolled','Easter Egg','modal');

    else
        
        cla(GraficosAX)
        
        fs = 44100;
        t = linspace(-3*pi,3*pi,3*fs);
        len = 3*fs;
        
        senalf = zeros(1,len);
        
        % DETERMINO LOS ARMÓNICOS
        if ArmonicosBT.Value
            
            N = str2double(ArmonicosBTV.String);
            
            % DIENTE DE SIERRA (A = pi)
            if SierraBT.Value

                senal = sawtooth(t);

                for n = 1:N
                    
                    senalf = senalf - (1/pi)*(2/n)*sin(n.*t);
                    
                end

            end

            % TREN DE PULSOS
            if PulsoBT.Value

                senal = ones(1,len);
                senal(1:len*1/6) = -1;
                senal(len*2/6:len*3/6) = -1;
                senal(len*4/6:len*5/6) = -1;
                % d = linspace(-3*pi,3*pi,3);
                % pulsos = (pi/4)*pulstran(t,d,'rectpuls',pi);

                for n = 1:N
                    
                    senalf = senalf + (4/pi)*sin((2*n-1).*t)/(2*n-1);
                    
                end

            end

            % SENO RECTIFICADO
            if SenoBT.Value

                senal = abs(sin(t));

                for n = 1:N
                    
                    senalf = senalf - (4/pi)*(1/(4*n^2-1))*cos(2*n.*t);
                    
                end

                senalf = senalf + 2/pi;

            end

%             % PULSO TRIANGULAR
%             if TriangleBT.Value
%         
%                 for n = 1:N
%         
%                     senalf = senalf - (1/(2*n-1)^2)*cos((2*n-1).*t);
%         
%                 end
%                 
%             end
        
        end
        
        % DETERMINO EL ECM LÍMITE
        if ErrBT.Value
            
            ECMlim = str2double(ErrBTV.String);
            
            n = 1;
            ECM = ECMlim+1;
            
            % DIENTE DE SIERRA (A = pi)
            if SierraBT.Value
                
                senal = sawtooth(t);
            
                while ECM > ECMlim
                    
                    senalf = senalf - (1/pi)*(2/n)*sin(n.*t);
                    ECM = (1/len)*sum((senal-senalf).^2);
                    n = n+1;
                    
                end
                
                N = n;
                
            end

            % TREN DE PULSOS
            if PulsoBT.Value

                senal = ones(1,len);
                senal(1:len*1/6) = -1;
                senal(len*2/6:len*3/6) = -1;
                senal(len*4/6:len*5/6) = -1;
                
                while ECM > ECMlim
                    
                    senalf = senalf + (4/pi)*sin((2*n-1).*t)/(2*n-1);
                    ECM = (1/len)*sum((senal-senalf).^2);
                    n = n+1;
                    
                end
                
                N = n;

            end

            % SENO RECTIFICADO
            if SenoBT.Value

                senal = abs(sin(t)) - 2/pi;
                
                while ECM > ECMlim
                    
                    senalf = senalf - (4/pi)*(1/(4*n^2-1))*cos(2*n.*t);
                    ECM = (1/len)*sum((senal-senalf).^2);
                    n = n+1;
                    
                end
                
                senal = senal + 2/pi;
                senalf = senalf + 2/pi;
                
                N = n;
                
            end
            
        end
        
        % PLOTEO LAS SEÑALES
        hold on;
        plot(GraficosAX,t,senal);
        plot(GraficosAX,t,senalf);
        hold off;
        
        formatSpec = 'Señal de Fourier con %d armónicos';
        str = compose(formatSpec,N);
        
        legend('Señal original', str,...
            'location','southeast');

        % ECM
        ECM = (1/len)*sum((senal-senalf).^2);
        ECMBT.String = num2str(ECM);

        % GIBBS
        Gibbs = (((max(senalf)-min(senalf))/(max(senal)-min(senal)))-1)*100;
        GibbsBT.String = num2str(Gibbs);
        
    end
    
end