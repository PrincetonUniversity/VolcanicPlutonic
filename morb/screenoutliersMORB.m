% morb=unelementify(morb,'k'); morb.data(morb.SiO2<35 | morb.SiO2 >85, :)=[]; morb=elementify(morb);
morb.Latitude(morb.Latitude<-90|morb.Latitude>90)=NaN;
morb.Longitude(morb.Longitude<-180|morb.Longitude>180)=NaN;
morb.TiO2(morb.TiO2.*morb.SiO2>300 | morb.TiO2<0.01)=NaN; %300 ,0.02; 
morb.Al2O3(morb.Al2O3>=25 | morb.Al2O3<=1)=NaN;
morb.Fe2O3(morb.Fe2O3>=22 | morb.Fe2O3<=0.01)=NaN; % 22,0.1
morb.Fe2O3T(morb.Fe2O3T>=25 | morb.Fe2O3T<=0.1)=NaN; % 22,0.1
morb.FeO(morb.FeO.*morb.SiO2>1050 | morb.FeO<=0.01)=NaN; % 1000,0.05
morb.FeOT(morb.FeOT.*morb.SiO2>1200 | morb.FeOT<=1)=NaN; 
morb.MgO(morb.MgO>=50 | morb.MgO <=0.003)=NaN; %morb.MgO(morb.MgO>30 | morb.MgO.*morb.SiO2.^2>300000)=NaN;
morb.CaO(morb.CaO>=20 | morb.CaO <=0.003)=NaN; %
morb.Na2O(morb.Na2O>=20 | morb.Na2O <=0.003)=NaN; %
morb.K2O(morb.K2O>=20 | morb.K2O <=0.003)=NaN; %
morb.P2O5(morb.P2O5>10 | morb.P2O5<=0.001)=NaN; % 1, 0.01
morb.MnO(morb.MnO>2 | morb.MnO<=0.001)=NaN; % 1, 0.01
morb.Loi(morb.Loi>=22 | morb.Loi <=0.005)=NaN;
morb.H2O_Plus(morb.H2O_Plus>20 | morb.H2O_Plus <=0.005)=NaN;
morb.H2O_Minus(morb.H2O_Minus>20 | morb.H2O_Minus <=0.005)=NaN;
morb.H2O(morb.H2O>20 | morb.H2O <=0.005)=NaN;
morb.Cr2O3(morb.Cr2O3>=10 | morb.Cr2O3 <=0.0003)=NaN;
morb.La(morb.La>=1000 | morb.La <=0.02)=NaN; % 450,0.1
morb.NiO(morb.NiO>=10 | morb.NiO <=0.0003)=NaN;
morb.Ce(morb.Ce>=1000 | morb.Ce <=0.2)=NaN; % morb.Ce(morb.Ce=500 | morb.Ce=300 | morb.Ce <=0.5)=NaN;
morb.Pr(morb.Pr>=100 | morb.Pr <=0.01)=NaN; % 50, 0.02
morb.Nd(morb.Nd>=400 | morb.Nd <=0.1)=NaN; % 350, 0.1
morb.Sm(morb.Sm>=100 | morb.Sm <=0.05)=NaN; % 50, 0.1
morb.Eu(morb.Eu>=20 | morb.Eu <=0.01)=NaN; % 10, 0.03
morb.Gd(morb.Gd>=50 | morb.Gd <=0.1)=NaN; % 30, 0.3
morb.Tb(morb.Tb>=12 | morb.Tb <=0.0)=NaN; % 7, 0.05
morb.Dy(morb.Dy>=70 | morb.Dy <=0.0)=NaN; % 40, 0.2
morb.Ho(morb.Ho>=11 | morb.Ho <=0.0)=NaN; % 7, 0.05
morb.Er(morb.Er>=27 | morb.Er <=0.1)=NaN; % 20, 0.2
morb.Tm(morb.Tm>=08 | morb.Tm <=0.01)=NaN; % 3, 0.05
morb.Yb(morb.Yb>=30 | morb.Yb <=0.05)=NaN; % 20, 0.2
morb.Lu(morb.Lu>=06 | morb.Lu <=0.01)=NaN; % 3, 0.035
morb.Li(morb.Li>=350 | morb.Li <=0.5)=NaN; % 150, 1
morb.Be(morb.Be>=70 | morb.Be <=0.01)=NaN; % 20, 0.1
morb.B(morb.B>=250 | morb.B <=0.1)=NaN; % 70, 0.2
morb.C(morb.C>=5 | morb.C <=0.001)=NaN; % 1, 0.002
morb.CO2(morb.CO2>=11 | morb.CO2 <=0.005)=NaN;

