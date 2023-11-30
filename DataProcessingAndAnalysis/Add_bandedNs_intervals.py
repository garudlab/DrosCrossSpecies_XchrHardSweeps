from optparse import OptionParser
import numpy as np
import math
import linecache
import statistics


def add_Ns(bed_file,out_file,numSamp):
    out_file = open(out_file,'w')
    #iterate through all lines in bed file
    with open(bed_file) as f:
        for line in f:
            lst_line=line.rstrip('\n').split('\t')
            pos_left=int(lst_line[1])
            pos_right=int(lst_line[2])

            for i in range(pos_left,pos_right+1):
                n_list = ["N"] * numSamp
                n_string=",".join(n_list)
                line_out=str(i)+","+n_string+"\n"
                # write to output file
                out_file.write(line_out)



def main():
    usage = """%prog  <input> <snp data>"""
    parser = OptionParser(usage)
    parser.add_option("-b", "--inBedFile", type="string",  default='-',    help="input bed file path")
    parser.add_option("-o", "--outFile", type="string",  default='-',    help="output file path")
    parser.add_option("-n", "--numSample", type="int",  default=10,    help="output file path")
   
    options, args= parser.parse_args()

    bed_file= options.inBedFile
    out_file= options.outFile
    numSamp= options.numSample


    add_Ns(bed_file,out_file,numSamp)

############################## run Main ##############################################################################
if __name__=="__main__":
    main()