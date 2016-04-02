import sys
import json

# key = term, value = score
_sentiment_terms = {}
# key = tweet, value = score
_tweets = {}

def get_sentiment_words(sent_file):
    global _sentiments_terms

    for line in sent_file.readlines():
        term, score = line.rstrip().split('\t')
        try:
            _sentiment_terms[term] = float(score)
        except KeyError:
            _sentiment_terms.add({term, float(score)})

def build_tweet_scores(tweet_file):
    global _sentiment_terms
    
    for tweet in tweet_file:
        tweet_score = 0.0
        # covert to a json object
        tweet_obj = json.loads(tweet)
        # split the tweet's content into a list
        tweet_text = tweet_obj['text']
        terms = tweet_obj['text'].split()

        # iterate through the terms in the tweet
        # and get the sentiment score for the tweet
        for term in terms:
            if term in _sentiment_terms:
                tweet_score += float(_sentiment_terms[term])

        # add the tweet to our dict 
        try:
            _tweets[tweet_text] = tweet_score
        except:
            # some error occurred
            pass

def dict_to_list(a_dict):
    a_list = []

    for key, value in a_dict.items():
        a_list.append([key, value])

    return a_list

def get_key(item):
    return item[1]

def get_tweets_by_highest_score():
    global _tweets
    tweets_list = dict_to_list(_tweets)
    return sorted(tweets_list, key=get_key, reverse=True)

def get_tweets_by_lowest_score():
    global _tweets
    tweets_list = dict_to_list(_tweets)
    return sorted(tweets_list, key=get_key)

def main():
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])

    get_sentiment_words(sent_file)
    build_tweet_scores(tweet_file)

    highest = get_tweets_by_highest_score()
    lowest = get_tweets_by_lowest_score()

    [print("{0}: {1}".format(tweet[1], tweet[0])) for tweet in highest[0:10]]
    [print("{0}: {1}".format(tweet[1], tweet[0])) for tweet in lowest[0:10]]

if __name__ == '__main__':
    main()
