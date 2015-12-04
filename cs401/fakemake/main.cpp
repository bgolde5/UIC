//
//  main.cpp
//  fakemake
//
//  Created by Bradley Golden on 11/27/15.
//  Copyright © 2015 Bradley Golden. All rights reserved.
//

#include <iostream>
#include <vector>
#include <sstream>
#include <fstream>
#include <map>
#include <string>
#include <list>

// assuming each node has no more than 100 neighboring nodes
#define NUM_NEIGHBORS 100

/******************************
 
 CLASSES
 
 ******************************/

class Node {

private:
    
    std::string filename;
    int timestamp;
    
public:
    
    bool is_composite;
    enum {WHITE = 0, GRAY = 1, BLACK = 2} color;
    Node** neighbors;
    bool updated;
    bool is_last_dependency;
    bool dependency_updated;
    
    Node (std::string fn, int ts, bool i_c){
        filename = fn;
        timestamp = ts;
        is_composite = i_c;
        neighbors = new Node*[NUM_NEIGHBORS];
        init_neighbors();
        color = WHITE;
        updated = false;
        is_last_dependency = false;
        dependency_updated = false;
    }
    
    void set_timestamp(int ts){
        timestamp = ts;
    }
    
    int get_timestamp(){
        return timestamp;
    }
    
    void set_filename(std::string fn){
        filename = fn;
    }
    
    std::string get_filename(){
        return filename;
    }
    
    void init_neighbors(){
        for (int i=0; i<NUM_NEIGHBORS; i++) {
            neighbors[i] = nullptr;
        }
    }
    
};

/******************************
 
 GLOBAL VARIABLES
 
 ******************************/

int clock_time = 1;
int highest_timestamp = 0;
std::map<std::string, Node> graph;
bool last_dependency = false;

/******************************
 
FUNCTIONS
 
******************************/

void print_graph(){
    
    int neighbor_index = 0;
    
    for (auto &a_node : graph){
        
        std::cout << a_node.second.get_filename() << " (" << a_node.second.color << ") ";
        
        // is a target file and has dependencies
        if (a_node.second.neighbors[0] != nullptr){
            std::cout << " : ";
            
            Node *curr_node = a_node.second.neighbors[0];
            
            while (curr_node != nullptr) {
                std::cout << curr_node->get_filename() << " (" << curr_node->color << ") ";
                curr_node = a_node.second.neighbors[++neighbor_index];
            }
        }
        
        std::cout << std::endl;
        neighbor_index = 0;
    }
}

void dfs_visit(Node &root) {

  root.color = Node::GRAY;

  // traverse all neighbor nodes
  for (int i=0; root.neighbors[i] != nullptr; i++) {

    // look for a cycle
    if (root.neighbors[i]->color == Node::GRAY) {

      std::cout << "A cycle exists in your makefile. Please correct it." << std::endl;
      exit(1);

    }

    // look for child node
    else if (root.neighbors[i]->color == Node::WHITE) {

      dfs_visit(*root.neighbors[i]);

      // set root to neighbor timestamp
      if (root.neighbors[i]->get_timestamp() > root.get_timestamp()) {

        root.dependency_updated = true;
      }

    }

    // look for parent node
    else if (root.neighbors[i]->color == Node::BLACK) {

      if (root.neighbors[i]->get_timestamp() > root.get_timestamp()) {

        root.dependency_updated = true;
      }
      // node has already been visited and is a child of the current root
      //root.set_timestamp(clock_time++);
      //root.updated = true;
    }

  }

  root.color = Node::BLACK;

  if (root.dependency_updated 
      && root.is_composite){

    root.set_timestamp(clock_time++);
    root.dependency_updated = false;

    std::cout << "making " << root.get_filename() << "... done" << std::endl;
  }

  else if (!root.dependency_updated 
      && root.is_composite){

    std::cout << root.get_filename() << " is already up to date" << std::endl;
  }
}

void reset_dfs() {

  highest_timestamp = 0;

  for (auto &node : graph) {

    node.second.color = Node::WHITE;
  }
}

void dfs() {

  for (auto &node : graph) {
    reset_dfs();
    dfs_visit(node.second);
  }
}

int valid_dependency(std::string filename){

  std::cout << "filename " << filename << std::endl;
  // file exsists and it's not composite
  if (graph.find(filename) != graph.end()
      && !(graph.find(filename)->second.is_composite)) {

    return 1;
  }

  return 0;
}

int valid_filename(std::string filename){

  if (graph.find(filename) != graph.end()) {

    return 1;
  }

  return 0;
}

