import json,sys,csv

def parseTMscore(filename):

	with open(filename, 'r', encoding='UTF-8') as file:
		tmcount=-1
		while (line := file.readline()):
			
			line = line.rstrip()
			#print(line)

			if "TM-score" in line:
				tmcount +=1
				if tmcount %3 == 0:
					tokenlist = line.split("=")
					tokenlist2 = tokenlist[1].split(" ")
					return round(float(tokenlist2[1].rstrip()),2)

def parselDDT(filename): 
    with open(filename, "r") as json_file:
        data = json.load(json_file)

    lddt = round(float(data['lddt']),2)
    
    return lddt

def parseINF(filename):
	
    with open(filename, 'r', encoding='UTF-8') as logfile:
		
        logfile.readline()

        rmsdline = logfile.readline()

        tokenlist = rmsdline.split(",")

        infall = tokenlist[2]

    return float(infall)

def parseClash(filename):
   
    with open(filename, 'r', encoding='UTF-8') as file:
        tmcount=-1
        while (line := file.readline()):
            
            line = line.rstrip()
            #print(line)

            if ".pdb" in line:
                tokenlist = line.split(":")
                #print(line)
                #print(tokenlist)
                return round(float(tokenlist[8].rstrip()),2)
      
if __name__ == '__main__':
	
    PDBID = sys.argv[1]
	
    tmscore = parseTMscore("TMlog.txt")
    lddt = parselDDT('Output/output.json')
    inf = parseINF(f'runs/default/{PDBID}_native_processed/inf/inf.{PDBID}_native_processed.txt')
    clash = parseClash("clashlog.txt")

    fullscorelist = [[tmscore,lddt,inf,clash]]

    #print(f"Target = {PDBID}\tTM-score = {tmscore}\tlDDT = {lddt}\tINF-All = {inf}\tClash = {clash}")

    filename = "Score.csv"

    with open(filename, 'a') as csvfile: 
        csvwriter = csv.writer(csvfile) 
        csvwriter.writerows(fullscorelist)