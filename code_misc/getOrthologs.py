import requests
import json
from optparse import OptionParser

def getOrtho(in_file,out_file):
    out_file = open(out_file,'w')
    #read one line at a time
    with open(in_file) as f:
        for line in f:
            lst_line=line.rstrip('\n').split('\t')
            ID = lst_line[6]
            name = lst_line[7]

            # Set the URL for the OrthoDB API
            endpoint="https://data.orthodb.org/current/search"
            taxon_id=7215 #Drosophila level
            
            url = f"{endpoint}?query={name}&level={taxon_id}"
            #url='https://data.orthodb.org/current/search?query=Ace&level=7215'

            # Send the GET request and get the response
            response = requests.get(url)

            if response.status_code == 200:
                # Parse the response as JSON
                data = json.loads(response.text)

                # Extract the orthologs from the response
                orthologs = data['bigdata'] 

                # Print the list of orthologs
                if orthologs is None:
                    #print("NoneType object, no othrolog found")
                    orthoID="None"
                    orthoName="None"
                else:
                   for ortholog in orthologs:
                        orthoID=ortholog['id']
                        orthoName=ortholog['name']

                #output file
                line_out = line + '\t' + orthoID + '\t' + orthoName + '\n'
                out_file.write(line_out)

            else:
               print("Error:", response.status_code)




def main():
    usage = """%prog  <input> <snp data>"""
    parser = OptionParser(usage)
    parser.add_option("-i", "--inFile", type="string",  default='-',    help="input file path for output")
    parser.add_option("-o", "--outFile", type="string",  default='-',    help="output file path")
    options, args= parser.parse_args()

    in_file= options.inFile
    out_file= options.outFile


    if in_file == "-": 
        print("ERROR: no input file")
    else:
        getOrtho(in_file,out_file)

############################## run Main ##############################################################################
if __name__=="__main__":
    main()