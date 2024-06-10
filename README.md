# CSVtoSPSS
Converts all of the CSV files in a given directory to SPSS data sets

This and other SPSS Python Extension functions can be found at http://www.stat-help.com/python.html

## Usage
**CSVtoSPSS(indir, [outdir], [readnames], [qualifier])**
* "indir" is the directory location of the original files
* "outdir" is the destination is where you want the SPSS files to be placed. If the second directory is excluded, the program will put the SPSS files in a subdirectory off of the location of the original files.  
* "readnames" is a boolean variable indicating whether or not the names of the variables are included in the first line of the file. This argument defaults to True.
* "qualifier" is a string variable that indicates the qualifier used to surround strings that are supposed to be in the same column. This defaults to a double quote.

## Example
**CSVtoSPSS(indir = "C:/School discipline/Data",   
outdir = "C:/School discipline/Data/SPSS",  
readnames = True)**
* This command would find all of the .csv files in the C:/School discipline/Data directory, convert them to SPSS format, and save the resulting files to the C:/School discipline/Data/SPSS directory. 
* The program will assume that the names of the variables are included in the first row of each of the files.
