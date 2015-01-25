if ~exist('mcvolcanic','var'); load mcvolcanic2; end
if ~exist('volcanic','var'); load volcanic; end
if ~exist('mcplutonic','var'); load mcplutonic2; end
if ~exist('plutonic','var'); load plutonic; end


% plotelements={'TiO2','Al2O3','FeOT','Cr','MgO','Ni','Co','CaO','Na2O','K2O','P2O5','H2O_Plus'}; yfigs=3; xfigs=4;
% plotelements={'CaO';'Al2O3';'FeOT';'MgO';'K2O';'Na2O';'Cr';'TiO2';'P2O5';}; yfigs=3; xfigs=3;
% plotelements={'CaO';'Al2O3';'FeOT';'MgO';'K2O';'Na2O';}; yfigs=2; xfigs=3;
% plotelements={'K2O','FeOT'}; yfigs=1; xfigs=2

plotelements={'MgO';'FeOT';'Al2O3';'K2O';}; xfigs=2; yfigs=2;
xmin=40;
xmax=80;

figure;
for i=1:length(plotelements)
    hold on; subaxis(yfigs,xfigs,mod(i-1,xfigs*yfigs)+1,'SpacingVert',0.02,'SpacingHoriz',0.05,'Margin',0.06); 
    binplot(mcplutonic.SiO2,mcplutonic.(plotelements{i}),40,80,length(mcplutonic.SiO2)./length(plutonic.SiO2),20,'.b')
    binplot(mcvolcanic.SiO2,mcvolcanic.(plotelements{i}),40,80,length(mcvolcanic.SiO2)./length(volcanic.SiO2),20,'.r')
    ylabel(plotelements{i}); setlabelfontsize(12)
    if any(mod(i-1,xfigs*yfigs)+1==(xfigs*yfigs-(0:xfigs-1))); xlabel('SiO2'); else set(gca,'xticklabel',[]); end
end
legend({'Plutonic','Volcanic'})

% cd into directory containing melts results
load residuals.csv residuals
residuals=sortrows(residuals,2);
residuals(residuals(:,2)==0,:)=[];

% Reference mineral compositions
elem={'SiO2','TiO2','Al2O3','Fe2O3','Cr2O3','FeO','MnO','MgO','NiO','CoO','CaO','Na2O','K2O','P2O5','CO2','H2O'};
ref.quartz.SiO2=100;

ref.apatite.CaO=55.82;
ref.apatite.P2O5=42.39;
ref.apatite.H2O=1.79;

ref.whitlockite.CaO=47.1;
ref.whitlockite.MgO=2.63;
ref.whitlockite.FeO=3.35;
ref.whitlockite.P2O5=46.37;

ref.aenigmatite.Na2O=6.73;
ref.aenigmatite.CaO=1.08;
ref.aenigmatite.MgO=1.08;
ref.aenigmatite.TiO2=9.77;
ref.aenigmatite.MnO=1.65;
ref.aenigmatite.Al2O3=1.90;
ref.aenigmatite.FeO=35.76;
ref.aenigmatite.Fe2O3=3.07;
ref.aenigmatite.SiO2=38.83;

% linecolor=[0.65 0.65 0.65]; % Gray
saturation=smooth([linspace(1,0.9,50)'; linspace(0.9,1,50)'],10);
hue=[linspace(1,0,100)'.^3,zeros(100,1),linspace(0,1,100)'];
cmap=hue.*repmat(saturation,1,3);



for ssim=1:200;
    dir = ['out' num2str(residuals(ssim,1))];
    melts=struct;
    % Import the results
    if exist([dir '/Phase_main_tbl.txt'],'file')
        cells=importc([dir '/Phase_main_tbl.txt'],' ');
        emptycols=all(cellfun('isempty', cells),1);
        cells=cells(:,~emptycols);
        pos=[find(all(cellfun('isempty', cells),2)); size(cells,1)+1];
        melts.minerals=cell(length(pos)-1,1);
        for i=1:(length(pos)-1)
            name=varname(cells(pos(i)+1,1));
            melts.(name{1}).elements=varname(cells(pos(i)+2,~cellfun('isempty',cells(pos(i)+2,:))));
            melts.(name{1}).data=str2double(cells(pos(i)+3:pos(i+1)-1,1:length(melts.(name{1}).elements)));
            melts.(name{1})=elementify(melts.(name{1}));
            melts.minerals(i)=name;
        end
        
        
        %%%%%%%%%%%%%%%%%%%% Zero-extend mineral masses %%%%%%%%%%%%%%%%%%%
        
        % Determine minimum and maximum temperature in the simulation
        minT=NaN;
        maxT=NaN;
        for i=1:length(melts.minerals)
            maxT=max([maxT max(melts.(melts.minerals{i}).Temperature)]);
            minT=min([minT min(melts.(melts.minerals{i}).Temperature)]);
        end
        
        % Determine temperature step
        if range(melts.liquid0.Temperature(1:end-1)-melts.liquid0.Temperature(2:end))<10^-5
            deltaT=melts.liquid0.Temperature(1)-melts.liquid0.Temperature(2);
            simlength=round((maxT-minT)./deltaT)+1;
        else
            error('Non-uniform temperature step');
        end
        
        % Make a new struct containing zero-extended mineral masses
        mass=struct;
        mass.minerals=melts.minerals;
        mass.solids=zeros(simlength,1);
        volume.solids=zeros(simlength,1);
        for i=1:length(melts.minerals)
            melts.(melts.minerals{i}).Index=round((maxT-melts.(melts.minerals{i}).Temperature)./deltaT)+1;
            mass.(melts.minerals{i})=zeros(simlength,1);
            mass.(melts.minerals{i})(melts.(melts.minerals{i}).Index)=melts.(melts.minerals{i}).mass;
            if i>1 && ~isequal(melts.minerals{i},'water')
                mass.solids=mass.solids+mass.(melts.minerals{i});
                volume.solids(melts.(melts.minerals{i}).Index) = nansum([volume.solids(melts.(melts.minerals{i}).Index) melts.(melts.minerals{i}).V], 2);
            end
        end
        
        % Fill in mineral compositions
        for i=1:length(melts.minerals)
            if any(ismember({'quartz','apatite','whitlockite','aenigmatite'},melts.minerals{i}))
                for e=elem
                    melts.(melts.minerals{i}).(e{:})=0;
                    if isfield(ref.(melts.minerals{i}),e)
                        melts.(melts.minerals{i}).(e{:})=ref.(melts.minerals{i}).(e{:});
                    end
                end
            end
        end
        
        
        % Calculate solid composition
        for j=1:length(elem)
            s.(elem{j})=NaN(simlength,1);
            for i=2:length(melts.minerals)
                if isfield(melts.(melts.minerals{i}),elem{j})
                    s.(elem{j})(melts.(melts.minerals{i}).Index) = nansum([s.(elem{j})(melts.(melts.minerals{i}).Index) ...
                        melts.(melts.minerals{i}).(elem{j}) .* melts.(melts.minerals{i}).mass], 2);
                end
            end
            s.(elem{j}) = s.(elem{j})./mass.solids;
        end
        
        % Calculate where SiO2 is increasing during differentiation, so as to plot only that
        posSi=melts.liquid0.SiO2>([0; melts.liquid0.SiO2(1:end-1)]-0.01); 

        %%%%%%%%%%%%%%%%%%%%%%%%%  Plot results  %%%%%%%%%%%%%%%%%%%%%%%%%%
        plotwater=(nanmean(melts.liquid0.H2O)-0)/4;%+0.2;
