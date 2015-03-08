% Montecarlo.m
% Run a full monte carlo simulation
% Each actual simulation task is conducted by mctask.m, this code provides
% the data needed for mctask to work and stores the results Any variables 
% needed during the simulation must exist in simitemsin; these variables
% will be read into datain, filtered, and passed to mctask.
%% Load required variables

% Range of silica values to examine
SiO2min=40;
SiO2max=80;

% Simitems is a cell array holding the names of all the variables to
% examine. Names must be formatted as in .elements
simitemsin={'SiO2';'FeOT';'MgO';'Ni';'CaO';'Al2O3';'Na2O';'K2O';'TiO2';'Zr';'Hf';'Yb';'Rb';'Ba';'Sr';'Eu_Eustar';};



%Parameters for each struct to plot

% f1=figure;
% f2=figure;
% in=morb;
% % in.k=invweight(morb.Latitude, morb.Longitude, morb.Age);
% % in.k=invweight(morb.Latitude, morb.Longitude, morb.SiO2*10);
% % in.k=ones(size(morb.SiO2));
% arc=logical(ones(size(morb.SiO2)));
% rift=logical(ones(size(morb.SiO2)));
% plotstyle='morb';
% test=in.SiO2>SiO2min & in.SiO2<SiO2max & ~isnan(in.Latitude) & ~isnan(in.Longitude);


in=volcanic;
arc=(in.Geolprov==11|in.Geolprov==12);
rift=(in.Geolprov==21|in.Geolprov==22)|(in.Geolprov==20&in.Age>180&in.Age<220);
plotstyle='.r';
test=in.SiO2>SiO2min & in.SiO2<SiO2max & ~isnan(in.Latitude) & ~isnan(in.Longitude) & in.Elevation>-100;


% in=plutonic
% arc=(in.Geolprov==11|in.Geolprov==12);
% rift=(in.Geolprov==21|in.Geolprov==22)|(in.Geolprov==20&in.Age>180&in.Age<220);
% plotstyle='.b';
% test=in.SiO2>SiO2min & in.SiO2<SiO2max & ~isnan(in.Latitude) & ~isnan(in.Longitude) & in.Elevation>-100;



% Construct a matrix holding all the data to be used in the simulation
uncert=zeros(size(simitemsin))';
datain=zeros(length(in.SiO2),length(simitemsin));
for i=1:length(simitemsin)
    datain(:,i)=in.(simitemsin{i});
    uncert(i)=in.err.(simitemsin{i});
end



% Create n matlab workers for parallel processing on n cores
n=4;
nn=matlabpool('size');
if nn>0&&nn~=n
    matlabpool close force local
    matlabpool(n)
elseif nn==0
    matlabpool(n)
end

%% Produce sample weights for bootstrap resamplingaaa

% Pare down data matrix to the silica range of interest
data=datain(test,:);
arc=arc(test);
rift=rift(test);


% Compute weighting coefficients
tic
if isfield(in,'k')
    k=in.k(test);
else
    lat=in.Latitude(test);
    lon=in.Longitude(test);
    k=NaN(length(lat),1);
    for i=1:length(lat)
        % Calculate k based on distribution of points on a sphere
        k(i)=nansum(1./((180/pi*acos(sin(lat(i)*pi/180).*sin(lat*pi/180)...
            +cos(lat(i)*pi/180).*cos(lat*pi/180).*cos(lon(i)*pi/180-lon*pi/180))).^2+1));
    end
    in.k=Inf(size(in.SiO2));
    in.k(test)=k;
end

fprintf('Calculating sample weights: ')
toc

% Compute probability of keeping a given data point when sampling
prob=1./((k.*median(5./k))+1);
% prob=1./((k.*median(2./k))+1); 


%% Run the monte carlo simulation and bootstrap resampling

tic;

% Number of simulations
nsims=10000;

% Number of variables to run the simulation for
ndata=30;

% Number of SiO2 divisions
nbins=20;

% Edges of SiO2 divisions
binedges=linspace(SiO2min,SiO2max,nbins+1)';

% Create 3-dimensional variables to hold the results
simaverages=zeros(nsims,nbins,ndata);
simerrors=zeros(nsims,nbins,ndata);
simratio=zeros(nsims,1);

