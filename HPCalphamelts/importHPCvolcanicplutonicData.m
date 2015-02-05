%% Import best-fitting simulations into melts(n) struct
if ~exist('residuals','file') % If not processed, delete column headers from residuals file
    [~,~]=unix('grep n residuals.csv > residualcolumns');
    [~,~]=unix('sed ''/^n/d'' residuals.csv > residuals');
    [~,~]=unix('rm residuals.csv');
end
load residuals
residuals=sortrows(residuals,2); % Sort by column 2 (least squared residual)
residuals(residuals(:,2)==0,:)=[]; % Delete simulations that did not run (residual of zero)


melts=struct;
nsims=350; % Number of simulations to import

for n=1:nsims;
    dir = ['out' num2str(residuals(n,1))];
    % Import the results
    if exist([dir '/Phase_main_tbl.txt'],'file')
        cells=importc([dir '/Phase_main_tbl.txt'],' ');
        emptycols=all(cellfun('isempty', cells),1);
        cells=cells(:,~emptycols);
        pos=[find(all(cellfun('isempty', cells),2)); size(cells,1)+1];
        melts(n).minerals=cell(length(pos)-1,1);
        for i=1:(length(pos)-1)
            name=varname(cells(pos(i)+1,1));
            melts(n).(name{1}).elements=varname(cells(pos(i)+2,~cellfun('isempty',cells(pos(i)+2,:))));
            melts(n).(name{1}).data=str2double(cells(pos(i)+3:pos(i+1)-1,1:length(melts(n).(name{1}).elements)));
            melts(n).(name{1})=elementify(melts(n).(name{1}));
            melts(n).minerals(i)=name;
        end
        
        % Calculate range where SiO2 is increasing during differentiation     
        melts(n).posSi=melts(n).liquid0.SiO2>([0; melts(n).liquid0.SiO2(1:end-1)]-0.01);      
    end
end

% Set colormap
saturation=smooth([linspace(1,0.9,50)'; linspace(0.9,1,50)'],10);
hue=[linspace(1,0,100)'.^3,zeros(100,1),linspace(0,1,100)'];
cmap=hue.*repmat(saturation,1,3);

nsims=length(melts);

%% Plot silica vs pressure for top N fits %%%%%

figure; subaxis(1,2,1,'SpacingHoriz',0.02); hold on; 
set(gca, 'YDir','reverse');
for n=1:nsims
    % Determine step number at which pressure first reaches minimum value
    [~,index]=min(melts(n).liquid0.Pressure);
    
%     normconst=100./(100-melts(n).liquid0.H2O-melts(n).liquid0.CO2); % Calculate volatile-free normalization
    normconst=1; % No normalization
    
    % Plot each simulation color-coded by average H2O
    plotwater=(nanmean(melts(n).liquid0.H2O(1)))*2;%/2-0.4;
    if plotwater>1; plotwater=1; end
    if plotwater<0; plotwater=0; end
    plot(melts(n).liquid0.SiO2(1:index).*normconst,melts(n).liquid0.Pressure(1:index)/10000,'Color',cmap(ceil(plotwater*100),:))
end
xlim([50 80])
ylim([0 2.1])
set(gca,'YTick',[0 0.5 1 1.5 2])
xlabel('SiO2'); ylabel('Pressure   (GPa)')


%% Plot temperature vs pressure for top N fits %%%%%

% figure; hold on; 
subaxis(1,2,2); hold on;
set(gca, 'XDir','reverse');
set(gca, 'YDir','reverse');
for n=1:nsims
    % Determine step number at which pressure first reaches minimum value
    [~,index]=min(melts(n).liquid0.Pressure);
    
%     normconst=100./(100-melts(n).liquid0.H2O-melts(n).liquid0.CO2); % Calculate volatile-free normalization
    normconst=1; % No normalization
    
    % Plot each simulation color-coded by average H2O
    plotwater=(nanmean(melts(n).liquid0.H2O))/4;%/2-0.4;
    if plotwater>1; plotwater=1; end
    if plotwater<0; plotwater=0; end
    plot(melts(n).liquid0.Temperature(1:index).*normconst,melts(n).liquid0.Pressure(1:index)/10000,'Color',cmap(ceil(plotwater*100),:))
end
xlim([680 1500])
ylim([0 2.1])
set(gca,'YTick',[])
xlabel('Temperature (C)'); % ylabel('Pressure   (GPa)')




%% Plot histograms of initial and average water content
H2O=NaN(nsims,1);
H2Oi=NaN(nsims,1);

for i=1:nsims
    H2O(i)=nanmean(melts(i).liquid0.H2O(melts(i).posSi));
    H2Oi(i)=melts(i).liquid0.H2O(1);
end

figure; 
subaxis(2,2,3); hist(H2O,linspace(0.05,4.95,50)); xlabel('Average H2O (wt. %)')
% figure; 
subaxis(2,2,1); hist(H2Oi,linspace(0.05,4.95,50)); xlabel('Initial H2O (wt. %)')

%% Plot histograms of initial and average CO2 content
CO2=NaN(nsims,1);
CO2i=NaN(nsims,1);

for i=1:nsims
    CO2(i)=nanmean(melts(i).liquid0.CO2(melts(i).posSi));
    CO2i(i)=melts(i).liquid0.CO2(1);
end

% figure; 
subaxis(2,2,4); hist(CO2,linspace(0.016,1.485,50)); xlabel('Average CO2 (wt. %)')
% figure; 
subaxis(2,2,2); hist(CO2i,linspace(0.016,1.485,50)); xlabel('Initial CO2 (wt. %)')

%% Plot initial H2O and CO2 concentrations from residuals file
n=500;
figure; 
[h,c]=hist(residuals(1:n,3),linspace(0.01,0.99,50));
subaxis(2,1,1); bar(c,h,1); 
ylim([0, max(h)]); set(gca,'YTick',[]); xlabel('Initial CO2 (wt. %)')
[h,c]=hist(residuals(1:n,4),50);
subaxis(2,1,2); bar(c,h,1); 
ylim([0, max(h)]); set(gca,'YTick',[]); xlabel('Initial H2O (wt. %)')



%% Plot Average MgO differentiation line
SiO2=[];
MgO=[];
for i=1:nsims
    SiO2=[SiO2; melts(i).liquid0.SiO2(melts(i).posSi)];
    MgO=[MgO; melts(i).liquid0.MgO(melts(i).posSi)];
    
end

Mg0=melts(1).liquid0.MgO(1);
Si0=melts(1).liquid0.SiO2(1);

npoints=25;
[c, m, e]=bin(SiO2,MgO,Si0,75,0,npoints);
m=[Mg0 m];
c=[Si0 c];

mm=linspace(m(1),m(end),npoints+1);

figure;
% Plot with 0 and 100% mixing between granite and basalt endmembers
mixingpercent=0;
hold on; plot(c,mixingpercent/100*mm+(100-mixingpercent)/100*m,'Color',[0 0 0],'LineWidth',2)
mixingpercent=100;
hold on; plot(c,mixingpercent/100*mm+(100-mixingpercent)/100*m,'--','Color',[0 0 0],'LineWidth',1)


% % Plot example curves for 20% mixing increments
% figure
% for mixingpercent=0:20:100;
%     hold on; plot(c,mixingpercent/100*mm+(100-mixingpercent)/100*m,'Color',[mixingpercent/200, mixingpercent/200, mixingpercent/200],'LineWidth',2)
% end
