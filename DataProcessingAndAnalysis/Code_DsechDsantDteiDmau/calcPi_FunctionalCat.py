from optparse import OptionParser
import linecache
import numpy as np
import pandas as pd
import subprocess
from bisect import bisect_left, bisect_right



def Pi_per_region(inFile,inFile_bed,outFile,chrom):
    out = open(outFile, "w")
    out.write("CHROM"+'\t'+"POS1"+'\t'+"POS2"+'\t'+"PI"+'\n')
    df_coords=pd.read_csv(inFile_bed,header=None,sep="\t") 
    df_chr_coord=df_coords[df_coords[0] == chrom]

    countLines =  open(inFile)
    numberLines =  len(countLines.readlines())
    last_pos = int(linecache.getline(inFile,numberLines).split(',')[0].strip('\n'))

    #calc Pi per site
    df_PiperSite = pd.DataFrame( columns=['POS','PI'])
    positions=[]
    Pi_lst=[]
    for i in range(1,numberLines):
        line=linecache.getline(inFile,i).strip('\n').split(',')
        #pos = int(line[0])
        positions.append(int(line[0]))
        snp_list=line[1:]
        Pi_site=Pi_at_site(snp_list)
        Pi_lst.append(Pi_site)
        #df_PiperSite.loc[len(df_PiperSite.index)] = [pos, Pi_site]

    np_positions=np.array(positions)
    np_Pi=np.array(Pi_lst)
    #compute Pi/bp in each region    
    for i in range(df_chr_coord.shape[0]):
        bps= df_chr_coord.iloc[i,2]-df_chr_coord.iloc[i,1]
        idx_pos_region=np.where((np_positions>= df_chr_coord.iloc[i,1]) & (np_positions< df_chr_coord.iloc[i,2]) )
        if idx_pos_region[0].size == 0:
            continue
        else:
            Pi_subset=np_Pi[idx_pos_region[0]]
            Pi = sum(Pi_subset)/bps # compute Pi/bp in the region
        #get output 
        out.write(str(chrom)+'\t' + str(df_chr_coord.iloc[i,1])+'\t'+str(df_chr_coord.iloc[i,2])+'\t' + str(Pi)+'\n')
                
            
def Pi_at_site(snp_list):
    #get snp counts
    unique_bases = set(snp_list)
    if ('N' in unique_bases): unique_bases.remove('N')
    if (len(unique_bases)==2):
        snp_dict = {key:snp_list.count(key) for key in snp_list}
        snp_dict_all = {key: value / total for total in (sum(snp_dict.values()),) for key, value in snp_dict.items()}
        snp_dict_all =  { key: value for key, value in snp_dict_all.items() if key != "N" } #remove N
        #remove N's
        #snp_dict = { key: value for key, value in snp_dict.items() if key != "N" }
        #get frequencies
        #snp_dict =  {key: value / total for total in (sum(snp_dict.values()),) for key, value in snp_dict.items()}
        #p=max(snp_dict.values())
        p=max(snp_dict_all.values())
        q=min(snp_dict_all.values())
    else:
        p=0
        q=0
    return 2*p*q*numStrains/(float(numStrains-1))

            


    

####################################Main functions#################################################################
def main():
#Mising data
    usage = """%prog  <input> <snp data>"""
    parser = OptionParser(usage)
    parser.add_option("-i", "--inFile", type="string",  default="-",    help="Input  file")
    parser.add_option("-b", "--inBed", type="string",  default="-",    help="Input bed file with region coordinates")
    parser.add_option("-o", "--outFile", type="string",  default="-",    help="Output File pi")
    parser.add_option("-c", "--Chrom", type="string",  default="-",    help="Chromosome")
    
    
    options, args= parser.parse_args()

    inFile= options.inFile
    inFile_bed=options.inBed
    outFile= options.outFile
    chrom= options.Chrom

    global numStrains
    numStrains = int(args[0])
    
    Pi_per_region(inFile,inFile_bed,outFile,chrom)
    
# ############################### Main ##############################################################################
if __name__=="__main__":
    main()
