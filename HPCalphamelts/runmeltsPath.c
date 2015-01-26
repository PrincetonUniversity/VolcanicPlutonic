// runmeltsPlutonic.c: call alphaMELTS n times on n processors
// Last modified 1/25/15 by C. Brenhin Keller

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <strings.h>
#include <time.h>
#include <mpi.h>
#include "arrays.h"
#include "runmelts.h"

int main(int argc, char **argv){
	MPI_Init(&argc, &argv);
	// Check input arguments
	if (argc != 2) {
		printf("USAGE: %s <sims_per_task> \n", argv[0]);
		exit(1);
	}
	// Get number of simulations per MPI task from command-line argument
	const int sims_per_task = atoi(argv[1]);

	// Starting composition
	//SiO2, TiO2, Al2O3, Fe2O3, Cr2O3, FeO, MnO, MgO, NiO, CoO, CaO, Na2O, K2O, P2O5, CO2, H2O
//	const double sc[16]={51.33, 0.98, 15.70, 0, 0.0582, 8.72, 0.17, 9.48, 0.0202, 0.0052, 9.93, 2.61, 0.88, 0.22, 1.14, 2.48}; // Primitive continental arc basalt, Kelemen 2014 TOG
	double *ic=malloc(16*sizeof(double)), *icq=malloc(16*sizeof(double));

	// Composition path to fit/minimize to
	// SiO2, TiO2, Al2O3, Cr2O3, FeOT, MnO, MgO, Ni, Co, CaO, Na2O, K2O, P2O5
/*	const double composition[15][13] = 
		{{50.979613,1.1690023,15.231422,0.041635479,9.0818295,0.17486412,6.6900805,0.012953388,0.0051886516,9.3522662,2.9386955,1.3423280,0.29856644},
		{52.925974,1.1317641,15.812696,0.028081653,8.3761499,0.17357375,5.5486577,0.0090310919,0.0045532476,8.2492886,3.2069928,1.7097772,0.32104945},
		{55.022895,1.0349283,16.687937,0.019390833,7.3264530,0.14594057,4.2152904,0.0072781067,0.0030927401,6.8677492,3.6654366,2.1708135,0.33926278},
		{57.005135,0.93554045,16.820477,0.012617400,6.7370692,0.13537211,3.4707621,0.0054965903,0.0027034463,5.9692059,3.8297514,2.5377692,0.32672485},
		{59.022200,0.83761594,16.785750,0.0082600449,6.3099672,0.12894138,2.7988933,0.0041014541,0.0022549115,5.2448577,3.9347444,2.7391756,0.29989056},
		{61.016330,0.74695516,16.572702,0.0073665721,5.7116875,0.11786098,2.3785881,0.0033465649,0.0019282575,4.7268870,3.9385052,2.8790708,0.24945402},
		{63.005149,0.67283323,16.282609,0.0058364970,4.9455857,0.099221324,1.9811915,0.0025989102,0.0015725352,4.1213992,4.0031123,2.9010505,0.22303072},
		{65.004458,0.58829584,15.881186,0.0049109988,4.3349831,0.085816583,1.6254273,0.0021689724,0.0014456290,3.5220715,3.9074390,3.1166157,0.20121130},
		{67.031760,0.49560578,15.469005,0.0041078016,3.6505567,0.074632284,1.2758417,0.0019584848,0.0012995764,2.9727752,3.7611164,3.4096894,0.17175863},
		{68.994041,0.42349432,14.995299,0.0036759395,3.0579879,0.066119339,0.92085973,0.0013969923,0.0010399440,2.4096793,3.7788267,3.5537203,0.14060032},
		{71.012929,0.32799358,14.436563,0.0024466503,2.6091835,0.057947366,0.64090520,0.0010530986,0.00087596818,1.8345930,3.7062601,3.9130216,0.11348708},
		{72.994979,0.23414727,13.785654,0.0023026652,1.9478408,0.052236451,0.42353628,0.00095525160,0.00078350208,1.3040653,3.5705121,4.2563434,0.086826909},
		{74.947294,0.16707255,13.115036,0.0025810930,1.3869914,0.049593507,0.28581892,0.0011395782,0.00094829783,0.89158683,3.4759595,4.4099875,0.068114931},
		{76.782822,0.14452773,12.316397,0.0025247924,1.1168832,0.043041956,0.21718072,0.0010232453,0.00094461893,0.59745493,3.3432270,4.3383327,0.051947804},
		{78.758746,0.18556105,11.216380,0.0037884299,1.2459005,0.039656902,0.30471980,0.0011186816,0.0013918153,0.56712211,2.8425096,3.5879441,0.063745967}};*/
	//PLUTONIC, raw means

	const double composition[15][13] = 
		{{50.959315,1.4533949,15.429112,0.032947751,10.604847,0.18050521,6.2956377,0.011925300,0.0055151830,9.1927508,2.8978804,1.0940515,0.29734026},
		{52.956150,1.2457083,15.793906,0.026702896,9.5539629,0.17126994,5.5531172,0.0094339069,0.0049192048,8.3934451,3.0984404,1.3871295,0.29409761},
		{54.959864,1.0942049,16.302941,0.019140731,8.4377540,0.16408989,4.5087938,0.0076372146,0.0042619016,7.3167660,3.4919452,1.7980666,0.28976893},
		{56.987484,0.96105940,16.530617,0.016206935,7.2926528,0.14702023,3.7234307,0.0060836886,0.0034142863,6.4029524,3.6904522,2.1898787,0.28174097},
		{58.988167,0.85982735,16.660171,0.010614959,6.5430814,0.13994148,3.0207039,0.0045215128,0.0027404319,5.6869214,3.9212211,2.3624638,0.27016404},
		{60.964951,0.77680399,16.512221,0.0086592287,5.6470079,0.13229665,2.4374906,0.0037119546,0.0023451237,4.8894697,4.0896268,2.6385671,0.24770567},
		{62.969230,0.71696754,16.075365,0.0075262199,5.1824608,0.11939064,2.0564861,0.0033032239,0.0019714252,4.1911654,4.1140840,2.7790448,0.22320844},
		{64.947933,0.63425708,15.700762,0.0062212077,4.4991707,0.10845482,1.6077934,0.0026224599,0.0018238638,3.4775284,4.1453165,2.9961350,0.19602851},
		{66.982995,0.56690481,14.982500,0.0045130454,4.1205754,0.098632546,1.1958142,0.0019121719,0.0016070891,2.7351686,3.9901524,3.3675616,0.16885485},
		{68.980188,0.46903239,14.496330,0.0037251196,3.4949134,0.092172294,0.90545283,0.0016262609,0.0014606950,2.1073182,3.9066694,3.5521655,0.12982287},
		{70.992016,0.38345169,13.863859,0.0031577418,2.9777085,0.081067758,0.65440056,0.0015396753,0.0011986159,1.6419542,3.7936664,3.7560096,0.10925396},
		{73.011183,0.27842721,13.225166,0.0031759412,2.3077147,0.066459914,0.44812612,0.0013042430,0.0010595218,1.1697197,3.5512539,4.1458005,0.076303926},
		{74.959570,0.21290092,12.699896,0.0026930487,1.8745072,0.056841057,0.35350961,0.0011877359,0.00078841188,0.80880957,3.3082042,4.3943012,0.048081579},
		{76.888400,0.18687065,12.243314,0.0029262113,1.3968142,0.051616104,0.30648860,0.0010659201,0.00072142755,0.73172868,3.2170443,4.1557748,0.048535734},
		{78.801169,0.22025007,11.258841,0.0032905523,1.3969219,0.040261161,0.39548820,0.0012159631,0.00098650182,0.63551958,2.6680846,3.7197029,0.044987548}};
	//VOLCANIC, raw means



	// Simulation variables
	char prefix[200], cmd_string[500];
	FILE *fp;
	int minerals=0, i, j, k;

	// Get world size (number of MPI processes) and world rank (# of this process)
	int world_size, world_rank;
	MPI_Comm_size(MPI_COMM_WORLD,&world_size);
	MPI_Comm_rank(MPI_COMM_WORLD,&world_rank);
	printf("Hello from %d of %d processors\n", world_rank, world_size);

	// Variables that control size and location of the simulation
	/***********************************************************/	
	// Number of simulations to run , and temperature step size in each simulation
	const int nsims=world_size*sims_per_task, deltaT=-10;
	int n=world_rank-world_size;
	// Location of scratch directory (ideally local scratch for each node)
	// This location may vary on your system - contact your sysadmin if unsure
	const char scratchdir[]="/scratch/";
	/***********************************************************/	
	const int maxMinerals=40, maxSteps=1700/abs(deltaT), maxColumns=50;

	// Variables for MPI communication and reducing results
	const int sendArraySize=ceil(nsims/world_size);
	int *sendarrayN=calloc(sendArraySize,sizeof(int)), *rbufN, sendArrayIndex=0; 
	double *sendarrayR=calloc(sendArraySize,sizeof(double)), *rbufR, *sendarrayCO2=calloc(sendArraySize,sizeof(double)), *rbufCO2, *sendarrayWater=calloc(sendArraySize,sizeof(double)), *rbufWater, *sendarrayfo2=calloc(sendArraySize,sizeof(double)), *rbuffo2;

	
	// Malloc space for the imported array
	double **rawMatrix=mallocDoubleArray(maxMinerals*maxSteps,maxColumns);
	double ***melts=malloc(maxMinerals*sizeof(double**));
	char **names=malloc(maxMinerals*sizeof(char*));
	char ***elements=malloc(maxMinerals*sizeof(char**));
	int *rows=malloc(maxMinerals*sizeof(int)), *columns=malloc(maxMinerals*sizeof(int));
	for (i=0; i<maxMinerals; i++){
			names[i]=malloc(30*sizeof(char));
			elements[i]=malloc(maxColumns*sizeof(char*));
			for (k=0; k<maxColumns; k++){
				elements[i][k]=malloc(30*sizeof(char));
			}
	}

	// Variables for RNG and P-T path generator	
	const int steps=7;
	unsigned seed=(time(NULL)*world_rank) % 2147483000;
	double r1, r2, n1, n2, Pi, Pf, liquidusTemp, absc[steps], ordn[steps], x[500], y[500], fo2Delta;
	int points;

	//  Variables for minimization
	int SiO2, TiO2, Al2O3, Fe2O3, Cr2O3, FeO, MnO, MgO, NiO, CoO, CaO, Na2O, K2O, P2O5, CO2, H2O;
	double *residuals=malloc(maxSteps * sizeof(double)), *normconst=malloc(maxSteps * sizeof(double)), minresiduals=0;
	int meltsrow;

	if ( world_rank == 1) {	
	//	printf("   rank\t       n\t residual\t     CO2      \t     H2O\t     fO2\t      initial pressure\n"); // Command line output format
		printf("rank\tn\tresidual\tCO2\tH2O\tfO2\tinitial pressure\n"); // Command line output format
	}

	// Run the simulation
	while (n<nsims-world_size) {
		// Increment n
		n=n+world_size;

		// Set initial oxide composition
		for(i=0; i<14; i++){ic[i]=sc[i];}

		// Determine initial water and CO2 content
		ic[14]=rand_r(&seed)/(double)RAND_MAX*1;
		ic[15]=rand_r(&seed)/(double)RAND_MAX*4;

		// Determine inital fO2
//		fo2Delta=rand_r(&seed)/((double)RAND_MAX)*2 - 1; // Uniformly distributed between -1 and 1
		fo2Delta=0;

		// Determine starting pressure
		r1=rand_r(&seed)/(double)RAND_MAX, r2=rand_r(&seed)/(double)RAND_MAX; //generate two standard uniform variables
//		n1=sqrt(-2*log(r1))*cos(2*3.1415926535*r2), n2=sqrt(-2*log(r1))*sin(2*3.1415926535*r2); //generate two independant standard gaussian variables
		Pi=10000+15000*r1, Pf=10000*r2;

		// Configure working directory
		sprintf(prefix,"%sout%d/", scratchdir, n);
		sprintf(cmd_string,"mkdir -p %s", prefix);
		system(cmd_string);

		// Run MELTS to equilibrate fO2 at the liquidus
		runmelts(prefix,ic,"pMELTS","isobaric","FMQ",fo2Delta,"1\nsc.melts\n10\n1\n3\n1\nliquid\n1\n0.99\n0\n0\n","","!",1700,Pi,deltaT,0,0.005);
		
		// If simulation failed, clean up scratch directory and move on to next simulation
		sprintf(cmd_string,"%sPhase_main_tbl.txt", prefix);
		if ((fp = fopen(cmd_string, "r")) == NULL) {
			fprintf(stderr, "%d: MELTS equilibration failed to produce output.\n", n);
			sprintf(cmd_string,"rm -r %s", prefix);
			system(cmd_string);
			continue;
		}
		importmelts(prefix, melts, rawMatrix, rows, columns, names, elements, &minerals); // Import results, if they exist
		if (minerals<1 | strcmp(names[0],"liquid_0")!=0) {
			fprintf(stderr, "%d: MELTS equilibration failed to calculate liquid composition.\n", n);
			sprintf(cmd_string,"rm -r %s", prefix);
			system(cmd_string);
			continue;
		}

		// Copy the liquid composition for use as the starting composition of the next MELTS calculation. Format:
		// Pressure Temperature mass S H V Cp viscosity SiO2 TiO2 Al2O3 Fe2O3 Cr2O3 FeO MnO MgO NiO CoO CaO Na2O K2O P2O5 CO2 H2O
		for (i=0; i<16; i++){
			icq[i]=melts[0][0][i+8];
 		}
		liquidusTemp=melts[0][0][1];
		points=(int)ceil((liquidusTemp-700)/(-deltaT));


		// Generate x and y vectors
		absc[0]=0;
		ordn[0]=NAN;
		while isnan(ordn[0]){
			ordn[0]=0;
			for (i=1; i<steps; i++){
				if ((double)rand_r(&seed)/(double)RAND_MAX > 0.5){
					ordn[i]=ordn[i-1]-(double)rand_r(&seed)/(double)RAND_MAX;
					absc[i]=absc[i-1]+(double)rand_r(&seed)/(double)RAND_MAX/2;
				} else {
					ordn[i]=ordn[i-1];
					absc[i]=absc[i-1]+(double)rand_r(&seed)/(double)RAND_MAX;
				}
			}
			for(i=0; i<steps; i++) {
				ordn[i]=ordn[i]-ordn[steps-1]; //Align y axis
				absc[i]=absc[i] * points / absc[steps-1]; //Scale x axis
			}
			for(i=steps-1; i>=0; i--) ordn[i]=ordn[i] * (Pi-Pf) / ordn[0] + Pf; //Scale y axis
		}

		for (i=1; i<steps; i++){
			for (j=floor(absc[i-1]); j<floor(absc[i]) & j<500; j++) {
				y[j]=ordn[i-1] + (j+1-absc[i-1]) / (absc[i]-absc[i-1]) * (ordn[i]-ordn[i-1]);
				x[j]=j+1;
			}
		}

		// Write P-T path to file
		sprintf(cmd_string,"%sptpath", prefix);
		fp=fopen(cmd_string, "w");
		for (i=0; i<points; i++) fprintf(fp,"%f %f\n",y[i],liquidusTemp+deltaT*i);
		fclose(fp);
	
		minerals=0;
	
		// Run MELTS
		runmelts(prefix,icq,"pMELTS","PTpath","None",0.0,"1\nsc.melts\n10\n1\n3\n1\nliquid\n1\n0.99\n0\n10\n0\n4\n0\n","!","",1700,Pi,deltaT,0,0.005);
	
		// If simulation failed, clean up scratch directory and move on to next simulation
		if ((fp = fopen(cmd_string, "r")) == NULL) {
			fprintf(stderr, "%d: melts simulation failed to produce output.\n", n);
			sprintf(cmd_string,"rm -r %s", prefix);
			system(cmd_string);
			continue;
		}
		importmelts(prefix, melts, rawMatrix, rows, columns, names, elements, &minerals); // Import results, if they exist
		if (minerals<1 | strcmp(names[0],"liquid_0")!=0) {
			fprintf(stderr, "%d: MELTS simulation failed to calculate liquid composition.\n", n);
			sprintf(cmd_string,"rm -r %s", prefix);
			system(cmd_string);
			continue;
		}

		// Find the columns containing useful elements
		for(i=0; i<columns[0]; i++){
			if (strcmp(elements[0][i], "SiO2")==0) SiO2=i;
			else if (strcmp(elements[0][i], "TiO2")==0) TiO2=i;
			else if (strcmp(elements[0][i], "Al2O3")==0) Al2O3=i;
			else if (strcmp(elements[0][i], "Fe2O3")==0) Fe2O3=i;
			else if (strcmp(elements[0][i], "Cr2O3")==0) Cr2O3=i;
			else if (strcmp(elements[0][i], "FeO")==0) FeO=i;
			else if (strcmp(elements[0][i], "MnO")==0) MnO=i;
			else if (strcmp(elements[0][i], "MgO")==0) MgO=i;
			else if (strcmp(elements[0][i], "NiO")==0) NiO=i;
			else if (strcmp(elements[0][i], "CoO")==0) CoO=i;
			else if (strcmp(elements[0][i], "CaO")==0) CaO=i;
			else if (strcmp(elements[0][i], "Na2O")==0) Na2O=i;
			else if (strcmp(elements[0][i], "K2O")==0) K2O=i;
			else if (strcmp(elements[0][i], "P2O5")==0) P2O5=i;
			else if (strcmp(elements[0][i], "CO2")==0) CO2=i;
			else if (strcmp(elements[0][i], "H2O")==0) H2O=i;
		}



		// Renormalize melts output
		for (meltsrow=0; meltsrow<rows[0]; meltsrow++){
			normconst[meltsrow]=1; //No normalization
//			normconst[meltsrow]=100/(100-melts[0][meltsrow][CO2]-melts[0][meltsrow][H2O]); //Anhydrous normalization
		}

		// Find how well this melts simulation matches the composition we're fitting to
		minresiduals=0;
		for (i=0; i<15; i++){
			for (meltsrow=0; meltsrow<rows[0]; meltsrow++){
				residuals[meltsrow]=(pow((composition[i][0] - normconst[meltsrow]*melts[0][meltsrow][SiO2]),2)*2 + 
						pow((composition[i][1] - normconst[meltsrow]*melts[0][meltsrow][TiO2]),2) + 
						pow((composition[i][2] - normconst[meltsrow]*melts[0][meltsrow][Al2O3]),2) + 
						pow((composition[i][3] - normconst[meltsrow]*melts[0][meltsrow][Cr2O3]),2) + 
						pow((composition[i][4] - normconst[meltsrow]*melts[0][meltsrow][FeO]-melts[0][meltsrow][Fe2O3]/1.1113),2) + 
						pow((composition[i][5] - normconst[meltsrow]*melts[0][meltsrow][MnO]),2) + 
						pow((composition[i][6] - normconst[meltsrow]*melts[0][meltsrow][MgO]),2) + 
						pow((composition[i][7] - normconst[meltsrow]*melts[0][meltsrow][NiO]),2) + 
						pow((composition[i][8] - normconst[meltsrow]*melts[0][meltsrow][CoO]),2) + 
						pow((composition[i][9] - normconst[meltsrow]*melts[0][meltsrow][CaO]),2) + 
						pow((composition[i][10] - normconst[meltsrow]*melts[0][meltsrow][Na2O]),2) + 
						pow((composition[i][11] - normconst[meltsrow]*melts[0][meltsrow][K2O]),2)*2 + 
						pow((composition[i][12] - normconst[meltsrow]*melts[0][meltsrow][P2O5]),2));
			}
			minresiduals=minresiduals+minArray(residuals, rows[0]);
		}
		
		// Print results to command line
//		printf("%7d\t%8d\t%14.8f\t%15.8f\t%15.8f\t%15.8f\t%20.8f\n", world_rank, n, minresiduals, ic[14], ic[15], fo2Delta, Pi);
		printf("%d\t%d\t%f\t%f\t%f\t%f\t%f\n", world_rank, n, minresiduals, ic[14], ic[15], fo2Delta, Pi);

		sendarrayN[sendArrayIndex]=n;
		sendarrayR[sendArrayIndex]=minresiduals;
		sendarrayCO2[sendArrayIndex]=ic[14];
		sendarrayWater[sendArrayIndex]=ic[15];
		sendarrayfo2[sendArrayIndex]=fo2Delta;

		
		// Copy useful output to current directory
		if  (minresiduals < 200){ // Recommended general: 200
			sprintf(cmd_string,"cp -r %s ./", prefix);
			system(cmd_string);
		}
		// Clean up scratch directory
		sprintf(cmd_string,"rm -r %s", prefix);
		system(cmd_string);
		

		minerals=0;
		sendArrayIndex++;
	}


	if ( world_rank == 0) {
		rbufN = (int *)malloc(world_size*sendArraySize*sizeof(int));  
		rbufR = (double *)malloc(world_size*sendArraySize*sizeof(double));
		rbufCO2 = (double *)malloc(world_size*sendArraySize*sizeof(double));
		rbufWater = (double *)malloc(world_size*sendArraySize*sizeof(double));
		rbuffo2 = (double *)malloc(world_size*sendArraySize*sizeof(double));

	} 
	MPI_Gather(sendarrayN, sendArraySize, MPI_INT, rbufN, sendArraySize, MPI_INT, 0, MPI_COMM_WORLD); 
	MPI_Gather(sendarrayR, sendArraySize, MPI_DOUBLE, rbufR, sendArraySize, MPI_DOUBLE, 0, MPI_COMM_WORLD); 
	MPI_Gather(sendarrayCO2, sendArraySize, MPI_DOUBLE, rbufCO2, sendArraySize, MPI_DOUBLE, 0, MPI_COMM_WORLD); 
	MPI_Gather(sendarrayWater, sendArraySize, MPI_DOUBLE, rbufWater, sendArraySize, MPI_DOUBLE, 0, MPI_COMM_WORLD); 
	MPI_Gather(sendarrayfo2, sendArraySize, MPI_DOUBLE, rbuffo2, sendArraySize, MPI_DOUBLE, 0, MPI_COMM_WORLD); 

	// Save results to file
	if (world_rank==0){
		fp=fopen("residuals.csv","w");
		fprintf(fp,"n\tresidual\tCO2\tH2O\tfO2\n"); // File output format
		for (n=0; n<nsims; n++){
			fprintf(fp,"%d\t%f\t%f\t%f\t%f\n", rbufN[n], rbufR[n], rbufCO2[n], rbufWater[n], rbuffo2[n]);
		}
		fclose(fp);
	}

	free(residuals);
	free(normconst);

	MPI_Finalize();
	return 0;
}
