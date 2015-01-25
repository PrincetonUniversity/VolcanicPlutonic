% simplemontecarlo.m // C. Brenhin Keller

%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
name='morb'; % Saved data struct to load. Struct must contain:
%   .data (matrix of data, with samples in rows and variables in columns)
%   .elements (cell array of column names)
%   .Latitude (column vector of latitude for each sample), and
%   .Longitude (column vector of longitude for each sample)
%   .Age (column vector of the estimated age for each sample)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% load(name) % Load datafile
morb=unelementify(morb,'keep'); % Re-compute data matrix
eval(['datain=' name '.data;']) % Get data matrix
uncertainty=0.02*ones(1,size(datain,2)); % Create approximate uncertainty 
% matrix (containing approximte 1-sigma uncertainties for each column)

%% Produce sample weights

eval(['lat=' name '.Latitude;']) % Get latitude data
eval(['lon=' name '.Longitude;']) % Get longitude data
eval(['age=' name '.Age;']) % Get age data


% Check if there is lat, lon, and age data
nodata=isnan(lat) | isnan(lon) | isnan(age);


k=NaN(length(lat),1);
i=1;
while i<=length(lat)
    if nodata(i)
        % If there is no data, set k=inf for weight=0
        k(i)=Inf;
    else
        % Otherwise, calculate k based on distribution of points on a sphere
        k(i)=nansum(1./((180/pi*acos(sin(lat(i)*pi/180).*sin(lat*pi/180)...
            +cos(lat(i)*pi/180).*cos(lat*pi/180).*cos(lon(i)*pi/180-lon*pi/180)...
            )/1.8).^2+1)+1./((((age(i))-age)/38).^2+1));   
    end
    i=i+1;
end

% Calculate resampling weight based on k
prob=1./((k.*nanmedian(5./k))+1);


%% Run the monte carlo process
% Number of rows to resample up to
samplerows=10^6;

% Create matrix to hold results
mc.data=NaN(samplerows,size(datain,2));


% Bootstrap resampling:
i=1;
while i<samplerows
    % select weighted sample of data
    r=rand(length(prob),1);
    sdata=datain(prob>r,:);
    
    if i+size(sdata,1)-1<=samplerows
        mc.data(i:i+size(sdata,1)-1,:)=sdata;
    else
        mc.data(i:end,:)=sdata(1:samplerows-i+1,:);
    end
    i=i+size(sdata,1);    
end

% Distribute variables over confidence interval
eval(['mc' name '.data=mc.data+mc.data.*repmat(uncertainty,samplerows,1).*randn(samplerows,size(datain,2));'])

% Populate fields of struct and calculate Eu anomalies
mc=elementify(mc);
mc.Eu_Eustar=mc.Eu./mc.Eustar;

% Save results
eval(['mc' name '.elements=' name '.elements;'])
eval(['save mc' name ' mc' name])


