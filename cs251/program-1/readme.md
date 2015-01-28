Prog 1: My Word
Write a program to analyze a 100 MB Google NGrams dataset containing words, dates and frequency counts, from the years 1800-2000.  While not using any particularly tricky data structure (arrays are fine), this program will help us think about the implications of large amounts of data.  (This file was extracted from the original ~4GB set of files by Josh Hug, from whose python assignment this one is based.)  See this link for a zipped version (27.8 MB) of the three data files provided for you to use, listed here in ascending order of size: 
very_short.csv (271 bytes)
words_that_start_with_q.csv (409 KB)
all_words.csv (91.7 MB)
The download also provides a 4th file (total_counts.csv) that we won't be using.  Each of these files is a tab-separated csv file with the following format, illustrated using the contents of very_short.csv:
airport     2007    175702  32788
airport     2008    173294  31271
request     2005    646179  81592
request     2006    677820  86967
request     2007    697645  92342
request     2008    795265  125775
wandered    2005    83769   32682
wandered    2006    87688   34647
wandered    2007    108634  40101
wandered    2008    171015  64395
Each row has the following items:

The word
The year
Number of times the word appeared in any text that year
Number of distinct texts that contain that word
Thus from the first row of the example above we can see that the word airport was used in 2007 175,702 times, in 32,788 texts.
The program is divided into the following parts, with the points shown (out of a total of 50 for running correctly):

(5 pts.) Display the total number of distinct words, across all years.  Running your program should look something like the following (except with the right answer):
 Author: Dale Reed
 Lab: Wed 8am
 Program: #1, Google NGram word count

 Total number of distinct words: 27,356,489,782

(10 pts.) Prompt for a word, and for that word give a list of its frequency, averaged over every 5 years.  1801-1805 would be averaged to give a single output, 1806-1810 similarly would be averaged to give a single output, and so on.  This should give a total of 40 entries.  have your program display the results using ASCII graphics scaled to fit on a ~120-column wide screen that is 50 lines high.  For instance a very small ASCII graph of this sort might look like the following:
        Students with Flu 
             (x10)
       ---------------
    9 |          x xx 
    7 |    x    x x  x
    5 |  xx x  x
    3 | x    xx
    1 |x
       ---------------
                1
       123456789012345
              Week
If you display the 40 values instead of graphing them, you will only get 3 points.

(10 pts.) Prompt for a particular year and give the average word length for that year.

(30 pts.) Give the average word length for all words, across all years, again averaged over every 5 years.  Display a graph (in addition to the one above) showing this result.
Turn this in on Blackboard into the Program1 assignment.
