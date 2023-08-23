from optparse import OptionParser
import numpy as np
import math
import linecache


def get_Pi(in_file,out_file,out_file2,chrom):
    
    out_file = open(out_file,'a')
    out_file2 = open(out_file2,'a')
    out_file.write("CHROM"+"\t"+"POS1"+"\t"+"POS2"+"\t"+"PI"+"\n" )

    with open(in_file) as f:
        for line in f:
            line=line.split()
            length= int(line[1])-int(line[0])
            haps=line[2:]
            np_haps=np.array([list(x) for x in haps])
            pi,S=Pi(np_haps,out_file2)
            line_out = str(chrom)+"\t"+str(line[0])+"\t"+str(line[1])+"\t"+str(pi/float(length))+"\n"
            print(line_out)
            out_file.write(line_out)

    out_file.close()
    out_file2.close()

def Pi(haps,out_file2):
    #get snp counts
    columns = haps.shape[1]
    pi=0
    S=0
    for j in range(columns):
        haps_list=list(haps[:,j])
        unique_bases = set(haps_list)
        numNs=haps_list.count('N')
        if ('N' in unique_bases): unique_bases.remove('N')
        if len(unique_bases)==2 and numNs/float(numStrains)<0.5:
            haps_dict = {key:haps_list.count(key) for key in haps_list}
            #print(haps_dict)
            snps_dict = {key: value for key, value in haps_dict.items() if key != "N"}
            #get frequencies
            p=float(max(snps_dict.values()))/sum(snps_dict.values())
            S+=1
        else:
            p=0
        pi+=2*p*(1-p)
        line_out2 = str(2*p*(1-p)*numStrains/(float(numStrains-1)))+"\t"+str(S)+"\t"+"\n"
        out_file2.write(line_out2)
    return [pi*numStrains/(float(numStrains-1)),S]


def main():
    usage = """%prog  <input> <snp data>"""
    parser = OptionParser(usage)
    parser.add_option("-i", "--inFile", type="string",  default='-',    help="input file path for output")
    parser.add_option("-o", "--outFile", type="string",  default='-',    help="output file path")
    parser.add_option("-s", "--statistic", type="string",  default='-',    help="statistic to compute")
    parser.add_option("-w", "--outFile2", type="string",  default='-',    help="output file path 2")
    parser.add_option("-c", "--chromosome", type="string",  default='-',    help="chromosome")
    options, args= parser.parse_args()

    in_file= options.inFile
    out_file= options.outFile
    #out_file2_path= options.outFile2
    stat = options.statistic
    out_file2= options.outFile2
    chrom=options.chromosome

    global numStrains
    numStrains = int(args[0])
    if stat == "pi": 
        get_Pi(in_file,out_file,out_file2,chrom) #computes S and Pi
    else:
        print("ERROR: statistic not defined")

############################## run Main ##############################################################################
if __name__=="__main__":
    main()
