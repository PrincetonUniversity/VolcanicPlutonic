// runmelts.h: C functions to interface with alphaMELTS
// Last modified 1/25/15 by C. Brenhin Keller

/* Run melts */
void runmelts(char prefix[], double sc[], char version[], char mode[], char fo2Path[], double fo2Delta, char batchString[], char saveAll[], char fractionateSolids[], double Ti, double Pi, double dT, double dP, double massin){

	char fractionateWater[2] = "!", // Fractionate all water? ("!" for no, "" for yes)
	     celciusOutput[2] = "", // Ouptut temperatures in celcius? ("!" for no, "" for yes)
	     ptpath[2]="!"; //Follow a PTpath file
	
	if (strcasecmp(mode,"ptpath")==0) ptpath[0]='\0';

	double  Pmax = 90000, // Default global simulation constraints
		Pmin = 1,
		Tmax = 3000, 
		Tmin = 700;

	FILE *fp;
	char path_string[100];

	// Normalize starting composition	
	double normconst=0;
	int i;
	for (i=0;i<16;i++){normconst=normconst+sc[i];}
	for (i=0;i<16;i++){sc[i]=sc[i]*100/normconst;}

	// Create .melts file containing the desired starting composition
	sprintf(path_string, "%ssc.melts", prefix);
	fp=fopen(path_string,"w");
	fprintf(fp,	"Title: dummy\
			\nInitial Composition: SiO2 %.4f\
			\nInitial Composition: TiO2 %.4f\
			\nInitial Composition: Al2O3 %.4f\
			\nInitial Composition: Fe2O3 %.4f\
			\nInitial Composition: Cr2O3 %.4f\
			\nInitial Composition: FeO %.4f\
			\nInitial Composition: MnO %.4f\
			\nInitial Composition: MgO %.4f\
			\nInitial Composition: NiO %.4f\
			\nInitial Composition: CoO %.4f\
			\nInitial Composition: CaO %.4f\
			\nInitial Composition: Na2O %.4f\
			\nInitial Composition: K2O %.4f\
			\nInitial Composition: P2O5 %.4f\
			\nInitial Composition: CO2 %.4f\
			\nInitial Composition: H2O %.4f\n",
			sc[0],sc[1],sc[2],sc[3],sc[4],sc[5],sc[6],sc[7],sc[8],sc[9],sc[10],sc[11],sc[12],sc[13],sc[14],sc[15]);
	fprintf(fp,	"Initial Temperature: %.2f\
			\nInitial Pressure: %.2f\
			\nlog fo2 Path: %s\n",
			Ti,Pi,fo2Path);
	if (fo2Delta!=0){
		fprintf(fp,"log fo2 Delta: %.2f\n",fo2Delta);
	}
	fclose(fp);

	//  Create melts_env file to specify type of MELTS calculation
	sprintf(path_string, "%smelts_env", prefix);
	fp=fopen(path_string,"w");
	fprintf(fp,"\nALPHAMELTS_VERSION\t\t%s\
			\nALPHAMELTS_MODE\t\t\t%s\
			\n%sALPHAMELTS_PTPATH_FILE\t\tptpath\
			\nALPHAMELTS_DELTAP\t\t%.0f\
			\nALPHAMELTS_DELTAT\t\t%.0f\
			\nALPHAMELTS_MAXP\t\t\t%.0f\
			\nALPHAMELTS_MINP\t\t\t%.0f\
			\nALPHAMELTS_MAXT\t\t\t%.0f\
			\nALPHAMELTS_MINT\t\t\t%.0f\
			\n%sALPHAMELTS_FRACTIONATE_SOLIDS\ttrue\
			\n%sALPHAMELTS_MASSIN\t\t%g\
			\n%sALPHAMELTS_FRACTIONATE_WATER\ttrue\
			\n%sALPHAMELTS_MINW\t\t\t0.005\
			\n%sALPHAMELTS_SAVE_ALL\t\ttrue\
			\n%sALPHAMELTS_CELSIUS_OUTPUT\ttrue\n",
			version,mode,ptpath,dP,dT,Pmax,Pmin,Tmax,Tmin,fractionateSolids,fractionateSolids,massin,fractionateWater,fractionateWater,saveAll,celciusOutput);
	fclose(fp);

	// Write batchfile
	sprintf(path_string, "%sbatch", prefix);
	fp=fopen(path_string,"w");
	fputs(batchString,fp);
	fclose(fp);


	// Run alphaMELTS
	// Replace '/scratch/gpfs/cbkeller/run_alphamelts_v1.41.pl' with the correct path to the alphamelts perl script on your system
	/***********************************************************/
	char cmd_string[200];
	sprintf(cmd_string,"cd %s; /scratch/gpfs/cbkeller/run_alphamelts_v1.41.pl -f melts_env -b batch > /dev/null", prefix); // Discard verbose output
//	sprintf(cmd_string,"cd %s; /scratch/gpfs/cbkeller/run_alphamelts_v1.41.pl -f melts_env -b batch", prefix); // Print all melts command line output for debugging
	system(cmd_string);
	/***********************************************************/	

}



