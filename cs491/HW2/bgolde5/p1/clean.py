import re
from collections import defaultdict
import csv
import urllib.request
import xml.etree.ElementTree as ET
import enchant
import string
import sys

wordnet_dict = {}
DictService = False # enabling this significantly slows this program but will result in more accurate spell checking

class DataCleaner(object):
    def __init__(self):
        pass

    def save(self, data, filename):

        names = sorted(data.keys())

        with open('cleaned.txt', 'w') as clean:
            for name in names:
                classes = data[name]
                classes = [a_class.rstrip() for a_class in classes]
                classes = '|'.join(classes)
                clean.write("{0}  - {1}\n".format(name, classes))

    def jaccard(self, list1, list2):
        """calculates the jaccard coefficient between two strings

        jaccard similarity is calucalted by the following: a intersect b / a union b

        assume each string contains punctuation, we must clean the lists into
        individual words
        """

        
        list1 = [self.remove_punctuation(item).lower() for item in list1]
        list2 = [self.remove_punctuation(item).lower() for item in list2]

        intersect_between_lists = set(list1).intersection(list2)
        union_between_lists = set(list1).union(list2)

        jaccard_coefficient = len(intersect_between_lists)/len(union_between_lists)

        return jaccard_coefficient

    def get_most_similar_classes(self, prof_classes_dict):

        prof_names = list(prof_classes_dict)
        highest_jaccard_similarity = {
                'jaccard_coef':None,
                'prof1':None,
                'prof2':None,
                'classes1':None,
                'classes2':None }
        curr_coef = -1;

        for i in range(0, len(prof_names)-1):

            # skip if less than 5 classes
            if len(prof_classes_dict[prof_names[i]]) <= 5:
                continue

            for j in range(i, len(prof_names)-1):
                if i == j:
                    pass

                elif len(prof_classes_dict[prof_names[j]]) <= 5:
                    continue
                else:
                    classes_list_1 = prof_classes_dict[prof_names[i]]
                    classes_list_2 = prof_classes_dict[prof_names[j]]

                    new_coef = self.jaccard(classes_list_1, classes_list_2)
                    if new_coef > curr_coef:
                        curr_coef = new_coef
                        highest_jaccard_similarity['prof1'] = prof_names[i]
                        highest_jaccard_similarity['prof2'] = prof_names[j]
                        highest_jaccard_similarity['classes1'] = classes_list_1
                        highest_jaccard_similarity['classes2'] = classes_list_2
                        highest_jaccard_similarity['jaccard_coef'] = curr_coef

        return highest_jaccard_similarity

    def fix_sentence_case(self, sentence):

        lower_case_words = ['a', 'an', 'the', 'at', 'by', 'for', 'in', 'of', 'on', 'to', 'up', 'and', 'as', 'but', 'or']

        old_sentence_list = sentence.split(" ")

        first_word = old_sentence_list[0].capitalize()

        if len(old_sentence_list) == 1:
            return first_word

        last_word = ''

        new_sentence = []
        new_sentence.append(first_word)

        old_sentence_list.pop(0) # remove first word, it's been capitalized and saved

        if len(old_sentence_list) > 1:
            last_word = old_sentence_list[-1].capitalize()
            old_sentence_list.pop(len(old_sentence_list)-1) # remove the last word, it's been capitalized and saved

        for word in old_sentence_list:

            reg_ex = re.match(r"(\w+)", word) # strip special characters i.e. ':' or ','

            # test that the word is alpha numeric
            if reg_ex is not None and reg_ex.group(0) not in lower_case_words:
                alpha_numeric_word = reg_ex.group(0)
                capitalized_word = alpha_numeric_word.capitalize()
                word = word.replace(alpha_numeric_word, capitalized_word) # maintain special chars i.e. 'Test:' or 'yes,'
                new_sentence.append(word)

            else:
                new_sentence.append(word)

        new_sentence.append(last_word)
        return " ".join(new_sentence)

    def soundex_distance(self, word):
        # source: https://en.wikipedia.org/wiki/Soundex

        consonants = ['b', 'f', 'p', 'v', 'c', 'g', 'j', 'k', 'q', 's', 'x', 'z', 'd', 't', 'l', 'm', 'n', 'r']

        # corresponds to the soudex mapping
        mapping = {
            'b':1, 'f':1, 'p':1, 'v':1,
            'c':2, 'g':2, 'j':2, 'k':2, 'q':2, 's':2, 'x':2, 'z':2,
            'd':3, 't':3,
            'l':4,
            'm':5, 'n':5,
            'r':6
        }

        # Save the first letter. Remove all occurrences of 'h' and 'w' except first letter
        first_letter = word[0]
        word = word[0] + re.sub(r'[HhWw]', '', word[1:])

        # Replace all consonants (include the first letter) with digits as in [2.] above
        word = list(word)
        for i, letter in enumerate(word):
            if letter.lower() in consonants:
                word[i] = str(mapping[letter.lower()])

        word = ''.join(word)

        # Replace all adjacent same digits with one digit.
        temp_word = word[0]
        i = 1
        while i < len(word):  
            if word[i] != word[i-1]:
                temp_word += word[i]
            i+=1

        word = temp_word

        # Remove all occurrences of a, e, i, o, u, y except first letter.
        word = word[0] + re.sub(r'[aeiouyhw]', '', word[1:])

        # If first symbol is a digit replace it with letter saved on step 1.
        word = re.sub(r'[0-9]', first_letter, word[0]) + word[1:]

        # Append 3 zeros if result contains less than 3 digits. Remove all except first letter and 3 digits after it (This step same as [4.] in explanation above).
        while len(word) < 4:
            word += '0'

        return word[:4]

    def correct_sentence_spelling(self, sentence):
        d = enchant.Dict("en_US")
        corrected_sentence = []

        for word_with_special_chars in sentence.split(" "):
            in_wordnet = False
            in_dict_service = False
            word = ''
            reg = None

            # replace any '&' with 'and'
            if word_with_special_chars == '&':
                word = 'and'
                continue

            reg = re.match(r"(?P<pre>[.,!?;:']*)(?P<word>[\w&]*)(?P<post>[.,!?;:']*)", word_with_special_chars) # group words and punctuation
            alpha_numeric_word = reg.group('word')

            #save punctuation before and after the word
            pre = reg.group('pre')
            post = reg.group('post')

            # first check word net because it's a constant time lookup
            try:
                word = wordnet_dict[alpha_numeric_word.lower()]
                in_wordnet = True
            except KeyError:
                word = ''
                in_wordnet = False

            # now check DictService online dictionary for word
            if DictService and dict_service_has_word(alpha_numeric_word):
                word = alpha_numeric_word

            # now that wornet and dictservice has been checked, lets check enchant
            elif in_wordnet == False and d.check(alpha_numeric_word) == False: # word isn't spelled correctly

                # find first closest suggested word
                for suggested_word in d.suggest(alpha_numeric_word):

    #                 print(alpha_numeric_word, suggested_word, d.suggest(alpha_numeric_word))
                    word = ''

                    # both words have a resonable edit distance and the soundex is the same
    #                 if len(alpha_numeric_word) == len(suggested_word) \
    #                 temp_suggested_word = suggested_word.replace("-", "").replace(" ", "")
                    temp_suggested_word = suggested_word
                    if self.edit_distance(alpha_numeric_word.lower(), temp_suggested_word.lower()) < 3                     and self.soundex_distance(alpha_numeric_word.lower()) == self.soundex_distance(temp_suggested_word.lower()):
    #                     print(alpha_numeric_word, suggested_word)
    #                     test = input(alpha_numeric_word + " " + suggested_word)
    #                     print(d.suggest(alpha_numeric_word))
                        word = suggested_word
                        break

                    else:
                        word = alpha_numeric_word

            else:
                word = alpha_numeric_word

            word = word_with_special_chars.replace(word_with_special_chars, word)
            corrected_sentence.append(pre+word+post)
    #         print(corrected_sentence)
    #         test = input()
        return " ".join(corrected_sentence)

    def dict_service_has_word(self, word, strategy='exact'):

        url = 'http://services.aonaware.com/DictService/DictService.asmx/Match?word={0}&strategy={1}'.format(word, strategy)
    #     print(url)
        results = urllib.request.urlopen(url).read()
        root = ET.fromstring(results)
        for child in root:
            for found_word in child:
                if found_word.text == word:
                    return True
        return False

    def load_wordnet_into_mem(self, filename):
        """Loads a wordnet csv into a dictionary for later use. The load is only completed once so each lookup can be done
        constant time."""
        temp = {}
        with open(filename) as f:
            reader = csv.reader(f)
            for word in reader:
                temp[word[0].lower()] = word[0].lower()
        return temp

    def resolve_list(self, a_list, mapping):
        resolved_list = []
        # given a mapping from a->b,
        # we want to always map to b
        # if the value we're looking for is 
        # b, than it is already correct
        for item in a_list:
            # try to find item in mapping and apply that value
            try:
                resolved_list.append(mapping[item])
            # otherwise use the original value i nthe list
            except KeyError:
                resolved_list.append(item)

        return resolved_list

    def fold_list_of_lists_to_one_list(self, list_of_lists):
        return [item for sublist in list_of_lists for item in sublist]

    # loop through each key value pair and see if they are similar
    def entity_resolution(self, data, distance_constant=5):
        """this function maps a word b->a or b->b using a dictionary"""
        resolved_data = {}
        jaccard_constant = 0.6
        for i in range(0, len(data)):
            data[i] = data[i].lower()
            for j in range(i, len(data)):
                if i == j:
                    pass
                elif self.edit_distance(data[i], data[j]) <= distance_constant or self.jaccard(data[i].split(' '), data[j].split(' ')) >= jaccard_constant:
                    try:
                        resolved_data[data[j]] = data[i]
                    except KeyError:
                        resolved_data.append({data[j], data[i]})
                    # input('{0},{1},{2}'.format(data[j], data[i], self.jaccard(data[i].split(' '), data[j].split(' '))))

                # the word is not changed and maps to itself
                else:
                    try:
                        resolved_data[data[j]] = data[j]
                    except KeyError:
                        resolved_data.append({data[j], data[j]})

        return resolved_data;

    def edit_distance(self, word1, word2):
        """This algorithm involves looping through word1 and converting it to word2 letter by letter,
        replacing/deleting/inserting each character that doesn't match exactly."""

        if len(word1) == 0:
            return 0
        if len(word2) == 0:
            return 0

        word1 = list(word1.lower())
        word2 = list(word2.lower())

        distance = 0

        # find the shortest word
        shortest_word_len = 0
        if len(word1) < len(word2):
            shortest_word_len = len(word1)
        else:
            shortest_word_len = len(word2)

        # find the longest word
        longest_word_len = 0
        if len(word1) > len(word2):
            longest_word_len = len(word1)
        else:
            longest_word_len = len(word2)

        # loop for the duration of the shortest word
        # ensures there is no insertion at this point
        # strictly deletion and replacing
    #     print("".join(word1), "".join(word2))
        for i in range(0, shortest_word_len):

            # letters are the same
            if word1[i] == word2[i]:
                pass

            # letters are not the same
            elif word1[i] != word2[i]:
                word1[i] = word2[i]
    #             print("".join(word1), "".join(word2))
                distance += 1

        # loop through any remaining characters
        # that are empty strings and replace / delete them
        for i in range(shortest_word_len, longest_word_len):
            # if word2 no longer has letters, than word1 is longer
            # deletion is needed
            if i >= shortest_word_len and len(word1) > len(word2):
                word1.pop()
                distance += 1
    #             print("".join(word1), "".join(word2))
                continue

            # if letters don't exist in word1 that are in word2
            # insertion is needed
            try:
                word1.append(word2[i])
    #             print("".join(word1), "".join(word2))
                distance += 1
                continue
            except:
                pass

        return distance

    def remove_punctuation(self, word):
        remove_punc_pattern = r'\w*'
        return re.match(remove_punc_pattern, word).group(0)

    def get_name(self, unknown_name_format):

        name_dict = {}
        pattern = None

        # format is firstname.lastname
        if len(unknown_name_format.split('.')) == 2 and len(unknown_name_format.split(' ')) == 1:
            first_name, last_name = unknown_name_format.split('.')
            return {'last_name':last_name.capitalize(), 'first_name':first_name.capitalize()}

        # one word in name
        elif len(unknown_name_format.split(' ')) == 1:
            return {'last_name':self.remove_punctuation(unknown_name_format).capitalize()}

        # if comma after first word
        elif unknown_name_format.split(" ")[0][-1] == ',':
            pattern = re.compile(r"(?P<last_name>\w+,)\s(((?P<middle_initial>\w+.|\w+)\s)|\b)((?P<first_name>\w+))|\b")

        else:
            pattern = re.compile(r"(?P<first_name>\w+(.|\b))\s*(((?P<middle_initial>\w+|\w+.)\s)|\b)(?P<last_name>\w*)")

        reg = re.match(pattern, unknown_name_format)

        if reg.group('first_name'):
            name_dict['first_name'] = self.remove_punctuation(reg.group('first_name')).capitalize()

        if reg.group('middle_initial'):
            name_dict['middle_initial'] = self.remove_punctuation(reg.group('middle_initial')).capitalize()

        if reg.group('last_name'):
            name_dict['last_name'] = self.remove_punctuation(reg.group('last_name')).capitalize()

        return name_dict;

    def separate_classes_into_list(self, classes):
        return re.split("\|", classes)

    def separate_name_from_classes(self, row):
        row = row.split("  - ")
        return row[0], row[1]

    # def append_name_to_each_cclass(name, classes):

    def import_csv(self, filename):
        with open(filename) as csvfile:
            data = defaultdict(list)
            classes_list = []
            for row in csvfile:
                name, classes = self.separate_name_from_classes(row)
                classes = self.separate_classes_into_list(classes)
                classes_list.append(classes)
                name = self.get_name(name)

                # oraganize all classes by last name
                # of professor who teaches them
                for a_class in classes:
                    a_class = a_class.replace('\n', '')
                    prof_name = name['last_name']
                    data[prof_name].append(a_class)

            return data

    def build_classes_list(self, data):
        classes = []
        for key, a_list in data.items():
            for an_item in a_list:
                if an_item in classes:
                    pass
                else:
                    classes.append(an_item.rstrip())
        return sorted(classes)

    def get_clean_data(self, filename):
        # print(entity_resolution_between_list(classes_list, 5))
        #     # TODO - see which classes are being resolved and chech that there are no errors

        # get the data in a dirty format
        # this data is organize is a dict where the key is the professor last name and the 
        # value is a list of classes that they teach
        data_dirty = self.import_csv(filename)

        # get a list of classes in a dirty format, the classes in the list are not distinct and
        # will need resolving later
        classes_list_dirty = self.build_classes_list(data_dirty)
    #     print(classes_list_dirty)

        # get a dictionary of key value pairs where the key value maps to a 
        # resolution between class_a -> class_b
        classes_dict_resolved = self.entity_resolution(classes_list_dirty, 5)
    #     print(classes_dict_resolved)

        # now resolve the classes associated with each professor
        # by passing in the existing mapping and a list of classes
        data_resolved = {}
        for professor, classes in data_dirty.items():
            data_resolved[professor] = self.resolve_list(classes, classes_dict_resolved)
    #     print(data_resolved)

        # now that we've resolved the data, it's time to
        # correct the spelling for each item

        # first lets load wordnet words into memory
        wordnet_dict = self.load_wordnet_into_mem('WordNet.csv')

        # now lets correct the spelling of each sentence
        data_spell_checked = data_resolved
        for name, classes in data_resolved.items():
            classes_spell_checked = []
            for a_class_dirty in classes:
                classes_spell_checked.append(self.correct_sentence_spelling(a_class_dirty))
            data_spell_checked[name] = classes_spell_checked

    #     print(data_spell_checked)

        # next lets fixed the capitalization of each word in the sentences
        data_capitalized_correctly = data_spell_checked
        for name, classes in data_spell_checked.items():
            classes_capitalized_correctly = []
            for a_class_dirty in classes:
                classes_capitalized_correctly.append(self.fix_sentence_case(a_class_dirty))
            data_capitalized_correctly[name] = classes_capitalized_correctly

    #     print(data_capitalized_correctly)

        # now we have a workable set that we can query from!
        data_clean = data_capitalized_correctly
        return data_clean

if __name__ == "__main__":
    filename = sys.argv[1]
    cleaner = DataCleaner()
    data = cleaner.get_clean_data(filename)
    cleaner.save(data, filename)
