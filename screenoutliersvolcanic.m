% test=isnan(volcanic.Latitude) | isnan(volcanic.Longitude) | volcanic.Elevation<-100 | volcanic.SiO2<40 | volcanic.SiO2>80;
volcanic.Latitude(volcanic.Latitude<-90|volcanic.Latitude>90)=NaN;
volcanic.Longitude(volcanic.Longitude<-180|volcanic.Longitude>180)=NaN;
volcanic.TiO2(volcanic.TiO2.*volcanic.SiO2>300 | volcanic.TiO2<0.01)=NaN; %300 ,0.02; 
volcanic.Al2O3(volcanic.Al2O3>=25 | volcanic.Al2O3<=1)=NaN;
volcanic.Fe2O3(volcanic.Fe2O3>=22 | volcanic.Fe2O3<=0.01)=NaN; % 22,0.1
volcanic.Fe2O3T(volcanic.Fe2O3T>=22 | volcanic.Fe2O3T<=0.1)=NaN; % 22,0.1
volcanic.FeO(volcanic.FeO.*volcanic.SiO2>1050 | volcanic.FeO<=0.01)=NaN; % 1000,0.05
volcanic.FeOT(volcanic.FeOT.*volcanic.SiO2>1200 | volcanic.FeOT<=0.01)=NaN; 
volcanic.MgO(volcanic.MgO>30 | volcanic.MgO.*volcanic.SiO2.^2>300000 | volcanic.MgO <=0.003)=NaN; 
volcanic.Na2O(volcanic.Na2O>=20 | volcanic.Na2O <=0.003)=NaN; %
volcanic.K2O(volcanic.K2O>=20 | volcanic.K2O <=0.003)=NaN; %
volcanic.P2O5(volcanic.P2O5>10 | volcanic.P2O5<=0.001)=NaN; % 1, 0.01
volcanic.MnO(volcanic.MnO>2 | volcanic.MnO<=0.001)=NaN; % 1, 0.01
volcanic.Loi(volcanic.Loi>=22 | volcanic.Loi <=0.005)=NaN;
volcanic.H2O_Plus(volcanic.H2O_Plus>20 | volcanic.H2O_Plus <=0.005)=NaN;
volcanic.H2O_Minus(volcanic.H2O_Minus>20 | volcanic.H2O_Minus <=0.005)=NaN;
volcanic.H2O(volcanic.H2O>20 | volcanic.H2O <=0.005)=NaN;
volcanic.Cr2O3(volcanic.Cr2O3>=10 | volcanic.Cr2O3 <=0.0003)=NaN;
volcanic.La(volcanic.La>=1000 | volcanic.La <=0.02)=NaN; % 450,0.1
volcanic.NiO(volcanic.NiO>=10 | volcanic.NiO <=0.0003)=NaN;
volcanic.Ce(volcanic.Ce>=1000 | volcanic.Ce <=0.2)=NaN; % volcanic.Ce(volcanic.Ce=500 | volcanic.Ce=300 | volcanic.Ce <=0.5)=NaN;
volcanic.Pr(volcanic.Pr>=100 | volcanic.Pr <=0.01)=NaN; % 50, 0.02
volcanic.Nd(volcanic.Nd>=400 | volcanic.Nd <=0.1)=NaN; % 350, 0.1
volcanic.Sm(volcanic.Sm>=100 | volcanic.Sm <=0.05)=NaN; % 50, 0.1
volcanic.Eu(volcanic.Eu>=20 | volcanic.Eu <=0.01)=NaN; % 10, 0.03
volcanic.Gd(volcanic.Gd>=50 | volcanic.Gd <=0.1)=NaN; % 30, 0.3
volcanic.Tb(volcanic.Tb>=12 | volcanic.Tb <=0.0)=NaN; % 7, 0.05
volcanic.Dy(volcanic.Dy>=70 | volcanic.Dy <=0.0)=NaN; % 40, 0.2
volcanic.Ho(volcanic.Ho>=11 | volcanic.Ho <=0.0)=NaN; % 7, 0.05
volcanic.Er(volcanic.Er>=27 | volcanic.Er <=0.1)=NaN; % 20, 0.2
volcanic.Tm(volcanic.Tm>=08 | volcanic.Tm <=0.01)=NaN; % 3, 0.05
volcanic.Yb(volcanic.Yb>=30 | volcanic.Yb <=0.05)=NaN; % 20, 0.2
volcanic.Lu(volcanic.Lu>=06 | volcanic.Lu <=0.01)=NaN; % 3, 0.035
volcanic.Li(volcanic.Li>=350 | volcanic.Li <=0.5)=NaN; % 150, 1
volcanic.Be(volcanic.Be>=70 | volcanic.Be <=0.01)=NaN; % 20, 0.1
volcanic.B(volcanic.B>=250 | volcanic.B <=0.1)=NaN; % 70, 0.2
volcanic.C(volcanic.C>=5 | volcanic.C <=0.001)=NaN; % 1, 0.002
volcanic.CO2(volcanic.CO2>=11 | volcanic.CO2 <=0.005)=NaN;

