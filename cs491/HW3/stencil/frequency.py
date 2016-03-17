import sys
import json
import operator
import codecs

_stopwords = []
_dictionary = {}

def build_stopwords(stopword_file):
    global _stopwords
    _stopwords = []
    with open(stopword_file) as s_file:
        _stopwords = s_file.read().splitlines()

def build_dictionary(tweets_file):
    global _dictionary
    _dictionary = {}
    tweets = {}
    reader = codecs.getreader("utf-8")
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
                word = word.lower()
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

def compute_term_frequency():
    total_all_occurrences = total_occurrences_of_all_terms()
    freq = {}

    for word, count in _dictionary.items():
        freq.update({word:total_occurrences_of_a_term(word)/total_all_occurrences})

    sorted_freq = sorted(freq.items(), key=operator.itemgetter(1), reverse=True)

    for key, value in sorted_freq:
        print(key, value)

def main():
    stopword_file = sys.argv[1]
    build_stopwords(stopword_file)

    tweets_file = sys.argv[2]
    build_dictionary(tweets_file)

    compute_term_frequency()

if __name__ == '__main__':
    main()
