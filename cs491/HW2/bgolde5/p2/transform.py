from bs4 import BeautifulSoup
import re
import csv

def import_html_file(filename):
    """import an entire html file using BeautifulSoup"""
    with open(filename) as html_file:
        soup = BeautifulSoup(html_file, 'html.parser')
        return soup

def get_table(html):
    return html.find_all('table', 'wikitable sortable')[1]

def get_header(table):
    th = table.find_all("th")
    return [th[0].get_text(), th[1].get_text(), th[2].get_text(), 
            th[3].get_text(), th[4].get_text(), th[5].get_text()]

def get_data(table):
    data = []
    for row in table.find_all("tr"):
        cells = row.find_all("td")
        row_data = []
        
        if cells:
            # Game
            row_data.append(cells[0].a.get_text())
            
            # Date
            row_data.append(cells[1].find_all("span")[1].get_text().split(", ")[1])
            
            # Winning team
            prog = re.compile(r'[a-zA-Z ]*')
            row_data.append(prog.match(cells[2].span.get_text()).group(0).rstrip())
            
            # Score
            row_data.append(cells[3].find_all("span")[1].get_text().rstrip())
            
            # Losing team
            row_data.append(prog.match(cells[4].span.get_text()).group(0).rstrip())
            
            # Venue
            row_data.append(cells[5].span.get_text().rstrip(' !'))
        
            data.append(row_data)
    
        
    # remove irrelevant data
    data = data[:-2]
    
    return data

def write_data_to_csv(header, data):
    
    with open("./result.csv", 'w') as csvfile:
        result = csv.writer(csvfile, delimiter = ',')
        
        # write the header of the csv first
        result.writerow([string for string in header])
        
        # now write the data
        for row in data:
            result.writerow([string for string in row])

if __name__=="__main__":
    soup = import_html_file('superbowl.html')
    table = get_table(soup)
    header = get_header(table)
    data = get_data(table)
    write_data_to_csv(header, data)
