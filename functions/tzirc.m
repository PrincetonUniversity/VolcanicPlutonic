function [T,M]=tzirc(CaO, Na2O, K2O, Al2O3, SiO2, Zr, TiO2, MgO)
% Calculate zircon saturation temperature in C

% M=(Na2O/30.9895 + K2O/47.0827 + 2*CaO/56.0774)./(Al2O3/50.9806 .* SiO2/60.0843); % Cation ratio
Na=Na2O/30.9895;
K=K2O/47.0827;
Ca=CaO/56.0774;
Al=Al2O3/50.9806;
Si=SiO2/60.0843;
Ti=TiO2/55.8667;
Mg=MgO/24.3050;

normconst=Na+K+Ca+Al+Si+Ti+Mg;
blah={'Na' 'K' 'Ca' 'Al' 'Si' 'Ti' 'Mg'};
for i=1:length(blah)
    eval([blah{i} '=' blah{i} './normconst;'])
end

M=(Na2O + K2O + 2*CaO)./(Al2O3 .* SiO2); % Cation ratio


T=12900./(2.95 + 0.85*M + log(496000./Zr)) - 273.15; % Temperature in Celcius
T(Zr<=0)=NaN;

