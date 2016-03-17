QUESTION 1:

BUILD INSTRUCTIONS:
1. Install the enchant library (pip3 install pyenchant)
2. Include the WordNet.csv file
3. $ python3 clean.py <filename> performs the transformation
4. $ python3 query.py <filename> performs the 3 requested queries

TRANSFORMATION RULES:
1. I’ve used the edit distance method to determine which classes are similar to other classes. In this process, I’ve restricted the difference coefficient to 5 characters. This proved to be the best balance between overcorrecting classes and under correcting classes. Of course there may be a few miscorrections. i.e. “calc i” and “calc ii” will both be resolved to “calc i” or “calc ii”.

2. For spelling, I’ve used the following methods to ensure accurate spelling:

  - Use WordNet to verify that the word is correctly spelled
  - Use a combination of Soundex, Edit Distance and pythons “Enchant” 
    library to determine if the word has been correctly spelled. 
    This is done by first checking if the word is spelled incorrectly,
    and then corresponding Enchant’s suggested words with the incorrect
    word. i.e. vizion might suggest viz ion, viz, vision. By using edit
    distance, it’s clear to see that “viz ion” and “viz” can be eliminated
    immediately, leaving vision. Because the soundex value of vizion and vision
    is identical, a match occurs and the word is replaced.
  - Lastly, if both Wordnet and my Soundex/Edit Distance/Enchant method fails,
    I assume the word is a strange one and will remain the same.
    i.e. “Filmmaking” (technically should be “Film making”)

3. For Jaccard distance, I’ve simply treated each class out
of the classes that a professor teaches as a single string.
I do this because I’ve already resolved the classes in the prior
steps and thus I assume each class is unique.