volcanic.F(volcanic.F<3)=volcanic.F(volcanic.F<3)*10^4; volcanic.F(volcanic.F>=5000 | volcanic.F<=5)=NaN; % bimodal by four orders of magnitude (ppm vs wt.% splits between <1 and >20)
volcanic.Cl(volcanic.Cl<3)=volcanic.Cl(volcanic.Cl<3)*10^4; volcanic.Cl(volcanic.Cl>=7000 | volcanic.Cl<=5)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
volcanic.S(volcanic.S<3)=volcanic.S(volcanic.S<3)*10^4; volcanic.S(volcanic.S>=10^4.2 | volcanic.S<=1)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
volcanic.P(volcanic.P<5)=volcanic.P(volcanic.P<5)*10^4; volcanic.P(volcanic.P>=5000 | volcanic.P<=10)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
volcanic.K(volcanic.K<10)=volcanic.K(volcanic.K<10)*10^4; volcanic.K( volcanic.K>10^5 | volcanic.K<150)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
volcanic.Ca(volcanic.Ca<100)=volcanic.Ca(volcanic.Ca<100)*10^4; volcanic.Ca(volcanic.Ca>1.1*10^5 | volcanic.Ca<300)=NaN; % Convert to ppm
volcanic.Mg(volcanic.Mg<50)=volcanic.Mg(volcanic.Mg<50)*10^4; volcanic.Mg(volcanic.Mg>1.1*10^5 | volcanic.Mg<15)=NaN; % Convert to ppm
volcanic.Ti(volcanic.Ti<9)=volcanic.Ti(volcanic.Ti<9)*10^4; volcanic.Ti(volcanic.Ti>=3*10^4 | volcanic.Ti<50)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
volcanic.Fe(volcanic.Fe<20)=volcanic.Fe(volcanic.Fe<20)*10^4; volcanic.Fe(volcanic.Fe>=1.5*10^5 | volcanic.Fe<=3000)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
volcanic.Al(volcanic.Al<100)=volcanic.Al(volcanic.Al<100)*10^4; volcanic.Al(volcanic.Al>=1.5*10^5 | volcanic.Al <=10^4)=NaN;
volcanic.Pt(volcanic.Pt>0.1)=volcanic.Pt(volcanic.Pt>0.1)/10^3; volcanic.Pt(volcanic.Pt>=0.1 | volcanic.Pt <=10^-4)=NaN; % Convert to PPM
volcanic.Pd(volcanic.Pd>0.1)=volcanic.Pd(volcanic.Pd>0.1)/10^3; volcanic.Pd(volcanic.Pd>=0.03 | volcanic.Pd <=10^-4)=NaN; % Convert to PPM
volcanic.Au(volcanic.Au>0.5)=volcanic.Au(volcanic.Au>0.5)/10^3;volcanic.Au(volcanic.Au>=0.06 | volcanic.Au <=10^-4)=NaN; % Convert to PPM

volcanic.W(volcanic.W==10)=NaN;
volcanic.Mo(volcanic.Mo>=2000 | volcanic.Mo<=0.05)=NaN; % 10, 0.1
% volcanic.W(volcanic.W>10)=volcanic.W(volcanic.W>10)/10^3; volcanic.W(volcanic.W>=9 | volcanic.W <=0.02)=NaN; % Convert to PPM
% volcanic.Mo(volcanic.Mo>20)=volcanic.Mo(volcanic.Mo>20)/10^3; volcanic.Mo(volcanic.Mo>=18 | volcanic.Mo <=0.05)=NaN; % Convert to PPM

