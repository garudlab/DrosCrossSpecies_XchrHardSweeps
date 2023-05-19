
# Mariana Harris
# mharris94@g.ucla.edu
# August 2022

# This script converts a vcf file to H12 output

import sys
from optparse import OptionParser
import copy
import csv
import linecache
import random
import time
import numpy as np
from collections import Counter



def VCFtoH12(inFile,outFile):

    countLines =  open(inFile)
    #numberLines =  len(countLines.readlines())

    with open(inFile) as file:
        while True:
            line = file.readline()
            line = line.split()
            pos= line[1]
            REF = line[3]
            ALT=line[4]
            samples= line[9:]
            FILTER=line[6]
            if FILTER != "PASS":
                #print("FILTER SITE")
                continue
            else:
                #print("good SNP")
                line1= str(pos)# start output line
                line2=line1
                #loop through samples getting genotype
                for sample in samples:
                    genotype=sample.split(',')[0]
                    genotype=genotype.split(':')[0]
                    phased=genotype.split('|')
                    if len(phased) == 2 :
                        #genotype is phased
                        #if len(ALT) ==1 :
                        phased=[REF if x == '0' and len(REF)==1 else ALT if x =='1' and len(ALT)==1 else 'N' for x in phased] # condition on REF and ALT being a single allele, otherwise they are masked (i.e more than a single allele or a deletion)
                        #else:
                        #    phased=[REF if x == '0' and len(REF)==1 else ALT[0] if x =='1' and ALT[0]!="*" else ALT[2] if x =='2' and ALT[2]!="*"  else  'N' for x in phased] #if there is deletion ???
                    else:
                        #not phased, so we mask if its heterozygous and output if homozyogous
                        phased=genotype.split('/')
                        #if len(ALT) ==1 :
                        phased=[REF if x == '0' and len(REF)==1 else ALT if x =='1' and len(ALT)==1 else 'N' for x in phased] # condition on REF and ALT being a single allele, otherwise they are masked (i.e more than a single allele or a deletion)
                        #else:
                        #    phased=[REF if x == '0' and len(REF)==1 else ALT[0] if x =='1' and ALT[0]!="*" else ALT[2] if x =='2' and ALT[2]!="*"  else  'N' for x in phased] #if there is deletion
                        # if they are heterozygous . 
                    if len(set(phased)) > 1: # it's heterozygous
                        print("heterozygous" +"\t"+str(phased))
                        phased=['N','N'] #het
                    line1= line1+","+str(phased[0])

                line1 = line1 +"\n"
                outFile.write(line1)
                        
       
    inFile.close()
    outFile.close()

######################
def mkOptionParser():
    """ Defines options and returns parser """

    usage = """%prog  <input> <number of strains>
    %prog calculates haplotype homozygosity chromosome-wide in the window size specified. The following summary statistics are outputted: left edge coordinate of window, right edge coordinate of window, center coordinate of window, K (number of unique haplotypes), haplotype frequency spectrum (singletons are not outputted for brevity), members of haplotypeGroups, H1, H2, H12, H2/H1. """

    parser = OptionParser(usage)

    parser.add_option("-o", "--outFile",        type="string",       default="-",    help="Write output to OUTFILE (default=stdout)")

    return parser

########################################################################

def main():
    """ see usage in mkOptionParser. """
    parser = mkOptionParser()
    options, args= parser.parse_args()


    inFile       = args[0]
    outFN        = options.outFile
    
    outFile      = open(outFN, 'w')

    VCFtoH12(inFile,outFile)

#run main
if __name__ == '__main__':
    main()
