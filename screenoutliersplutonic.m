% test=isnan(plutonic.Latitude) | isnan(plutonic.Longitude) | plutonic.Elevation<-100 | plutonic.SiO2<40 | plutonic.SiO2>80;
plutonic.Latitude(plutonic.Latitude<-90|plutonic.Latitude>90)=NaN;
plutonic.Longitude(plutonic.Longitude<-180|plutonic.Longitude>180)=NaN;
plutonic.TiO2(plutonic.TiO2.*plutonic.SiO2>300 | plutonic.TiO2<0.01)=NaN; %300 ,0.02; 
plutonic.Al2O3(plutonic.Al2O3>=25 | plutonic.Al2O3<=1)=NaN;
plutonic.Fe2O3(plutonic.Fe2O3>=22 | plutonic.Fe2O3<=0.01)=NaN; % 22,0.1
plutonic.Fe2O3T(plutonic.Fe2O3T>=22 | plutonic.Fe2O3T<=0.1)=NaN; % 22,0.1
plutonic.FeO(plutonic.FeO.*plutonic.SiO2>1050 | plutonic.FeO<=0.01)=NaN; % 1000,0.05
plutonic.FeOT(plutonic.FeOT.*plutonic.SiO2>1200 | plutonic.FeOT<=0.01)=NaN; 
plutonic.MgO(plutonic.MgO>50 | plutonic.MgO.*plutonic.SiO2.^4>3.5*10^8 | plutonic.MgO <=0.003)=NaN; 
plutonic.Na2O(plutonic.Na2O>=20 | plutonic.Na2O <=0.003)=NaN; %
plutonic.K2O(plutonic.K2O>=20 | plutonic.K2O <=0.003)=NaN; %
plutonic.P2O5(plutonic.P2O5>10 | plutonic.P2O5<=0.001)=NaN; % 1, 0.01
plutonic.MnO(plutonic.MnO>2 | plutonic.MnO<=0.001)=NaN; % 1, 0.01
plutonic.Loi(plutonic.Loi>=22 | plutonic.Loi <=0.005)=NaN;
plutonic.H2O_Plus(plutonic.H2O_Plus>20 | plutonic.H2O_Plus <=0.005)=NaN;
plutonic.H2O_Minus(plutonic.H2O_Minus>20 | plutonic.H2O_Minus <=0.005)=NaN;
plutonic.H2O(plutonic.H2O>20 | plutonic.H2O <=0.005)=NaN;
plutonic.Cr2O3(plutonic.Cr2O3>=10 | plutonic.Cr2O3 <=0.0003)=NaN;
plutonic.La(plutonic.La>=1000 | plutonic.La <=0.02)=NaN; % 450,0.1
plutonic.NiO(plutonic.NiO>=10 | plutonic.NiO <=0.0003)=NaN;
plutonic.Ce(plutonic.Ce>=1000 | plutonic.Ce <=0.2)=NaN; % plutonic.Ce(plutonic.Ce=500 | plutonic.Ce=300 | plutonic.Ce <=0.5)=NaN;
plutonic.Pr(plutonic.Pr>=100 | plutonic.Pr <=0.01)=NaN; % 50, 0.02
plutonic.Nd(plutonic.Nd>=400 | plutonic.Nd <=0.1)=NaN; % 350, 0.1
plutonic.Sm(plutonic.Sm>=100 | plutonic.Sm <=0.05)=NaN; % 50, 0.1
plutonic.Eu(plutonic.Eu>=20 | plutonic.Eu <=0.01)=NaN; % 10, 0.03
plutonic.Gd(plutonic.Gd>=50 | plutonic.Gd <=0.1)=NaN; % 30, 0.3
plutonic.Tb(plutonic.Tb>=12 | plutonic.Tb <=0.0)=NaN; % 7, 0.05
plutonic.Dy(plutonic.Dy>=70 | plutonic.Dy <=0.0)=NaN; % 40, 0.2
plutonic.Ho(plutonic.Ho>=11 | plutonic.Ho <=0.0)=NaN; % 7, 0.05
plutonic.Er(plutonic.Er>=27 | plutonic.Er <=0.1)=NaN; % 20, 0.2
plutonic.Tm(plutonic.Tm>=08 | plutonic.Tm <=0.01)=NaN; % 3, 0.05
plutonic.Yb(plutonic.Yb>=30 | plutonic.Yb <=0.05)=NaN; % 20, 0.2
plutonic.Lu(plutonic.Lu>=06 | plutonic.Lu <=0.01)=NaN; % 3, 0.035
plutonic.Li(plutonic.Li>=350 | plutonic.Li <=0.5)=NaN; % 150, 1
plutonic.Be(plutonic.Be>=70 | plutonic.Be <=0.01)=NaN; % 20, 0.1
plutonic.B(plutonic.B>=250 | plutonic.B <=0.1)=NaN; % 70, 0.2
plutonic.C(plutonic.C>=5 | plutonic.C <=0.001)=NaN; % 1, 0.002
plutonic.CO2(plutonic.CO2>=11 | plutonic.CO2 <=0.005)=NaN;

