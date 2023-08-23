from optparse import OptionParser
import numpy as np
import pandas as pd


def parseAT(df,window):
    Mut = df.to_numpy()
    pos = df.columns.to_numpy()

    #print(pos)
    pos = pos.astype(float)
    pos = pos * window
    pos = np.round(pos, 0)
    pos = np.int_(pos) 
    #print(pos)

    np.vstack((pos, Mut))

    Mut2 = np.where(Mut == 0, 'A', Mut)
    Mut2 = np.where(Mut == 1, 'T', Mut2)
    #print(Mut2.shape)

    posMut = (np.vstack((pos, Mut2))).transpose()
    return posMut


def parseMS(File):
    MS = pd.read_csv(File, skiprows=2,header=None)  # ,sep="\s*",engine='python'
    pos = list(MS.iloc[0, :])[0].split()
    pos = pos[1:]
    # this value is currently 0 im curious if this is the problem??
    nonunique = list(set([x for x in pos if pos.count(x) > 1]))
    if len(nonunique) > 0:
        # print(nonunique)
        for x in nonunique:
            indx = np.where(np.array(pos) == x)[0]
            for i in indx[1:]:
                pos[i] = pos[i] + str(i)
    MS = (MS.iloc[1:, :])[0].apply(lambda x: pd.Series(list(x)))  # separate each char into different columns
    MS.columns = pos  # name columns with position

    return MS.apply(pd.to_numeric)  # MS.transpose()


# ##############################################main###############################################################
def main():
    # arguments to take in from command line, in this simplified case we only need the
    # input and output file
    usage = """%prog  <input> <snp data>"""
    parser = OptionParser(usage)
    parser.add_option("-i", "--inFile", type="string", default="-", help="Input File")
    parser.add_option("-o", "--outFile", type="string", default="-", help="Output File")
    parser.add_option("-w", "--windowSz", type="float", default=20000, help="window size")


    options, args = parser.parse_args()
    inFile = options.inFile

    outFile = options.outFile

    window = options.windowSz

    MS = parseMS(inFile)
    posMuts = parseAT(MS,window)
    #get 400 SNP window
    #posMutsCenter = posMuts.shape[0]
    #posMutsCenter = int(posMutsCenter/2)
    #leftCoor = posMutsCenter - 200
    #posMuts = posMuts[leftCoor:leftCoor+401,:]
    #print(posMuts.shape)
 
    pd.DataFrame(posMuts).to_csv(outFile, mode='w', index=False, header=False)


if __name__ == '__main__':
    main()