morb.F(morb.F<3)=morb.F(morb.F<3)*10^4; morb.F(morb.F>=5000 | morb.F<=5)=NaN; % bimodal by four orders of magnitude (ppm vs wt.% splits between <1 and >20)
morb.Cl(morb.Cl<3)=morb.Cl(morb.Cl<3)*10^4; morb.Cl(morb.Cl>=7000 | morb.Cl<=5)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
morb.S(morb.S<3)=morb.S(morb.S<3)*10^4; morb.S(morb.S>=10^4.2 | morb.S<=1)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
morb.P(morb.P<5)=morb.P(morb.P<5)*10^4; morb.P(morb.P>=5000 | morb.P<=10)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
morb.K(morb.K<10)=morb.K(morb.K<10)*10^4; morb.K( morb.K>10^5 | morb.K<150)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
morb.Ca(morb.Ca<100)=morb.Ca(morb.Ca<100)*10^4; morb.Ca(morb.Ca>1.1*10^5 | morb.Ca<300)=NaN; % Convert to ppm
morb.Ti(morb.Ti<9)=morb.Ti(morb.Ti<9)*10^4; morb.Ti(morb.Ti>=3*10^4 | morb.Ti<50)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
morb.Fe(morb.Fe<20)=morb.Fe(morb.Fe<20)*10^4; morb.Fe(morb.Fe>=1.5*10^5 | morb.Fe<=3000)=NaN; % bimodal by four orders of magnitude (ppm vs wt.%; splits between <1 and >10)
morb.Pt(morb.Pt>0.1)=morb.Pt(morb.Pt>0.1)/10^3; morb.Pt(morb.Pt>=0.1 | morb.Pt <=10^-4)=NaN; % Convert to PPM
morb.Pd(morb.Pd>0.1)=morb.Pd(morb.Pd>0.1)/10^3; morb.Pd(morb.Pd>=0.03 | morb.Pd <=10^-4)=NaN; % Convert to PPM
morb.Au(morb.Au>0.5)=morb.Au(morb.Au>0.5)/10^3;morb.Au(morb.Au>=0.06 | morb.Au <=10^-4)=NaN; % Convert to PPM
morb.W(morb.W==10)=NaN; % morb.W(morb.W>10)=morb.W(morb.W>10)/10^3; morb.W(morb.W>=5 | morb.W <=0.01)=NaN; % Convert to PPM
morb.Ir(morb.Ir>=0.01 | morb.Ir<0.0001)=NaN; % May have PPM, PPB, and PPT
% morb.Re(morb.Re>=0.01 | morb.Re<0.0001)=NaN; % May have PPM, PPB, and PPT
morb.Re(morb.Re>10^3)=morb.Re(morb.Re>10^3)/10^9; morb.Re(morb.Re>10^1)=morb.Re(morb.Re>10^1)/10^6; morb.Re(morb.Re>10^-2)=morb.Re(morb.Re>10^-2)/10^3; morb.Re(morb.Re>0.003|morb.Re<10^-5.5)=NaN;
morb.Hg(morb.Hg>10)=morb.Hg(morb.Hg>10)/10^3; morb.Hg(morb.Hg>=7 | morb.Hg <=0.001)=NaN; % Convert to PPM
morb.Bi(morb.Bi>10)=morb.Bi(morb.Bi>10)/10^3; morb.Bi(morb.Bi>=7 | morb.Bi <=0.002)=NaN; % Convert to PPM