plutonic.F(plutonic.F<3)=plutonic.F(plutonic.F<3)*10^4; plutonic.F(plutonic.F>=5000 | plutonic.F<=5)=NaN; % bimodal by four orders of magnitude (ppm vs wt.% splits between <1 and >20)
plutonic.Cl(plutonic.Cl<3)=plutonic.Cl(plutonic.Cl<3)*10^4; plutonic.Cl(plutonic.Cl>=7000 | plutonic.Cl<=5)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
plutonic.S(plutonic.S<3)=plutonic.S(plutonic.S<3)*10^4; plutonic.S(plutonic.S>=10^4.2 | plutonic.S<=1)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
plutonic.P(plutonic.P<5)=plutonic.P(plutonic.P<5)*10^4; plutonic.P(plutonic.P>=5000 | plutonic.P<=10)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
plutonic.K(plutonic.K<11)=plutonic.K(plutonic.K<11)*10^4; plutonic.K( plutonic.K>10^5 | plutonic.K<150)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
plutonic.Ca(plutonic.Ca<100)=plutonic.Ca(plutonic.Ca<100)*10^4; plutonic.Ca(plutonic.Ca>1.1*10^5 | plutonic.Ca<300)=NaN; % Convert to ppm
plutonic.Mg(plutonic.Mg<50)=plutonic.Mg(plutonic.Mg<50)*10^4; plutonic.Mg(plutonic.Mg>1.1*10^5 | plutonic.Mg<15)=NaN; % Convert to ppm
plutonic.Ti(plutonic.Ti<9)=plutonic.Ti(plutonic.Ti<9)*10^4; plutonic.Ti(plutonic.Ti>=3*10^4 | plutonic.Ti<50)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
plutonic.Fe(plutonic.Fe<20)=plutonic.Fe(plutonic.Fe<20)*10^4; plutonic.Fe(plutonic.Fe>=1.5*10^5 | plutonic.Fe<=3000)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
plutonic.Al(plutonic.Al<100)=plutonic.Al(plutonic.Al<100)*10^4; plutonic.Al(plutonic.Al>=1.5*10^5 | plutonic.Al <=10^4)=NaN;
plutonic.Pt(plutonic.Pt>0.1)=plutonic.Pt(plutonic.Pt>0.1)/10^3; plutonic.Pt(plutonic.Pt>=0.1 | plutonic.Pt <=10^-4)=NaN; % Convert to PPM
plutonic.Pd(plutonic.Pd>0.1)=plutonic.Pd(plutonic.Pd>0.1)/10^3; plutonic.Pd(plutonic.Pd>=0.03 | plutonic.Pd <=10^-4)=NaN; % Convert to PPM
plutonic.Au(plutonic.Au>0.5)=plutonic.Au(plutonic.Au>0.5)/10^3;plutonic.Au(plutonic.Au>=0.06 | plutonic.Au <=10^-4)=NaN; % Convert to PPM

plutonic.W(plutonic.W==10)=NaN; 
plutonic.Mo(plutonic.Mo>=2000 | plutonic.Mo./plutonic.SiO2.^4>10^-4.2 | plutonic.Mo<=0.05)=NaN; % 10, 0.1
% plutonic.W(plutonic.W>10)=plutonic.W(plutonic.W>10)/10^3; plutonic.W(plutonic.W>=9 | plutonic.W <=0.02)=NaN; % Convert to PPM
% plutonic.Mo(plutonic.Mo>20)=plutonic.Mo(plutonic.Mo>20)/10^3; plutonic.Mo(plutonic.Mo>=18 | plutonic.Mo <=0.05)=NaN; % Convert to PPM

