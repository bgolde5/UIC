import sys
import json

_states = {
        "AL":"Alabama",
        "AK":"Alaska",
        "AZ":"Arizona",
        "AR":"Arkansas",
        "CA":"California",
        "CO":"Colorado",
        "CT":"Connecticut",
        "DE":"Delaware",
        "DC":"District of Columbia",
        "FL":"Florida",
        "GA":"Georgia",
        "HI":"Hawaii",
        "ID":"Idaho",
        "IL":"Illinois",
        "IN":"Indiana",
        "IA":"Iowa",
        "KS":"Kansas",
        "KY":"Kentucky",
        "LA":"Louisiana",
        "ME":"Maine",
        "MT":"Montana",
        "NE":"Nebraska",
        "NV":"Nevada",
        "NH":"New Hampshire",
        "NJ":"New Jersey",
        "NM":"New Mexico",
        "NY":"New York",
        "NC":"North Carolina",
        "ND":"North Dakota",
        "OH":"Ohio",
        "OK":"Oklahoma",
        "OR":"Oregon",
        "MD":"Maryland",
        "MA":"Massachusetts",
        "MI":"Michigan",
        "MN":"Minnesota",
        "MS":"Mississippi",
        "MO":"Missouri",
        "PA":"Pennsylvania",
        "RI":"Rhode Island",
        "SC":"South Carolina",
        "SD":"South Dakota",
        "TN":"Tennessee",
        "TX":"Texas",
        "UT":"Utah",
        "VT":"Vermont",
        "VA":"Virginia",
        "WA":"Washington",
        "WV":"West Virginia",
        "WI":"Wisconsin",
        "WY":"Wyoming"}

def get_states():
    global _states
    return _states

def get_sentiment_terms(sent_file):
    terms = {}
    for row in sent_file:
        term, score = row.split('\t')
        terms[term] = score.rstrip()
    return terms

def get_state_from_string(city_state_str):
    states = get_states()
    city, state_abbr = city_state_str.split(", ")

    if state_abbr in states:
        return states[state_abbr]

def get_tweet_sentiment_score(tweet, sentiment_terms):
    tweet = tweet.split()

    score = 0
    for term in tweet:
        if term in sentiment_terms:
            score+=float(sentiment_terms[term])
    return score

def calculate_happiest_states(sent_file, tweets):

    sentiment_terms = get_sentiment_terms(sent_file)
    happiest_states = {}

    for tweet in tweets:
        tweet_obj = json.loads(tweet)
        tweet_text = "" 

        # grab text from the tweet
        try:
            tweet_text = tweet_obj['text']
        except:
            # tweet is blank
            continue

        # get state from place object
        state = None
        try:
            state = get_state_from_string(tweet_obj['place']['full_name'])
        except:
            pass

        # get state from user object
        if state is None:
            try:
                state = get_state_from_string(tweet_obj['user']['location'])
            except:
                pass

        # build the happiest states dictionary
        # key = state, value = list of scores
        if state is not None:
            score = get_tweet_sentiment_score(tweet_text, sentiment_terms)
            if state in happiest_states:
                # state is available
                happiest_states[state].append(score)
            else:
                happiest_states[state] = [score]

    results = []
    for state, scores in happiest_states.items():
        sentiment_avg = sum(scores)/len(scores)
        results.append([state, sentiment_avg])

    return results

def get_key(item):
    return item[1]

def print_happiest_states(states):
    happiest_states=sorted(states, key=get_key, reverse=True)
    for state in happiest_states:
        print("{0}: {1}".format(state[1], state[0]))

def main():
    sent_file = open(sys.argv[1])
    tweets_file = open(sys.argv[2])

    happiest_states = calculate_happiest_states(sent_file, tweets_file)

    print_happiest_states(happiest_states)

if __name__ == '__main__':
    main()