morb.Sc(morb.Sc>200 | morb.Sc.*morb.SiO2>=5000 | morb.Sc <=0.1)=NaN; % 4000, 0.3
morb.V(morb.V>=1000 | morb.V <=0.1)=NaN; % 700, 0.5
morb.Cr(morb.Cr>=6000 | morb.Cr.*morb.SiO2.^3 > 6*10^8 | morb.Cr <=0.4)=NaN; % 4000, 0.6
morb.Mn(morb.Mn>=4000 | morb.Mn.*morb.SiO2.^2 > 10^7 | morb.Mn <=5)=NaN; %s 3000, 10
morb.Co(morb.Co>=250 | morb.Co <=0.01)=NaN; % 150, 0.05
morb.Ni(morb.Ni>=2000 | morb.Ni.*morb.SiO2.^3 > 2*10^8 | morb.Ni <=0.01)=NaN; % 1800, 0.1
morb.Cu(morb.Cu>=2000 | morb.Cu <=0.1)=NaN; % 500, 0.5
morb.Zn(morb.Zn>=700 | morb.Zn <=1)=NaN; % 400, 5
morb.Ga(morb.Ga>=50 | morb.Ga <=1)=NaN; % 40, 5
morb.Zr(morb.Zr>=2000 | morb.Zr <=1)=NaN; % 1800, 5
% morb.Os(morb.Os>=1 | morb.Os <0.0001)=NaN; % 40, 5 %
morb.Os(morb.Os>10^3)=morb.Os(morb.Os>10^3)/10^9; morb.Os(morb.Os>10^1)=morb.Os(morb.Os>10^1)/10^6; morb.Os(morb.Os>10^-2)=morb.Os(morb.Os>10^-2)/10^3; 
morb.Rb(morb.Rb>=1100 | morb.Rb <0.05)=NaN;
morb.Ba(morb.Ba>7000 | morb.Ba<=1)=NaN; % 4000, 5a
morb.Y(morb.Y>400 | morb.Y<=1)=NaN; % 145, 2
morb.Pb(morb.Pb>400 | morb.Pb<=0.05)=NaN; % 100, 0.05
morb.Te(morb.Te>=100 | morb.Te <=10^-4)=NaN; % 10, 0.005
morb.Nb(morb.Nb>800 | morb.Nb<=0.1)=NaN; % 300, 0.1
% morb.H - Not much data - DELETE
morb.Tl(morb.Tl>=15 | morb.Tl<=0.005)=NaN;
morb.Sn(morb.Sn>=50 | morb.Sn<=0.05)=NaN; % 10, 0.5
morb.Cd(morb.Cd>=10 | morb.Cd<=0.01)=NaN;
morb.As(morb.As>=150 | morb.As<=0.1)=NaN; % 20, 0.2
morb.Sr(morb.Sr>=6000 | morb.Sr.*morb.SiO2 <100 | morb.Sr.*morb.SiO2>10^5.5 |morb.Sr<=0.5)=NaN; % 3000, 0.2
morb.Se(morb.Se>=100 | morb.Se<=0.01)=NaN; % 20, 0.2
morb.Ta(morb.Ta>=40 | morb.Ta<=0.1)=NaN; % 13, 0.1
morb.Mo(morb.Mo>=2000 | morb.Mo./morb.SiO2.^4>10^-4.2 | morb.Mo<=0.05)=NaN; % 10, 0.1
morb.U(morb.U>=50 | morb.U<=0.01)=NaN; % 13, 0.01
morb.Cs(morb.Cs>=100 | morb.Cs./morb.SiO2.^2>0.03 | morb.Cs<0.01)=NaN; % 20, <=0.01
morb.Sb(morb.Sb>=10 | morb.Sb<=0.01)=NaN; % 2.5, 0.025
morb.Ag(morb.Ag>=10 | morb.Ag<=0.001)=NaN; % 2.5, 0.001
morb.Th(morb.Th>=200 | morb.Th<=0.01)=NaN; % 100, 0.01
morb.Hf(morb.Hf>=70 | morb.Hf<0.1)=NaN; %


morb.Sr87_Sr86(morb.Sr87_Sr86>2 | morb.Sr87_Sr86<=0.7)=NaN; % 0.75, 0.7
morb.Nd143_Nd144(morb.Nd143_Nd144>0.514 | morb.Nd143_Nd144 <0.51)=NaN;