plutonic.Ir(plutonic.Ir>0.1)=plutonic.Ir(plutonic.Ir>0.1)/10^3; plutonic.Ir(plutonic.Ir>=0.02 | plutonic.Ir<0.0001)=NaN; % Convert to PPM
% plutonic.Re(plutonic.Re>0.01)=plutonic.Re(plutonic.Re>0.01)/10^3; plutonic.Re(plutonic.Re>0.002 | plutonic.Re<0.00005)=NaN; % Convert to PPM
plutonic.Re(plutonic.Re>10^3)=plutonic.Re(plutonic.Re>10^3)/10^9; plutonic.Re(plutonic.Re>10^1)=plutonic.Re(plutonic.Re>10^1)/10^6; plutonic.Re(plutonic.Re>10^-2)=plutonic.Re(plutonic.Re>10^-2)/10^3; plutonic.Re(plutonic.Re>0.003|plutonic.Re<10^-5.5)=NaN;
plutonic.Hg(plutonic.Hg>10)=plutonic.Hg(plutonic.Hg>10)/10^3; plutonic.Hg(plutonic.Hg>=7 | plutonic.Hg <=0.001)=NaN; % Convert to PPM
plutonic.Bi(plutonic.Bi>10)=plutonic.Bi(plutonic.Bi>10)/10^3; plutonic.Bi(plutonic.Bi>=7 | plutonic.Bi <=0.002)=NaN; % Convert to PPM


plutonic.Sc(plutonic.Sc.*plutonic.SiO2>=5000 | plutonic.Sc <=0.1)=NaN; % 4000, 0.3
plutonic.V(plutonic.V>=1000 | plutonic.V <=0.1)=NaN; % 700, 0.5
plutonic.Cr(plutonic.Cr>=6000 | plutonic.Cr.*plutonic.SiO2.^3 > 6*10^8 | plutonic.Cr <=0.4)=NaN; % 4000, 0.6
plutonic.Mn(plutonic.Mn>=4000 | plutonic.Mn.*plutonic.SiO2.^2 > 10^7 | plutonic.Mn <=5)=NaN; %s 3000, 10
plutonic.Co(plutonic.Co>=250 | plutonic.Co <=0.01)=NaN; % 150, 0.05
plutonic.Ni(plutonic.Ni>=2000 | plutonic.Ni.*plutonic.SiO2.^3 > 2*10^8 | plutonic.Ni <=0.01)=NaN; % 1800, 0.1
plutonic.Cu(plutonic.Cu>=2000 | plutonic.Cu <=0.1)=NaN; % 500, 0.5
plutonic.Zn(plutonic.Zn>=700 | plutonic.Zn <=1)=NaN; % 400, 5
plutonic.Ga(plutonic.Ga>=50 | plutonic.Ga <=1)=NaN; % 40, 5
plutonic.Zr(plutonic.Zr>=2000 | plutonic.Zr <=1)=NaN; % 1800, 5
% plutonic.Os(plutonic.Os>=1 | plutonic.Os <0.0001)=NaN; % 40, 5
plutonic.Os(plutonic.Os>10^3)=plutonic.Os(plutonic.Os>10^3)/10^9; plutonic.Os(plutonic.Os>10^1)=plutonic.Os(plutonic.Os>10^1)/10^6; plutonic.Os(plutonic.Os>10^-2)=plutonic.Os(plutonic.Os>10^-2)/10^3; 
plutonic.Rb(plutonic.Rb>=1100 | plutonic.Rb <0.05)=NaN;
plutonic.Bi(plutonic.Bi>=1 | plutonic.Bi <0.009)=NaN;
plutonic.I(plutonic.I>=10^6 | plutonic.I <=0)=NaN; % plutonic.I - Not enough data
plutonic.Nd143_Nd144(plutonic.Nd143_Nd144>0.514 | plutonic.Nd143_Nd144 <0.51)=NaN; %.5133, .5105
plutonic.Ba(plutonic.Ba>7000 | plutonic.Ba<=1)=NaN; % 4000, 5
plutonic.Y(plutonic.Y>400 | plutonic.Y<=1)=NaN; % 145, 2
plutonic.Pb(plutonic.Pb>500 | plutonic.Pb<=0.05)=NaN; % 100, 0.05
plutonic.D18O(plutonic.D18O>14 | plutonic.D18O<=0.1)=NaN;
plutonic.Te(plutonic.Te>=10^6 | plutonic.Te <=0)=NaN; % plutonic.Te - Not enough data
plutonic.Nb(plutonic.Nb>800 | plutonic.Nb<=0.1)=NaN; % 300, 0.1
% plutonic.H - No data DELETE
plutonic.Sr87_Sr86(plutonic.Sr87_Sr86>1 | plutonic.Sr87_Sr86<=0.7)=NaN; % 0.75, 0.7
plutonic.Tl(plutonic.Tl>=15 | plutonic.Tl<=0.005)=NaN;
plutonic.Sn(plutonic.Sn>=50 | plutonic.Sn<=0.05)=NaN; % 10, 0.5
plutonic.Cd(plutonic.Cd>=10 | plutonic.Cd<=0.01)=NaN;
plutonic.As(plutonic.As>=150 | plutonic.As<=0.1)=NaN; % 20, 0.2
plutonic.Sr(plutonic.Sr>=6000 | plutonic.Sr.*plutonic.SiO2 <100 | plutonic.Sr.*plutonic.SiO2>10^5.5 |plutonic.Sr<=0.5)=NaN; % 3000, 0.2
plutonic.Se(plutonic.Se>=100 | plutonic.Se<=0.01)=NaN; % 20, 0.2
plutonic.Ta(plutonic.Ta>=40 | plutonic.Ta<=0.1)=NaN; % 13, 0.1
plutonic.U(plutonic.U>=50 | plutonic.U<=0.01)=NaN; % 13, 0.01
plutonic.Cs(plutonic.Cs>=100 | plutonic.Cs./plutonic.SiO2.^2>0.03 | plutonic.Cs<0.01)=NaN; % 20, <=0.01
plutonic.Sb(plutonic.Sb>=10 | plutonic.Sb<=0.01)=NaN; % 2.5, 0.025
plutonic.Ag(plutonic.Ag>=10 | plutonic.Ag<=0.001)=NaN; % 2.5, 0.001
plutonic.Th(plutonic.Th>=220 | plutonic.Th<=0.01)=NaN; % 100, 0.01
plutonic.Hf(plutonic.Hf>=70 | plutonic.Hf<0.1)=NaN; %


