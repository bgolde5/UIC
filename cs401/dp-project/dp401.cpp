#include <iostream>
#include <fstream>
#include <vector>
#include <iterator>
#include <string>
#include <algorithm>

double gate_delay = 1.0;
int num_pins;
int count = 0;

struct node
{
  std::string data;
  node *left;
  node *right;
};

node *tree = NULL;

node *insert(node *tree, std::string ele)
{
  if (tree == NULL)
  {
    tree = new node;
    tree->left = tree->right = NULL;
    tree->data = ele;
  }
  else if (ele <= tree->data)
    tree->left = insert(tree->left, ele);
  else
    tree->right = insert(tree->right, ele);

  return(tree);
}

void postorder(node *tree)
{
  if (tree != NULL)
  {
    postorder(tree->left);
    postorder(tree->right);
    std::cout << tree->data << " ";
  }
}

// function: read_pin_file
// description: reads the file contents of the pin file
//				sets num_pins (global var) to the first line the file
// returns: a vector of arrival times
std::vector<double> read_pin_file(std::string file) {
  std::vector<double> pins;
  std::ifstream ifs_file(file);
  std::string line;

  //get number of pins from first line
  std::getline(ifs_file, line);
  num_pins = stoi(line);

  // read remaining values into vector pins
  while (std::getline(ifs_file, line)) {
    pins.push_back(std::stoi(line));
  }

  return pins;
}

void print_matrix(std::vector<std::vector<double> > m)
{
  for (int i = 0; i < m.size(); i++) {
    for (int j = 0; j < m.size(); j++) {
      std::cout << m[i][j] << "\t";
    }
    std::cout << std::endl;
  }
}

double max(double x, double y) {
  if (x > y)
    return x;
  else
    return y;
}

//
// Reference: Introduction to Algorithms by Thomas H. Cormen - Third Edition
//
void print_optimal_parens(std::vector<std::vector<double> > m, std::vector<std::vector<double> > s, int i, int j)
{
  if (i == j)
  {
    std::cout << " " << m[i][j] << " ";

  }
  else
  {
    std::cout << "(";
    print_optimal_parens(m, s, i, s[i][j]);
    print_optimal_parens(m, s, s[i][j] + 1, j);
    std::cout << ")";
  }
}

double lookup_chain(std::vector<std::vector<double> > &m, std::vector<double> p, int i, int j)
{
  if (m[i][j] < INT_MAX)
  {
    return m[i][j];
  }

  if (i == j)
  {
    m[i][j] = p[i];
  }

  else
  {
    double q;

    for (int k = i; k <= j - 1; k++)
    {
      q = max(lookup_chain(m, p, i, k), lookup_chain(m, p, k + 1, j)) + gate_delay;

      if (q < m[i][j])
      {
        m[i][j] = q;
      }
    }
  }
  return m[i][j];
}

// removes all int_max for prettier printing 
void clean_matrix(std::vector<std::vector<double> > &m)
{
  for (int i = 0; i < m.size(); i++)
  {
    for (int j = 0; j < m.size(); j++)
    {
      if (m[i][j] == INT_MAX)
        m[i][j] = 0;
    }
  }
}

double memoized_matrix_chain(std::vector<double> p)
{
  std::vector<std::vector<double> > m(num_pins, std::vector<double>(num_pins, INT_MAX));
  std::vector<std::vector<double> > s(num_pins, std::vector<double>(num_pins, INT_MAX));

  double temp =  lookup_chain(m, p, 0, num_pins-1);

  clean_matrix(m);

  //print_matrix(m);

  return temp;
}

int main(int argc, char** argv)
{
  std::vector<double> pins;
  std::string file = argv[1];

  if (argc > 2)
    std::string trash = argv[2];

  if (argc > 3)
    std::string trash2 = argv[3];

  // get num_pins and pins from file
  pins = read_pin_file(file);

  double result;

  result = memoized_matrix_chain(pins);

  std::cout << "Arrival time: " << result << std::endl;
  std::cout << "Cost: " << result << std::endl;
  std::cout << "Topology: " << ":(" << std::endl;

  return 0;
}
