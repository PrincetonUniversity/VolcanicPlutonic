//#include <stdlib.h>
//#include <math.h>

// Make a 1d array of points spaced by Step between Lower and Upper
double* array(double lower, double step, double upper){
	if (step<=0){
		perror("Step size too small");
	} 
	else {
		int i=0, numsteps=(upper-lower)/step+1;
		double *someArray=malloc(numsteps*sizeof(double));
		while (i<numsteps) {
			someArray[i]=lower+i*step;
			i++;
		}
		return someArray;
	}
return 0;
}

int* arrayInt(int lower, int step, int upper){
	if (step<=0){
		perror("Step size too small");
	} 
	else {
		int i=0, numsteps=(upper-lower)/step+1;
		int  *someArray=malloc(numsteps*sizeof(int));
		while (i<numsteps) {
			someArray[i]=lower+i*step;
			i++;
		}
		return someArray;
	}
return 0;
}

/* Make a 1-d array of n points linearly spaced between Lower and Upper */
double* linspace(double lower, double upper, double n){
	int i=0;
	double *someArray=malloc(n*sizeof(double));
	while (i<n){
		someArray[i]=(upper-lower)*i/(n-1)+lower;
		i++;
	}
	return someArray;
}

int* linspaceInt(int lower, int upper, int n){
	int i=0, *someArray=malloc(n*sizeof(int));
	while (i<n){
		someArray[i]=(upper-lower)*i/(n-1)+lower;
		i++;
	}
	return someArray;
}

/* Find the minimum of a 1-d array */
double min(double a, double b){
	if (b<a) return b;
	return a;
}

int minInt(int a, int b){
	if (b<a) return b;
	return a;
}

double minArray(double someArray[],int length){
	int i;
	double currentMin=someArray[0];
	for (i=1; i<length; i++){
		if (someArray[i]<currentMin){currentMin=someArray[i];}
	}
	return currentMin;
}

int minArrayInt(int someArray[],int length){
	int i, currentMin=someArray[0];
	for (i=1; i<length; i++){
		if (someArray[i]<currentMin){currentMin=someArray[i];}
	}
	return currentMin;
}

/* Find the maximum of a 1-d array */
double max(double a, double b){
	if (b>a) return b;
	return a;
}

int maxInt(int a, int b){
	if (b>a) return b;
	return a;
}

double maxArray(double someArray[], int length){
	int i;
	double currentMax=someArray[0];
	for (i=1; i<length; i++){
		if (someArray[i]>currentMax){currentMax=someArray[i];}
	}
	return currentMax;
}

int maxArrayInt(int someArray[], int length){
	int i, currentMax=someArray[0];
	for (i=1; i<length; i++){
		if (someArray[i]>currentMax){currentMax=someArray[i];}
	}
	return currentMax;
}



/* Malloc a 2D array of doubles of dimensions Rows x Columns */
double **mallocDoubleArray(int rows, int columns) {
	int i; double **someArray;
	someArray = (double **) malloc(rows*sizeof(double *));
	for (i = 0; i < rows; i++){
		someArray[i] = (double *) malloc(columns*sizeof(double));
	}
	return someArray;
} 

/* Free a 2D array of doubles of length rows */
void freeDoubleArray(double **someArray, int rows) {
	int i;
	for (i=0; i<rows; i++) {free(someArray[i]);}
	free(someArray);
}


/* Malloc a 2D array of ints of dimensions Rows x Columns */
int **mallocIntArray(int rows, int columns) {
	int i; int **someArray;
	someArray = (int **) malloc(rows*sizeof(int *));
	for (i = 0; i < rows; i++){
		someArray[i] = (int *) malloc(columns*sizeof(int));
	}
	return someArray;
} 

/* Free a 2D array of ints of length rows */
void freeIntArray(int **someArray, int rows) {
	int i;
	for (i=0; i<rows; i++) {free(someArray[i]);}
	free(someArray);
}




/* Parse a CSV file, return pointer to array of doubles */
double **csvparse(char filePath[], int * const restrict rows, int * const restrict columns){

	// File to open
	FILE *fp;
	fp=fopen(filePath,"r");

	char c;
	int numColumns=0, maxColumns=0, numChars=0, maxChars=0, numRows=0;

	// Determine maximum number of characters per row, delimiters per row, and rows
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
		}
	} 
	// If the last line isn't blank, add one more to the row counter
	fseek(fp,-1,SEEK_CUR);
	if(getc(fp)!='\n'){numRows++;}


	// Malloc space for the imported array
	double ** const restrict importedMatrix=mallocDoubleArray(numRows,maxColumns);
	*rows=numRows;
	*columns=maxColumns;				

	// For each line,
	int i=0, j=0, k, field[maxColumns+2];
	char str[maxChars+2];
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
			} else if(str[k]=='\n'){str[k]='\0';}
		}

		// and perform operations on each field
		for (j=0;j<maxColumns;j++){
			importedMatrix[i][j]=strtod(&str[field[j]],&endp);
			if(endp==&str[field[j]]){importedMatrix[i][j]=NAN;}
		}
		i++;
	}
	fclose(fp);

	printf("Maximum number of characters: %d\n", maxChars);
	printf("Maximum number of delimiters: %d\n", maxColumns);
	printf("Number of rows: %d\n", numRows);

return importedMatrix;

}


		
