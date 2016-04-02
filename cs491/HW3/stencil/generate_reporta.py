import json

with open('../answers/search_output_bgolde5.txt') as tweets:
    word = tweets.readline()
    tweet_json = []
    print("--------------------------")
    print("Tweet Examples for '" + word.rstrip() + "'")
    print("--------------------------")
    for tweet in tweets:
        tweet_json.append(json.loads(tweet))
    for a_tweet_json in tweet_json:
        for something in a_tweet_json['statuses'][0:20]:
            print(something['text'])

print("")
print("")
with open('../answers/term_freq_bgolde5.txt') as term_file:
    print("-----------------------")
    print("Top 30 Term Frequencies")
    print("-----------------------")
    for line in term_file.readlines()[0:30]:
        print(line.rstrip())