/* Parse a MELTS file, return pointer to array of arrays of doubles */
double ***importmelts(char prefix[], double ***importedMelts, double **rawMatrix, int *rows, int *columns, char **names, char ***elements, int *minerals) {

	// File to open
	FILE *fp;
	char filePath[50];
	sprintf(filePath,"%sPhase_main_tbl.txt", prefix);
	fp=fopen(filePath,"r");

	// Determine maximum number of characters per row, delimiters per row, and rows
	char c, teststr[8];
	int a,numMinerals=0, numColumns=0, maxColumns=0, numChars=0, maxChars=0, numRows=0;
	for(c=getc(fp); c != EOF; c=getc(fp)){
		numChars++;
		if (c==' '){numColumns++;}
		if (c=='\n'){
			numRows++;
			//if there is a trailing delimiter, don't add an extra column for it
			fseek(fp,-2,SEEK_CUR);
			if(getc(fp)!=' '){numColumns++;}
			fseek(fp,+1,SEEK_CUR);	
			// See if we have a new maximum, and reset the counters
			if (numChars>maxChars){maxChars=numChars;}
			if (numColumns>maxColumns){maxColumns=numColumns;}
			numChars=0;
			numColumns=0;
			// Count up the number of different minerals in the file
			c=getc(fp);
			if (c=='P'){
				for(a=0; a<7; a++){teststr[a]=getc(fp);}
				teststr[7]='\0';
				fseek(fp,-7,SEEK_CUR);
				if (strcasecmp(teststr,"ressure")==0){numMinerals++;}
			}
			if (c!=EOF) {fseek(fp,-1,SEEK_CUR);}
		}
	} 	
	// If the last line isn't blank, add one more to the row counter
	fseek(fp,-1,SEEK_CUR);
	if(getc(fp)!='\n'){numRows++;}

	// For each line,
	int mineral=0, i=0, j=0, k, i_last, field[maxColumns+2];
	char str[maxChars+2], str_last[maxChars+2];
	char *endp;
	rewind(fp);
	while(fgets(str,maxChars+2,fp)!=NULL){	

		// identify the delimited fields,
		field[0]=0;
		for(k=1;k<maxColumns+2;k++){field[k]=maxChars+1;}
		for(k=0, numColumns=0; str[k]!='\0'; k++){
			if (str[k]==' '){
				str[k]='\0';
				field[numColumns+1]=k+1;
				numColumns++;
			} else if(str[k]=='\n'){
				str[k]='\0';
				if (k>0){
					// add 1 to numColumns if the last character in the row isn't a delimiter
					if (str[k-1]!='\0'){numColumns++;}
				}
			} 
		}

		// and parse each field, storing numerical results in rawMatrix.
		for (j=0;j<maxColumns;j++){
			rawMatrix[i][j]=strtod(&str[field[j]],&endp);
			if(endp==&str[field[j]]){rawMatrix[i][j]=NAN;}
		}
		
		// If the first word is "pressure", then we have reached a header row, so store the column names in one array, store a pointer to the next row, and store the name (first field) from the previous row.
		if (strcasecmp(&str[0],"pressure")==0){	
			importedMelts[mineral]=&rawMatrix[i+1];
			strcpy(names[mineral], str_last);
			for (k=0; k<numColumns; k++){
				strcpy(elements[mineral][k], &str[field[k]]);
			}
			columns[mineral]=numColumns;
			if (mineral>0){
				rows[mineral-1]=i-i_last-3;
			}
			mineral++;
			i_last=i;
		}
		strcpy(str_last, str);
		i++;
	}
	fclose(fp);
	rows[mineral-1]=i-i_last-1;
	


	// Write metadata for the imported melts data and return the imported matrix
	*minerals=mineral;
	return importedMelts;
}