volcanic.Ir(volcanic.Ir>=0.01 | volcanic.Ir<0.0001)=NaN; % May have PPM, PPB, and PPT
% volcanic.Re(volcanic.Re>=0.01 | volcanic.Re<0.0001)=NaN; % May have PPM, PPB, and PPT
volcanic.Re(volcanic.Re>10^3)=volcanic.Re(volcanic.Re>10^3)/10^9; volcanic.Re(volcanic.Re>10^1)=volcanic.Re(volcanic.Re>10^1)/10^6; volcanic.Re(volcanic.Re>10^-2)=volcanic.Re(volcanic.Re>10^-2)/10^3; volcanic.Re(volcanic.Re>0.003|volcanic.Re<10^-5.5)=NaN;
volcanic.Hg(volcanic.Hg>10)=volcanic.Hg(volcanic.Hg>10)/10^3; volcanic.Hg(volcanic.Hg>=7 | volcanic.Hg <=0.001)=NaN; % Convert to PPM
volcanic.Bi(volcanic.Bi>10)=volcanic.Bi(volcanic.Bi>10)/10^3; volcanic.Bi(volcanic.Bi>=7 | volcanic.Bi <=0.002)=NaN; % Convert to PPM


volcanic.Sc(volcanic.Sc.*volcanic.SiO2>=5000 | volcanic.Sc <=0.1)=NaN; % 4000, 0.3
volcanic.V(volcanic.V>=1000 | volcanic.V <=0.1)=NaN; % 700, 0.5
volcanic.Cr(volcanic.Cr>=6000 | volcanic.Cr.*volcanic.SiO2.^3 > 6*10^8 | volcanic.Cr <=0.4)=NaN; % 4000, 0.6
volcanic.Mn(volcanic.Mn>=4000 | volcanic.Mn.*volcanic.SiO2.^2 > 10^7 | volcanic.Mn <=5)=NaN; %s 3000, 10
volcanic.Co(volcanic.Co>=250 | volcanic.Co <=0.01)=NaN; % 150, 0.05
volcanic.Ni(volcanic.Ni>=2000 | volcanic.Ni.*volcanic.SiO2.^3 > 2*10^8 | volcanic.Ni <=0.01)=NaN; % 1800, 0.1
volcanic.Cu(volcanic.Cu>=2000 | volcanic.Cu <=0.1)=NaN; % 500, 0.5
volcanic.Zn(volcanic.Zn>=700 | volcanic.Zn <=1)=NaN; % 400, 5
volcanic.Ga(volcanic.Ga>=50 | volcanic.Ga <=1)=NaN; % 40, 5
volcanic.Zr(volcanic.Zr>=2000 | volcanic.Zr <=1)=NaN; % 1800, 5
% volcanic.Os(volcanic.Os>=1 | volcanic.Os <0.0001)=NaN; % 40, 5
volcanic.Os(volcanic.Os>10^3)=volcanic.Os(volcanic.Os>10^3)/10^9; volcanic.Os(volcanic.Os>10^1)=volcanic.Os(volcanic.Os>10^1)/10^6; volcanic.Os(volcanic.Os>10^-2)=volcanic.Os(volcanic.Os>10^-2)/10^3; 
volcanic.Rb(volcanic.Rb>=1100 | volcanic.Rb <0.05)=NaN;
volcanic.Bi(volcanic.Bi>=1 | volcanic.Bi <0.009)=NaN;
volcanic.I(volcanic.I>=10^6 | volcanic.I <=0)=NaN; % volcanic.I - Not enough data
volcanic.Nd143_Nd144(volcanic.Nd143_Nd144>0.514 | volcanic.Nd143_Nd144 <0.51)=NaN;
volcanic.Ba(volcanic.Ba>7000 | volcanic.Ba<=1)=NaN; % 4000, 5
volcanic.Y(volcanic.Y>400 | volcanic.Y<=1)=NaN; % 145, 2
volcanic.Pb(volcanic.Pb>500 | volcanic.Pb<=0.05)=NaN; % 100, 0.05
volcanic.D18O(volcanic.D18O>14 | volcanic.D18O<=0.1)=NaN;
volcanic.Te(volcanic.Te>=10^6 | volcanic.Te <=0)=NaN; % volcanic.Te - Not enough data
volcanic.Nb(volcanic.Nb>800 | volcanic.Nb<=0.1)=NaN; % 300, 0.1
% volcanic.H - No data DELETE
volcanic.Sr87_Sr86(volcanic.Sr87_Sr86>1 | volcanic.Sr87_Sr86<=0.7)=NaN; % 0.75, 0.7
volcanic.Tl(volcanic.Tl>=15 | volcanic.Tl<=0.005)=NaN;
volcanic.Sn(volcanic.Sn>=50 | volcanic.Sn<=0.05)=NaN; % 10, 0.5
volcanic.Cd(volcanic.Cd>=10 | volcanic.Cd<=0.01)=NaN;
volcanic.As(volcanic.As>=150 | volcanic.As<=0.1)=NaN; % 20, 0.2
volcanic.Sr(volcanic.Sr>=6000 | volcanic.Sr.*volcanic.SiO2 <100 | volcanic.Sr.*volcanic.SiO2>10^5.5 |volcanic.Sr<=0.5)=NaN; % 3000, 0.2
volcanic.Se(volcanic.Se>=100 | volcanic.Se<=0.01)=NaN; % 20, 0.2
volcanic.Ta(volcanic.Ta>=40 | volcanic.Ta<=0.1)=NaN; % 13, 0.1
volcanic.U(volcanic.U>=50 | volcanic.U<=0.01)=NaN; % 13, 0.01
volcanic.Cs(volcanic.Cs>=100 | volcanic.Cs./volcanic.SiO2.^2>0.03 | volcanic.Cs<0.01)=NaN; % 20, <=0.01
volcanic.Sb(volcanic.Sb>=10 | volcanic.Sb<=0.01)=NaN; % 2.5, 0.025
volcanic.Ag(volcanic.Ag>=10 | volcanic.Ag<=0.001)=NaN; % 2.5, 0.001
volcanic.Th(volcanic.Th>=200 | volcanic.Th<=0.01)=NaN; % 100, 0.01
volcanic.Hf(volcanic.Hf>=70 | volcanic.Hf<0.1)=NaN; %