%         plotwater=melts.liquid0.H2O(1)/2;
        if plotwater>1; plotwater=1; end
        if plotwater<0; plotwater=0; end

        linecolor=cmap(ceil(plotwater*100),:);
%         linecolor=[(1-plotwater) 0 plotwater];
                
%         cumulatecolor=[0 plotwater 0];
        plotelements=regexprep(plotelements,'H2O_Plus','H2O');
        for i=1:length(plotelements)
            hold on; subaxis(yfigs,xfigs,mod(i-1,xfigs*yfigs)+1); 
            if isequal(plotelements{i},'FeOT')
                % liquid
                plot(melts.liquid0.SiO2(posSi).*100./(100-melts.liquid0.H2O(posSi)),melts.liquid0.FeO(posSi).*100./(100-melts.liquid0.H2O(posSi))+melts.liquid0.Fe2O3(posSi).*100./(100-melts.liquid0.H2O(posSi)).*((55.845+16)/(55.845+24)),'Color',linecolor);
                % solid (color each point individually by melt silica)
                for step=1:length(s.SiO2)
                    if posSi(step)&&mass.solids(step)>0
                        plot((1+0.01*randn(round(mass.solids(20)),1)).*s.SiO2(step),(1+0.01*randn(round(mass.solids(20)),1)).*s.FeO(step)+(1+0.01*randn(round(mass.solids(20)),1)).*s.Fe2O3(step).*((55.845+16)/(55.845+24)),'.','MarkerSize',mass.solids(step),'Color',[0 (melts.liquid0.SiO2(step)-45)/45 0]);
                    end
                end
            else
                % liquid
                plot(melts.liquid0.SiO2(posSi).*100./(100-melts.liquid0.H2O(posSi)),melts.liquid0.(plotelements{i})(posSi).*100./(100-melts.liquid0.H2O(posSi)),'Color',linecolor);
                % solid (color each point individually by melt silica)
                for step=1:length(s.SiO2)
                    if posSi(step)&&mass.solids(step)>0
                        plot((1+0.01*randn(round(mass.solids(20)),1)).*s.SiO2(step),(1+0.01*randn(round(mass.solids(20)),1)).*s.(plotelements{i})(step),'.','MarkerSize',mass.solids(step),'Color',[0 (melts.liquid0.SiO2(step)-45)/45 0]);
                    end
                end
            end
            xlim([xmin xmax])
            
        end
    end
end


for i=1:length(plotelements)
    hold on; subaxis(yfigs,xfigs,mod(i-1,xfigs*yfigs)+1); binplot(mcplutonic.SiO2,mcplutonic.(plotelements{i}),40,80,length(mcplutonic.SiO2)./length(plutonic.SiO2),20,'.b')
    hold on; subaxis(yfigs,xfigs,mod(i-1,xfigs*yfigs)+1); binplot(mcvolcanic.SiO2,mcvolcanic.(plotelements{i}),40,80,length(mcvolcanic.SiO2)./length(volcanic.SiO2),20,'.r')
    colormap([0.4*ones(54,2),(0.47:0.01:1)'])
    caxis([1 3])
end


%% Plot mineral percentages
mins=[];
figure; hold on;
for i=2:length(melts.minerals)
    mins=[mins mass.(melts.minerals{i}) ./ mass.solids];
end
plot(melts.liquid0.SiO2, mins)
legend(melts.minerals{2:end})


% figure; plot(s.SiO2); ylabel('SiO_2')

%% Examine mineralogy
index=40;
for i=2:length(mass.minerals)
    fprintf([mass.minerals{i} ': \t%.0f%%\n'], mass.(mass.minerals{i})(index) ./ mass.solids(index)*100)
end
fprintf('%.0f%% SiO2\n\n', s.SiO2(index))
