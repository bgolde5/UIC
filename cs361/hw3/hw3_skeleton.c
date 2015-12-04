#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

struct memory_region{
    size_t * start;
    size_t * end;
};

struct memory_region global_mem;
struct memory_region heap_mem;
struct memory_region stack_mem;


//marking related operations

int is_marked(size_t* chunk) {
  //complete
}

void mark(size_t* chunk) {
  //complete
}

void clear_mark(size_t* chunk) {
  //complete
}

// chunk related operations

void* next_chunk(void* c) { 
	//if next chunk > sbrk(0), return 0
}
int in_use(void *c) { 
}


// index related operations

#define IND_INTERVAL ( (10000-0) / INDEX_SIZE )
void build_heap_index() {	
	
}

// the actual collection code

void sweep() {
		if(in_use(chunk) && !is_marked(chunk)) {
			// difficulty: when free the chunk, if next chunk is free, it will be coalesced, namely size will be the addition of two chunks. so where is the next chunk?
		}
		else {	
			clear_mark();      
			chunk=next_chunk(chunk);
		}
}

//determine if what "looks" like a pointer actually points to a block in the heap
size_t * isPtr(size_t * ptr) {
	//if(ptr is not in heap range) return 0;
	
	//there is two ways to find the chunk: traverse the heap section to find two chunks such x,y that x<ptr<y, then x is the chunk.
	//smarter implement is to use the heapindex[INDEX_SIZE]: split heap section into some "roughly-same-size" parts,which contain a bunch of chunks. Then traverse the indexed chunk instead of every chunk. 

	if(in_use(chunk)) return chunk;
	else return NULL;
}

void traverse(void* start, void* end) {
  for (size_t * ptr=start; ptr<end; ptr++) {
    size_t * chunk = isPtr((size_t *)*ptr);
    if(chunk && !is_marked(chunk)) {
      mark(chunk);
      //in the loop ptr point to one chunk block, and *ptr may point to another chunk.	
      traverse(chunk,((void*)chunk)+chunk_size(chunk));
    }
  }    
}

// standard initialization 

void init_gc() {
  init_global_range();
  heap_mem.start=malloc(512);
}

void gc() {
  heap_mem.end=sbrk(0);
  //build the index that makes determining valid ptrs easier
  build_heap_index();

  //traverse memory regions
  //in the loop ptr point to global section, and *ptr point to heap section	
  traverse(global_mem.start,global_mem.end);
  //in the loop ptr point to stack section, and *ptr point to heap section	
  traverse(stack_mem.start,stack_mem.end);
  sweep();
}
