# -*- coding: utf-8 -*-
"""
Created on Fri Oct  4 07:35:36 2019

@author: pathouli
"""

from crawler import crawler

my_path = '/Users/annatakacs/Downloads/Columbia/Study/Semester_2/NLP/HW/HW2/'
the_query = ['australia fire', 'topic 2', 'topic 3', 'topic 4'] 
num_docs = 50

my_func = crawler()

for i in the_query: 
    my_func.write_crawl_results(my_path, i, num_docs)


# Question 1
# 
# When running the program for searches on 'qmss columbia', it generates a 
# folder in the given working directory with up to 50 search results. In my 
# case, there are only 31 documents available in the folder. The files are numbered
# starting from 0. 
# Based on the functions which the texts are run through, the text files 
# available in the folder are clean texts, punctuation is eliminated. 


