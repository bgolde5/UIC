size_t chuck_size(void *p) {
  size_t *mem = (size_t *)p;
  mem -= 1
  size_t val = *mem;
  return (val & ~7);
}

p1 = malloc(100); // p1 address = 1000
p1size = chunk_size(p1); // size = 100

// check from address 1000 to address 1100
size_t *m = p1;
while( m < p1 + chunk_size(p1) ) {
  mark(m);
  m++;
}

void * nextBlock(void *p) {
  size_t *mem = (size_t *)p;
  size_t memsize = chunk_size(men);

  size_t *nextMem = men + memorize;
  return nextMem;
}


int isPtr(void *p) {
   // return true if p is a valid pointer to a chunk.
   // that means p is a return val of a malloc call

   // to check if p is a return value if an malloc,
   // you have to find all return values of all malloc calls till now
   // check if p is one of them

  // how to get all return values of malloc? 
  // and to check all chunks

  // how to check all chunks?
  size_t *being = first_chunk(); // heap_mem.start
  size_t *end = end_chunk();  // heam_mem.end / sbrk(0)
  while(begin < end) {
     if(begin == p  ) {  // or check p lies between begin && begin + chunk_size(begin)
       return true;
     }
     begin = nextBlock(begin);
  }

  return false;
}

int blockAllocated(void *p) {
  size_t *nextMem = nextBlock(p);

  size_t *nextHeader = nextMem - 1;
 
  size_t nextHeaderVal = *nextHeader;

  // TODO: check if last bit is set in nextHeaderVal
  return ….;
}

mark_range(void *start, void *end) {
   for( each block between start and end) {
      mark(block);
   }
}

mark(void *p) {
   // implement as in book
}


gc() {
  mark_range(global.start, global.end);
  sweep(global.start, global.end);

  mark_range(stack.start, stack.end);
  sweep(stack.start, stack.end);
}
