import sys
import csv

_sentiment_terms = {}
_user_names = []

def build_user_names():
    global _user_names

    try:
        with open('user_names.txt', 'rb') as user_names:
            for user_name in user_names.readlines():
                _user_names.append(user_name.rstrip().decode('utf-8'))

    except FileNotFoundError:
        print("ALERT!")
        print("Please place the user names file in the same directory as this script.")
        return False
    
    return True

def get_sentiment_terms(terms_file):
    terms = {}
    for row in terms_file:
        term, score = row.split('\t')
        terms[term] = score.rstrip()
    return terms

def get_score_from_tweet(tweet):
    global _sentiment_terms

    tweet = tweet.split(' ')

    score = 0
    for term in tweet:
        if term in _sentiment_terms:
            score += float(_sentiment_terms[term])
    return score

def get_happiest_actors(actors_tweets_file):
    # happiest_actors = {}
    all_actors = {}
    actor, tweet = "", "" 

    # iterate through all rows in the actors tweets file
    # and build a dictionary of [actor name] = [list of scores]
    # some rows however may be a continuation of a previous row
    # and must be taken into consideration
    for row in actors_tweets_file:
        # this row is blank
        if len(row) < 1:
            tweet += "\n\r"
            continue

        # check if the first index contains the user_name
        if row[0] not in _user_names:
            # this row is a continuation of the previous user's tweet
            # this tweet is most likely multiline
            # let's append the text to the current tweet
            tweet += row[0]
            continue

        # the row now has a username in it
        # and the tweet hasn't been 
        if row[0] in _user_names:

            # checking if the tweet has been saved or not
            # if the length of the tweet is greater than 0,
            # let's go ahead and save it
            if len(tweet) > 0 and len(actor) > 0:
                tweet_score = get_score_from_tweet(tweet)
                if actor in all_actors:
                    # add this tweet score to their existing list of tweet scores
                    all_actors[actor].append(tweet_score)
                else:
                    # create an actor with a new scores list
                    all_actors[actor] = [tweet_score]
                # now reset the tweet and actor name
                actor, tweet = "", ""

            # in this case, the tweet hasn't been saved yet
            # and it's most likely the first row of a possible
            # multirow tweet
            # let's save the actor's name and the tweet
            else:
                actor = row[0]
                tweet = row[1].lstrip()

    results = []
    for actor, scores in all_actors.items():
        sentiment_avg = sum(scores)/len(scores)
        results.append([actor, sentiment_avg])

    results = sorted(results, key=get_key, reverse=True)

    for result in results:
        print("{0}: {1}".format(result[1], result[0]))

def get_key(item):
   return item[1] 

def main():
    global _sentiment_terms

    sent_file = open(sys.argv[1])
    csv_file = open(sys.argv[2])
    file_reader = csv.reader(csv_file)

    if build_user_names() == False:
        return

    _sentiment_terms = get_sentiment_terms(sent_file)
    happiest_actors = get_happiest_actors(file_reader)

if __name__ == '__main__':
    main()
