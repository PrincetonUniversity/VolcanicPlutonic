 function [simaverage, simerror, simratio] = mctaskVP(data, prob, uncert, binedges, nbins, arc, rift)

% select weighted sample of data
r=rand(length(prob),1);
sdata=data(prob>r,:);
arc=arc(prob>r);
rift=rift(prob>r);

% Randomize variables over uncertainty interval
sdata=sdata+sdata.*repmat(uncert,size(sdata,1),1).*randn(size(sdata));
silica=sdata(:,1);


% % Parameters for major and trace element data independent of tectonic setting (commented out)
% param=NaN(size(sdata,1),1,15);
% param(:,1,1)=sdata(:,2); % FeOT
% param(:,1,2)=sdata(:,3); % MgO
% param(:,1,3)=sdata(:,4); % Ni
% param(:,1,4)=sdata(:,5); % CaO
% param(:,1,5)=sdata(:,6); % Al2O3
% param(:,1,6)=sdata(:,7); % Na2O
% param(:,1,7)=sdata(:,8); % K2O
% param(:,1,8)=sdata(:,9); % TiO2
% param(:,1,9)=sdata(:,10); % Zr
% param(:,1,10)=sdata(:,11); % Hf
% param(:,1,11)=sdata(:,12); % Yb
% param(:,1,12)=sdata(:,13); % Rb
% param(:,1,13)=sdata(:,14); % Ba
% param(:,1,14)=sdata(:,15); % Sr
% param(:,1,15)=sdata(:,16); % Eu_Eustar

% Parameters for arc and rift trace and major element monte carlo
param=NaN(size(sdata,1),1,30);
param(arc,1,1)=sdata(arc,2); % FeOT
param(rift,1,2)=sdata(rift,2); % FeOT
param(arc,1,3)=sdata(arc,3); % MgO
param(rift,1,4)=sdata(rift,3); % MgO
param(arc,1,5)=sdata(arc,4); % Ni
param(rift,1,6)=sdata(rift,4); % Ni
param(arc,1,7)=sdata(arc,5); % CaO
param(rift,1,8)=sdata(rift,5); % CaO
param(arc,1,9)=sdata(arc,6); % Al2O3
param(rift,1,10)=sdata(rift,6); % Al2O3
param(arc,1,11)=sdata(arc,7); % Na2O
param(rift,1,12)=sdata(rift,7); % Na2O
param(arc,1,13)=sdata(arc,8); % K2O
param(rift,1,14)=sdata(rift,8); % K2O
param(arc,1,15)=sdata(arc,9); % TiO2
param(rift,1,16)=sdata(rift,9); % TiO2
param(arc,1,17)=sdata(arc,10); % Zr
param(rift,1,18)=sdata(rift,10); % Zr
param(arc,1,19)=sdata(arc,11); % Hf
param(rift,1,20)=sdata(rift,11); % Hf
param(arc,1,21)=sdata(arc,12); % Yb
param(rift,1,22)=sdata(rift,12); % Yb
param(arc,1,23)=sdata(arc,13); % Rb
param(rift,1,24)=sdata(rift,13); % Rb
param(arc,1,25)=sdata(arc,14); % Ba
param(rift,1,26)=sdata(rift,14); % Ba
param(arc,1,27)=sdata(arc,15); % Sr
param(rift,1,28)=sdata(rift,15); % Sr
param(arc,1,29)=sdata(arc,16); % Eu_Eustar
param(rift,1,30)=sdata(rift,16); % Eu_Eustar



% Find average values for each quantity of interest for each time bin
simaverage=NaN(1,nbins,size(param,3));
simerror=simaverage;
simratio=size(sdata,1)./size(data,1);
for j=1:nbins
    simaverage(1,j,:)=nanmean(param(silica>binedges(j) & silica<binedges(j+1),:,:),1);
    simerror(1,j,:)=nansem(param(silica>binedges(j) & silica<binedges(j+1),:,:),1);
end

% for j=1:nbins % Alternatively, use medians
%     simaverage(1,j,19:22)=nanmedian(param(silica>binedges(j) & silica<binedges(j+1),:,19:22),1);
%     simerror(1,j,19:22)=nansem(param(silica>binedges(j) & silica<binedges(j+1),:,19:22),1);
% end




end