import argparse
import oauth2 as oauth
import urllib.request as urllib
import json
import sys
import csv
from io import StringIO

# added
import requests

# See Assignment 1 instructions for how to get these credentials
access_token_key = "194570211-1k69BWp9sYWSm19uRVc2XV3uu8CnmO0sSa8AZ1Gg"
access_token_secret = "rVlHqiaVdUfzqHZQWA6TDoJ0K2uTT76wwDXAWfXUYCyLz"

consumer_key = "Kx8toGGoyzr1KWpkvvi774QLB"
consumer_secret = "pLUhlchKfewJA4ftJ4EH0i9Ijz3ukvjsjx1v4pP2kfk00O7LRb"

_debug = 0

oauth_token    = oauth.Token(key=access_token_key, secret=access_token_secret)
oauth_consumer = oauth.Consumer(key=consumer_key, secret=consumer_secret)

signature_method_hmac_sha1 = oauth.SignatureMethod_HMAC_SHA1()

http_method = "GET"


http_handler  = urllib.HTTPHandler(debuglevel=_debug)
https_handler = urllib.HTTPSHandler(debuglevel=_debug)

'''
Construct, sign, and open a twitter request
using the hard-coded credentials above.
'''
def twitterreq(url, method, parameters):
    req = oauth.Request.from_consumer_and_token(oauth_consumer,
                                             token=oauth_token,
                                             http_method=http_method,
                                             http_url=url, 
                                             parameters=parameters)

    req.sign_request(signature_method_hmac_sha1, oauth_consumer, oauth_token)

    headers = req.to_header()

    if http_method == "POST":
        encoded_post_data = req.to_postdata()
    else:
        encoded_post_data = None
        url = req.to_url()

    opener = urllib.OpenerDirector()
    opener.add_handler(http_handler)
    opener.add_handler(https_handler)

    response = opener.open(url, encoded_post_data)

    return response

def fetch_samples():
    url = "https://stream.twitter.com/1.1/statuses/sample.json?language=en"
    parameters = []
    response = twitterreq(url, "GET", parameters)
    io = StringIO()
    for line in response:
        print(line.strip().decode('utf-8'))

def fetch_by_terms(term):
    url = "https://api.twitter.com/1.1/search/tweets.json"
    parameters = [("q", term), ("count", 100)]
    response = twitterreq(url, "GET", parameters)
    io = StringIO()
    for line in response:
        print(line.strip().decode('utf-8'))

def fetch_by_user_name(user_name):
    url = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    parameters = [
                ("screen_name", user_name), 
                ("count", 100), 
                ("exclude_replies", True)]
    response = twitterreq(url, "GET", parameters)
    print (response.readline())

def fetch_by_user_names(user_name_file):
    #TODO: Fetch the tweets by the list of usernames and write them to stdout in the CSV format
    url = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    print("user_name, tweet")

    with open(user_name_file) as sn_file:
        for screen_name in sn_file:
            parameters = [
                    ("screen_name", screen_name), 
                    ("count", 100), 
                    ("exclude_replies", True)]
            response = twitterreq(url, "GET", parameters)
            tweets = json.loads(response.read().decode('utf-8'))
            for tweet in tweets:
                try:
                    row = "{0},\"{1}\"".format(screen_name.rstrip(), tweet['text'])
                    print(row)
                except: # a possible error has occured
                    pass

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', required=True, help='Enter the command')
    parser.add_argument('-term', help='Enter the search term')
    parser.add_argument('-file', help='Enter the user name file')
    parser.add_argument('-user_name', help='Enter the user name file')
    opts = parser.parse_args()
    if opts.c == "fetch_samples":
        fetch_samples()
    elif opts.c == "fetch_by_terms":
        term = opts.term
        print (term)
        fetch_by_terms(term)
    elif opts.c == "fetch_by_user_names":
        user_name_file = opts.file
        fetch_by_user_names(user_name_file)
    elif opts.c == "fetch_by_user_name":
        user_name = opts.user_name
        fetch_by_user_name(user_name)
    else:
        raise Exception("Unrecognized command")
