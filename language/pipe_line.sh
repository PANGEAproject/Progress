#!/bin/bash
## Notes: V1.0, 06/10/2018
## Author(s): Velez Santiago Jesus, Cazares Rodriguez Jesus Antonio
## Email(s): jvelez@lcg.unam.mx, jesuscr@lcg.unam.mx

#===================================================================================================#
# Objetive: Automatically classify phrases with and without information about regulatory
#           interactions between transcription factors.
# Input:
#   -$1: File with setences of category to search.
#   -$2: File with sentences of category OTHER. 
#   -$3: Category to search. [Optional] [default: 'RI']
#   -$4: Proportion of test Class/Data by file.
#   -$5: Proportion of training Class/Data by file.  
#   -$6: Feactures to get for separeted by ','.
#   -$7: Check to delimited end of line in {$1,$2}. [Optional] [default: 'PANGEA'] 
# Output:
#   -{$1,$2}.check  Step: 1)
#   -{$1,$2}.check.conll    Step: 2)
#   -{$1,$2}.check.conll.parsed Step: 3)
#   -{$1,$2}.{word,lemma,pos,ner}   Step: 4)
#   -{testData,trainingData}.{word,lemma,pos,ner}   Step: 5)
# Dependencies: extract_data_corenlp.py V1.0
# Example:
#   ./pipe_line.sh sentences_RI.txt sentences_OTHER.txt RI 0.30 0.70 'word,lemma,pos,ner'
#   ./pipe_line.sh sentences_RI.txt sentences_OTHER.txt RI 0.25 0.75 'word,lemma,pos,ner' NO-PANGEA
#===================================================================================================#

# 1) Add check mark to sentences files.
python extract_data_corenlp.py 1 $1
python extract_data_corenlp.py 1 $2

# 2) Run corenlp.sh to extract the raw data of catergories for each file. 
/export/apps/corenlp/corenlp.sh -annotators tokenize,ssplit,pos,lemma,ner -outputFormat conll -file $(cut -f3 $1.check) -outputDirectory . 
/export/apps/corenlp/corenlp.sh -annotators tokenize,ssplit,pos,lemma,ner -outputFormat conll -file $(cut -f3 $2.check) -outputDirectory . 

# 3) Parse raw results from corenlp to generate an intermediate file with all categories for each sentence (i.e. word split by ' ' and categories for word split by '|'). 
python extract_data_corenlp.py 2 $1.check.conll > $1.check.conll.parsed
python extract_data_corenlp.py 2 $2.check.conll > $2.check.conll.parsed

# 4) Get files for each category (i.e. 0:'word',1:'lemma',2:'pos',3:'ner') from parsed files.
#>>> For sentences of category RI.
python extract_data_corenlp.py 3 $1.check.conll.parsed 0 > $1.word
python extract_data_corenlp.py 3 $1.check.conll.parsed 1 > $1.lemma
python extract_data_corenlp.py 3 $1.check.conll.parsed 2 > $1.pos
python extract_data_corenlp.py 3 $1.check.conll.parsed 3 > $1.ner
#>>> For sentences of category OTHER.
python extract_data_corenlp.py 3 $2.check.conll.parsed 0 > $2.word
python extract_data_corenlp.py 3 $2.check.conll.parsed 1 > $2.lemma
python extract_data_corenlp.py 3 $2.check.conll.parsed 2 > $2.pos
python extract_data_corenlp.py 3 $2.check.conll.parsed 3 > $2.ner

#5) Split data in TrainingData and Testdata.
length_RI=$(wc -l $1 | cut -f1 -d ' ');
length_OTHER=$(wc -l $2 | cut -f1 -d ' ');
python extract_data_corenlp.py 4 $1 $2 $length_RI $length_OTHER $4 $5 $6 $3
