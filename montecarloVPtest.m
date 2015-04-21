% Produce the the (~10^7 row) monte carlo table out for quick examination
% with plotmcVolcPlutvariable).m

% Get input data
name='plutonic';
eval(['in=' name ';'])

simitems={'Latitude';'Longitude';'Elevation';'Age';'SiO2';'TiO2';'Al2O3';'Fe2O3';'FeO';'FeOT';'MgO';'CaO';'Na2O';'K2O';'P2O5';'MnO';'Loi';'H2O_Plus';'H2O_Minus';'H2O';'La';'Ce';'Pr';'Nd';'Sm';'Eu';'Gd';'Tb';'Dy';'Ho';'Er';'Tm';'Yb';'Lu';'Li';'Be';'B';'C';'CO2';'F';'Cl';'K';'Mg';'Sc';'Ti';'V';'Fe';'Cr';'Co';'Ni';'Cu';'Zn';'Ga';'Zr';'Os';'Rb';'Bi';'I';'Hg';'Nd143_Nd144';'Ba';'Y';'Pb';'D18O';'Te';'Nb';'Sr87_Sr86';'Tl';'Pt';'Sn';'Cd';'As';'Pd';'Sr';'Se';'S';'Au';'Ta';'Mo';'U';'Cs';'Sb';'Ag';'W';'Th';'Re';'Hf';'Ir';'Eustar';'Geolprov'};

test=~isnan(in.Latitude)&~isnan(in.Longitude)&in.Elevation>-100;

% Construct data matrix
data=zeros(length(in.SiO2),length(simitems));
for i=1:length(simitems)
    data(:,i)=in.(simitems{i});
end
data=data(test,:);

% Construct uncertainty matrix
absoluteErr=1; % Whether the data struct uses absolute vs. relative errors
uncertainty=zeros(length(in.SiO2),length(simitems));
for i=1:length(simitems)
    uncertainty(:,i)=in.CalcAbsErr.(simitems{i});
end
uncertainty=uncertainty(test,:);


%% Produce sample weights

tic
if isfield(in,'k')
    k=in.k(test);
else
    lat=in.Latitude(test);
    lon=in.Longitude(test);
    k=NaN(length(lat),1);
    for i=1:length(lat)
%         % Calculate k based on distribution of points on a sphere
        k(i)=nansum(1./((180/pi*acos(sin(lat(i)*pi/180).*sin(lat*pi/180)...
            +cos(lat(i)*pi/180).*cos(lat*pi/180).*cos(lon(i)*pi/180-lon*pi/180))).^2+1)); % The +1 prevents singularities
%         k(i)=nansum(1./((180/pi*acos(sin(lat(i)*pi/180).*sin(lat*pi/180)...
%             +cos(lat(i)*pi/180).*cos(lat*pi/180).*cos(lon(i)*pi/180-lon*pi/180))).^2));
    end
    in.k=Inf(size(in.SiO2));
    in.k(test)=k;
end
assignin('base',name,in)

% prob=1./((k.*median(5./k))+1);
% prob = 1./( k./prctile(k,20) + 1 );

prob = 1./( k./prctile(k,10) + 1 );

fprintf('Calculating sample weights: ')
toc

%% Run the monte carlo

% Number of rows to simulate
samplerows=10^7;

tic;
out.data=NaN(samplerows,size(data,2));
fprintf('Creating target variable: ')
toc

tic;
i=1;
fprintf('\n%i',i)
while i<samplerows
    % select weighted sample of data
    r=rand(length(prob),1);
    sdata=data(prob>r,:);
    
    % Randomize all data over estimated uncertainty interval
    suncertainty=uncertainty(prob>r,:);
    r=randn(size(sdata));
    if absoluteErr
        sdata=sdata+r.*suncertainty;
    else
        sdata=sdata.*(1+r.*suncertainty);
    end
    
    % put data into output
    if i+size(sdata,1)-1<=samplerows
        out.data(i:i+size(sdata,1)-1,:)=sdata;
    else
        out.data(i:end,:)=sdata(1:samplerows-i+1,:);
    end
    
    % Show progress
    bspstr=repmat('\b',1,floor(log10(i))+1);
    fprintf(bspstr)
    i=i+size(sdata,1);
    fprintf('%i',i)
end

% % Randomize silica data only
% out.data(:,strcmp(simitems,'SiO2'))=out.data(:,strcmp(simitems,'SiO2')).*(1+0.001*randn(samplerows,1));

fprintf('\nRunning Monte Carlo: ')
toc

out.elements=simitems;
out=elementify(out);

out.notes=in.notes;

% Return results;
assignin('base', ['mc' name], out)

