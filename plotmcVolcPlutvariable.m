%% Load dataset

if ~exist('mcvolcanic','var')
    load mcvolcanic
end
if ~exist('volcanic','var')
    load volcanic
end
if ~exist('mcplutonic','var')
    load mcplutonic
end
if ~exist('plutonic','var')
    load plutonic
end


%% Arc
Elem='MgO';

ptestArc=(mcplutonic.Geolprov==11|mcplutonic.Geolprov==12);
vtestArc=(mcvolcanic.Geolprov==11|mcvolcanic.Geolprov==12);

figure;
xlabel('SiO2'); ylabel(Elem);
test=mcvolcanic.(Elem)>0&vtestArc;
[c m e]=bin(mcvolcanic.SiO2(test),mcvolcanic.(Elem)(test),40,80,length(mcvolcanic.SiO2)./length(volcanic.SiO2),20);
hold on; errorbar(c,m,2*e,'.r')
test=mcplutonic.(Elem)>0&ptestArc;
[c m e]=bin(mcplutonic.SiO2(test),mcplutonic.(Elem)(test),40,80,length(mcplutonic.SiO2)./length(plutonic.SiO2),20);
hold on; errorbar(c,m,2*e,'.b')


title('Arc')
legend('Volcanic','Plutonic'); 



%% Rift
Elem='FeOT';

ptestRift=(mcplutonic.Geolprov==21|mcplutonic.Geolprov==22);
vtestRift=(mcvolcanic.Geolprov==21|mcvolcanic.Geolprov==22);

figure;
xlabel('SiO2'); ylabel(Elem);
test=mcvolcanic.(Elem)>0&vtestRift;
[c m e]=bin(mcvolcanic.SiO2(test),mcvolcanic.(Elem)(test),40,80,length(mcvolcanic.SiO2)./length(volcanic.SiO2),20);
hold on; errorbar(c,m,2*e,'.r')
test=mcplutonic.(Elem)>0&ptestRift;
[c m e]=bin(mcplutonic.SiO2(test),mcplutonic.(Elem)(test),40,80,length(mcplutonic.SiO2)./length(plutonic.SiO2),20);
hold on; errorbar(c,m,2*e,'.b')

title('Rift')
legend('Volcanic','Plutonic'); 


%% All
Elem='MgO';


figure;
xlabel('SiO2'); ylabel(Elem);
test=mcvolcanic.(Elem)>0;
[c m e]=bin(mcvolcanic.SiO2(test),mcvolcanic.(Elem)(test),40,80,length(mcvolcanic.SiO2)./length(volcanic.SiO2),20);
hold on; errorbar(c,m,2*e,'.r')
test=mcplutonic.(Elem)>0;
[c m e]=bin(mcplutonic.SiO2(test),mcplutonic.(Elem)(test),40,80,length(mcplutonic.SiO2)./length(plutonic.SiO2),20);
hold on; errorbar(c,m,2*e,'.b')


title('Arc')
legend('Volcanic','Plutonic'); 