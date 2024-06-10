* Encoding: UTF-8.
* Convert CSV files to SPSS
* By Jamie DeCoster

* This program converts all of the CSV files in an indicated directory and
converts them to SPSS data sets. 

**** Usage: CSVtoSPSS(indir, [outdir], [readnames], [qualifier])
**** "indir" is the directory location of the original files
**** "outdir" is the destination is where you want the SPSS files to be 
* placed. If the second directory is excluded, the program will put the SPSS 
* files in a subdirectory off of the location of the original files.  
**** "readnames" is a boolean variable indicating whether or not the names of 
* the variables are included in the first line of the file. This argument defaults to True.
**** "qualifier" is a string variable that indicates the qualifier used to surround strings
* that are supposed to be in the same column. This defaults to a double quote.

**** Example
* CSVtoSPSS(indir = "C:/School discipline/Data",
* outdir = "C:/School discipline/Data/SPSS",
* readnames = True)
**** This command would find all of the .csv files in the C:/School discipline/Data directory,
* convert them to SPSS format, and save the resulting files to the C:/School discipline/Data/SPSS
* directory. The program will assume that the names of the variables are included in the first
* row of each of the files.

**********
* Version History
**********
* 2017-09-05 Created based on ExcelToSPSS 2014-03-19.sps
* 2017-09-27 Added example

set printback = off.
BEGIN PROGRAM PYTHON3.
import spss, os, time

def CSVtoSPSS(indir, outdir = "NONE", readnames = True, qualifier = '"'):

# Strip / at the end if it is present
    for dir in [indir, outdir]:
        if (dir[len(dir)-1] == "/"):
            dir = dir[:len(dir)-1]
            
# If outdir is excluded, create output directory if it doesn't exist
    if outdir == "NONE":
        if not os.path.exists(indir + "/SPSS"):
            os.mkdir(indir + "/SPSS")
        outdir = indir + "/SPSS"

# Get a list of all .csv files in the directory (csvfiles)
    allfiles=[os.path.normcase(f)
    	for f in os.listdir(indir)]
    csvfiles=[]
    for f in allfiles:
    	fname, fext = os.path.splitext(f)
    	if ('.csv' == fext and fname[:2] != '~$'):
    		csvfiles.append(fname)

# Convert csv files
    for fname in csvfiles:
# Create variable list
          f = open(indir + "/" + fname + ".csv", "r")
          firstline = f.readline().split(",")
          f.close()
          if (readnames == True):
               firstcase = "2"
               varList = firstline
          else:
               firstcase = "1"
               varList = []
               for t in range(len(firstline)):
                    varList.append("var" + str(t+1).zfill(4))
          
          time.sleep(.25)

# Define qualifier
          if (qualifier == '"'):
               q = "/QUALIFIER = '" + '"' + "'"
          else:
               q = '/QUALIFIER = "{0}"'.format(qualifier)

          submitstring = """PRESERVE.
SET DECIMAL DOT.

GET DATA  /TYPE=TXT
  /FILE="{0}/{1}.csv"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS=","
{2}
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE={3}
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
""".format(indir, fname, q, firstcase)

          for t in range(len(varList)):
               submitstring += varList[t] + " AUTO\n"
          submitstring += """  /MAP.
RESTORE.

CACHE.
EXECUTE.
DATASET NAME $DataSet WINDOW=FRONT.

SAVE OUTFILE='{0}/{1}.sav'
  /COMPRESSED.""".format(outdir,fname)
          spss.Submit(submitstring)
end program python.
set printback = on.