void do_time() {

  std::cout << clock_time << std::endl;
}

// assumes valid filename (target or basic)
void do_touch(std::string filename) {

  // pointer to node in memory for access
  Node *file = &(graph.find(filename)->second);

  if (!file->is_composite) {

    file->set_timestamp(clock_time);
    file->updated = true;
    std::cout << "File '" << file->get_filename() << "' has been modified." << std::endl;
    clock_time++;
  }

  else {

    std::cout << "Touch cannot be performed on target file '" << filename << "'." << std::endl;
  }
}

// assumes valid filename
void do_timestamp(std::string filename) {

  Node *file = &(graph.find(filename)->second);

  std::cout << std::to_string(file->get_timestamp()) << std::endl;
}

void do_timestamps() {

  for (auto &elem : graph){
    std::cout << elem.second.get_filename() << " " << elem.second.get_timestamp() << std::endl;
  }
}

// assumes valid target
void do_make(std::string target) {

  dfs_visit(graph.find(target)->second);
  reset_dfs();
}

void read_file() {

}

// executes a given command
int execute_command(std::string cmd, std::string arg){

  std::cout.clear(); // clear any junk in cout buffer

  if (cmd.compare("time") == 0) {
    do_time();
  }

  else if (cmd.compare("touch") == 0) {

    if (valid_filename(arg)) {

      do_touch(arg);
    }
    else {

      std::cout << "Invalid filename" << std::endl;
    }
  }

  else if (cmd.compare("timestamp") == 0) {

    if (valid_filename(arg)) {

      do_timestamp(arg);
    }
    else {

      std::cout << "Invalid filename" << std::endl;
    }

  }

  else if (cmd.compare("timestamps") == 0) {

    do_timestamps();
  }

  else if (cmd.compare("make") == 0) {

    if (valid_filename(arg)){

      do_make(arg);
    }
    else {

      std::cout << "Invalid target" << std::endl;
    }

  }
  else if (cmd.compare("quit") == 0) {

    return 0;
  }
  else {

    std::cout << "Invalid argument" << std:: endl;
  }
  return 1;

}

// split user input
std::vector<std::string> split(std::string string) {

  std::istringstream iss(string);

  std::vector<std::string> tokens{std::istream_iterator<std::string>{iss},
    std::istream_iterator<std::string>{}};

  return tokens;
}

// reads input from the user
int input(){

  std::string input;
  std::vector<std::string> result;

  std::cout << "> ";
  getline( std::cin, input );

  result = split(input);

  return execute_command(result[0], result[1]);
}

// use hash map to find each target dependency
// and do a look up to point the nodes to each other
int read_file(std::string filename){

  int neighbor_index = 0;

  std::ifstream file(filename);
  std::string line;

  while (std::getline(file, line)) {

    std::istringstream iss(line);
    std::string first_file, punctuation;

    // composite file
    if ((iss >> first_file >> punctuation)) {

      std::string target = first_file;

      // check for duplicate target or dependency
      if (valid_filename(first_file)){
        std::cout << "Duplicate target or dependency in the makefile." << std::endl;
        return 0;
      }

      // insert target file
      Node target_node = *new Node(target, 0, true);

      // get dependency files
      std::string dependency;

      neighbor_index = 0;

      Node *dep_node; // used inside while loop

      while ((iss >> dependency)){

        // pull dependency from hash map
        if(valid_filename(dependency)){

          dep_node = &(graph.find(dependency)->second);

          // point target file to dependency
          target_node.neighbors[neighbor_index] = dep_node;
          neighbor_index++;

          //std::cout << "size: " << target_node.next.size() << " ";
        }

        else {
           //invalid dependency, file is in incorrect format
          std::cout << "Invalid dependency '" << dependency << "'. Please correct your makefile." << std::endl;
          return 0;
        }
        graph.insert(std::pair<std::string, Node> (target, target_node));
      }
      dep_node->is_last_dependency = true;
    }

    // basic file
    else {

      std::string basic = first_file;

      // insert basic file
      Node newNode = *new Node(basic, 0, false);
      graph.insert(std::pair<std::string, Node> (basic, newNode));
    }
  }
  return 1;
}

/******************************

  MAIN

 ******************************/
int main(int argc, const char * argv[]) {

  std::string filename;

  if (argc == 2){
    filename = argv[1];
  }

  else {
    std::cout << "Missing filename. Requires <executable> <filename>" << std::endl;
    return 1;
  }

  if(!read_file(filename))
    return 0;

  while (input()) {
    // continue reading and executing input
  }

  return 0;
}
