#!/bin/python3
## Notes: V1.0, 06/10/2018
## Author(s): Velez Santiago Jesus, Cazares Rodriguez Jesus Antonio
## Email(s): jvelez@lcg.unam.mx, jesuscr@lcg.unam.mx

import sys
import os
from math import floor

def add_check_to_lines_in_file(raw_data,check = 'PANGEA'):
    check = check + '.'
    with open(raw_data,'r') as f:
        with open(raw_data + '.check' ,'w') as f_check:
            for line in f:
                line = line.split('\t')
                transform_line = line[2] + check # Add check to sentence.
                line = '\t'.join(line[0:2]) +'\t'+ transform_line + '\t' + '\t'.join(line[3:])
                f_check.write(line)

def parse_corenlp_results(corenlp_results,check = 'PANGEA'):
    with open(corenlp_results,'r') as f:
        complete_line = []
        skip_line = False
        for line in f:
            if not line.startswith('\n'):
                if not skip_line:
                    line = line.split('\t')
                    if line[1] == check:
                        print(' '.join(complete_line[:-1]))
                        complete_line = []
                        skip_line = True
                    else:
                        complete_line.append('|'.join(line[1:5]))
            else:
                skip_line = False

def get_category(corenlp_resulst_parsed,category):
    with open(corenlp_resulst_parsed,'r') as f:
        for line in f:
            line = line.split(' ')
            print(' '.join([word.split('|')[category] for word in line]))

def create_training_and_test_classes(file_RI,file_OTHER,len_RI,len_OTHER,p_TEST,p_TRAINING,feactures,category='RI'):
    amount_lines_RI_TRAINING = int(floor(len_RI * p_TRAINING))
    amount_lines_RI_TEST = int(floor(len_RI * p_TEST))
    amount_lines_OTHER_TRAINING = int(floor(len_OTHER * p_TRAINING))
    amount_lines_OTHER_TEST = int(floor(len_OTHER * p_TEST))

    amount_lines_RI_TEST += (len_RI-amount_lines_RI_TRAINING-amount_lines_RI_TEST)
    amount_lines_OTHER_TEST += (len_OTHER-amount_lines_OTHER_TRAINING-amount_lines_OTHER_TEST)
    

    for feacture in feactures:
        current_RI_file = file_RI + '.' +feacture 
        current_OTHER_file = file_OTHER + '.' + feacture 

        output_file_TEST = 'testData' + '.' + feacture
        output_file_TRAINING = 'trainingData' + '.' +feacture

        os.system('head -n {} {} > {}'.format(amount_lines_RI_TEST,current_RI_file,output_file_TEST))
        os.system('tail -n {} {} > {}'.format(amount_lines_RI_TRAINING,current_RI_file,output_file_TRAINING))

        # Append sentences of class OTHER to preexisting files.        
        os.system('head -n {} {} | cat >> {}'.format(amount_lines_OTHER_TEST,current_OTHER_file,output_file_TEST))
        os.system('tail -n {} {} | cat >> {}'.format(amount_lines_OTHER_TRAINING,current_OTHER_file,output_file_TRAINING))        

        # Generate files testClass and trainingClass.
        testClass = '\n'.join(([category] * amount_lines_RI_TEST)) + '\n' + '\n'.join(['OTHER']*amount_lines_OTHER_TEST)
        trainingClass = '\n'.join(([category] * amount_lines_RI_TRAINING)) + '\n' + '\n'.join(['OTHER']*amount_lines_OTHER_TRAINING)

        output_file_TEST_CLASS = 'testClass' + '.' + feacture
        output_file_TRAINING_CLASS = 'trainingClass' + '.' + feacture

        os.system("echo '{}' > {}".format(testClass,output_file_TEST_CLASS))
        os.system("echo '{}' > {}".format(trainingClass,output_file_TRAINING_CLASS))

if __name__ == '__main__':
    if sys.argv[1] == '1':
        try:
            # Raw data to add a check point to verify in next steps.
            add_check_to_lines_in_file(sys.argv[2],sys.argv[3])
        except IndexError:
            # Use check by default: 'PANGEA'.
            print(sys.argv)
            add_check_to_lines_in_file(sys.argv[2])
    elif sys.argv[1] == '2':
        try: 
            # Parse corenlp results after run cornlp with file cheked with check defined by user.
            parse_corenlp_results(sys.argv[2],sys.argv[3])
        except IndexError:
            # Use check by default: 'PANGEA'.
            parse_corenlp_results(sys.argv[2])
    elif sys.argv[1] == '3':
        # Get only the category selected by user from results parsed.
        get_category(sys.argv[2],int(sys.argv[3]))
    elif sys.argv[1] == '4':
        feactures = sys.argv[8].split(',')
        create_training_and_test_classes(sys.argv[2],sys.argv[3],int(sys.argv[4]),int(sys.argv[5]),float(sys.argv[6]),float(sys.argv[7]),feactures,sys.argv[9])