%%


plutonic=h2oconversion(plutonic);
        
plutonic.Al2O3(isnan(plutonic.Al2O3)) = roundsigfigs( plutonic.Al(isnan(plutonic.Al2O3)).*(26.9815+24)./26.9815.*10^-4, sigfigs(plutonic.Al(isnan(plutonic.Al2O3))) );
plutonic.CaO(isnan(plutonic.CaO)) = roundsigfigs( plutonic.Ca(isnan(plutonic.CaO)).*(40.078+16)./40.078.*10^-4, sigfigs(plutonic.Ca(isnan(plutonic.CaO))) );
plutonic.Cr(isnan(plutonic.Cr)) = roundsigfigs( plutonic.Cr2O3(isnan(plutonic.Cr)).*51.9961./(51.9961+24).*10^4, sigfigs(plutonic.Cr2O3(isnan(plutonic.Cr))) );
plutonic.MnO(isnan(plutonic.MnO)) = roundsigfigs( plutonic.Mn(isnan(plutonic.MnO)).*(54.93805+16)./54.93805.*10^-4, sigfigs(plutonic.Mn(isnan(plutonic.MnO))) );
plutonic.Ni(isnan(plutonic.Ni)) = roundsigfigs( plutonic.NiO(isnan(plutonic.Ni)).*58.6934./(58.6934+16).*10^4, sigfigs(plutonic.NiO(isnan(plutonic.Ni))) );
plutonic.P2O5(isnan(plutonic.P2O5)) = roundsigfigs( plutonic.P(isnan(plutonic.P2O5)).*(30.97376+40)./30.97376.*10^-4, sigfigs(plutonic.P(isnan(plutonic.P2O5))) );


removeFields={'Al','Ca','Cr2O3','Mn','NiO','P','CaCO3','H','H2O_Total','Fe2O3T'};
plutonic.elements(ismember(plutonic.elements,removeFields))=[];
plutonic = rmfield(plutonic, removeFields(isfield(plutonic,removeFields)));
addFields={'Eustar','Geolprov'};
plutonic.elements=[plutonic.elements',addFields(~ismember(addFields,plutonic.elements))]';





