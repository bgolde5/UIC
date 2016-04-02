import sys
import json

_stopwords = []
_dictionary = {}

def build_stopwords(stopword_file):
    """
    Builds a list of stopwords to be used while parsing 
    tweets. A stopword is a common word that will be ignored.

    Example Stopwords: its, dont, i
    """
    global _stopwords
    _stopwords = []
    with open(stopword_file) as s_file:
        _stopwords = s_file.read().splitlines()

def build_dictionary(tweets_file):
    """
    Builds a dictionary of words from a given tweet file. This
    tweet file is expected to be in proper JSON format. The key
    for the dictionary is the word and the value is the number
    of words that appears in the provided JSON file.

    Example: the -> dictionary['the'] = <number of occurrences of the>
    """
    global _dictionary
    _dictionary = {}
    tweets = {}
    test = None
    with open(tweets_file) as tweets:
        # get each tweet from the file
        for tweet in tweets:
            # convert to a json object
            tweet_obj = json.loads(tweet)
            # split the tweet's contents into a list
            words = tweet_obj['text'].split()
            # iterate words in the tweet
            for word in words:
                word = word.lower().replace("'", "")
                if word not in _stopwords:
                    # increment the count of the word found
                    if word in _dictionary:
                        # word already exists
                        _dictionary[word] += 1
                    else:
                        # add word to the dictionary
                        _dictionary.update({word:1})

def total_occurrences_of_all_terms():
    total = 0
    for word, occurrences in _dictionary.items():
        total += occurrences
    return total

def total_occurrences_of_a_term(term):
    return _dictionary[term]

def get_key(item):
    return item[1]

def dict_to_list(a_dict):
    a_list = []

    for key, value in a_dict.items():
        a_list.append([key,value])

    return a_list

def compute_term_frequency():
    total_all_occurrences = total_occurrences_of_all_terms()
    freq = {}

    for word, count in _dictionary.items():
        freq.update({word:total_occurrences_of_a_term(word)/total_all_occurrences})

    # a work around for sorting a dictionary
    # without the operator library
    # first converto to list and sort the list
    freq = dict_to_list(freq)
    freq = sorted(freq, key=get_key, reverse=True)

    for pair in freq:
        print(pair[0], pair[1])

def main():
    stopword_file = sys.argv[1]
    build_stopwords(stopword_file)

    tweets_file = sys.argv[2]
    build_dictionary(tweets_file)

    compute_term_frequency()

if __name__ == '__main__':
    main()
