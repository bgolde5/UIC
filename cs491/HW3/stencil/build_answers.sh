#!/bin/bash

mkdir ../answers
mkdir ../answers/part-a
mkdir ../answers/part-b

# backup this file
cp ./build_answers.sh ../answers/

echo "Starting Part a..."

# Streaming API
echo "Streaming API starting..."
cp streaming_output_full.txt ../answers/part-b/streaming_output_full_bgolde5.txt
head -n 20 streaming_output_full.txt > ../answers/part-a/streaming_output_short_bgolde5.txt

# Search API
echo "Search API starting..."
python3 fetch_tweets.py -c fetch_by_terms -term "love" > ../answers/part-a/search_output_bgolde5.txt

# User API
echo "User API starting..."
python3 fetch_tweets.py -c fetch_by_user_names -file ../data/user_names.txt > ../answers/part-a/breaking_bad_tweets_bgolde5.csv
cp fetch_tweets.py ../answers/part-a/fetch_tweets_bgolde5.py

# Term Frequency
echo "Term Frequency starting..."
python3 frequency.py ../data/stopwords.txt streaming_output_full.txt > ../answers/parta/term_freq_bgolde5.txt
cp frequency.py ../answers/parta/frequency_bgolde5.py

echo "Generating reporta_bgolde5.txt..."
python3 generate_reporta.py > ../answers/part-a/reporta_bgolde5.txt
echo "Part a done!"

echo "Starting Part b..."

# Determine Sentiment of each Tweet
echo "Starting Determine Sentiment of each Tweet..."
python3 tweet_sentiment.py ../data/AFINN-111.txt streaming_output_full.txt > ../answers/part-b/tweet_sentiment_bgolde5.txt

# Happiest Breaking Bad Actors
echo "Starting Happiest Breaking Bad Actor..."
python3 happiest_actor.py ../data/AFINN-111.txt ../answers/breaking_bad_tweets_bgolde5.csv > ../answers/part-b/happiest_actor_bgolde5.txt

# Happiest State
echo "Starting Happiest State..."
python3 happiest_state.py ../data/AFINN-111.txt streaming_output_full.txt > ../answers/part-b/happiest_state_bgolde5.txt

echo "Generating reportb_bgolde5.txt..."
python3 generate_reportb.py > ../answers/part-b/reportb_bgolde5.txt

echo "Part b done!"