% Set minimum SiO2 uncertainty for each sample
% data(data(:,1)<10 | isnan(data(:,1)),1)=10;


% Run the simulation in parallel. Running the simulation task as a function
% avoids problems with indexing in parallelized code.
parfor i=1:nsims
    
    % mctask does all the hard work; simaverages and simerrors hold the results
    [simaverages(i,:,:) simerrors(i,:,:) simratio(i)]=mctaskVP(data,prob,uncert,binedges,nbins,arc,rift);
        
end
simerrors=simerrors.*(sqrt(nanmean(simratio))+1/sqrt(nsims));

toc % Record time taken to run simulation

% Compute vector of SiO2-bin centers for plotting
bincenters=linspace(SiO2min+(SiO2max-SiO2min)/2/nbins,SiO2max-(SiO2max-SiO2min)/2/nbins,nbins)';


% Simitems holds names for the outputs of mctask that are formatted to serve as figure titles
simitemsout={'FeOT';'MgO';'Ni';'CaO';'Al2O3';'Na2O';'K2O';'TiO2';'Zr';'Hf';'Yb';'Rb';'Ba';'Sr';'Eu_Eustar';};
% Printnames contains equivalent names formatted as valid filenames
printnames={'FeOT';'MgO';'Ni';'CaO';'Al2O3';'Na2O';'K2O';'TiO2';'Zr';'Hf';'Yb';'Rb';'Ba';'Sr';'Eu_Eustar';};
ymax=[15 30 1000 14 19 5.3 5.5 3 700 18 9 270 1300 1200 1.5];





%% Plot the results

% For each item in the simulation output, create a figure with the results


if strcmp(plotstyle,'morb')
    figure(f1);
    for i=1:16
        subaxis(8,2,i,'SpacingVert',0.02,'SpacingHoriz',0.02,'Margin',0.08); hold on; 
        c=bincenters';
        m=nanmean(simaverages(:,:,i));
%         e=nanstd(simaverages(:,:,i));
        e=nanmean(simerrors(:,:,i));
        fill([c fliplr(c)],[m+2*e fliplr(m-2*e)],[0.8 0.8 0.8],'EdgeColor','None');
        plot(c,m,'Color',[0.6 0.6 0.6])
        
    end
    
    figure(f2);
    for i=1:14
        subaxis(7,2,i,'SpacingVert',0.02,'SpacingHoriz',0.02,'Margin',0.08); hold on; 
        c=bincenters';
        m=nanmean(simaverages(:,:,i+16));
%         e=nanstd(simaverages(:,:,i+16));
        e=nanmean(simerrors(:,:,i+16));
        fill([c fliplr(c)],[m+2*e fliplr(m-2*e)],[0.8 0.8 0.8],'EdgeColor','None');
        plot(c,m,'Color',[0.6 0.6 0.6])
        
    end
    
else
    figure(f1);
    for i=1:16
        hold on; subaxis(8,2,i,'SpacingVert',0.02,'SpacingHoriz',0.02,'Margin',0.08);
        errorbar(bincenters,nanmean(simaverages(:,:,i)),2.*nanmean(simerrors(:,:,i)),plotstyle)
        if mod(i,2); ylabel(printnames(ceil(i/2))); end
        ylim([0 ymax(ceil(i/2))])
    end
    
    figure(f2);
    for i=1:14
        hold on; subaxis(7,2,i,'SpacingVert',0.02,'SpacingHoriz',0.02,'Margin',0.08);
        errorbar(bincenters,nanmean(simaverages(:,:,i+16)),2.*nanmean(simerrors(:,:,i+16)),plotstyle)
        if mod(i,2); ylabel(printnames(ceil((i+16)/2))); end
        ylim([0 ymax(ceil((i+16)/2))])
    end
end


% matlabpool close

%%
% % Save resultss
% eval([savetitle '.bincenters=bincenters;']); eval([savetitle '.simaverages=simaverages;']); eval([savetitle '.simerrors=simerrors;']); eval([savetitle '.simitems=printnames;']);
% for i=1:length(printnames)
%     eval([savetitle '.' printnames{i} '=simaverages(:,:,' num2str(i) ');'])
%     eval([savetitle '.' printnames{i} '_err=simerrors(:,:,' num2str(i) ');'])
% end
% eval(['save ' savetitle ' ' savetitle]);
