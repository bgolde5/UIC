import json

with open("../answers/tweet_sentiment_bgolde5.txt") as tweets:
    tweet_json = []
    print("------------------------")
    print("Tweet Sentiment Analysis")
    print("------------------------")
    [print(row.rstrip()) for row in tweets]
    print("")

with open("../answers/happiest_actor_bgolde5.txt") as happiest_actor:
    print("-----------------------------------")
    print("Happiest Breaking Bad Actor Results")
    print("-----------------------------------")
    [print(row.rstrip()) for row in happiest_actor]
    print("")

with open("../answers/happiest_state_bgolde5.txt") as happiest_state:
    print("----------------------")
    print("Happiest State Results")
    print("----------------------")
    happiest_states = happiest_state.readlines()
    [print(row.rstrip()) for row in happiest_states[0:5]]
    happiest_states.reverse()
    [print(row.rstrip()) for row in happiest_states[0:5]]