%%


volcanic=h2oconversion(volcanic);
        
volcanic.Al2O3(isnan(volcanic.Al2O3)) = roundsigfigs( volcanic.Al(isnan(volcanic.Al2O3)).*(26.9815+24)./26.9815.*10^-4, sigfigs(volcanic.Al(isnan(volcanic.Al2O3))) );
volcanic.CaO(isnan(volcanic.CaO)) = roundsigfigs( volcanic.Ca(isnan(volcanic.CaO)).*(40.078+16)./40.078.*10^-4, sigfigs(volcanic.Ca(isnan(volcanic.CaO))) );
volcanic.Cr(isnan(volcanic.Cr)) = roundsigfigs( volcanic.Cr2O3(isnan(volcanic.Cr)).*51.9961./(51.9961+24).*10^4, sigfigs(volcanic.Cr2O3(isnan(volcanic.Cr))) );
volcanic.MnO(isnan(volcanic.MnO)) = roundsigfigs( volcanic.Mn(isnan(volcanic.MnO)).*(54.93805+16)./54.93805.*10^-4, sigfigs(volcanic.Mn(isnan(volcanic.MnO))) );
volcanic.Ni(isnan(volcanic.Ni)) = roundsigfigs( volcanic.NiO(isnan(volcanic.Ni)).*58.6934./(58.6934+16).*10^4, sigfigs(volcanic.NiO(isnan(volcanic.Ni))) );
volcanic.P2O5(isnan(volcanic.P2O5)) = roundsigfigs( volcanic.P(isnan(volcanic.P2O5)).*(30.97376+40)./30.97376.*10^-4, sigfigs(volcanic.P(isnan(volcanic.P2O5))) );


removeFields={'Al','Ca','Cr2O3','Mn','NiO','P','CaCO3','H','H2O_Total','Fe2O3T'};
volcanic.elements(ismember(volcanic.elements,removeFields))=[];
volcanic = rmfield(volcanic, removeFields(isfield(volcanic,removeFields)));
addFields={'Eustar','Geolprov'};
volcanic.elements=[volcanic.elements',addFields(~ismember(addFields,volcanic.elements))]';





