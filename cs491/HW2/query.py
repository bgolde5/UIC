import clean
from clean import DataCleaner
import sys

# Query 1
def q1(filename):
    data = DataCleaner().get_clean_data(filename)
    classes_list = DataCleaner().build_classes_list(data)
    classes_mapping = DataCleaner().entity_resolution(classes_list)
    print("Query 1 results: {0}".format(len(classes_mapping)))

# Query 2
def q2(filename):
    data = DataCleaner().get_clean_data(filename)
    print("Query 2 results: ", end="")
    classes = data['Theys']
    for i in range(0,len(classes)-2):
        print(classes[i] + ", ", end="")
    print(classes[len(classes)-1])

# Query 3
def q3(filename):
    cleaner = DataCleaner() 
    data = cleaner.get_clean_data(filename)
    print("Query 3 results: ", end="")
    jaccard_solution = cleaner.get_most_similar_classes(data)
    print(jaccard_solution['prof1'] + ", " + jaccard_solution['prof2'])

if __name__ == '__main__':
    filename = sys.argv[1]
    q1(filename)
    q2(filename)
    q3(filename)
