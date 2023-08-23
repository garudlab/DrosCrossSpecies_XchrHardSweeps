from optparse import OptionParser
import numpy as np
import pandas as pd
import math
import statistics as stat

# takes an inputfile outputfile and the genome, partial frequency and theta
def calcStats(inFile,outFile, H, Ns):
    # file io open the outfile for writing
    out = open(outFile, 'a')

    # parse the inputfile of 101011s to calculate stats
    MS = parseMS(inFile)
    
    #segsites
    S=MS.shape[1]
    # run the pi calculations with calcPi function
    Pi,varPi = calcPi(MS,5e4)
    TajD=calcTajimasD(MS,5e4)

    # add the calc to a line with formatting
    line = str(S/5e4)+ "\t" +str(Pi) + "\t" + str(varPi)+ "\t" + str(TajD)+"\t" + str(H)+"\t" + str(Ns)+"\n"
    #print(line)
    # write the line to the outfile
    out.write(line)
    out.close()

#calculates Pi using 2pq estimation
def calcPi(MSdata,L):
    # add rows
    n = MSdata.shape[0]
    # vector of data
    p = MSdata.sum(axis=0) / n
    # frequency of data at each position
    Pi_array= (2 * p * (1 - p)) * n / (n - 1)
    Pi = sum(Pi_array)/L # compute Pi/bp
    ZeroPi=pd.Series(np.zeros(int(L-len(Pi_array)))) #zero Pi sites to add to variance
    varPi = (Pi_array.append(ZeroPi)).var()

    return Pi,varPi

#calculates pi using pairwise difference definition
def calcPi_pairwise(MSdata,L):
    np_MS=MSdata.to_numpy()
    n = MSdata.shape[0]
    lst_P=[]
    for i in range(0,n-1):
        for j in range(i+1,n):
            samp1=np_MS[i,:]
            samp2=np_MS[j,:]
            lst_P.append(sum(abs(samp1-samp2)))
    P=stat.mean(lst_P)/L
    return P

#calculates pi using S estimation
def calcPi_W(MSdata,L):
    n = MSdata.shape[0]
    S=MSdata.shape[1]
    a1=(1 / np.arange(1, n)).sum() #sum array of 1,1/2,....,1/n-1   
    W=S/a1

    return W/L

def calcTajimasD(MSdata,L):
    n = MSdata.shape[0]
    P=calcPi_pairwise(MSdata,5e4)*L
    S=MSdata.shape[1]
    a1=(1 / np.arange(1, n)).sum()
    a2=(1 / (np.arange(1, n)**2)).sum()
    b1=(n+1)/(3*(n-1))
    b2=2*(n**2+n+3)/(9*n*(n-1))
    c1=b1-1/a1
    c2=b2-(n+2)/(a1*n)+a2/a1**2
    e1=c1/a1
    e2=c2/(a1**2+a2)
    D=(P-S/a1)
    TajD=D/math.sqrt(e1*S+e2*S*(S-1))
    return TajD

# parses the MS output file and returns the data in
# a formatted fashion so that calcPi can read and
# calculate
def parseMS(File):
    MS = pd.read_csv(File, header=None, skiprows=2)  # ,sep="\s*",engine='python'
    pos = list(MS.iloc[0, :])[0].split()
    pos = pos[1:]
    MS = (MS.iloc[1:, :])[0].apply(lambda x: pd.Series(list(x)))  # separate each char into different columns
    MS.columns = pos  # name columns with position

    return MS.apply(pd.to_numeric)  

def binom(n,k):
    return int(math.factorial(n)/(math.factorial(n-k)*math.factorial(k)))

###############################################main###############################################################
def main():
    # arguments to take in from command line, in this simplified case we only need the
    # input and output file 
    usage = """%prog  <input> <snp data>"""
    parser = OptionParser(usage)
    parser.add_option("-i", "--inFile", type="string", default="-", help="Input File")
    parser.add_option("-o", "--outFile", type="string", default="-", help="Output File")
    parser.add_option("-d", "--Dominance", type=float, default=0.5, help="Dominance coeff")
    parser.add_option("-s", "--selec", type=float, default=0.0, help="selection coeff")

    options, args = parser.parse_args()
    inFile = options.inFile
    outFile = options.outFile
    H= options.Dominance
    Nes = options.selec
    #slim_p1_100_final.txt
    calcStats(inFile,outFile,H,-1*Nes)
      


############################### Main ##############################################################################
if __name__ == "__main__":
    main()
