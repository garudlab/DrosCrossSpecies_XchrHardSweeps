from optparse import OptionParser
import numpy as np
import math
import linecache
import statistics

def get_popgen_stats(in_file,out_file,w):

    out_file = open(out_file,'a')
    #compute and output S/bp pi/bp watersons theta and proportion of snps that are singletions per window 
    out_file.write('position'+'\t'+'S'+"\t"+'pi'+"\t"+'watersons'+"\t"+'singletons'+"\t"+'Var(pi)'+"\t"+'TajD'+"\n")

    countLines =  open(in_file)
    numberLines =  len(countLines.readlines())
    last_pos = int(linecache.getline(in_file,numberLines).split(',')[0].strip('\n'))
    last_pos_bins= round(last_pos,-4)

    #binLength=int(math.ceil(N / 1e4)) * 1e4
    bins=np.arange(0,last_pos_bins+w*1000,w*1000)
    snps_window=[]
    heterozigosity_lst=[]
    
    window_size=float(w)*1000
    line=linecache.getline(in_file,1).strip('\n').split(',')
    pos = int(line[0])
    snp_list=line[1:]
    first_bin=bins[bins>=pos][0] # find first bin
    j=np.absolute(bins-first_bin).argmin() #find index of first bin in bins array
    pi=0
    pi_Full=0
    i=1
    for window in bins[j:]: #calc pi in non-overlapping windows
        #print(window)
        if pos<=last_pos:
            singletons=0
            #start_pos=pos
            Pi_lst=[]
            while pos < window:
                snps_window.append(snp_list)
                het,singletons=heterozigosity2(snp_list,singletons)
                Pi_lst.append(het) #update pi list in window
                pi=pi+het
                pi_Full=pi_Full+het
                line=linecache.getline(in_file,i).strip('\n').split(',')
                if line == ['']:
                    break;
                else:
                    pos = int(line[0])
                    snp_list=line[1:]
                i+=1
            if len(snps_window)>=2:
                TajD=calcTajimasD(np.asarray(snps_window))
                out_file.write(str(window)+'\t'+str(len(snps_window)/window_size)+"\t"+str(pi/window_size)+"\t"+str(len(snps_window)/(5.550497*window_size))+"\t"+str(singletons/window_size)+"\t"+str(statistics.variance(Pi_lst))+"\t" + str(TajD/window_size)+"\n") #change Waterson's theta constant
            elif len(snps_window) ==1:
                TajD=calcTajimasD(np.asarray(snps_window))
                out_file.write(str(window)+'\t'+str(len(snps_window)/window_size)+"\t"+str(pi/window_size)+"\t"+str(len(snps_window)/(5.550497*window_size))+"\t"+str(singletons/window_size)+"\t"+"0"+"\t" + str(TajD/window_size)+"\n") #change Waterson's theta constant
            else:
                out_file.write(str(window)+'\t'+str(len(snps_window)/window_size)+"\t"+str(pi/window_size)+"\t"+str(len(snps_window)/(5.550497*window_size))+"\t"+str(0)+"\t" + str(0)+"\n") #change Waterson's theta constant
           
            snps_window=[]
            pi=0  

    #out_file2.write(str(pi_Full)+"\n")
    out_file.close()

def heterozigosity2(snp_list,singletons):
    #get snp counts
    unique_bases = set(snp_list)
    if ('N' in unique_bases): unique_bases.remove('N')
    if (len(unique_bases)==2):
        snp_dict = {key:snp_list.count(key) for key in snp_list}
        for key, value in snp_dict.items():
            if 1 == value and key !="N":
                singletons+=1
        #if (1 in snp_dict.values() and ('N' in snp_dict.keys())) and (snp_dict['N'] != 1 or ('N' not in snp_dict.keys())):
        #    print(snp_dict)
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
        #print(set(snp_list))
        p=0
        q=0
    return [2*p*q*numStrains/(float(numStrains-1)),singletons]

def calcTajimasD(SNPdata):
    L=SNPdata.shape[0]
    n = SNPdata.shape[1]
    P=calcPi_pairwise(SNPdata,L)*L
    S=SNPdata.shape[0]
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

#calculates pi using pairwise difference definition
def calcPi_pairwise(SNPdata,L):
    n = SNPdata.shape[0]
    lst_P=[]
    for i in range(0,n-1):
        for j in range(i+1,n):
            samp1=SNPdata[i,:]
            samp2=SNPdata[j,:]
            counter=0 # count number of difference between two samples
            for k in range(len(samp1)):
                if samp1[k]=='N' or samp2[k]=='N':
                    continue
                elif samp1[k]!=samp2[k]:
                    counter+=1
            lst_P.append(counter)
    if len(lst_P)==0:
        P=0
    elif len(lst_P)==1:
        P=lst_P[0]
    else:
        P=statistics.mean(lst_P)/L
    return P

def main():
    usage = """%prog  <input> <snp data>"""
    parser = OptionParser(usage)
    parser.add_option("-i", "--inFile", type="string",  default='-',    help="input file path for output")
    parser.add_option("-o", "--outFile", type="string",  default='-',    help="output file path")
    #parser.add_option("-a", "--outFile2", type="string",  default='-',    help="output file2 path")
    parser.add_option("-w", "--window", type="float",  default=10,    help="window length in kb")
    options, args= parser.parse_args()

    in_file= options.inFile
    out_file= options.outFile
    #out_file2_path= options.outFile2
    w = options.window

    global numStrains
    numStrains = int(args[0])
    get_popgen_stats(in_file,out_file,w)
    #get_LD(in_file_path,out_file_path,N)

############################## run Main ##############################################################################
if __name__=="__main__":
    main()
