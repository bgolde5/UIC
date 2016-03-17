
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 12 37 10 80       	mov    $0x80103712,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 4c 88 10 	movl   $0x8010884c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100049:	e8 cf 50 00 00       	call   8010511d <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 05 11 80 84 	movl   $0x80110584,0x80110590
80100055:	05 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 05 11 80 84 	movl   $0x80110584,0x80110594
8010005f:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 05 11 80    	mov    0x80110594,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 05 11 80 	movl   $0x80110584,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 05 11 80       	mov    0x80110594,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 05 11 80       	mov    %eax,0x80110594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801000bd:	e8 7c 50 00 00       	call   8010513e <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 05 11 80       	mov    0x80110594,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100104:	e8 97 50 00 00       	call   801051a0 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 c6 10 	movl   $0x8010c680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 36 4d 00 00       	call   80104e5a <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 05 11 80       	mov    0x80110590,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010017c:	e8 1f 50 00 00       	call   801051a0 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 53 88 10 80 	movl   $0x80108853,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 dc 25 00 00       	call   801027b4 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 64 88 10 80 	movl   $0x80108864,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 9f 25 00 00       	call   801027b4 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 6b 88 10 80 	movl   $0x8010886b,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010023c:	e8 fd 4e 00 00       	call   8010513e <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 05 11 80    	mov    0x80110594,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 05 11 80 	movl   $0x80110584,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 05 11 80       	mov    0x80110594,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 05 11 80       	mov    %eax,0x80110594

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 9d 4c 00 00       	call   80104f3f <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801002a9:	e8 f2 4e 00 00       	call   801051a0 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801003bb:	e8 7e 4d 00 00       	call   8010513e <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 72 88 10 80 	movl   $0x80108872,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 7b 88 10 80 	movl   $0x8010887b,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100533:	e8 68 4c 00 00       	call   801051a0 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 82 88 10 80 	movl   $0x80108882,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 91 88 10 80 	movl   $0x80108891,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 5b 4c 00 00       	call   801051ef <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 93 88 10 80 	movl   $0x80108893,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 90 10 80       	mov    0x80109000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 aa 4d 00 00       	call   80105461 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 90 10 80       	mov    0x80109000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 ac 4c 00 00       	call   80105392 <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 14 67 00 00       	call   80106e8f <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 08 67 00 00       	call   80106e8f <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 fc 66 00 00       	call   80106e8f <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 ef 66 00 00       	call   80106e8f <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 a0 07 11 80 	movl   $0x801107a0,(%esp)
801007ba:	e8 7f 49 00 00       	call   8010513e <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 fa 47 00 00       	call   80104fe9 <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 5c 08 11 80       	mov    0x8011085c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 5c 08 11 80       	mov    %eax,0x8011085c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 5c 08 11 80    	mov    0x8011085c,%edx
80100816:	a1 58 08 11 80       	mov    0x80110858,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 5c 08 11 80       	mov    0x8011085c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 d4 07 11 80 	movzbl -0x7feef82c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 5c 08 11 80    	mov    0x8011085c,%edx
80100840:	a1 58 08 11 80       	mov    0x80110858,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 5c 08 11 80       	mov    0x8011085c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 5c 08 11 80       	mov    %eax,0x8011085c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 5c 08 11 80    	mov    0x8011085c,%edx
8010087c:	a1 54 08 11 80       	mov    0x80110854,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 5c 08 11 80       	mov    0x8011085c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 5c 08 11 80    	mov    %edx,0x8011085c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 d4 07 11 80    	mov    %al,-0x7feef82c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 5c 08 11 80       	mov    0x8011085c,%eax
801008d5:	8b 15 54 08 11 80    	mov    0x80110854,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 5c 08 11 80       	mov    0x8011085c,%eax
801008e7:	a3 58 08 11 80       	mov    %eax,0x80110858
          wakeup(&input.r);
801008ec:	c7 04 24 54 08 11 80 	movl   $0x80110854,(%esp)
801008f3:	e8 47 46 00 00       	call   80104f3f <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 a0 07 11 80 	movl   $0x801107a0,(%esp)
80100914:	e8 87 48 00 00       	call   801051a0 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 8e 10 00 00       	call   801019ba <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 a0 07 11 80 	movl   $0x801107a0,(%esp)
80100939:	e8 00 48 00 00       	call   8010513e <acquire>
  while(n > 0){
8010093e:	e9 ac 00 00 00       	jmp    801009ef <consoleread+0xd4>
    while(input.r == input.w){
80100943:	eb 44                	jmp    80100989 <consoleread+0x6e>
      if(current->proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 00                	mov    (%eax),%eax
8010094d:	8b 40 60             	mov    0x60(%eax),%eax
80100950:	85 c0                	test   %eax,%eax
80100952:	74 21                	je     80100975 <consoleread+0x5a>
        release(&input.lock);
80100954:	c7 04 24 a0 07 11 80 	movl   $0x801107a0,(%esp)
8010095b:	e8 40 48 00 00       	call   801051a0 <release>
        ilock(ip);
80100960:	8b 45 08             	mov    0x8(%ebp),%eax
80100963:	89 04 24             	mov    %eax,(%esp)
80100966:	e8 01 0f 00 00       	call   8010186c <ilock>
        return -1;
8010096b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100970:	e9 a5 00 00 00       	jmp    80100a1a <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
80100975:	c7 44 24 04 a0 07 11 	movl   $0x801107a0,0x4(%esp)
8010097c:	80 
8010097d:	c7 04 24 54 08 11 80 	movl   $0x80110854,(%esp)
80100984:	e8 d1 44 00 00       	call   80104e5a <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100989:	8b 15 54 08 11 80    	mov    0x80110854,%edx
8010098f:	a1 58 08 11 80       	mov    0x80110858,%eax
80100994:	39 c2                	cmp    %eax,%edx
80100996:	74 ad                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100998:	a1 54 08 11 80       	mov    0x80110854,%eax
8010099d:	8d 50 01             	lea    0x1(%eax),%edx
801009a0:	89 15 54 08 11 80    	mov    %edx,0x80110854
801009a6:	83 e0 7f             	and    $0x7f,%eax
801009a9:	0f b6 80 d4 07 11 80 	movzbl -0x7feef82c(%eax),%eax
801009b0:	0f be c0             	movsbl %al,%eax
801009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b6:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009ba:	75 19                	jne    801009d5 <consoleread+0xba>
      if(n < target){
801009bc:	8b 45 10             	mov    0x10(%ebp),%eax
801009bf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c2:	73 0f                	jae    801009d3 <consoleread+0xb8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c4:	a1 54 08 11 80       	mov    0x80110854,%eax
801009c9:	83 e8 01             	sub    $0x1,%eax
801009cc:	a3 54 08 11 80       	mov    %eax,0x80110854
      }
      break;
801009d1:	eb 26                	jmp    801009f9 <consoleread+0xde>
801009d3:	eb 24                	jmp    801009f9 <consoleread+0xde>
    }
    *dst++ = c;
801009d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d8:	8d 50 01             	lea    0x1(%eax),%edx
801009db:	89 55 0c             	mov    %edx,0xc(%ebp)
801009de:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009e1:	88 10                	mov    %dl,(%eax)
    --n;
801009e3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009eb:	75 02                	jne    801009ef <consoleread+0xd4>
      break;
801009ed:	eb 0a                	jmp    801009f9 <consoleread+0xde>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f3:	0f 8f 4a ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009f9:	c7 04 24 a0 07 11 80 	movl   $0x801107a0,(%esp)
80100a00:	e8 9b 47 00 00       	call   801051a0 <release>
  ilock(ip);
80100a05:	8b 45 08             	mov    0x8(%ebp),%eax
80100a08:	89 04 24             	mov    %eax,(%esp)
80100a0b:	e8 5c 0e 00 00       	call   8010186c <ilock>

  return target - n;
80100a10:	8b 45 10             	mov    0x10(%ebp),%eax
80100a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a16:	29 c2                	sub    %eax,%edx
80100a18:	89 d0                	mov    %edx,%eax
}
80100a1a:	c9                   	leave  
80100a1b:	c3                   	ret    

80100a1c <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1c:	55                   	push   %ebp
80100a1d:	89 e5                	mov    %esp,%ebp
80100a1f:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a22:	8b 45 08             	mov    0x8(%ebp),%eax
80100a25:	89 04 24             	mov    %eax,(%esp)
80100a28:	e8 8d 0f 00 00       	call   801019ba <iunlock>
  acquire(&cons.lock);
80100a2d:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a34:	e8 05 47 00 00       	call   8010513e <acquire>
  for(i = 0; i < n; i++)
80100a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a40:	eb 1d                	jmp    80100a5f <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a42:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a45:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a48:	01 d0                	add    %edx,%eax
80100a4a:	0f b6 00             	movzbl (%eax),%eax
80100a4d:	0f be c0             	movsbl %al,%eax
80100a50:	0f b6 c0             	movzbl %al,%eax
80100a53:	89 04 24             	mov    %eax,(%esp)
80100a56:	e8 f5 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a5b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a62:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a65:	7c db                	jl     80100a42 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a67:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a6e:	e8 2d 47 00 00       	call   801051a0 <release>
  ilock(ip);
80100a73:	8b 45 08             	mov    0x8(%ebp),%eax
80100a76:	89 04 24             	mov    %eax,(%esp)
80100a79:	e8 ee 0d 00 00       	call   8010186c <ilock>

  return n;
80100a7e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a81:	c9                   	leave  
80100a82:	c3                   	ret    

80100a83 <consoleinit>:

void
consoleinit(void)
{
80100a83:	55                   	push   %ebp
80100a84:	89 e5                	mov    %esp,%ebp
80100a86:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a89:	c7 44 24 04 97 88 10 	movl   $0x80108897,0x4(%esp)
80100a90:	80 
80100a91:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a98:	e8 80 46 00 00       	call   8010511d <initlock>
  initlock(&input.lock, "input");
80100a9d:	c7 44 24 04 9f 88 10 	movl   $0x8010889f,0x4(%esp)
80100aa4:	80 
80100aa5:	c7 04 24 a0 07 11 80 	movl   $0x801107a0,(%esp)
80100aac:	e8 6c 46 00 00       	call   8010511d <initlock>

  devsw[CONSOLE].write = consolewrite;
80100ab1:	c7 05 0c 12 11 80 1c 	movl   $0x80100a1c,0x8011120c
80100ab8:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100abb:	c7 05 08 12 11 80 1b 	movl   $0x8010091b,0x80111208
80100ac2:	09 10 80 
  cons.locking = 1;
80100ac5:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100acc:	00 00 00 

  picenable(IRQ_KBD);
80100acf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad6:	e8 d4 32 00 00       	call   80103daf <picenable>
  ioapicenable(IRQ_KBD, 0);
80100adb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae2:	00 
80100ae3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100aea:	e8 81 1e 00 00       	call   80102970 <ioapicenable>
}
80100aef:	c9                   	leave  
80100af0:	c3                   	ret    

80100af1 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100af1:	55                   	push   %ebp
80100af2:	89 e5                	mov    %esp,%ebp
80100af4:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100afa:	e8 24 29 00 00       	call   80103423 <begin_op>
  if((ip = namei(path)) == 0){
80100aff:	8b 45 08             	mov    0x8(%ebp),%eax
80100b02:	89 04 24             	mov    %eax,(%esp)
80100b05:	e8 0f 19 00 00       	call   80102419 <namei>
80100b0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b0d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b11:	75 0f                	jne    80100b22 <exec+0x31>
    end_op();
80100b13:	e8 8f 29 00 00       	call   801034a7 <end_op>
    return -1;
80100b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1d:	e9 f7 03 00 00       	jmp    80100f19 <exec+0x428>
  }
  ilock(ip);
80100b22:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b25:	89 04 24             	mov    %eax,(%esp)
80100b28:	e8 3f 0d 00 00       	call   8010186c <ilock>
  pgdir = 0;
80100b2d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b34:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b3b:	00 
80100b3c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b43:	00 
80100b44:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b51:	89 04 24             	mov    %eax,(%esp)
80100b54:	e8 20 12 00 00       	call   80101d79 <readi>
80100b59:	83 f8 33             	cmp    $0x33,%eax
80100b5c:	77 05                	ja     80100b63 <exec+0x72>
    goto bad;
80100b5e:	e9 8a 03 00 00       	jmp    80100eed <exec+0x3fc>
  if(elf.magic != ELF_MAGIC)
80100b63:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b69:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6e:	74 05                	je     80100b75 <exec+0x84>
    goto bad;
80100b70:	e9 78 03 00 00       	jmp    80100eed <exec+0x3fc>

  if((pgdir = setupkvm()) == 0)
80100b75:	e8 66 74 00 00       	call   80107fe0 <setupkvm>
80100b7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b7d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b81:	75 05                	jne    80100b88 <exec+0x97>
    goto bad;
80100b83:	e9 65 03 00 00       	jmp    80100eed <exec+0x3fc>

  // Load program into memory.
  sz = 0;
80100b88:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b96:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b9f:	e9 cb 00 00 00       	jmp    80100c6f <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ba7:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bae:	00 
80100baf:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bb3:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bc0:	89 04 24             	mov    %eax,(%esp)
80100bc3:	e8 b1 11 00 00       	call   80101d79 <readi>
80100bc8:	83 f8 20             	cmp    $0x20,%eax
80100bcb:	74 05                	je     80100bd2 <exec+0xe1>
      goto bad;
80100bcd:	e9 1b 03 00 00       	jmp    80100eed <exec+0x3fc>
    if(ph.type != ELF_PROG_LOAD)
80100bd2:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bd8:	83 f8 01             	cmp    $0x1,%eax
80100bdb:	74 05                	je     80100be2 <exec+0xf1>
      continue;
80100bdd:	e9 80 00 00 00       	jmp    80100c62 <exec+0x171>
    if(ph.memsz < ph.filesz)
80100be2:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100be8:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bee:	39 c2                	cmp    %eax,%edx
80100bf0:	73 05                	jae    80100bf7 <exec+0x106>
      goto bad;
80100bf2:	e9 f6 02 00 00       	jmp    80100eed <exec+0x3fc>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf7:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bfd:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c03:	01 d0                	add    %edx,%eax
80100c05:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c13:	89 04 24             	mov    %eax,(%esp)
80100c16:	e8 93 77 00 00       	call   801083ae <allocuvm>
80100c1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c1e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c22:	75 05                	jne    80100c29 <exec+0x138>
      goto bad;
80100c24:	e9 c4 02 00 00       	jmp    80100eed <exec+0x3fc>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c29:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c2f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c35:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c3b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c3f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c43:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c46:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c51:	89 04 24             	mov    %eax,(%esp)
80100c54:	e8 6a 76 00 00       	call   801082c3 <loaduvm>
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	79 05                	jns    80100c62 <exec+0x171>
      goto bad;
80100c5d:	e9 8b 02 00 00       	jmp    80100eed <exec+0x3fc>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c62:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c69:	83 c0 20             	add    $0x20,%eax
80100c6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c6f:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c76:	0f b7 c0             	movzwl %ax,%eax
80100c79:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c7c:	0f 8f 22 ff ff ff    	jg     80100ba4 <exec+0xb3>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c82:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c85:	89 04 24             	mov    %eax,(%esp)
80100c88:	e8 63 0e 00 00       	call   80101af0 <iunlockput>
  end_op();
80100c8d:	e8 15 28 00 00       	call   801034a7 <end_op>
  ip = 0;
80100c92:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c99:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9c:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ca1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cac:	05 00 20 00 00       	add    $0x2000,%eax
80100cb1:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cbf:	89 04 24             	mov    %eax,(%esp)
80100cc2:	e8 e7 76 00 00       	call   801083ae <allocuvm>
80100cc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cce:	75 05                	jne    80100cd5 <exec+0x1e4>
    goto bad;
80100cd0:	e9 18 02 00 00       	jmp    80100eed <exec+0x3fc>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd8:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ce4:	89 04 24             	mov    %eax,(%esp)
80100ce7:	e8 f2 78 00 00       	call   801085de <clearpteu>
  sp = sz;
80100cec:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cef:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cf9:	e9 9a 00 00 00       	jmp    80100d98 <exec+0x2a7>
    if(argc >= MAXARG)
80100cfe:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d02:	76 05                	jbe    80100d09 <exec+0x218>
      goto bad;
80100d04:	e9 e4 01 00 00       	jmp    80100eed <exec+0x3fc>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d0c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d13:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d16:	01 d0                	add    %edx,%eax
80100d18:	8b 00                	mov    (%eax),%eax
80100d1a:	89 04 24             	mov    %eax,(%esp)
80100d1d:	e8 da 48 00 00       	call   801055fc <strlen>
80100d22:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d25:	29 c2                	sub    %eax,%edx
80100d27:	89 d0                	mov    %edx,%eax
80100d29:	83 e8 01             	sub    $0x1,%eax
80100d2c:	83 e0 fc             	and    $0xfffffffc,%eax
80100d2f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d3f:	01 d0                	add    %edx,%eax
80100d41:	8b 00                	mov    (%eax),%eax
80100d43:	89 04 24             	mov    %eax,(%esp)
80100d46:	e8 b1 48 00 00       	call   801055fc <strlen>
80100d4b:	83 c0 01             	add    $0x1,%eax
80100d4e:	89 c2                	mov    %eax,%edx
80100d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d53:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5d:	01 c8                	add    %ecx,%eax
80100d5f:	8b 00                	mov    (%eax),%eax
80100d61:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d65:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d69:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d73:	89 04 24             	mov    %eax,(%esp)
80100d76:	e8 28 7a 00 00       	call   801087a3 <copyout>
80100d7b:	85 c0                	test   %eax,%eax
80100d7d:	79 05                	jns    80100d84 <exec+0x293>
      goto bad;
80100d7f:	e9 69 01 00 00       	jmp    80100eed <exec+0x3fc>
    ustack[3+argc] = sp;
80100d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d87:	8d 50 03             	lea    0x3(%eax),%edx
80100d8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d8d:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d94:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d9b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100da2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da5:	01 d0                	add    %edx,%eax
80100da7:	8b 00                	mov    (%eax),%eax
80100da9:	85 c0                	test   %eax,%eax
80100dab:	0f 85 4d ff ff ff    	jne    80100cfe <exec+0x20d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db4:	83 c0 03             	add    $0x3,%eax
80100db7:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dbe:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dc2:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dc9:	ff ff ff 
  ustack[1] = argc;
80100dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dcf:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd8:	83 c0 01             	add    $0x1,%eax
80100ddb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de5:	29 d0                	sub    %edx,%eax
80100de7:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100ded:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df0:	83 c0 04             	add    $0x4,%eax
80100df3:	c1 e0 02             	shl    $0x2,%eax
80100df6:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100df9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfc:	83 c0 04             	add    $0x4,%eax
80100dff:	c1 e0 02             	shl    $0x2,%eax
80100e02:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e06:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e10:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e13:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e1a:	89 04 24             	mov    %eax,(%esp)
80100e1d:	e8 81 79 00 00       	call   801087a3 <copyout>
80100e22:	85 c0                	test   %eax,%eax
80100e24:	79 05                	jns    80100e2b <exec+0x33a>
    goto bad;
80100e26:	e9 c2 00 00 00       	jmp    80100eed <exec+0x3fc>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80100e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e34:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e37:	eb 17                	jmp    80100e50 <exec+0x35f>
    if(*s == '/')
80100e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e3c:	0f b6 00             	movzbl (%eax),%eax
80100e3f:	3c 2f                	cmp    $0x2f,%al
80100e41:	75 09                	jne    80100e4c <exec+0x35b>
      last = s+1;
80100e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e46:	83 c0 01             	add    $0x1,%eax
80100e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e4c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e53:	0f b6 00             	movzbl (%eax),%eax
80100e56:	84 c0                	test   %al,%al
80100e58:	75 df                	jne    80100e39 <exec+0x348>
    if(*s == '/')
      last = s+1;
  safestrcpy(current->proc->name, last, sizeof(current->proc->name));
80100e5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e60:	8b 00                	mov    (%eax),%eax
80100e62:	8d 50 50             	lea    0x50(%eax),%edx
80100e65:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e6c:	00 
80100e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e70:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e74:	89 14 24             	mov    %edx,(%esp)
80100e77:	e8 36 47 00 00       	call   801055b2 <safestrcpy>

  // Commit to the user image.
  oldpgdir = current->proc->pgdir;
80100e7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e82:	8b 00                	mov    (%eax),%eax
80100e84:	8b 40 08             	mov    0x8(%eax),%eax
80100e87:	89 45 d0             	mov    %eax,-0x30(%ebp)
  current->proc->pgdir = pgdir;
80100e8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e90:	8b 00                	mov    (%eax),%eax
80100e92:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e95:	89 50 08             	mov    %edx,0x8(%eax)
  current->proc->sz = sz;
80100e98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9e:	8b 00                	mov    (%eax),%eax
80100ea0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ea3:	89 10                	mov    %edx,(%eax)
  
  current->tf->eip = elf.entry;  // main
80100ea5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eab:	8b 40 78             	mov    0x78(%eax),%eax
80100eae:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eb4:	89 50 38             	mov    %edx,0x38(%eax)
  current->tf->esp = sp;
80100eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebd:	8b 40 78             	mov    0x78(%eax),%eax
80100ec0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ec3:	89 50 44             	mov    %edx,0x44(%eax)
  killsiblingthreads();
80100ec6:	e8 56 36 00 00       	call   80104521 <killsiblingthreads>

  switchuvm(current->proc);
80100ecb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed1:	8b 00                	mov    (%eax),%eax
80100ed3:	89 04 24             	mov    %eax,(%esp)
80100ed6:	e8 f6 71 00 00       	call   801080d1 <switchuvm>
  freevm(oldpgdir);
80100edb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ede:	89 04 24             	mov    %eax,(%esp)
80100ee1:	e8 5e 76 00 00       	call   80108544 <freevm>
  return 0;
80100ee6:	b8 00 00 00 00       	mov    $0x0,%eax
80100eeb:	eb 2c                	jmp    80100f19 <exec+0x428>

 bad:
  if(pgdir)
80100eed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ef1:	74 0b                	je     80100efe <exec+0x40d>
    freevm(pgdir);
80100ef3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ef6:	89 04 24             	mov    %eax,(%esp)
80100ef9:	e8 46 76 00 00       	call   80108544 <freevm>
  if(ip){
80100efe:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f02:	74 10                	je     80100f14 <exec+0x423>
    iunlockput(ip);
80100f04:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f07:	89 04 24             	mov    %eax,(%esp)
80100f0a:	e8 e1 0b 00 00       	call   80101af0 <iunlockput>
    end_op();
80100f0f:	e8 93 25 00 00       	call   801034a7 <end_op>
  }
  return -1;
80100f14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f19:	c9                   	leave  
80100f1a:	c3                   	ret    

80100f1b <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f1b:	55                   	push   %ebp
80100f1c:	89 e5                	mov    %esp,%ebp
80100f1e:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f21:	c7 44 24 04 a5 88 10 	movl   $0x801088a5,0x4(%esp)
80100f28:	80 
80100f29:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80100f30:	e8 e8 41 00 00       	call   8010511d <initlock>
}
80100f35:	c9                   	leave  
80100f36:	c3                   	ret    

80100f37 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f37:	55                   	push   %ebp
80100f38:	89 e5                	mov    %esp,%ebp
80100f3a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f3d:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80100f44:	e8 f5 41 00 00       	call   8010513e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f49:	c7 45 f4 94 08 11 80 	movl   $0x80110894,-0xc(%ebp)
80100f50:	eb 29                	jmp    80100f7b <filealloc+0x44>
    if(f->ref == 0){
80100f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f55:	8b 40 04             	mov    0x4(%eax),%eax
80100f58:	85 c0                	test   %eax,%eax
80100f5a:	75 1b                	jne    80100f77 <filealloc+0x40>
      f->ref = 1;
80100f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f5f:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f66:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80100f6d:	e8 2e 42 00 00       	call   801051a0 <release>
      return f;
80100f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f75:	eb 1e                	jmp    80100f95 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f77:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f7b:	81 7d f4 f4 11 11 80 	cmpl   $0x801111f4,-0xc(%ebp)
80100f82:	72 ce                	jb     80100f52 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f84:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80100f8b:	e8 10 42 00 00       	call   801051a0 <release>
  return 0;
80100f90:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f95:	c9                   	leave  
80100f96:	c3                   	ret    

80100f97 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f97:	55                   	push   %ebp
80100f98:	89 e5                	mov    %esp,%ebp
80100f9a:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f9d:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80100fa4:	e8 95 41 00 00       	call   8010513e <acquire>
  if(f->ref < 1)
80100fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80100fac:	8b 40 04             	mov    0x4(%eax),%eax
80100faf:	85 c0                	test   %eax,%eax
80100fb1:	7f 0c                	jg     80100fbf <filedup+0x28>
    panic("filedup");
80100fb3:	c7 04 24 ac 88 10 80 	movl   $0x801088ac,(%esp)
80100fba:	e8 7b f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc2:	8b 40 04             	mov    0x4(%eax),%eax
80100fc5:	8d 50 01             	lea    0x1(%eax),%edx
80100fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80100fcb:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fce:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80100fd5:	e8 c6 41 00 00       	call   801051a0 <release>
  return f;
80100fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fdd:	c9                   	leave  
80100fde:	c3                   	ret    

80100fdf <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fdf:	55                   	push   %ebp
80100fe0:	89 e5                	mov    %esp,%ebp
80100fe2:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fe5:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80100fec:	e8 4d 41 00 00       	call   8010513e <acquire>
  if(f->ref < 1)
80100ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff4:	8b 40 04             	mov    0x4(%eax),%eax
80100ff7:	85 c0                	test   %eax,%eax
80100ff9:	7f 0c                	jg     80101007 <fileclose+0x28>
    panic("fileclose");
80100ffb:	c7 04 24 b4 88 10 80 	movl   $0x801088b4,(%esp)
80101002:	e8 33 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80101007:	8b 45 08             	mov    0x8(%ebp),%eax
8010100a:	8b 40 04             	mov    0x4(%eax),%eax
8010100d:	8d 50 ff             	lea    -0x1(%eax),%edx
80101010:	8b 45 08             	mov    0x8(%ebp),%eax
80101013:	89 50 04             	mov    %edx,0x4(%eax)
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	8b 40 04             	mov    0x4(%eax),%eax
8010101c:	85 c0                	test   %eax,%eax
8010101e:	7e 11                	jle    80101031 <fileclose+0x52>
    release(&ftable.lock);
80101020:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80101027:	e8 74 41 00 00       	call   801051a0 <release>
8010102c:	e9 82 00 00 00       	jmp    801010b3 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101031:	8b 45 08             	mov    0x8(%ebp),%eax
80101034:	8b 10                	mov    (%eax),%edx
80101036:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101039:	8b 50 04             	mov    0x4(%eax),%edx
8010103c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010103f:	8b 50 08             	mov    0x8(%eax),%edx
80101042:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101045:	8b 50 0c             	mov    0xc(%eax),%edx
80101048:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010104b:	8b 50 10             	mov    0x10(%eax),%edx
8010104e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101051:	8b 40 14             	mov    0x14(%eax),%eax
80101054:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101057:	8b 45 08             	mov    0x8(%ebp),%eax
8010105a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101061:	8b 45 08             	mov    0x8(%ebp),%eax
80101064:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010106a:	c7 04 24 60 08 11 80 	movl   $0x80110860,(%esp)
80101071:	e8 2a 41 00 00       	call   801051a0 <release>
  
  if(ff.type == FD_PIPE)
80101076:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101079:	83 f8 01             	cmp    $0x1,%eax
8010107c:	75 18                	jne    80101096 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010107e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101082:	0f be d0             	movsbl %al,%edx
80101085:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101088:	89 54 24 04          	mov    %edx,0x4(%esp)
8010108c:	89 04 24             	mov    %eax,(%esp)
8010108f:	e8 cb 2f 00 00       	call   8010405f <pipeclose>
80101094:	eb 1d                	jmp    801010b3 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101096:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101099:	83 f8 02             	cmp    $0x2,%eax
8010109c:	75 15                	jne    801010b3 <fileclose+0xd4>
    begin_op();
8010109e:	e8 80 23 00 00       	call   80103423 <begin_op>
    iput(ff.ip);
801010a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010a6:	89 04 24             	mov    %eax,(%esp)
801010a9:	e8 71 09 00 00       	call   80101a1f <iput>
    end_op();
801010ae:	e8 f4 23 00 00       	call   801034a7 <end_op>
  }
}
801010b3:	c9                   	leave  
801010b4:	c3                   	ret    

801010b5 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010b5:	55                   	push   %ebp
801010b6:	89 e5                	mov    %esp,%ebp
801010b8:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010bb:	8b 45 08             	mov    0x8(%ebp),%eax
801010be:	8b 00                	mov    (%eax),%eax
801010c0:	83 f8 02             	cmp    $0x2,%eax
801010c3:	75 38                	jne    801010fd <filestat+0x48>
    ilock(f->ip);
801010c5:	8b 45 08             	mov    0x8(%ebp),%eax
801010c8:	8b 40 10             	mov    0x10(%eax),%eax
801010cb:	89 04 24             	mov    %eax,(%esp)
801010ce:	e8 99 07 00 00       	call   8010186c <ilock>
    stati(f->ip, st);
801010d3:	8b 45 08             	mov    0x8(%ebp),%eax
801010d6:	8b 40 10             	mov    0x10(%eax),%eax
801010d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801010dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801010e0:	89 04 24             	mov    %eax,(%esp)
801010e3:	e8 4c 0c 00 00       	call   80101d34 <stati>
    iunlock(f->ip);
801010e8:	8b 45 08             	mov    0x8(%ebp),%eax
801010eb:	8b 40 10             	mov    0x10(%eax),%eax
801010ee:	89 04 24             	mov    %eax,(%esp)
801010f1:	e8 c4 08 00 00       	call   801019ba <iunlock>
    return 0;
801010f6:	b8 00 00 00 00       	mov    $0x0,%eax
801010fb:	eb 05                	jmp    80101102 <filestat+0x4d>
  }
  return -1;
801010fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101102:	c9                   	leave  
80101103:	c3                   	ret    

80101104 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101104:	55                   	push   %ebp
80101105:	89 e5                	mov    %esp,%ebp
80101107:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010110a:	8b 45 08             	mov    0x8(%ebp),%eax
8010110d:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101111:	84 c0                	test   %al,%al
80101113:	75 0a                	jne    8010111f <fileread+0x1b>
    return -1;
80101115:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010111a:	e9 9f 00 00 00       	jmp    801011be <fileread+0xba>
  if(f->type == FD_PIPE)
8010111f:	8b 45 08             	mov    0x8(%ebp),%eax
80101122:	8b 00                	mov    (%eax),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	75 1e                	jne    80101147 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101129:	8b 45 08             	mov    0x8(%ebp),%eax
8010112c:	8b 40 0c             	mov    0xc(%eax),%eax
8010112f:	8b 55 10             	mov    0x10(%ebp),%edx
80101132:	89 54 24 08          	mov    %edx,0x8(%esp)
80101136:	8b 55 0c             	mov    0xc(%ebp),%edx
80101139:	89 54 24 04          	mov    %edx,0x4(%esp)
8010113d:	89 04 24             	mov    %eax,(%esp)
80101140:	e8 9d 30 00 00       	call   801041e2 <piperead>
80101145:	eb 77                	jmp    801011be <fileread+0xba>
  if(f->type == FD_INODE){
80101147:	8b 45 08             	mov    0x8(%ebp),%eax
8010114a:	8b 00                	mov    (%eax),%eax
8010114c:	83 f8 02             	cmp    $0x2,%eax
8010114f:	75 61                	jne    801011b2 <fileread+0xae>
    ilock(f->ip);
80101151:	8b 45 08             	mov    0x8(%ebp),%eax
80101154:	8b 40 10             	mov    0x10(%eax),%eax
80101157:	89 04 24             	mov    %eax,(%esp)
8010115a:	e8 0d 07 00 00       	call   8010186c <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010115f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101162:	8b 45 08             	mov    0x8(%ebp),%eax
80101165:	8b 50 14             	mov    0x14(%eax),%edx
80101168:	8b 45 08             	mov    0x8(%ebp),%eax
8010116b:	8b 40 10             	mov    0x10(%eax),%eax
8010116e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101172:	89 54 24 08          	mov    %edx,0x8(%esp)
80101176:	8b 55 0c             	mov    0xc(%ebp),%edx
80101179:	89 54 24 04          	mov    %edx,0x4(%esp)
8010117d:	89 04 24             	mov    %eax,(%esp)
80101180:	e8 f4 0b 00 00       	call   80101d79 <readi>
80101185:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101188:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010118c:	7e 11                	jle    8010119f <fileread+0x9b>
      f->off += r;
8010118e:	8b 45 08             	mov    0x8(%ebp),%eax
80101191:	8b 50 14             	mov    0x14(%eax),%edx
80101194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101197:	01 c2                	add    %eax,%edx
80101199:	8b 45 08             	mov    0x8(%ebp),%eax
8010119c:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010119f:	8b 45 08             	mov    0x8(%ebp),%eax
801011a2:	8b 40 10             	mov    0x10(%eax),%eax
801011a5:	89 04 24             	mov    %eax,(%esp)
801011a8:	e8 0d 08 00 00       	call   801019ba <iunlock>
    return r;
801011ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011b0:	eb 0c                	jmp    801011be <fileread+0xba>
  }
  panic("fileread");
801011b2:	c7 04 24 be 88 10 80 	movl   $0x801088be,(%esp)
801011b9:	e8 7c f3 ff ff       	call   8010053a <panic>
}
801011be:	c9                   	leave  
801011bf:	c3                   	ret    

801011c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	53                   	push   %ebx
801011c4:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011c7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ca:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011ce:	84 c0                	test   %al,%al
801011d0:	75 0a                	jne    801011dc <filewrite+0x1c>
    return -1;
801011d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011d7:	e9 20 01 00 00       	jmp    801012fc <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011dc:	8b 45 08             	mov    0x8(%ebp),%eax
801011df:	8b 00                	mov    (%eax),%eax
801011e1:	83 f8 01             	cmp    $0x1,%eax
801011e4:	75 21                	jne    80101207 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011e6:	8b 45 08             	mov    0x8(%ebp),%eax
801011e9:	8b 40 0c             	mov    0xc(%eax),%eax
801011ec:	8b 55 10             	mov    0x10(%ebp),%edx
801011ef:	89 54 24 08          	mov    %edx,0x8(%esp)
801011f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801011f6:	89 54 24 04          	mov    %edx,0x4(%esp)
801011fa:	89 04 24             	mov    %eax,(%esp)
801011fd:	e8 ef 2e 00 00       	call   801040f1 <pipewrite>
80101202:	e9 f5 00 00 00       	jmp    801012fc <filewrite+0x13c>
  if(f->type == FD_INODE){
80101207:	8b 45 08             	mov    0x8(%ebp),%eax
8010120a:	8b 00                	mov    (%eax),%eax
8010120c:	83 f8 02             	cmp    $0x2,%eax
8010120f:	0f 85 db 00 00 00    	jne    801012f0 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101215:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010121c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101223:	e9 a8 00 00 00       	jmp    801012d0 <filewrite+0x110>
      int n1 = n - i;
80101228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010122b:	8b 55 10             	mov    0x10(%ebp),%edx
8010122e:	29 c2                	sub    %eax,%edx
80101230:	89 d0                	mov    %edx,%eax
80101232:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101235:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101238:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010123b:	7e 06                	jle    80101243 <filewrite+0x83>
        n1 = max;
8010123d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101240:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101243:	e8 db 21 00 00       	call   80103423 <begin_op>
      ilock(f->ip);
80101248:	8b 45 08             	mov    0x8(%ebp),%eax
8010124b:	8b 40 10             	mov    0x10(%eax),%eax
8010124e:	89 04 24             	mov    %eax,(%esp)
80101251:	e8 16 06 00 00       	call   8010186c <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101256:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101259:	8b 45 08             	mov    0x8(%ebp),%eax
8010125c:	8b 50 14             	mov    0x14(%eax),%edx
8010125f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101262:	8b 45 0c             	mov    0xc(%ebp),%eax
80101265:	01 c3                	add    %eax,%ebx
80101267:	8b 45 08             	mov    0x8(%ebp),%eax
8010126a:	8b 40 10             	mov    0x10(%eax),%eax
8010126d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101271:	89 54 24 08          	mov    %edx,0x8(%esp)
80101275:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101279:	89 04 24             	mov    %eax,(%esp)
8010127c:	e8 5c 0c 00 00       	call   80101edd <writei>
80101281:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101284:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101288:	7e 11                	jle    8010129b <filewrite+0xdb>
        f->off += r;
8010128a:	8b 45 08             	mov    0x8(%ebp),%eax
8010128d:	8b 50 14             	mov    0x14(%eax),%edx
80101290:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101293:	01 c2                	add    %eax,%edx
80101295:	8b 45 08             	mov    0x8(%ebp),%eax
80101298:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010129b:	8b 45 08             	mov    0x8(%ebp),%eax
8010129e:	8b 40 10             	mov    0x10(%eax),%eax
801012a1:	89 04 24             	mov    %eax,(%esp)
801012a4:	e8 11 07 00 00       	call   801019ba <iunlock>
      end_op();
801012a9:	e8 f9 21 00 00       	call   801034a7 <end_op>

      if(r < 0)
801012ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012b2:	79 02                	jns    801012b6 <filewrite+0xf6>
        break;
801012b4:	eb 26                	jmp    801012dc <filewrite+0x11c>
      if(r != n1)
801012b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012bc:	74 0c                	je     801012ca <filewrite+0x10a>
        panic("short filewrite");
801012be:	c7 04 24 c7 88 10 80 	movl   $0x801088c7,(%esp)
801012c5:	e8 70 f2 ff ff       	call   8010053a <panic>
      i += r;
801012ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012cd:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d3:	3b 45 10             	cmp    0x10(%ebp),%eax
801012d6:	0f 8c 4c ff ff ff    	jl     80101228 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012df:	3b 45 10             	cmp    0x10(%ebp),%eax
801012e2:	75 05                	jne    801012e9 <filewrite+0x129>
801012e4:	8b 45 10             	mov    0x10(%ebp),%eax
801012e7:	eb 05                	jmp    801012ee <filewrite+0x12e>
801012e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012ee:	eb 0c                	jmp    801012fc <filewrite+0x13c>
  }
  panic("filewrite");
801012f0:	c7 04 24 d7 88 10 80 	movl   $0x801088d7,(%esp)
801012f7:	e8 3e f2 ff ff       	call   8010053a <panic>
}
801012fc:	83 c4 24             	add    $0x24,%esp
801012ff:	5b                   	pop    %ebx
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    

80101302 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101302:	55                   	push   %ebp
80101303:	89 e5                	mov    %esp,%ebp
80101305:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101308:	8b 45 08             	mov    0x8(%ebp),%eax
8010130b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101312:	00 
80101313:	89 04 24             	mov    %eax,(%esp)
80101316:	e8 8b ee ff ff       	call   801001a6 <bread>
8010131b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010131e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101321:	83 c0 18             	add    $0x18,%eax
80101324:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010132b:	00 
8010132c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101330:	8b 45 0c             	mov    0xc(%ebp),%eax
80101333:	89 04 24             	mov    %eax,(%esp)
80101336:	e8 26 41 00 00       	call   80105461 <memmove>
  brelse(bp);
8010133b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010133e:	89 04 24             	mov    %eax,(%esp)
80101341:	e8 d1 ee ff ff       	call   80100217 <brelse>
}
80101346:	c9                   	leave  
80101347:	c3                   	ret    

80101348 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101348:	55                   	push   %ebp
80101349:	89 e5                	mov    %esp,%ebp
8010134b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010134e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101351:	8b 45 08             	mov    0x8(%ebp),%eax
80101354:	89 54 24 04          	mov    %edx,0x4(%esp)
80101358:	89 04 24             	mov    %eax,(%esp)
8010135b:	e8 46 ee ff ff       	call   801001a6 <bread>
80101360:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101366:	83 c0 18             	add    $0x18,%eax
80101369:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101370:	00 
80101371:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101378:	00 
80101379:	89 04 24             	mov    %eax,(%esp)
8010137c:	e8 11 40 00 00       	call   80105392 <memset>
  log_write(bp);
80101381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101384:	89 04 24             	mov    %eax,(%esp)
80101387:	e8 a2 22 00 00       	call   8010362e <log_write>
  brelse(bp);
8010138c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138f:	89 04 24             	mov    %eax,(%esp)
80101392:	e8 80 ee ff ff       	call   80100217 <brelse>
}
80101397:	c9                   	leave  
80101398:	c3                   	ret    

80101399 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101399:	55                   	push   %ebp
8010139a:	89 e5                	mov    %esp,%ebp
8010139c:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
8010139f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013a6:	8b 45 08             	mov    0x8(%ebp),%eax
801013a9:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013ac:	89 54 24 04          	mov    %edx,0x4(%esp)
801013b0:	89 04 24             	mov    %eax,(%esp)
801013b3:	e8 4a ff ff ff       	call   80101302 <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013bf:	e9 07 01 00 00       	jmp    801014cb <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c7:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013cd:	85 c0                	test   %eax,%eax
801013cf:	0f 48 c2             	cmovs  %edx,%eax
801013d2:	c1 f8 0c             	sar    $0xc,%eax
801013d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013d8:	c1 ea 03             	shr    $0x3,%edx
801013db:	01 d0                	add    %edx,%eax
801013dd:	83 c0 03             	add    $0x3,%eax
801013e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801013e4:	8b 45 08             	mov    0x8(%ebp),%eax
801013e7:	89 04 24             	mov    %eax,(%esp)
801013ea:	e8 b7 ed ff ff       	call   801001a6 <bread>
801013ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013f9:	e9 9d 00 00 00       	jmp    8010149b <balloc+0x102>
      m = 1 << (bi % 8);
801013fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101401:	99                   	cltd   
80101402:	c1 ea 1d             	shr    $0x1d,%edx
80101405:	01 d0                	add    %edx,%eax
80101407:	83 e0 07             	and    $0x7,%eax
8010140a:	29 d0                	sub    %edx,%eax
8010140c:	ba 01 00 00 00       	mov    $0x1,%edx
80101411:	89 c1                	mov    %eax,%ecx
80101413:	d3 e2                	shl    %cl,%edx
80101415:	89 d0                	mov    %edx,%eax
80101417:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010141d:	8d 50 07             	lea    0x7(%eax),%edx
80101420:	85 c0                	test   %eax,%eax
80101422:	0f 48 c2             	cmovs  %edx,%eax
80101425:	c1 f8 03             	sar    $0x3,%eax
80101428:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010142b:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101430:	0f b6 c0             	movzbl %al,%eax
80101433:	23 45 e8             	and    -0x18(%ebp),%eax
80101436:	85 c0                	test   %eax,%eax
80101438:	75 5d                	jne    80101497 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
8010143a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010143d:	8d 50 07             	lea    0x7(%eax),%edx
80101440:	85 c0                	test   %eax,%eax
80101442:	0f 48 c2             	cmovs  %edx,%eax
80101445:	c1 f8 03             	sar    $0x3,%eax
80101448:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010144b:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101450:	89 d1                	mov    %edx,%ecx
80101452:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101455:	09 ca                	or     %ecx,%edx
80101457:	89 d1                	mov    %edx,%ecx
80101459:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010145c:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101460:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101463:	89 04 24             	mov    %eax,(%esp)
80101466:	e8 c3 21 00 00       	call   8010362e <log_write>
        brelse(bp);
8010146b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010146e:	89 04 24             	mov    %eax,(%esp)
80101471:	e8 a1 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101476:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101479:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010147c:	01 c2                	add    %eax,%edx
8010147e:	8b 45 08             	mov    0x8(%ebp),%eax
80101481:	89 54 24 04          	mov    %edx,0x4(%esp)
80101485:	89 04 24             	mov    %eax,(%esp)
80101488:	e8 bb fe ff ff       	call   80101348 <bzero>
        return b + bi;
8010148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101490:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101493:	01 d0                	add    %edx,%eax
80101495:	eb 4e                	jmp    801014e5 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101497:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010149b:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014a2:	7f 15                	jg     801014b9 <balloc+0x120>
801014a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014aa:	01 d0                	add    %edx,%eax
801014ac:	89 c2                	mov    %eax,%edx
801014ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014b1:	39 c2                	cmp    %eax,%edx
801014b3:	0f 82 45 ff ff ff    	jb     801013fe <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014bc:	89 04 24             	mov    %eax,(%esp)
801014bf:	e8 53 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014c4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014d1:	39 c2                	cmp    %eax,%edx
801014d3:	0f 82 eb fe ff ff    	jb     801013c4 <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014d9:	c7 04 24 e1 88 10 80 	movl   $0x801088e1,(%esp)
801014e0:	e8 55 f0 ff ff       	call   8010053a <panic>
}
801014e5:	c9                   	leave  
801014e6:	c3                   	ret    

801014e7 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014e7:	55                   	push   %ebp
801014e8:	89 e5                	mov    %esp,%ebp
801014ea:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014ed:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f4:	8b 45 08             	mov    0x8(%ebp),%eax
801014f7:	89 04 24             	mov    %eax,(%esp)
801014fa:	e8 03 fe ff ff       	call   80101302 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80101502:	c1 e8 0c             	shr    $0xc,%eax
80101505:	89 c2                	mov    %eax,%edx
80101507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010150a:	c1 e8 03             	shr    $0x3,%eax
8010150d:	01 d0                	add    %edx,%eax
8010150f:	8d 50 03             	lea    0x3(%eax),%edx
80101512:	8b 45 08             	mov    0x8(%ebp),%eax
80101515:	89 54 24 04          	mov    %edx,0x4(%esp)
80101519:	89 04 24             	mov    %eax,(%esp)
8010151c:	e8 85 ec ff ff       	call   801001a6 <bread>
80101521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101524:	8b 45 0c             	mov    0xc(%ebp),%eax
80101527:	25 ff 0f 00 00       	and    $0xfff,%eax
8010152c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010152f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101532:	99                   	cltd   
80101533:	c1 ea 1d             	shr    $0x1d,%edx
80101536:	01 d0                	add    %edx,%eax
80101538:	83 e0 07             	and    $0x7,%eax
8010153b:	29 d0                	sub    %edx,%eax
8010153d:	ba 01 00 00 00       	mov    $0x1,%edx
80101542:	89 c1                	mov    %eax,%ecx
80101544:	d3 e2                	shl    %cl,%edx
80101546:	89 d0                	mov    %edx,%eax
80101548:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010154b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154e:	8d 50 07             	lea    0x7(%eax),%edx
80101551:	85 c0                	test   %eax,%eax
80101553:	0f 48 c2             	cmovs  %edx,%eax
80101556:	c1 f8 03             	sar    $0x3,%eax
80101559:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010155c:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101561:	0f b6 c0             	movzbl %al,%eax
80101564:	23 45 ec             	and    -0x14(%ebp),%eax
80101567:	85 c0                	test   %eax,%eax
80101569:	75 0c                	jne    80101577 <bfree+0x90>
    panic("freeing free block");
8010156b:	c7 04 24 f7 88 10 80 	movl   $0x801088f7,(%esp)
80101572:	e8 c3 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101577:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010157a:	8d 50 07             	lea    0x7(%eax),%edx
8010157d:	85 c0                	test   %eax,%eax
8010157f:	0f 48 c2             	cmovs  %edx,%eax
80101582:	c1 f8 03             	sar    $0x3,%eax
80101585:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101588:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010158d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80101590:	f7 d1                	not    %ecx
80101592:	21 ca                	and    %ecx,%edx
80101594:	89 d1                	mov    %edx,%ecx
80101596:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101599:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a0:	89 04 24             	mov    %eax,(%esp)
801015a3:	e8 86 20 00 00       	call   8010362e <log_write>
  brelse(bp);
801015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ab:	89 04 24             	mov    %eax,(%esp)
801015ae:	e8 64 ec ff ff       	call   80100217 <brelse>
}
801015b3:	c9                   	leave  
801015b4:	c3                   	ret    

801015b5 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015b5:	55                   	push   %ebp
801015b6:	89 e5                	mov    %esp,%ebp
801015b8:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015bb:	c7 44 24 04 0a 89 10 	movl   $0x8010890a,0x4(%esp)
801015c2:	80 
801015c3:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
801015ca:	e8 4e 3b 00 00       	call   8010511d <initlock>
}
801015cf:	c9                   	leave  
801015d0:	c3                   	ret    

801015d1 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015d1:	55                   	push   %ebp
801015d2:	89 e5                	mov    %esp,%ebp
801015d4:	83 ec 38             	sub    $0x38,%esp
801015d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801015da:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015de:	8b 45 08             	mov    0x8(%ebp),%eax
801015e1:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015e4:	89 54 24 04          	mov    %edx,0x4(%esp)
801015e8:	89 04 24             	mov    %eax,(%esp)
801015eb:	e8 12 fd ff ff       	call   80101302 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015f7:	e9 98 00 00 00       	jmp    80101694 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ff:	c1 e8 03             	shr    $0x3,%eax
80101602:	83 c0 02             	add    $0x2,%eax
80101605:	89 44 24 04          	mov    %eax,0x4(%esp)
80101609:	8b 45 08             	mov    0x8(%ebp),%eax
8010160c:	89 04 24             	mov    %eax,(%esp)
8010160f:	e8 92 eb ff ff       	call   801001a6 <bread>
80101614:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101617:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010161a:	8d 50 18             	lea    0x18(%eax),%edx
8010161d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101620:	83 e0 07             	and    $0x7,%eax
80101623:	c1 e0 06             	shl    $0x6,%eax
80101626:	01 d0                	add    %edx,%eax
80101628:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010162b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010162e:	0f b7 00             	movzwl (%eax),%eax
80101631:	66 85 c0             	test   %ax,%ax
80101634:	75 4f                	jne    80101685 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101636:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010163d:	00 
8010163e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101645:	00 
80101646:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101649:	89 04 24             	mov    %eax,(%esp)
8010164c:	e8 41 3d 00 00       	call   80105392 <memset>
      dip->type = type;
80101651:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101654:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101658:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010165b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165e:	89 04 24             	mov    %eax,(%esp)
80101661:	e8 c8 1f 00 00       	call   8010362e <log_write>
      brelse(bp);
80101666:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101669:	89 04 24             	mov    %eax,(%esp)
8010166c:	e8 a6 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
80101671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101674:	89 44 24 04          	mov    %eax,0x4(%esp)
80101678:	8b 45 08             	mov    0x8(%ebp),%eax
8010167b:	89 04 24             	mov    %eax,(%esp)
8010167e:	e8 e5 00 00 00       	call   80101768 <iget>
80101683:	eb 29                	jmp    801016ae <ialloc+0xdd>
    }
    brelse(bp);
80101685:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101688:	89 04 24             	mov    %eax,(%esp)
8010168b:	e8 87 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
80101690:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101694:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010169a:	39 c2                	cmp    %eax,%edx
8010169c:	0f 82 5a ff ff ff    	jb     801015fc <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016a2:	c7 04 24 11 89 10 80 	movl   $0x80108911,(%esp)
801016a9:	e8 8c ee ff ff       	call   8010053a <panic>
}
801016ae:	c9                   	leave  
801016af:	c3                   	ret    

801016b0 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016b6:	8b 45 08             	mov    0x8(%ebp),%eax
801016b9:	8b 40 04             	mov    0x4(%eax),%eax
801016bc:	c1 e8 03             	shr    $0x3,%eax
801016bf:	8d 50 02             	lea    0x2(%eax),%edx
801016c2:	8b 45 08             	mov    0x8(%ebp),%eax
801016c5:	8b 00                	mov    (%eax),%eax
801016c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801016cb:	89 04 24             	mov    %eax,(%esp)
801016ce:	e8 d3 ea ff ff       	call   801001a6 <bread>
801016d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d9:	8d 50 18             	lea    0x18(%eax),%edx
801016dc:	8b 45 08             	mov    0x8(%ebp),%eax
801016df:	8b 40 04             	mov    0x4(%eax),%eax
801016e2:	83 e0 07             	and    $0x7,%eax
801016e5:	c1 e0 06             	shl    $0x6,%eax
801016e8:	01 d0                	add    %edx,%eax
801016ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016ed:	8b 45 08             	mov    0x8(%ebp),%eax
801016f0:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f7:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016fa:	8b 45 08             	mov    0x8(%ebp),%eax
801016fd:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101701:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101704:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101708:	8b 45 08             	mov    0x8(%ebp),%eax
8010170b:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010170f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101712:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101716:	8b 45 08             	mov    0x8(%ebp),%eax
80101719:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101720:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101724:	8b 45 08             	mov    0x8(%ebp),%eax
80101727:	8b 50 18             	mov    0x18(%eax),%edx
8010172a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010172d:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	8b 45 08             	mov    0x8(%ebp),%eax
80101733:	8d 50 1c             	lea    0x1c(%eax),%edx
80101736:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101739:	83 c0 0c             	add    $0xc,%eax
8010173c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101743:	00 
80101744:	89 54 24 04          	mov    %edx,0x4(%esp)
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 11 3d 00 00       	call   80105461 <memmove>
  log_write(bp);
80101750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101753:	89 04 24             	mov    %eax,(%esp)
80101756:	e8 d3 1e 00 00       	call   8010362e <log_write>
  brelse(bp);
8010175b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175e:	89 04 24             	mov    %eax,(%esp)
80101761:	e8 b1 ea ff ff       	call   80100217 <brelse>
}
80101766:	c9                   	leave  
80101767:	c3                   	ret    

80101768 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101768:	55                   	push   %ebp
80101769:	89 e5                	mov    %esp,%ebp
8010176b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010176e:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101775:	e8 c4 39 00 00       	call   8010513e <acquire>

  // Is the inode already cached?
  empty = 0;
8010177a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101781:	c7 45 f4 94 12 11 80 	movl   $0x80111294,-0xc(%ebp)
80101788:	eb 59                	jmp    801017e3 <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010178a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178d:	8b 40 08             	mov    0x8(%eax),%eax
80101790:	85 c0                	test   %eax,%eax
80101792:	7e 35                	jle    801017c9 <iget+0x61>
80101794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101797:	8b 00                	mov    (%eax),%eax
80101799:	3b 45 08             	cmp    0x8(%ebp),%eax
8010179c:	75 2b                	jne    801017c9 <iget+0x61>
8010179e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a1:	8b 40 04             	mov    0x4(%eax),%eax
801017a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017a7:	75 20                	jne    801017c9 <iget+0x61>
      ip->ref++;
801017a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ac:	8b 40 08             	mov    0x8(%eax),%eax
801017af:	8d 50 01             	lea    0x1(%eax),%edx
801017b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b5:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017b8:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
801017bf:	e8 dc 39 00 00       	call   801051a0 <release>
      return ip;
801017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c7:	eb 6f                	jmp    80101838 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017cd:	75 10                	jne    801017df <iget+0x77>
801017cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d2:	8b 40 08             	mov    0x8(%eax),%eax
801017d5:	85 c0                	test   %eax,%eax
801017d7:	75 06                	jne    801017df <iget+0x77>
      empty = ip;
801017d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017df:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017e3:	81 7d f4 34 22 11 80 	cmpl   $0x80112234,-0xc(%ebp)
801017ea:	72 9e                	jb     8010178a <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017f0:	75 0c                	jne    801017fe <iget+0x96>
    panic("iget: no inodes");
801017f2:	c7 04 24 23 89 10 80 	movl   $0x80108923,(%esp)
801017f9:	e8 3c ed ff ff       	call   8010053a <panic>

  ip = empty;
801017fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101801:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101807:	8b 55 08             	mov    0x8(%ebp),%edx
8010180a:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010180c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101812:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101818:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010181f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101822:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101829:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101830:	e8 6b 39 00 00       	call   801051a0 <release>

  return ip;
80101835:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101838:	c9                   	leave  
80101839:	c3                   	ret    

8010183a <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010183a:	55                   	push   %ebp
8010183b:	89 e5                	mov    %esp,%ebp
8010183d:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101840:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101847:	e8 f2 38 00 00       	call   8010513e <acquire>
  ip->ref++;
8010184c:	8b 45 08             	mov    0x8(%ebp),%eax
8010184f:	8b 40 08             	mov    0x8(%eax),%eax
80101852:	8d 50 01             	lea    0x1(%eax),%edx
80101855:	8b 45 08             	mov    0x8(%ebp),%eax
80101858:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010185b:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101862:	e8 39 39 00 00       	call   801051a0 <release>
  return ip;
80101867:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010186a:	c9                   	leave  
8010186b:	c3                   	ret    

8010186c <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010186c:	55                   	push   %ebp
8010186d:	89 e5                	mov    %esp,%ebp
8010186f:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101872:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101876:	74 0a                	je     80101882 <ilock+0x16>
80101878:	8b 45 08             	mov    0x8(%ebp),%eax
8010187b:	8b 40 08             	mov    0x8(%eax),%eax
8010187e:	85 c0                	test   %eax,%eax
80101880:	7f 0c                	jg     8010188e <ilock+0x22>
    panic("ilock");
80101882:	c7 04 24 33 89 10 80 	movl   $0x80108933,(%esp)
80101889:	e8 ac ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
8010188e:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101895:	e8 a4 38 00 00       	call   8010513e <acquire>
  while(ip->flags & I_BUSY)
8010189a:	eb 13                	jmp    801018af <ilock+0x43>
    sleep(ip, &icache.lock);
8010189c:	c7 44 24 04 60 12 11 	movl   $0x80111260,0x4(%esp)
801018a3:	80 
801018a4:	8b 45 08             	mov    0x8(%ebp),%eax
801018a7:	89 04 24             	mov    %eax,(%esp)
801018aa:	e8 ab 35 00 00       	call   80104e5a <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018af:	8b 45 08             	mov    0x8(%ebp),%eax
801018b2:	8b 40 0c             	mov    0xc(%eax),%eax
801018b5:	83 e0 01             	and    $0x1,%eax
801018b8:	85 c0                	test   %eax,%eax
801018ba:	75 e0                	jne    8010189c <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018bc:	8b 45 08             	mov    0x8(%ebp),%eax
801018bf:	8b 40 0c             	mov    0xc(%eax),%eax
801018c2:	83 c8 01             	or     $0x1,%eax
801018c5:	89 c2                	mov    %eax,%edx
801018c7:	8b 45 08             	mov    0x8(%ebp),%eax
801018ca:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018cd:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
801018d4:	e8 c7 38 00 00       	call   801051a0 <release>

  if(!(ip->flags & I_VALID)){
801018d9:	8b 45 08             	mov    0x8(%ebp),%eax
801018dc:	8b 40 0c             	mov    0xc(%eax),%eax
801018df:	83 e0 02             	and    $0x2,%eax
801018e2:	85 c0                	test   %eax,%eax
801018e4:	0f 85 ce 00 00 00    	jne    801019b8 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018ea:	8b 45 08             	mov    0x8(%ebp),%eax
801018ed:	8b 40 04             	mov    0x4(%eax),%eax
801018f0:	c1 e8 03             	shr    $0x3,%eax
801018f3:	8d 50 02             	lea    0x2(%eax),%edx
801018f6:	8b 45 08             	mov    0x8(%ebp),%eax
801018f9:	8b 00                	mov    (%eax),%eax
801018fb:	89 54 24 04          	mov    %edx,0x4(%esp)
801018ff:	89 04 24             	mov    %eax,(%esp)
80101902:	e8 9f e8 ff ff       	call   801001a6 <bread>
80101907:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190d:	8d 50 18             	lea    0x18(%eax),%edx
80101910:	8b 45 08             	mov    0x8(%ebp),%eax
80101913:	8b 40 04             	mov    0x4(%eax),%eax
80101916:	83 e0 07             	and    $0x7,%eax
80101919:	c1 e0 06             	shl    $0x6,%eax
8010191c:	01 d0                	add    %edx,%eax
8010191e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101921:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101924:	0f b7 10             	movzwl (%eax),%edx
80101927:	8b 45 08             	mov    0x8(%ebp),%eax
8010192a:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010192e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101931:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101935:	8b 45 08             	mov    0x8(%ebp),%eax
80101938:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010193c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193f:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101943:	8b 45 08             	mov    0x8(%ebp),%eax
80101946:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
8010194a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194d:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101951:	8b 45 08             	mov    0x8(%ebp),%eax
80101954:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101958:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010195b:	8b 50 08             	mov    0x8(%eax),%edx
8010195e:	8b 45 08             	mov    0x8(%ebp),%eax
80101961:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101964:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101967:	8d 50 0c             	lea    0xc(%eax),%edx
8010196a:	8b 45 08             	mov    0x8(%ebp),%eax
8010196d:	83 c0 1c             	add    $0x1c,%eax
80101970:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101977:	00 
80101978:	89 54 24 04          	mov    %edx,0x4(%esp)
8010197c:	89 04 24             	mov    %eax,(%esp)
8010197f:	e8 dd 3a 00 00       	call   80105461 <memmove>
    brelse(bp);
80101984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101987:	89 04 24             	mov    %eax,(%esp)
8010198a:	e8 88 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
8010198f:	8b 45 08             	mov    0x8(%ebp),%eax
80101992:	8b 40 0c             	mov    0xc(%eax),%eax
80101995:	83 c8 02             	or     $0x2,%eax
80101998:	89 c2                	mov    %eax,%edx
8010199a:	8b 45 08             	mov    0x8(%ebp),%eax
8010199d:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019a0:	8b 45 08             	mov    0x8(%ebp),%eax
801019a3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019a7:	66 85 c0             	test   %ax,%ax
801019aa:	75 0c                	jne    801019b8 <ilock+0x14c>
      panic("ilock: no type");
801019ac:	c7 04 24 39 89 10 80 	movl   $0x80108939,(%esp)
801019b3:	e8 82 eb ff ff       	call   8010053a <panic>
  }
}
801019b8:	c9                   	leave  
801019b9:	c3                   	ret    

801019ba <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019ba:	55                   	push   %ebp
801019bb:	89 e5                	mov    %esp,%ebp
801019bd:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019c4:	74 17                	je     801019dd <iunlock+0x23>
801019c6:	8b 45 08             	mov    0x8(%ebp),%eax
801019c9:	8b 40 0c             	mov    0xc(%eax),%eax
801019cc:	83 e0 01             	and    $0x1,%eax
801019cf:	85 c0                	test   %eax,%eax
801019d1:	74 0a                	je     801019dd <iunlock+0x23>
801019d3:	8b 45 08             	mov    0x8(%ebp),%eax
801019d6:	8b 40 08             	mov    0x8(%eax),%eax
801019d9:	85 c0                	test   %eax,%eax
801019db:	7f 0c                	jg     801019e9 <iunlock+0x2f>
    panic("iunlock");
801019dd:	c7 04 24 48 89 10 80 	movl   $0x80108948,(%esp)
801019e4:	e8 51 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019e9:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
801019f0:	e8 49 37 00 00       	call   8010513e <acquire>
  ip->flags &= ~I_BUSY;
801019f5:	8b 45 08             	mov    0x8(%ebp),%eax
801019f8:	8b 40 0c             	mov    0xc(%eax),%eax
801019fb:	83 e0 fe             	and    $0xfffffffe,%eax
801019fe:	89 c2                	mov    %eax,%edx
80101a00:	8b 45 08             	mov    0x8(%ebp),%eax
80101a03:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a06:	8b 45 08             	mov    0x8(%ebp),%eax
80101a09:	89 04 24             	mov    %eax,(%esp)
80101a0c:	e8 2e 35 00 00       	call   80104f3f <wakeup>
  release(&icache.lock);
80101a11:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101a18:	e8 83 37 00 00       	call   801051a0 <release>
}
80101a1d:	c9                   	leave  
80101a1e:	c3                   	ret    

80101a1f <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a1f:	55                   	push   %ebp
80101a20:	89 e5                	mov    %esp,%ebp
80101a22:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a25:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101a2c:	e8 0d 37 00 00       	call   8010513e <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a31:	8b 45 08             	mov    0x8(%ebp),%eax
80101a34:	8b 40 08             	mov    0x8(%eax),%eax
80101a37:	83 f8 01             	cmp    $0x1,%eax
80101a3a:	0f 85 93 00 00 00    	jne    80101ad3 <iput+0xb4>
80101a40:	8b 45 08             	mov    0x8(%ebp),%eax
80101a43:	8b 40 0c             	mov    0xc(%eax),%eax
80101a46:	83 e0 02             	and    $0x2,%eax
80101a49:	85 c0                	test   %eax,%eax
80101a4b:	0f 84 82 00 00 00    	je     80101ad3 <iput+0xb4>
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a58:	66 85 c0             	test   %ax,%ax
80101a5b:	75 76                	jne    80101ad3 <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a60:	8b 40 0c             	mov    0xc(%eax),%eax
80101a63:	83 e0 01             	and    $0x1,%eax
80101a66:	85 c0                	test   %eax,%eax
80101a68:	74 0c                	je     80101a76 <iput+0x57>
      panic("iput busy");
80101a6a:	c7 04 24 50 89 10 80 	movl   $0x80108950,(%esp)
80101a71:	e8 c4 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a76:	8b 45 08             	mov    0x8(%ebp),%eax
80101a79:	8b 40 0c             	mov    0xc(%eax),%eax
80101a7c:	83 c8 01             	or     $0x1,%eax
80101a7f:	89 c2                	mov    %eax,%edx
80101a81:	8b 45 08             	mov    0x8(%ebp),%eax
80101a84:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a87:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101a8e:	e8 0d 37 00 00       	call   801051a0 <release>
    itrunc(ip);
80101a93:	8b 45 08             	mov    0x8(%ebp),%eax
80101a96:	89 04 24             	mov    %eax,(%esp)
80101a99:	e8 7d 01 00 00       	call   80101c1b <itrunc>
    ip->type = 0;
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaa:	89 04 24             	mov    %eax,(%esp)
80101aad:	e8 fe fb ff ff       	call   801016b0 <iupdate>
    acquire(&icache.lock);
80101ab2:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101ab9:	e8 80 36 00 00       	call   8010513e <acquire>
    ip->flags = 0;
80101abe:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80101acb:	89 04 24             	mov    %eax,(%esp)
80101ace:	e8 6c 34 00 00       	call   80104f3f <wakeup>
  }
  ip->ref--;
80101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad6:	8b 40 08             	mov    0x8(%eax),%eax
80101ad9:	8d 50 ff             	lea    -0x1(%eax),%edx
80101adc:	8b 45 08             	mov    0x8(%ebp),%eax
80101adf:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ae2:	c7 04 24 60 12 11 80 	movl   $0x80111260,(%esp)
80101ae9:	e8 b2 36 00 00       	call   801051a0 <release>
}
80101aee:	c9                   	leave  
80101aef:	c3                   	ret    

80101af0 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101af6:	8b 45 08             	mov    0x8(%ebp),%eax
80101af9:	89 04 24             	mov    %eax,(%esp)
80101afc:	e8 b9 fe ff ff       	call   801019ba <iunlock>
  iput(ip);
80101b01:	8b 45 08             	mov    0x8(%ebp),%eax
80101b04:	89 04 24             	mov    %eax,(%esp)
80101b07:	e8 13 ff ff ff       	call   80101a1f <iput>
}
80101b0c:	c9                   	leave  
80101b0d:	c3                   	ret    

80101b0e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b0e:	55                   	push   %ebp
80101b0f:	89 e5                	mov    %esp,%ebp
80101b11:	53                   	push   %ebx
80101b12:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b15:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b19:	77 3e                	ja     80101b59 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b21:	83 c2 04             	add    $0x4,%edx
80101b24:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b2f:	75 20                	jne    80101b51 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b31:	8b 45 08             	mov    0x8(%ebp),%eax
80101b34:	8b 00                	mov    (%eax),%eax
80101b36:	89 04 24             	mov    %eax,(%esp)
80101b39:	e8 5b f8 ff ff       	call   80101399 <balloc>
80101b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b41:	8b 45 08             	mov    0x8(%ebp),%eax
80101b44:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b47:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b4d:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b54:	e9 bc 00 00 00       	jmp    80101c15 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b59:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b5d:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b61:	0f 87 a2 00 00 00    	ja     80101c09 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b67:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b74:	75 19                	jne    80101b8f <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b76:	8b 45 08             	mov    0x8(%ebp),%eax
80101b79:	8b 00                	mov    (%eax),%eax
80101b7b:	89 04 24             	mov    %eax,(%esp)
80101b7e:	e8 16 f8 ff ff       	call   80101399 <balloc>
80101b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b86:	8b 45 08             	mov    0x8(%ebp),%eax
80101b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b8c:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b92:	8b 00                	mov    (%eax),%eax
80101b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b97:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b9b:	89 04 24             	mov    %eax,(%esp)
80101b9e:	e8 03 e6 ff ff       	call   801001a6 <bread>
80101ba3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ba9:	83 c0 18             	add    $0x18,%eax
80101bac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101baf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bbc:	01 d0                	add    %edx,%eax
80101bbe:	8b 00                	mov    (%eax),%eax
80101bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bc7:	75 30                	jne    80101bf9 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bcc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bd6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdc:	8b 00                	mov    (%eax),%eax
80101bde:	89 04 24             	mov    %eax,(%esp)
80101be1:	e8 b3 f7 ff ff       	call   80101399 <balloc>
80101be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bec:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bf1:	89 04 24             	mov    %eax,(%esp)
80101bf4:	e8 35 1a 00 00       	call   8010362e <log_write>
    }
    brelse(bp);
80101bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bfc:	89 04 24             	mov    %eax,(%esp)
80101bff:	e8 13 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c07:	eb 0c                	jmp    80101c15 <bmap+0x107>
  }

  panic("bmap: out of range");
80101c09:	c7 04 24 5a 89 10 80 	movl   $0x8010895a,(%esp)
80101c10:	e8 25 e9 ff ff       	call   8010053a <panic>
}
80101c15:	83 c4 24             	add    $0x24,%esp
80101c18:	5b                   	pop    %ebx
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    

80101c1b <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c1b:	55                   	push   %ebp
80101c1c:	89 e5                	mov    %esp,%ebp
80101c1e:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c28:	eb 44                	jmp    80101c6e <itrunc+0x53>
    if(ip->addrs[i]){
80101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c30:	83 c2 04             	add    $0x4,%edx
80101c33:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c37:	85 c0                	test   %eax,%eax
80101c39:	74 2f                	je     80101c6a <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c41:	83 c2 04             	add    $0x4,%edx
80101c44:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c48:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4b:	8b 00                	mov    (%eax),%eax
80101c4d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c51:	89 04 24             	mov    %eax,(%esp)
80101c54:	e8 8e f8 ff ff       	call   801014e7 <bfree>
      ip->addrs[i] = 0;
80101c59:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c5f:	83 c2 04             	add    $0x4,%edx
80101c62:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c69:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c6e:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c72:	7e b6                	jle    80101c2a <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c74:	8b 45 08             	mov    0x8(%ebp),%eax
80101c77:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c7a:	85 c0                	test   %eax,%eax
80101c7c:	0f 84 9b 00 00 00    	je     80101d1d <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c82:	8b 45 08             	mov    0x8(%ebp),%eax
80101c85:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c88:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8b:	8b 00                	mov    (%eax),%eax
80101c8d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c91:	89 04 24             	mov    %eax,(%esp)
80101c94:	e8 0d e5 ff ff       	call   801001a6 <bread>
80101c99:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c9f:	83 c0 18             	add    $0x18,%eax
80101ca2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ca5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101cac:	eb 3b                	jmp    80101ce9 <itrunc+0xce>
      if(a[j])
80101cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cb1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cbb:	01 d0                	add    %edx,%eax
80101cbd:	8b 00                	mov    (%eax),%eax
80101cbf:	85 c0                	test   %eax,%eax
80101cc1:	74 22                	je     80101ce5 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ccd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cd0:	01 d0                	add    %edx,%eax
80101cd2:	8b 10                	mov    (%eax),%edx
80101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd7:	8b 00                	mov    (%eax),%eax
80101cd9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cdd:	89 04 24             	mov    %eax,(%esp)
80101ce0:	e8 02 f8 ff ff       	call   801014e7 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ce5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cec:	83 f8 7f             	cmp    $0x7f,%eax
80101cef:	76 bd                	jbe    80101cae <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf4:	89 04 24             	mov    %eax,(%esp)
80101cf7:	e8 1b e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101cff:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d02:	8b 45 08             	mov    0x8(%ebp),%eax
80101d05:	8b 00                	mov    (%eax),%eax
80101d07:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d0b:	89 04 24             	mov    %eax,(%esp)
80101d0e:	e8 d4 f7 ff ff       	call   801014e7 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d13:	8b 45 08             	mov    0x8(%ebp),%eax
80101d16:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d20:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d27:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2a:	89 04 24             	mov    %eax,(%esp)
80101d2d:	e8 7e f9 ff ff       	call   801016b0 <iupdate>
}
80101d32:	c9                   	leave  
80101d33:	c3                   	ret    

80101d34 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d34:	55                   	push   %ebp
80101d35:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d37:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3a:	8b 00                	mov    (%eax),%eax
80101d3c:	89 c2                	mov    %eax,%edx
80101d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d41:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d44:	8b 45 08             	mov    0x8(%ebp),%eax
80101d47:	8b 50 04             	mov    0x4(%eax),%edx
80101d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d4d:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d50:	8b 45 08             	mov    0x8(%ebp),%eax
80101d53:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d57:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d5a:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d60:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d64:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d67:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6e:	8b 50 18             	mov    0x18(%eax),%edx
80101d71:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d74:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d77:	5d                   	pop    %ebp
80101d78:	c3                   	ret    

80101d79 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d79:	55                   	push   %ebp
80101d7a:	89 e5                	mov    %esp,%ebp
80101d7c:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d82:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d86:	66 83 f8 03          	cmp    $0x3,%ax
80101d8a:	75 60                	jne    80101dec <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d93:	66 85 c0             	test   %ax,%ax
80101d96:	78 20                	js     80101db8 <readi+0x3f>
80101d98:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d9f:	66 83 f8 09          	cmp    $0x9,%ax
80101da3:	7f 13                	jg     80101db8 <readi+0x3f>
80101da5:	8b 45 08             	mov    0x8(%ebp),%eax
80101da8:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dac:	98                   	cwtl   
80101dad:	8b 04 c5 00 12 11 80 	mov    -0x7feeee00(,%eax,8),%eax
80101db4:	85 c0                	test   %eax,%eax
80101db6:	75 0a                	jne    80101dc2 <readi+0x49>
      return -1;
80101db8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dbd:	e9 19 01 00 00       	jmp    80101edb <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc9:	98                   	cwtl   
80101dca:	8b 04 c5 00 12 11 80 	mov    -0x7feeee00(,%eax,8),%eax
80101dd1:	8b 55 14             	mov    0x14(%ebp),%edx
80101dd4:	89 54 24 08          	mov    %edx,0x8(%esp)
80101dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ddb:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ddf:	8b 55 08             	mov    0x8(%ebp),%edx
80101de2:	89 14 24             	mov    %edx,(%esp)
80101de5:	ff d0                	call   *%eax
80101de7:	e9 ef 00 00 00       	jmp    80101edb <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101dec:	8b 45 08             	mov    0x8(%ebp),%eax
80101def:	8b 40 18             	mov    0x18(%eax),%eax
80101df2:	3b 45 10             	cmp    0x10(%ebp),%eax
80101df5:	72 0d                	jb     80101e04 <readi+0x8b>
80101df7:	8b 45 14             	mov    0x14(%ebp),%eax
80101dfa:	8b 55 10             	mov    0x10(%ebp),%edx
80101dfd:	01 d0                	add    %edx,%eax
80101dff:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e02:	73 0a                	jae    80101e0e <readi+0x95>
    return -1;
80101e04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e09:	e9 cd 00 00 00       	jmp    80101edb <readi+0x162>
  if(off + n > ip->size)
80101e0e:	8b 45 14             	mov    0x14(%ebp),%eax
80101e11:	8b 55 10             	mov    0x10(%ebp),%edx
80101e14:	01 c2                	add    %eax,%edx
80101e16:	8b 45 08             	mov    0x8(%ebp),%eax
80101e19:	8b 40 18             	mov    0x18(%eax),%eax
80101e1c:	39 c2                	cmp    %eax,%edx
80101e1e:	76 0c                	jbe    80101e2c <readi+0xb3>
    n = ip->size - off;
80101e20:	8b 45 08             	mov    0x8(%ebp),%eax
80101e23:	8b 40 18             	mov    0x18(%eax),%eax
80101e26:	2b 45 10             	sub    0x10(%ebp),%eax
80101e29:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e33:	e9 94 00 00 00       	jmp    80101ecc <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e38:	8b 45 10             	mov    0x10(%ebp),%eax
80101e3b:	c1 e8 09             	shr    $0x9,%eax
80101e3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e42:	8b 45 08             	mov    0x8(%ebp),%eax
80101e45:	89 04 24             	mov    %eax,(%esp)
80101e48:	e8 c1 fc ff ff       	call   80101b0e <bmap>
80101e4d:	8b 55 08             	mov    0x8(%ebp),%edx
80101e50:	8b 12                	mov    (%edx),%edx
80101e52:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e56:	89 14 24             	mov    %edx,(%esp)
80101e59:	e8 48 e3 ff ff       	call   801001a6 <bread>
80101e5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e61:	8b 45 10             	mov    0x10(%ebp),%eax
80101e64:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e69:	89 c2                	mov    %eax,%edx
80101e6b:	b8 00 02 00 00       	mov    $0x200,%eax
80101e70:	29 d0                	sub    %edx,%eax
80101e72:	89 c2                	mov    %eax,%edx
80101e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e77:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e7a:	29 c1                	sub    %eax,%ecx
80101e7c:	89 c8                	mov    %ecx,%eax
80101e7e:	39 c2                	cmp    %eax,%edx
80101e80:	0f 46 c2             	cmovbe %edx,%eax
80101e83:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e86:	8b 45 10             	mov    0x10(%ebp),%eax
80101e89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e8e:	8d 50 10             	lea    0x10(%eax),%edx
80101e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e94:	01 d0                	add    %edx,%eax
80101e96:	8d 50 08             	lea    0x8(%eax),%edx
80101e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e9c:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ea0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea7:	89 04 24             	mov    %eax,(%esp)
80101eaa:	e8 b2 35 00 00       	call   80105461 <memmove>
    brelse(bp);
80101eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eb2:	89 04 24             	mov    %eax,(%esp)
80101eb5:	e8 5d e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ebd:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ec0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec3:	01 45 10             	add    %eax,0x10(%ebp)
80101ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec9:	01 45 0c             	add    %eax,0xc(%ebp)
80101ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ecf:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ed2:	0f 82 60 ff ff ff    	jb     80101e38 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ed8:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101edb:	c9                   	leave  
80101edc:	c3                   	ret    

80101edd <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101edd:	55                   	push   %ebp
80101ede:	89 e5                	mov    %esp,%ebp
80101ee0:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101eea:	66 83 f8 03          	cmp    $0x3,%ax
80101eee:	75 60                	jne    80101f50 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ef0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef7:	66 85 c0             	test   %ax,%ax
80101efa:	78 20                	js     80101f1c <writei+0x3f>
80101efc:	8b 45 08             	mov    0x8(%ebp),%eax
80101eff:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f03:	66 83 f8 09          	cmp    $0x9,%ax
80101f07:	7f 13                	jg     80101f1c <writei+0x3f>
80101f09:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f10:	98                   	cwtl   
80101f11:	8b 04 c5 04 12 11 80 	mov    -0x7feeedfc(,%eax,8),%eax
80101f18:	85 c0                	test   %eax,%eax
80101f1a:	75 0a                	jne    80101f26 <writei+0x49>
      return -1;
80101f1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f21:	e9 44 01 00 00       	jmp    8010206a <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f26:	8b 45 08             	mov    0x8(%ebp),%eax
80101f29:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f2d:	98                   	cwtl   
80101f2e:	8b 04 c5 04 12 11 80 	mov    -0x7feeedfc(,%eax,8),%eax
80101f35:	8b 55 14             	mov    0x14(%ebp),%edx
80101f38:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f3f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f43:	8b 55 08             	mov    0x8(%ebp),%edx
80101f46:	89 14 24             	mov    %edx,(%esp)
80101f49:	ff d0                	call   *%eax
80101f4b:	e9 1a 01 00 00       	jmp    8010206a <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f50:	8b 45 08             	mov    0x8(%ebp),%eax
80101f53:	8b 40 18             	mov    0x18(%eax),%eax
80101f56:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f59:	72 0d                	jb     80101f68 <writei+0x8b>
80101f5b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f5e:	8b 55 10             	mov    0x10(%ebp),%edx
80101f61:	01 d0                	add    %edx,%eax
80101f63:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f66:	73 0a                	jae    80101f72 <writei+0x95>
    return -1;
80101f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f6d:	e9 f8 00 00 00       	jmp    8010206a <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f72:	8b 45 14             	mov    0x14(%ebp),%eax
80101f75:	8b 55 10             	mov    0x10(%ebp),%edx
80101f78:	01 d0                	add    %edx,%eax
80101f7a:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f7f:	76 0a                	jbe    80101f8b <writei+0xae>
    return -1;
80101f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f86:	e9 df 00 00 00       	jmp    8010206a <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f92:	e9 9f 00 00 00       	jmp    80102036 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f97:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9a:	c1 e8 09             	shr    $0x9,%eax
80101f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa4:	89 04 24             	mov    %eax,(%esp)
80101fa7:	e8 62 fb ff ff       	call   80101b0e <bmap>
80101fac:	8b 55 08             	mov    0x8(%ebp),%edx
80101faf:	8b 12                	mov    (%edx),%edx
80101fb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fb5:	89 14 24             	mov    %edx,(%esp)
80101fb8:	e8 e9 e1 ff ff       	call   801001a6 <bread>
80101fbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc3:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc8:	89 c2                	mov    %eax,%edx
80101fca:	b8 00 02 00 00       	mov    $0x200,%eax
80101fcf:	29 d0                	sub    %edx,%eax
80101fd1:	89 c2                	mov    %eax,%edx
80101fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fd6:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fd9:	29 c1                	sub    %eax,%ecx
80101fdb:	89 c8                	mov    %ecx,%eax
80101fdd:	39 c2                	cmp    %eax,%edx
80101fdf:	0f 46 c2             	cmovbe %edx,%eax
80101fe2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fe5:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe8:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fed:	8d 50 10             	lea    0x10(%eax),%edx
80101ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff3:	01 d0                	add    %edx,%eax
80101ff5:	8d 50 08             	lea    0x8(%eax),%edx
80101ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ffb:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fff:	8b 45 0c             	mov    0xc(%ebp),%eax
80102002:	89 44 24 04          	mov    %eax,0x4(%esp)
80102006:	89 14 24             	mov    %edx,(%esp)
80102009:	e8 53 34 00 00       	call   80105461 <memmove>
    log_write(bp);
8010200e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102011:	89 04 24             	mov    %eax,(%esp)
80102014:	e8 15 16 00 00       	call   8010362e <log_write>
    brelse(bp);
80102019:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010201c:	89 04 24             	mov    %eax,(%esp)
8010201f:	e8 f3 e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102024:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102027:	01 45 f4             	add    %eax,-0xc(%ebp)
8010202a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010202d:	01 45 10             	add    %eax,0x10(%ebp)
80102030:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102033:	01 45 0c             	add    %eax,0xc(%ebp)
80102036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102039:	3b 45 14             	cmp    0x14(%ebp),%eax
8010203c:	0f 82 55 ff ff ff    	jb     80101f97 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102042:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102046:	74 1f                	je     80102067 <writei+0x18a>
80102048:	8b 45 08             	mov    0x8(%ebp),%eax
8010204b:	8b 40 18             	mov    0x18(%eax),%eax
8010204e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102051:	73 14                	jae    80102067 <writei+0x18a>
    ip->size = off;
80102053:	8b 45 08             	mov    0x8(%ebp),%eax
80102056:	8b 55 10             	mov    0x10(%ebp),%edx
80102059:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010205c:	8b 45 08             	mov    0x8(%ebp),%eax
8010205f:	89 04 24             	mov    %eax,(%esp)
80102062:	e8 49 f6 ff ff       	call   801016b0 <iupdate>
  }
  return n;
80102067:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010206a:	c9                   	leave  
8010206b:	c3                   	ret    

8010206c <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010206c:	55                   	push   %ebp
8010206d:	89 e5                	mov    %esp,%ebp
8010206f:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102072:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102079:	00 
8010207a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010207d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102081:	8b 45 08             	mov    0x8(%ebp),%eax
80102084:	89 04 24             	mov    %eax,(%esp)
80102087:	e8 78 34 00 00       	call   80105504 <strncmp>
}
8010208c:	c9                   	leave  
8010208d:	c3                   	ret    

8010208e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010208e:	55                   	push   %ebp
8010208f:	89 e5                	mov    %esp,%ebp
80102091:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102094:	8b 45 08             	mov    0x8(%ebp),%eax
80102097:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010209b:	66 83 f8 01          	cmp    $0x1,%ax
8010209f:	74 0c                	je     801020ad <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020a1:	c7 04 24 6d 89 10 80 	movl   $0x8010896d,(%esp)
801020a8:	e8 8d e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020b4:	e9 88 00 00 00       	jmp    80102141 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020b9:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020c0:	00 
801020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020c4:	89 44 24 08          	mov    %eax,0x8(%esp)
801020c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801020cf:	8b 45 08             	mov    0x8(%ebp),%eax
801020d2:	89 04 24             	mov    %eax,(%esp)
801020d5:	e8 9f fc ff ff       	call   80101d79 <readi>
801020da:	83 f8 10             	cmp    $0x10,%eax
801020dd:	74 0c                	je     801020eb <dirlookup+0x5d>
      panic("dirlink read");
801020df:	c7 04 24 7f 89 10 80 	movl   $0x8010897f,(%esp)
801020e6:	e8 4f e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020eb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020ef:	66 85 c0             	test   %ax,%ax
801020f2:	75 02                	jne    801020f6 <dirlookup+0x68>
      continue;
801020f4:	eb 47                	jmp    8010213d <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801020f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020f9:	83 c0 02             	add    $0x2,%eax
801020fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102100:	8b 45 0c             	mov    0xc(%ebp),%eax
80102103:	89 04 24             	mov    %eax,(%esp)
80102106:	e8 61 ff ff ff       	call   8010206c <namecmp>
8010210b:	85 c0                	test   %eax,%eax
8010210d:	75 2e                	jne    8010213d <dirlookup+0xaf>
      // entry matches path element
      if(poff)
8010210f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102113:	74 08                	je     8010211d <dirlookup+0x8f>
        *poff = off;
80102115:	8b 45 10             	mov    0x10(%ebp),%eax
80102118:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010211b:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010211d:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102121:	0f b7 c0             	movzwl %ax,%eax
80102124:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102127:	8b 45 08             	mov    0x8(%ebp),%eax
8010212a:	8b 00                	mov    (%eax),%eax
8010212c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010212f:	89 54 24 04          	mov    %edx,0x4(%esp)
80102133:	89 04 24             	mov    %eax,(%esp)
80102136:	e8 2d f6 ff ff       	call   80101768 <iget>
8010213b:	eb 18                	jmp    80102155 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010213d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102141:	8b 45 08             	mov    0x8(%ebp),%eax
80102144:	8b 40 18             	mov    0x18(%eax),%eax
80102147:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010214a:	0f 87 69 ff ff ff    	ja     801020b9 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102150:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102155:	c9                   	leave  
80102156:	c3                   	ret    

80102157 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102157:	55                   	push   %ebp
80102158:	89 e5                	mov    %esp,%ebp
8010215a:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010215d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102164:	00 
80102165:	8b 45 0c             	mov    0xc(%ebp),%eax
80102168:	89 44 24 04          	mov    %eax,0x4(%esp)
8010216c:	8b 45 08             	mov    0x8(%ebp),%eax
8010216f:	89 04 24             	mov    %eax,(%esp)
80102172:	e8 17 ff ff ff       	call   8010208e <dirlookup>
80102177:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010217a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010217e:	74 15                	je     80102195 <dirlink+0x3e>
    iput(ip);
80102180:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102183:	89 04 24             	mov    %eax,(%esp)
80102186:	e8 94 f8 ff ff       	call   80101a1f <iput>
    return -1;
8010218b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102190:	e9 b7 00 00 00       	jmp    8010224c <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102195:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010219c:	eb 46                	jmp    801021e4 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021a1:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021a8:	00 
801021a9:	89 44 24 08          	mov    %eax,0x8(%esp)
801021ad:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801021b4:	8b 45 08             	mov    0x8(%ebp),%eax
801021b7:	89 04 24             	mov    %eax,(%esp)
801021ba:	e8 ba fb ff ff       	call   80101d79 <readi>
801021bf:	83 f8 10             	cmp    $0x10,%eax
801021c2:	74 0c                	je     801021d0 <dirlink+0x79>
      panic("dirlink read");
801021c4:	c7 04 24 7f 89 10 80 	movl   $0x8010897f,(%esp)
801021cb:	e8 6a e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021d0:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021d4:	66 85 c0             	test   %ax,%ax
801021d7:	75 02                	jne    801021db <dirlink+0x84>
      break;
801021d9:	eb 16                	jmp    801021f1 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021de:	83 c0 10             	add    $0x10,%eax
801021e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021e7:	8b 45 08             	mov    0x8(%ebp),%eax
801021ea:	8b 40 18             	mov    0x18(%eax),%eax
801021ed:	39 c2                	cmp    %eax,%edx
801021ef:	72 ad                	jb     8010219e <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801021f1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021f8:	00 
801021f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801021fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102200:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102203:	83 c0 02             	add    $0x2,%eax
80102206:	89 04 24             	mov    %eax,(%esp)
80102209:	e8 4c 33 00 00       	call   8010555a <strncpy>
  de.inum = inum;
8010220e:	8b 45 10             	mov    0x10(%ebp),%eax
80102211:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102215:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102218:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010221f:	00 
80102220:	89 44 24 08          	mov    %eax,0x8(%esp)
80102224:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102227:	89 44 24 04          	mov    %eax,0x4(%esp)
8010222b:	8b 45 08             	mov    0x8(%ebp),%eax
8010222e:	89 04 24             	mov    %eax,(%esp)
80102231:	e8 a7 fc ff ff       	call   80101edd <writei>
80102236:	83 f8 10             	cmp    $0x10,%eax
80102239:	74 0c                	je     80102247 <dirlink+0xf0>
    panic("dirlink");
8010223b:	c7 04 24 8c 89 10 80 	movl   $0x8010898c,(%esp)
80102242:	e8 f3 e2 ff ff       	call   8010053a <panic>
  
  return 0;
80102247:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010224c:	c9                   	leave  
8010224d:	c3                   	ret    

8010224e <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010224e:	55                   	push   %ebp
8010224f:	89 e5                	mov    %esp,%ebp
80102251:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102254:	eb 04                	jmp    8010225a <skipelem+0xc>
    path++;
80102256:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010225a:	8b 45 08             	mov    0x8(%ebp),%eax
8010225d:	0f b6 00             	movzbl (%eax),%eax
80102260:	3c 2f                	cmp    $0x2f,%al
80102262:	74 f2                	je     80102256 <skipelem+0x8>
    path++;
  if(*path == 0)
80102264:	8b 45 08             	mov    0x8(%ebp),%eax
80102267:	0f b6 00             	movzbl (%eax),%eax
8010226a:	84 c0                	test   %al,%al
8010226c:	75 0a                	jne    80102278 <skipelem+0x2a>
    return 0;
8010226e:	b8 00 00 00 00       	mov    $0x0,%eax
80102273:	e9 86 00 00 00       	jmp    801022fe <skipelem+0xb0>
  s = path;
80102278:	8b 45 08             	mov    0x8(%ebp),%eax
8010227b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010227e:	eb 04                	jmp    80102284 <skipelem+0x36>
    path++;
80102280:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102284:	8b 45 08             	mov    0x8(%ebp),%eax
80102287:	0f b6 00             	movzbl (%eax),%eax
8010228a:	3c 2f                	cmp    $0x2f,%al
8010228c:	74 0a                	je     80102298 <skipelem+0x4a>
8010228e:	8b 45 08             	mov    0x8(%ebp),%eax
80102291:	0f b6 00             	movzbl (%eax),%eax
80102294:	84 c0                	test   %al,%al
80102296:	75 e8                	jne    80102280 <skipelem+0x32>
    path++;
  len = path - s;
80102298:	8b 55 08             	mov    0x8(%ebp),%edx
8010229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010229e:	29 c2                	sub    %eax,%edx
801022a0:	89 d0                	mov    %edx,%eax
801022a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022a5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022a9:	7e 1c                	jle    801022c7 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
801022ab:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022b2:	00 
801022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801022bd:	89 04 24             	mov    %eax,(%esp)
801022c0:	e8 9c 31 00 00       	call   80105461 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022c5:	eb 2a                	jmp    801022f1 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022ca:	89 44 24 08          	mov    %eax,0x8(%esp)
801022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801022d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801022d8:	89 04 24             	mov    %eax,(%esp)
801022db:	e8 81 31 00 00       	call   80105461 <memmove>
    name[len] = 0;
801022e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801022e6:	01 d0                	add    %edx,%eax
801022e8:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022eb:	eb 04                	jmp    801022f1 <skipelem+0xa3>
    path++;
801022ed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022f1:	8b 45 08             	mov    0x8(%ebp),%eax
801022f4:	0f b6 00             	movzbl (%eax),%eax
801022f7:	3c 2f                	cmp    $0x2f,%al
801022f9:	74 f2                	je     801022ed <skipelem+0x9f>
    path++;
  return path;
801022fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022fe:	c9                   	leave  
801022ff:	c3                   	ret    

80102300 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102306:	8b 45 08             	mov    0x8(%ebp),%eax
80102309:	0f b6 00             	movzbl (%eax),%eax
8010230c:	3c 2f                	cmp    $0x2f,%al
8010230e:	75 1c                	jne    8010232c <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102310:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102317:	00 
80102318:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010231f:	e8 44 f4 ff ff       	call   80101768 <iget>
80102324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(current->proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102327:	e9 b1 00 00 00       	jmp    801023dd <namex+0xdd>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(current->proc->cwd);
8010232c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102332:	8b 00                	mov    (%eax),%eax
80102334:	8b 40 4c             	mov    0x4c(%eax),%eax
80102337:	89 04 24             	mov    %eax,(%esp)
8010233a:	e8 fb f4 ff ff       	call   8010183a <idup>
8010233f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102342:	e9 96 00 00 00       	jmp    801023dd <namex+0xdd>
    ilock(ip);
80102347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234a:	89 04 24             	mov    %eax,(%esp)
8010234d:	e8 1a f5 ff ff       	call   8010186c <ilock>
    if(ip->type != T_DIR){
80102352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102355:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102359:	66 83 f8 01          	cmp    $0x1,%ax
8010235d:	74 15                	je     80102374 <namex+0x74>
      iunlockput(ip);
8010235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102362:	89 04 24             	mov    %eax,(%esp)
80102365:	e8 86 f7 ff ff       	call   80101af0 <iunlockput>
      return 0;
8010236a:	b8 00 00 00 00       	mov    $0x0,%eax
8010236f:	e9 a3 00 00 00       	jmp    80102417 <namex+0x117>
    }
    if(nameiparent && *path == '\0'){
80102374:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102378:	74 1d                	je     80102397 <namex+0x97>
8010237a:	8b 45 08             	mov    0x8(%ebp),%eax
8010237d:	0f b6 00             	movzbl (%eax),%eax
80102380:	84 c0                	test   %al,%al
80102382:	75 13                	jne    80102397 <namex+0x97>
      // Stop one level early.
      iunlock(ip);
80102384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102387:	89 04 24             	mov    %eax,(%esp)
8010238a:	e8 2b f6 ff ff       	call   801019ba <iunlock>
      return ip;
8010238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102392:	e9 80 00 00 00       	jmp    80102417 <namex+0x117>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102397:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010239e:	00 
8010239f:	8b 45 10             	mov    0x10(%ebp),%eax
801023a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a9:	89 04 24             	mov    %eax,(%esp)
801023ac:	e8 dd fc ff ff       	call   8010208e <dirlookup>
801023b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023b8:	75 12                	jne    801023cc <namex+0xcc>
      iunlockput(ip);
801023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023bd:	89 04 24             	mov    %eax,(%esp)
801023c0:	e8 2b f7 ff ff       	call   80101af0 <iunlockput>
      return 0;
801023c5:	b8 00 00 00 00       	mov    $0x0,%eax
801023ca:	eb 4b                	jmp    80102417 <namex+0x117>
    }
    iunlockput(ip);
801023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023cf:	89 04 24             	mov    %eax,(%esp)
801023d2:	e8 19 f7 ff ff       	call   80101af0 <iunlockput>
    ip = next;
801023d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(current->proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023dd:	8b 45 10             	mov    0x10(%ebp),%eax
801023e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801023e4:	8b 45 08             	mov    0x8(%ebp),%eax
801023e7:	89 04 24             	mov    %eax,(%esp)
801023ea:	e8 5f fe ff ff       	call   8010224e <skipelem>
801023ef:	89 45 08             	mov    %eax,0x8(%ebp)
801023f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023f6:	0f 85 4b ff ff ff    	jne    80102347 <namex+0x47>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102400:	74 12                	je     80102414 <namex+0x114>
    iput(ip);
80102402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102405:	89 04 24             	mov    %eax,(%esp)
80102408:	e8 12 f6 ff ff       	call   80101a1f <iput>
    return 0;
8010240d:	b8 00 00 00 00       	mov    $0x0,%eax
80102412:	eb 03                	jmp    80102417 <namex+0x117>
  }
  return ip;
80102414:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102417:	c9                   	leave  
80102418:	c3                   	ret    

80102419 <namei>:

struct inode*
namei(char *path)
{
80102419:	55                   	push   %ebp
8010241a:	89 e5                	mov    %esp,%ebp
8010241c:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010241f:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102422:	89 44 24 08          	mov    %eax,0x8(%esp)
80102426:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010242d:	00 
8010242e:	8b 45 08             	mov    0x8(%ebp),%eax
80102431:	89 04 24             	mov    %eax,(%esp)
80102434:	e8 c7 fe ff ff       	call   80102300 <namex>
}
80102439:	c9                   	leave  
8010243a:	c3                   	ret    

8010243b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010243b:	55                   	push   %ebp
8010243c:	89 e5                	mov    %esp,%ebp
8010243e:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102441:	8b 45 0c             	mov    0xc(%ebp),%eax
80102444:	89 44 24 08          	mov    %eax,0x8(%esp)
80102448:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010244f:	00 
80102450:	8b 45 08             	mov    0x8(%ebp),%eax
80102453:	89 04 24             	mov    %eax,(%esp)
80102456:	e8 a5 fe ff ff       	call   80102300 <namex>
}
8010245b:	c9                   	leave  
8010245c:	c3                   	ret    

8010245d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010245d:	55                   	push   %ebp
8010245e:	89 e5                	mov    %esp,%ebp
80102460:	83 ec 14             	sub    $0x14,%esp
80102463:	8b 45 08             	mov    0x8(%ebp),%eax
80102466:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010246a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010246e:	89 c2                	mov    %eax,%edx
80102470:	ec                   	in     (%dx),%al
80102471:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102474:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102478:	c9                   	leave  
80102479:	c3                   	ret    

8010247a <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010247a:	55                   	push   %ebp
8010247b:	89 e5                	mov    %esp,%ebp
8010247d:	57                   	push   %edi
8010247e:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010247f:	8b 55 08             	mov    0x8(%ebp),%edx
80102482:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102485:	8b 45 10             	mov    0x10(%ebp),%eax
80102488:	89 cb                	mov    %ecx,%ebx
8010248a:	89 df                	mov    %ebx,%edi
8010248c:	89 c1                	mov    %eax,%ecx
8010248e:	fc                   	cld    
8010248f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102491:	89 c8                	mov    %ecx,%eax
80102493:	89 fb                	mov    %edi,%ebx
80102495:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102498:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010249b:	5b                   	pop    %ebx
8010249c:	5f                   	pop    %edi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    

8010249f <outb>:

static inline void
outb(ushort port, uchar data)
{
8010249f:	55                   	push   %ebp
801024a0:	89 e5                	mov    %esp,%ebp
801024a2:	83 ec 08             	sub    $0x8,%esp
801024a5:	8b 55 08             	mov    0x8(%ebp),%edx
801024a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801024ab:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024af:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024b2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024b6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024ba:	ee                   	out    %al,(%dx)
}
801024bb:	c9                   	leave  
801024bc:	c3                   	ret    

801024bd <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024bd:	55                   	push   %ebp
801024be:	89 e5                	mov    %esp,%ebp
801024c0:	56                   	push   %esi
801024c1:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024c2:	8b 55 08             	mov    0x8(%ebp),%edx
801024c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024c8:	8b 45 10             	mov    0x10(%ebp),%eax
801024cb:	89 cb                	mov    %ecx,%ebx
801024cd:	89 de                	mov    %ebx,%esi
801024cf:	89 c1                	mov    %eax,%ecx
801024d1:	fc                   	cld    
801024d2:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024d4:	89 c8                	mov    %ecx,%eax
801024d6:	89 f3                	mov    %esi,%ebx
801024d8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024db:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024de:	5b                   	pop    %ebx
801024df:	5e                   	pop    %esi
801024e0:	5d                   	pop    %ebp
801024e1:	c3                   	ret    

801024e2 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024e2:	55                   	push   %ebp
801024e3:	89 e5                	mov    %esp,%ebp
801024e5:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024e8:	90                   	nop
801024e9:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024f0:	e8 68 ff ff ff       	call   8010245d <inb>
801024f5:	0f b6 c0             	movzbl %al,%eax
801024f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024fe:	25 c0 00 00 00       	and    $0xc0,%eax
80102503:	83 f8 40             	cmp    $0x40,%eax
80102506:	75 e1                	jne    801024e9 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010250c:	74 11                	je     8010251f <idewait+0x3d>
8010250e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102511:	83 e0 21             	and    $0x21,%eax
80102514:	85 c0                	test   %eax,%eax
80102516:	74 07                	je     8010251f <idewait+0x3d>
    return -1;
80102518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010251d:	eb 05                	jmp    80102524 <idewait+0x42>
  return 0;
8010251f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102524:	c9                   	leave  
80102525:	c3                   	ret    

80102526 <ideinit>:

void
ideinit(void)
{
80102526:	55                   	push   %ebp
80102527:	89 e5                	mov    %esp,%ebp
80102529:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010252c:	c7 44 24 04 94 89 10 	movl   $0x80108994,0x4(%esp)
80102533:	80 
80102534:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010253b:	e8 dd 2b 00 00       	call   8010511d <initlock>
  picenable(IRQ_IDE);
80102540:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102547:	e8 63 18 00 00       	call   80103daf <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010254c:	a1 60 29 11 80       	mov    0x80112960,%eax
80102551:	83 e8 01             	sub    $0x1,%eax
80102554:	89 44 24 04          	mov    %eax,0x4(%esp)
80102558:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010255f:	e8 0c 04 00 00       	call   80102970 <ioapicenable>
  idewait(0);
80102564:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010256b:	e8 72 ff ff ff       	call   801024e2 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102570:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102577:	00 
80102578:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010257f:	e8 1b ff ff ff       	call   8010249f <outb>
  for(i=0; i<1000; i++){
80102584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010258b:	eb 20                	jmp    801025ad <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010258d:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102594:	e8 c4 fe ff ff       	call   8010245d <inb>
80102599:	84 c0                	test   %al,%al
8010259b:	74 0c                	je     801025a9 <ideinit+0x83>
      havedisk1 = 1;
8010259d:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
801025a4:	00 00 00 
      break;
801025a7:	eb 0d                	jmp    801025b6 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025ad:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025b4:	7e d7                	jle    8010258d <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025b6:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025bd:	00 
801025be:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025c5:	e8 d5 fe ff ff       	call   8010249f <outb>
}
801025ca:	c9                   	leave  
801025cb:	c3                   	ret    

801025cc <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025cc:	55                   	push   %ebp
801025cd:	89 e5                	mov    %esp,%ebp
801025cf:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025d6:	75 0c                	jne    801025e4 <idestart+0x18>
    panic("idestart");
801025d8:	c7 04 24 98 89 10 80 	movl   $0x80108998,(%esp)
801025df:	e8 56 df ff ff       	call   8010053a <panic>

  idewait(0);
801025e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025eb:	e8 f2 fe ff ff       	call   801024e2 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025f7:	00 
801025f8:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025ff:	e8 9b fe ff ff       	call   8010249f <outb>
  outb(0x1f2, 1);  // number of sectors
80102604:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010260b:	00 
8010260c:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102613:	e8 87 fe ff ff       	call   8010249f <outb>
  outb(0x1f3, b->sector & 0xff);
80102618:	8b 45 08             	mov    0x8(%ebp),%eax
8010261b:	8b 40 08             	mov    0x8(%eax),%eax
8010261e:	0f b6 c0             	movzbl %al,%eax
80102621:	89 44 24 04          	mov    %eax,0x4(%esp)
80102625:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010262c:	e8 6e fe ff ff       	call   8010249f <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102631:	8b 45 08             	mov    0x8(%ebp),%eax
80102634:	8b 40 08             	mov    0x8(%eax),%eax
80102637:	c1 e8 08             	shr    $0x8,%eax
8010263a:	0f b6 c0             	movzbl %al,%eax
8010263d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102641:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102648:	e8 52 fe ff ff       	call   8010249f <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010264d:	8b 45 08             	mov    0x8(%ebp),%eax
80102650:	8b 40 08             	mov    0x8(%eax),%eax
80102653:	c1 e8 10             	shr    $0x10,%eax
80102656:	0f b6 c0             	movzbl %al,%eax
80102659:	89 44 24 04          	mov    %eax,0x4(%esp)
8010265d:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102664:	e8 36 fe ff ff       	call   8010249f <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
8010266c:	8b 40 04             	mov    0x4(%eax),%eax
8010266f:	83 e0 01             	and    $0x1,%eax
80102672:	c1 e0 04             	shl    $0x4,%eax
80102675:	89 c2                	mov    %eax,%edx
80102677:	8b 45 08             	mov    0x8(%ebp),%eax
8010267a:	8b 40 08             	mov    0x8(%eax),%eax
8010267d:	c1 e8 18             	shr    $0x18,%eax
80102680:	83 e0 0f             	and    $0xf,%eax
80102683:	09 d0                	or     %edx,%eax
80102685:	83 c8 e0             	or     $0xffffffe0,%eax
80102688:	0f b6 c0             	movzbl %al,%eax
8010268b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010268f:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102696:	e8 04 fe ff ff       	call   8010249f <outb>
  if(b->flags & B_DIRTY){
8010269b:	8b 45 08             	mov    0x8(%ebp),%eax
8010269e:	8b 00                	mov    (%eax),%eax
801026a0:	83 e0 04             	and    $0x4,%eax
801026a3:	85 c0                	test   %eax,%eax
801026a5:	74 34                	je     801026db <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026a7:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026ae:	00 
801026af:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026b6:	e8 e4 fd ff ff       	call   8010249f <outb>
    outsl(0x1f0, b->data, 512/4);
801026bb:	8b 45 08             	mov    0x8(%ebp),%eax
801026be:	83 c0 18             	add    $0x18,%eax
801026c1:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026c8:	00 
801026c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801026cd:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026d4:	e8 e4 fd ff ff       	call   801024bd <outsl>
801026d9:	eb 14                	jmp    801026ef <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026db:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026e2:	00 
801026e3:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026ea:	e8 b0 fd ff ff       	call   8010249f <outb>
  }
}
801026ef:	c9                   	leave  
801026f0:	c3                   	ret    

801026f1 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026f1:	55                   	push   %ebp
801026f2:	89 e5                	mov    %esp,%ebp
801026f4:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026f7:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801026fe:	e8 3b 2a 00 00       	call   8010513e <acquire>
  if((b = idequeue) == 0){
80102703:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102708:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010270b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010270f:	75 11                	jne    80102722 <ideintr+0x31>
    release(&idelock);
80102711:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102718:	e8 83 2a 00 00       	call   801051a0 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010271d:	e9 90 00 00 00       	jmp    801027b2 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102725:	8b 40 14             	mov    0x14(%eax),%eax
80102728:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102730:	8b 00                	mov    (%eax),%eax
80102732:	83 e0 04             	and    $0x4,%eax
80102735:	85 c0                	test   %eax,%eax
80102737:	75 2e                	jne    80102767 <ideintr+0x76>
80102739:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102740:	e8 9d fd ff ff       	call   801024e2 <idewait>
80102745:	85 c0                	test   %eax,%eax
80102747:	78 1e                	js     80102767 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274c:	83 c0 18             	add    $0x18,%eax
8010274f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102756:	00 
80102757:	89 44 24 04          	mov    %eax,0x4(%esp)
8010275b:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102762:	e8 13 fd ff ff       	call   8010247a <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276a:	8b 00                	mov    (%eax),%eax
8010276c:	83 c8 02             	or     $0x2,%eax
8010276f:	89 c2                	mov    %eax,%edx
80102771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102774:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102779:	8b 00                	mov    (%eax),%eax
8010277b:	83 e0 fb             	and    $0xfffffffb,%eax
8010277e:	89 c2                	mov    %eax,%edx
80102780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102783:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102788:	89 04 24             	mov    %eax,(%esp)
8010278b:	e8 af 27 00 00       	call   80104f3f <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102790:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102795:	85 c0                	test   %eax,%eax
80102797:	74 0d                	je     801027a6 <ideintr+0xb5>
    idestart(idequeue);
80102799:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010279e:	89 04 24             	mov    %eax,(%esp)
801027a1:	e8 26 fe ff ff       	call   801025cc <idestart>

  release(&idelock);
801027a6:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801027ad:	e8 ee 29 00 00       	call   801051a0 <release>
}
801027b2:	c9                   	leave  
801027b3:	c3                   	ret    

801027b4 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027b4:	55                   	push   %ebp
801027b5:	89 e5                	mov    %esp,%ebp
801027b7:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027ba:	8b 45 08             	mov    0x8(%ebp),%eax
801027bd:	8b 00                	mov    (%eax),%eax
801027bf:	83 e0 01             	and    $0x1,%eax
801027c2:	85 c0                	test   %eax,%eax
801027c4:	75 0c                	jne    801027d2 <iderw+0x1e>
    panic("iderw: buf not busy");
801027c6:	c7 04 24 a1 89 10 80 	movl   $0x801089a1,(%esp)
801027cd:	e8 68 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027d2:	8b 45 08             	mov    0x8(%ebp),%eax
801027d5:	8b 00                	mov    (%eax),%eax
801027d7:	83 e0 06             	and    $0x6,%eax
801027da:	83 f8 02             	cmp    $0x2,%eax
801027dd:	75 0c                	jne    801027eb <iderw+0x37>
    panic("iderw: nothing to do");
801027df:	c7 04 24 b5 89 10 80 	movl   $0x801089b5,(%esp)
801027e6:	e8 4f dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027eb:	8b 45 08             	mov    0x8(%ebp),%eax
801027ee:	8b 40 04             	mov    0x4(%eax),%eax
801027f1:	85 c0                	test   %eax,%eax
801027f3:	74 15                	je     8010280a <iderw+0x56>
801027f5:	a1 58 b6 10 80       	mov    0x8010b658,%eax
801027fa:	85 c0                	test   %eax,%eax
801027fc:	75 0c                	jne    8010280a <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027fe:	c7 04 24 ca 89 10 80 	movl   $0x801089ca,(%esp)
80102805:	e8 30 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010280a:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102811:	e8 28 29 00 00       	call   8010513e <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102816:	8b 45 08             	mov    0x8(%ebp),%eax
80102819:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102820:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
80102827:	eb 0b                	jmp    80102834 <iderw+0x80>
80102829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282c:	8b 00                	mov    (%eax),%eax
8010282e:	83 c0 14             	add    $0x14,%eax
80102831:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102837:	8b 00                	mov    (%eax),%eax
80102839:	85 c0                	test   %eax,%eax
8010283b:	75 ec                	jne    80102829 <iderw+0x75>
    ;
  *pp = b;
8010283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102840:	8b 55 08             	mov    0x8(%ebp),%edx
80102843:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102845:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010284a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010284d:	75 0d                	jne    8010285c <iderw+0xa8>
    idestart(b);
8010284f:	8b 45 08             	mov    0x8(%ebp),%eax
80102852:	89 04 24             	mov    %eax,(%esp)
80102855:	e8 72 fd ff ff       	call   801025cc <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010285a:	eb 15                	jmp    80102871 <iderw+0xbd>
8010285c:	eb 13                	jmp    80102871 <iderw+0xbd>
    sleep(b, &idelock);
8010285e:	c7 44 24 04 20 b6 10 	movl   $0x8010b620,0x4(%esp)
80102865:	80 
80102866:	8b 45 08             	mov    0x8(%ebp),%eax
80102869:	89 04 24             	mov    %eax,(%esp)
8010286c:	e8 e9 25 00 00       	call   80104e5a <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102871:	8b 45 08             	mov    0x8(%ebp),%eax
80102874:	8b 00                	mov    (%eax),%eax
80102876:	83 e0 06             	and    $0x6,%eax
80102879:	83 f8 02             	cmp    $0x2,%eax
8010287c:	75 e0                	jne    8010285e <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
8010287e:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102885:	e8 16 29 00 00       	call   801051a0 <release>
}
8010288a:	c9                   	leave  
8010288b:	c3                   	ret    

8010288c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010288c:	55                   	push   %ebp
8010288d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010288f:	a1 34 22 11 80       	mov    0x80112234,%eax
80102894:	8b 55 08             	mov    0x8(%ebp),%edx
80102897:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102899:	a1 34 22 11 80       	mov    0x80112234,%eax
8010289e:	8b 40 10             	mov    0x10(%eax),%eax
}
801028a1:	5d                   	pop    %ebp
801028a2:	c3                   	ret    

801028a3 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028a3:	55                   	push   %ebp
801028a4:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028a6:	a1 34 22 11 80       	mov    0x80112234,%eax
801028ab:	8b 55 08             	mov    0x8(%ebp),%edx
801028ae:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028b0:	a1 34 22 11 80       	mov    0x80112234,%eax
801028b5:	8b 55 0c             	mov    0xc(%ebp),%edx
801028b8:	89 50 10             	mov    %edx,0x10(%eax)
}
801028bb:	5d                   	pop    %ebp
801028bc:	c3                   	ret    

801028bd <ioapicinit>:

void
ioapicinit(void)
{
801028bd:	55                   	push   %ebp
801028be:	89 e5                	mov    %esp,%ebp
801028c0:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028c3:	a1 64 23 11 80       	mov    0x80112364,%eax
801028c8:	85 c0                	test   %eax,%eax
801028ca:	75 05                	jne    801028d1 <ioapicinit+0x14>
    return;
801028cc:	e9 9d 00 00 00       	jmp    8010296e <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028d1:	c7 05 34 22 11 80 00 	movl   $0xfec00000,0x80112234
801028d8:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028e2:	e8 a5 ff ff ff       	call   8010288c <ioapicread>
801028e7:	c1 e8 10             	shr    $0x10,%eax
801028ea:	25 ff 00 00 00       	and    $0xff,%eax
801028ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028f9:	e8 8e ff ff ff       	call   8010288c <ioapicread>
801028fe:	c1 e8 18             	shr    $0x18,%eax
80102901:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102904:	0f b6 05 60 23 11 80 	movzbl 0x80112360,%eax
8010290b:	0f b6 c0             	movzbl %al,%eax
8010290e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102911:	74 0c                	je     8010291f <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102913:	c7 04 24 e8 89 10 80 	movl   $0x801089e8,(%esp)
8010291a:	e8 81 da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010291f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102926:	eb 3e                	jmp    80102966 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010292b:	83 c0 20             	add    $0x20,%eax
8010292e:	0d 00 00 01 00       	or     $0x10000,%eax
80102933:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102936:	83 c2 08             	add    $0x8,%edx
80102939:	01 d2                	add    %edx,%edx
8010293b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010293f:	89 14 24             	mov    %edx,(%esp)
80102942:	e8 5c ff ff ff       	call   801028a3 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102947:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294a:	83 c0 08             	add    $0x8,%eax
8010294d:	01 c0                	add    %eax,%eax
8010294f:	83 c0 01             	add    $0x1,%eax
80102952:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102959:	00 
8010295a:	89 04 24             	mov    %eax,(%esp)
8010295d:	e8 41 ff ff ff       	call   801028a3 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102962:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102969:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010296c:	7e ba                	jle    80102928 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010296e:	c9                   	leave  
8010296f:	c3                   	ret    

80102970 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102976:	a1 64 23 11 80       	mov    0x80112364,%eax
8010297b:	85 c0                	test   %eax,%eax
8010297d:	75 02                	jne    80102981 <ioapicenable+0x11>
    return;
8010297f:	eb 37                	jmp    801029b8 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102981:	8b 45 08             	mov    0x8(%ebp),%eax
80102984:	83 c0 20             	add    $0x20,%eax
80102987:	8b 55 08             	mov    0x8(%ebp),%edx
8010298a:	83 c2 08             	add    $0x8,%edx
8010298d:	01 d2                	add    %edx,%edx
8010298f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102993:	89 14 24             	mov    %edx,(%esp)
80102996:	e8 08 ff ff ff       	call   801028a3 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010299b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010299e:	c1 e0 18             	shl    $0x18,%eax
801029a1:	8b 55 08             	mov    0x8(%ebp),%edx
801029a4:	83 c2 08             	add    $0x8,%edx
801029a7:	01 d2                	add    %edx,%edx
801029a9:	83 c2 01             	add    $0x1,%edx
801029ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b0:	89 14 24             	mov    %edx,(%esp)
801029b3:	e8 eb fe ff ff       	call   801028a3 <ioapicwrite>
}
801029b8:	c9                   	leave  
801029b9:	c3                   	ret    

801029ba <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029ba:	55                   	push   %ebp
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	8b 45 08             	mov    0x8(%ebp),%eax
801029c0:	05 00 00 00 80       	add    $0x80000000,%eax
801029c5:	5d                   	pop    %ebp
801029c6:	c3                   	ret    

801029c7 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029c7:	55                   	push   %ebp
801029c8:	89 e5                	mov    %esp,%ebp
801029ca:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029cd:	c7 44 24 04 1a 8a 10 	movl   $0x80108a1a,0x4(%esp)
801029d4:	80 
801029d5:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
801029dc:	e8 3c 27 00 00       	call   8010511d <initlock>
  kmem.use_lock = 0;
801029e1:	c7 05 74 22 11 80 00 	movl   $0x0,0x80112274
801029e8:	00 00 00 
  freerange(vstart, vend);
801029eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801029ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f2:	8b 45 08             	mov    0x8(%ebp),%eax
801029f5:	89 04 24             	mov    %eax,(%esp)
801029f8:	e8 26 00 00 00       	call   80102a23 <freerange>
}
801029fd:	c9                   	leave  
801029fe:	c3                   	ret    

801029ff <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029ff:	55                   	push   %ebp
80102a00:	89 e5                	mov    %esp,%ebp
80102a02:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a05:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a08:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a0f:	89 04 24             	mov    %eax,(%esp)
80102a12:	e8 0c 00 00 00       	call   80102a23 <freerange>
  kmem.use_lock = 1;
80102a17:	c7 05 74 22 11 80 01 	movl   $0x1,0x80112274
80102a1e:	00 00 00 
}
80102a21:	c9                   	leave  
80102a22:	c3                   	ret    

80102a23 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a23:	55                   	push   %ebp
80102a24:	89 e5                	mov    %esp,%ebp
80102a26:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a29:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2c:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a31:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a39:	eb 12                	jmp    80102a4d <freerange+0x2a>
    kfree(p);
80102a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3e:	89 04 24             	mov    %eax,(%esp)
80102a41:	e8 16 00 00 00       	call   80102a5c <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a46:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a50:	05 00 10 00 00       	add    $0x1000,%eax
80102a55:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a58:	76 e1                	jbe    80102a3b <freerange+0x18>
    kfree(p);
}
80102a5a:	c9                   	leave  
80102a5b:	c3                   	ret    

80102a5c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a5c:	55                   	push   %ebp
80102a5d:	89 e5                	mov    %esp,%ebp
80102a5f:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a62:	8b 45 08             	mov    0x8(%ebp),%eax
80102a65:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a6a:	85 c0                	test   %eax,%eax
80102a6c:	75 1b                	jne    80102a89 <kfree+0x2d>
80102a6e:	81 7d 08 5c 54 11 80 	cmpl   $0x8011545c,0x8(%ebp)
80102a75:	72 12                	jb     80102a89 <kfree+0x2d>
80102a77:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7a:	89 04 24             	mov    %eax,(%esp)
80102a7d:	e8 38 ff ff ff       	call   801029ba <v2p>
80102a82:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a87:	76 0c                	jbe    80102a95 <kfree+0x39>
    panic("kfree");
80102a89:	c7 04 24 1f 8a 10 80 	movl   $0x80108a1f,(%esp)
80102a90:	e8 a5 da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a95:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a9c:	00 
80102a9d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102aa4:	00 
80102aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa8:	89 04 24             	mov    %eax,(%esp)
80102aab:	e8 e2 28 00 00       	call   80105392 <memset>

  if(kmem.use_lock)
80102ab0:	a1 74 22 11 80       	mov    0x80112274,%eax
80102ab5:	85 c0                	test   %eax,%eax
80102ab7:	74 0c                	je     80102ac5 <kfree+0x69>
    acquire(&kmem.lock);
80102ab9:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80102ac0:	e8 79 26 00 00       	call   8010513e <acquire>
  r = (struct run*)v;
80102ac5:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102acb:	8b 15 78 22 11 80    	mov    0x80112278,%edx
80102ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad4:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ad9:	a3 78 22 11 80       	mov    %eax,0x80112278
  if(kmem.use_lock)
80102ade:	a1 74 22 11 80       	mov    0x80112274,%eax
80102ae3:	85 c0                	test   %eax,%eax
80102ae5:	74 0c                	je     80102af3 <kfree+0x97>
    release(&kmem.lock);
80102ae7:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80102aee:	e8 ad 26 00 00       	call   801051a0 <release>
}
80102af3:	c9                   	leave  
80102af4:	c3                   	ret    

80102af5 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102af5:	55                   	push   %ebp
80102af6:	89 e5                	mov    %esp,%ebp
80102af8:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102afb:	a1 74 22 11 80       	mov    0x80112274,%eax
80102b00:	85 c0                	test   %eax,%eax
80102b02:	74 0c                	je     80102b10 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b04:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80102b0b:	e8 2e 26 00 00       	call   8010513e <acquire>
  r = kmem.freelist;
80102b10:	a1 78 22 11 80       	mov    0x80112278,%eax
80102b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b1c:	74 0a                	je     80102b28 <kalloc+0x33>
    kmem.freelist = r->next;
80102b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b21:	8b 00                	mov    (%eax),%eax
80102b23:	a3 78 22 11 80       	mov    %eax,0x80112278
  if(kmem.use_lock)
80102b28:	a1 74 22 11 80       	mov    0x80112274,%eax
80102b2d:	85 c0                	test   %eax,%eax
80102b2f:	74 0c                	je     80102b3d <kalloc+0x48>
    release(&kmem.lock);
80102b31:	c7 04 24 40 22 11 80 	movl   $0x80112240,(%esp)
80102b38:	e8 63 26 00 00       	call   801051a0 <release>
  return (char*)r;
80102b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b40:	c9                   	leave  
80102b41:	c3                   	ret    

80102b42 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b42:	55                   	push   %ebp
80102b43:	89 e5                	mov    %esp,%ebp
80102b45:	83 ec 14             	sub    $0x14,%esp
80102b48:	8b 45 08             	mov    0x8(%ebp),%eax
80102b4b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b53:	89 c2                	mov    %eax,%edx
80102b55:	ec                   	in     (%dx),%al
80102b56:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b59:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b5d:	c9                   	leave  
80102b5e:	c3                   	ret    

80102b5f <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b5f:	55                   	push   %ebp
80102b60:	89 e5                	mov    %esp,%ebp
80102b62:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b65:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b6c:	e8 d1 ff ff ff       	call   80102b42 <inb>
80102b71:	0f b6 c0             	movzbl %al,%eax
80102b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b7a:	83 e0 01             	and    $0x1,%eax
80102b7d:	85 c0                	test   %eax,%eax
80102b7f:	75 0a                	jne    80102b8b <kbdgetc+0x2c>
    return -1;
80102b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b86:	e9 25 01 00 00       	jmp    80102cb0 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102b8b:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b92:	e8 ab ff ff ff       	call   80102b42 <inb>
80102b97:	0f b6 c0             	movzbl %al,%eax
80102b9a:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b9d:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102ba4:	75 17                	jne    80102bbd <kbdgetc+0x5e>
    shift |= E0ESC;
80102ba6:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102bab:	83 c8 40             	or     $0x40,%eax
80102bae:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102bb3:	b8 00 00 00 00       	mov    $0x0,%eax
80102bb8:	e9 f3 00 00 00       	jmp    80102cb0 <kbdgetc+0x151>
  } else if(data & 0x80){
80102bbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bc0:	25 80 00 00 00       	and    $0x80,%eax
80102bc5:	85 c0                	test   %eax,%eax
80102bc7:	74 45                	je     80102c0e <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bc9:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102bce:	83 e0 40             	and    $0x40,%eax
80102bd1:	85 c0                	test   %eax,%eax
80102bd3:	75 08                	jne    80102bdd <kbdgetc+0x7e>
80102bd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bd8:	83 e0 7f             	and    $0x7f,%eax
80102bdb:	eb 03                	jmp    80102be0 <kbdgetc+0x81>
80102bdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102be0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102be6:	05 20 90 10 80       	add    $0x80109020,%eax
80102beb:	0f b6 00             	movzbl (%eax),%eax
80102bee:	83 c8 40             	or     $0x40,%eax
80102bf1:	0f b6 c0             	movzbl %al,%eax
80102bf4:	f7 d0                	not    %eax
80102bf6:	89 c2                	mov    %eax,%edx
80102bf8:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102bfd:	21 d0                	and    %edx,%eax
80102bff:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102c04:	b8 00 00 00 00       	mov    $0x0,%eax
80102c09:	e9 a2 00 00 00       	jmp    80102cb0 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c0e:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c13:	83 e0 40             	and    $0x40,%eax
80102c16:	85 c0                	test   %eax,%eax
80102c18:	74 14                	je     80102c2e <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c1a:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c21:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c26:	83 e0 bf             	and    $0xffffffbf,%eax
80102c29:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102c2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c31:	05 20 90 10 80       	add    $0x80109020,%eax
80102c36:	0f b6 00             	movzbl (%eax),%eax
80102c39:	0f b6 d0             	movzbl %al,%edx
80102c3c:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c41:	09 d0                	or     %edx,%eax
80102c43:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c4b:	05 20 91 10 80       	add    $0x80109120,%eax
80102c50:	0f b6 00             	movzbl (%eax),%eax
80102c53:	0f b6 d0             	movzbl %al,%edx
80102c56:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c5b:	31 d0                	xor    %edx,%eax
80102c5d:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c62:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c67:	83 e0 03             	and    $0x3,%eax
80102c6a:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c74:	01 d0                	add    %edx,%eax
80102c76:	0f b6 00             	movzbl (%eax),%eax
80102c79:	0f b6 c0             	movzbl %al,%eax
80102c7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c7f:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c84:	83 e0 08             	and    $0x8,%eax
80102c87:	85 c0                	test   %eax,%eax
80102c89:	74 22                	je     80102cad <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102c8b:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c8f:	76 0c                	jbe    80102c9d <kbdgetc+0x13e>
80102c91:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c95:	77 06                	ja     80102c9d <kbdgetc+0x13e>
      c += 'A' - 'a';
80102c97:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c9b:	eb 10                	jmp    80102cad <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102c9d:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102ca1:	76 0a                	jbe    80102cad <kbdgetc+0x14e>
80102ca3:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102ca7:	77 04                	ja     80102cad <kbdgetc+0x14e>
      c += 'a' - 'A';
80102ca9:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102cad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102cb0:	c9                   	leave  
80102cb1:	c3                   	ret    

80102cb2 <kbdintr>:

void
kbdintr(void)
{
80102cb2:	55                   	push   %ebp
80102cb3:	89 e5                	mov    %esp,%ebp
80102cb5:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cb8:	c7 04 24 5f 2b 10 80 	movl   $0x80102b5f,(%esp)
80102cbf:	e8 e9 da ff ff       	call   801007ad <consoleintr>
}
80102cc4:	c9                   	leave  
80102cc5:	c3                   	ret    

80102cc6 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102cc6:	55                   	push   %ebp
80102cc7:	89 e5                	mov    %esp,%ebp
80102cc9:	83 ec 14             	sub    $0x14,%esp
80102ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80102ccf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cd7:	89 c2                	mov    %eax,%edx
80102cd9:	ec                   	in     (%dx),%al
80102cda:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cdd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ce1:	c9                   	leave  
80102ce2:	c3                   	ret    

80102ce3 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102ce3:	55                   	push   %ebp
80102ce4:	89 e5                	mov    %esp,%ebp
80102ce6:	83 ec 08             	sub    $0x8,%esp
80102ce9:	8b 55 08             	mov    0x8(%ebp),%edx
80102cec:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cef:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102cf3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cfa:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cfe:	ee                   	out    %al,(%dx)
}
80102cff:	c9                   	leave  
80102d00:	c3                   	ret    

80102d01 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d01:	55                   	push   %ebp
80102d02:	89 e5                	mov    %esp,%ebp
80102d04:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d07:	9c                   	pushf  
80102d08:	58                   	pop    %eax
80102d09:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d0f:	c9                   	leave  
80102d10:	c3                   	ret    

80102d11 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d11:	55                   	push   %ebp
80102d12:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d14:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102d19:	8b 55 08             	mov    0x8(%ebp),%edx
80102d1c:	c1 e2 02             	shl    $0x2,%edx
80102d1f:	01 c2                	add    %eax,%edx
80102d21:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d24:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d26:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102d2b:	83 c0 20             	add    $0x20,%eax
80102d2e:	8b 00                	mov    (%eax),%eax
}
80102d30:	5d                   	pop    %ebp
80102d31:	c3                   	ret    

80102d32 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d32:	55                   	push   %ebp
80102d33:	89 e5                	mov    %esp,%ebp
80102d35:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d38:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102d3d:	85 c0                	test   %eax,%eax
80102d3f:	75 05                	jne    80102d46 <lapicinit+0x14>
    return;
80102d41:	e9 43 01 00 00       	jmp    80102e89 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d46:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d4d:	00 
80102d4e:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d55:	e8 b7 ff ff ff       	call   80102d11 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d5a:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d61:	00 
80102d62:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d69:	e8 a3 ff ff ff       	call   80102d11 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d6e:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d75:	00 
80102d76:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d7d:	e8 8f ff ff ff       	call   80102d11 <lapicw>
  lapicw(TICR, 10000000); 
80102d82:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d89:	00 
80102d8a:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d91:	e8 7b ff ff ff       	call   80102d11 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d96:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d9d:	00 
80102d9e:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102da5:	e8 67 ff ff ff       	call   80102d11 <lapicw>
  lapicw(LINT1, MASKED);
80102daa:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102db1:	00 
80102db2:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102db9:	e8 53 ff ff ff       	call   80102d11 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102dbe:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102dc3:	83 c0 30             	add    $0x30,%eax
80102dc6:	8b 00                	mov    (%eax),%eax
80102dc8:	c1 e8 10             	shr    $0x10,%eax
80102dcb:	0f b6 c0             	movzbl %al,%eax
80102dce:	83 f8 03             	cmp    $0x3,%eax
80102dd1:	76 14                	jbe    80102de7 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102dd3:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dda:	00 
80102ddb:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102de2:	e8 2a ff ff ff       	call   80102d11 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102de7:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102dee:	00 
80102def:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102df6:	e8 16 ff ff ff       	call   80102d11 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102dfb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e02:	00 
80102e03:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e0a:	e8 02 ff ff ff       	call   80102d11 <lapicw>
  lapicw(ESR, 0);
80102e0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e16:	00 
80102e17:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e1e:	e8 ee fe ff ff       	call   80102d11 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e2a:	00 
80102e2b:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e32:	e8 da fe ff ff       	call   80102d11 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e3e:	00 
80102e3f:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e46:	e8 c6 fe ff ff       	call   80102d11 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e4b:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e52:	00 
80102e53:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e5a:	e8 b2 fe ff ff       	call   80102d11 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e5f:	90                   	nop
80102e60:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102e65:	05 00 03 00 00       	add    $0x300,%eax
80102e6a:	8b 00                	mov    (%eax),%eax
80102e6c:	25 00 10 00 00       	and    $0x1000,%eax
80102e71:	85 c0                	test   %eax,%eax
80102e73:	75 eb                	jne    80102e60 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e75:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e7c:	00 
80102e7d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e84:	e8 88 fe ff ff       	call   80102d11 <lapicw>
}
80102e89:	c9                   	leave  
80102e8a:	c3                   	ret    

80102e8b <cpunum>:

int
cpunum(void)
{
80102e8b:	55                   	push   %ebp
80102e8c:	89 e5                	mov    %esp,%ebp
80102e8e:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e91:	e8 6b fe ff ff       	call   80102d01 <readeflags>
80102e96:	25 00 02 00 00       	and    $0x200,%eax
80102e9b:	85 c0                	test   %eax,%eax
80102e9d:	74 25                	je     80102ec4 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102e9f:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102ea4:	8d 50 01             	lea    0x1(%eax),%edx
80102ea7:	89 15 60 b6 10 80    	mov    %edx,0x8010b660
80102ead:	85 c0                	test   %eax,%eax
80102eaf:	75 13                	jne    80102ec4 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102eb1:	8b 45 04             	mov    0x4(%ebp),%eax
80102eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102eb8:	c7 04 24 28 8a 10 80 	movl   $0x80108a28,(%esp)
80102ebf:	e8 dc d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102ec4:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102ec9:	85 c0                	test   %eax,%eax
80102ecb:	74 0f                	je     80102edc <cpunum+0x51>
    return lapic[ID]>>24;
80102ecd:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102ed2:	83 c0 20             	add    $0x20,%eax
80102ed5:	8b 00                	mov    (%eax),%eax
80102ed7:	c1 e8 18             	shr    $0x18,%eax
80102eda:	eb 05                	jmp    80102ee1 <cpunum+0x56>
  return 0;
80102edc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ee1:	c9                   	leave  
80102ee2:	c3                   	ret    

80102ee3 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ee3:	55                   	push   %ebp
80102ee4:	89 e5                	mov    %esp,%ebp
80102ee6:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102ee9:	a1 7c 22 11 80       	mov    0x8011227c,%eax
80102eee:	85 c0                	test   %eax,%eax
80102ef0:	74 14                	je     80102f06 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102ef2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ef9:	00 
80102efa:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f01:	e8 0b fe ff ff       	call   80102d11 <lapicw>
}
80102f06:	c9                   	leave  
80102f07:	c3                   	ret    

80102f08 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f08:	55                   	push   %ebp
80102f09:	89 e5                	mov    %esp,%ebp
}
80102f0b:	5d                   	pop    %ebp
80102f0c:	c3                   	ret    

80102f0d <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f0d:	55                   	push   %ebp
80102f0e:	89 e5                	mov    %esp,%ebp
80102f10:	83 ec 1c             	sub    $0x1c,%esp
80102f13:	8b 45 08             	mov    0x8(%ebp),%eax
80102f16:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f19:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f20:	00 
80102f21:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f28:	e8 b6 fd ff ff       	call   80102ce3 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102f2d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f34:	00 
80102f35:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f3c:	e8 a2 fd ff ff       	call   80102ce3 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f41:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f48:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f4b:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f50:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f53:	8d 50 02             	lea    0x2(%eax),%edx
80102f56:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f59:	c1 e8 04             	shr    $0x4,%eax
80102f5c:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f5f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f63:	c1 e0 18             	shl    $0x18,%eax
80102f66:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f6a:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f71:	e8 9b fd ff ff       	call   80102d11 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f76:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f7d:	00 
80102f7e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f85:	e8 87 fd ff ff       	call   80102d11 <lapicw>
  microdelay(200);
80102f8a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f91:	e8 72 ff ff ff       	call   80102f08 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f96:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f9d:	00 
80102f9e:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fa5:	e8 67 fd ff ff       	call   80102d11 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102faa:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fb1:	e8 52 ff ff ff       	call   80102f08 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102fbd:	eb 40                	jmp    80102fff <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fbf:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fc3:	c1 e0 18             	shl    $0x18,%eax
80102fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fca:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fd1:	e8 3b fd ff ff       	call   80102d11 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fd9:	c1 e8 0c             	shr    $0xc,%eax
80102fdc:	80 cc 06             	or     $0x6,%ah
80102fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fe3:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fea:	e8 22 fd ff ff       	call   80102d11 <lapicw>
    microdelay(200);
80102fef:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102ff6:	e8 0d ff ff ff       	call   80102f08 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102ffb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102fff:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103003:	7e ba                	jle    80102fbf <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103005:	c9                   	leave  
80103006:	c3                   	ret    

80103007 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103007:	55                   	push   %ebp
80103008:	89 e5                	mov    %esp,%ebp
8010300a:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
8010300d:	8b 45 08             	mov    0x8(%ebp),%eax
80103010:	0f b6 c0             	movzbl %al,%eax
80103013:	89 44 24 04          	mov    %eax,0x4(%esp)
80103017:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010301e:	e8 c0 fc ff ff       	call   80102ce3 <outb>
  microdelay(200);
80103023:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010302a:	e8 d9 fe ff ff       	call   80102f08 <microdelay>

  return inb(CMOS_RETURN);
8010302f:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103036:	e8 8b fc ff ff       	call   80102cc6 <inb>
8010303b:	0f b6 c0             	movzbl %al,%eax
}
8010303e:	c9                   	leave  
8010303f:	c3                   	ret    

80103040 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103046:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010304d:	e8 b5 ff ff ff       	call   80103007 <cmos_read>
80103052:	8b 55 08             	mov    0x8(%ebp),%edx
80103055:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103057:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010305e:	e8 a4 ff ff ff       	call   80103007 <cmos_read>
80103063:	8b 55 08             	mov    0x8(%ebp),%edx
80103066:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103069:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80103070:	e8 92 ff ff ff       	call   80103007 <cmos_read>
80103075:	8b 55 08             	mov    0x8(%ebp),%edx
80103078:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010307b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103082:	e8 80 ff ff ff       	call   80103007 <cmos_read>
80103087:	8b 55 08             	mov    0x8(%ebp),%edx
8010308a:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010308d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103094:	e8 6e ff ff ff       	call   80103007 <cmos_read>
80103099:	8b 55 08             	mov    0x8(%ebp),%edx
8010309c:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010309f:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801030a6:	e8 5c ff ff ff       	call   80103007 <cmos_read>
801030ab:	8b 55 08             	mov    0x8(%ebp),%edx
801030ae:	89 42 14             	mov    %eax,0x14(%edx)
}
801030b1:	c9                   	leave  
801030b2:	c3                   	ret    

801030b3 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801030b3:	55                   	push   %ebp
801030b4:	89 e5                	mov    %esp,%ebp
801030b6:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801030b9:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801030c0:	e8 42 ff ff ff       	call   80103007 <cmos_read>
801030c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030cb:	83 e0 04             	and    $0x4,%eax
801030ce:	85 c0                	test   %eax,%eax
801030d0:	0f 94 c0             	sete   %al
801030d3:	0f b6 c0             	movzbl %al,%eax
801030d6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801030d9:	8d 45 d8             	lea    -0x28(%ebp),%eax
801030dc:	89 04 24             	mov    %eax,(%esp)
801030df:	e8 5c ff ff ff       	call   80103040 <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801030e4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801030eb:	e8 17 ff ff ff       	call   80103007 <cmos_read>
801030f0:	25 80 00 00 00       	and    $0x80,%eax
801030f5:	85 c0                	test   %eax,%eax
801030f7:	74 02                	je     801030fb <cmostime+0x48>
        continue;
801030f9:	eb 36                	jmp    80103131 <cmostime+0x7e>
    fill_rtcdate(&t2);
801030fb:	8d 45 c0             	lea    -0x40(%ebp),%eax
801030fe:	89 04 24             	mov    %eax,(%esp)
80103101:	e8 3a ff ff ff       	call   80103040 <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103106:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010310d:	00 
8010310e:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103111:	89 44 24 04          	mov    %eax,0x4(%esp)
80103115:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103118:	89 04 24             	mov    %eax,(%esp)
8010311b:	e8 e9 22 00 00       	call   80105409 <memcmp>
80103120:	85 c0                	test   %eax,%eax
80103122:	75 0d                	jne    80103131 <cmostime+0x7e>
      break;
80103124:	90                   	nop
  }

  // convert
  if (bcd) {
80103125:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103129:	0f 84 ac 00 00 00    	je     801031db <cmostime+0x128>
8010312f:	eb 02                	jmp    80103133 <cmostime+0x80>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103131:	eb a6                	jmp    801030d9 <cmostime+0x26>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103133:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103136:	c1 e8 04             	shr    $0x4,%eax
80103139:	89 c2                	mov    %eax,%edx
8010313b:	89 d0                	mov    %edx,%eax
8010313d:	c1 e0 02             	shl    $0x2,%eax
80103140:	01 d0                	add    %edx,%eax
80103142:	01 c0                	add    %eax,%eax
80103144:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103147:	83 e2 0f             	and    $0xf,%edx
8010314a:	01 d0                	add    %edx,%eax
8010314c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
8010314f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103152:	c1 e8 04             	shr    $0x4,%eax
80103155:	89 c2                	mov    %eax,%edx
80103157:	89 d0                	mov    %edx,%eax
80103159:	c1 e0 02             	shl    $0x2,%eax
8010315c:	01 d0                	add    %edx,%eax
8010315e:	01 c0                	add    %eax,%eax
80103160:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103163:	83 e2 0f             	and    $0xf,%edx
80103166:	01 d0                	add    %edx,%eax
80103168:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010316b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010316e:	c1 e8 04             	shr    $0x4,%eax
80103171:	89 c2                	mov    %eax,%edx
80103173:	89 d0                	mov    %edx,%eax
80103175:	c1 e0 02             	shl    $0x2,%eax
80103178:	01 d0                	add    %edx,%eax
8010317a:	01 c0                	add    %eax,%eax
8010317c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010317f:	83 e2 0f             	and    $0xf,%edx
80103182:	01 d0                	add    %edx,%eax
80103184:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010318a:	c1 e8 04             	shr    $0x4,%eax
8010318d:	89 c2                	mov    %eax,%edx
8010318f:	89 d0                	mov    %edx,%eax
80103191:	c1 e0 02             	shl    $0x2,%eax
80103194:	01 d0                	add    %edx,%eax
80103196:	01 c0                	add    %eax,%eax
80103198:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010319b:	83 e2 0f             	and    $0xf,%edx
8010319e:	01 d0                	add    %edx,%eax
801031a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801031a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031a6:	c1 e8 04             	shr    $0x4,%eax
801031a9:	89 c2                	mov    %eax,%edx
801031ab:	89 d0                	mov    %edx,%eax
801031ad:	c1 e0 02             	shl    $0x2,%eax
801031b0:	01 d0                	add    %edx,%eax
801031b2:	01 c0                	add    %eax,%eax
801031b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031b7:	83 e2 0f             	and    $0xf,%edx
801031ba:	01 d0                	add    %edx,%eax
801031bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801031bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031c2:	c1 e8 04             	shr    $0x4,%eax
801031c5:	89 c2                	mov    %eax,%edx
801031c7:	89 d0                	mov    %edx,%eax
801031c9:	c1 e0 02             	shl    $0x2,%eax
801031cc:	01 d0                	add    %edx,%eax
801031ce:	01 c0                	add    %eax,%eax
801031d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801031d3:	83 e2 0f             	and    $0xf,%edx
801031d6:	01 d0                	add    %edx,%eax
801031d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801031db:	8b 45 08             	mov    0x8(%ebp),%eax
801031de:	8b 55 d8             	mov    -0x28(%ebp),%edx
801031e1:	89 10                	mov    %edx,(%eax)
801031e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801031e6:	89 50 04             	mov    %edx,0x4(%eax)
801031e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031ec:	89 50 08             	mov    %edx,0x8(%eax)
801031ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031f2:	89 50 0c             	mov    %edx,0xc(%eax)
801031f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031f8:	89 50 10             	mov    %edx,0x10(%eax)
801031fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801031fe:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103201:	8b 45 08             	mov    0x8(%ebp),%eax
80103204:	8b 40 14             	mov    0x14(%eax),%eax
80103207:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010320d:	8b 45 08             	mov    0x8(%ebp),%eax
80103210:	89 50 14             	mov    %edx,0x14(%eax)
}
80103213:	c9                   	leave  
80103214:	c3                   	ret    

80103215 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
80103215:	55                   	push   %ebp
80103216:	89 e5                	mov    %esp,%ebp
80103218:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010321b:	c7 44 24 04 54 8a 10 	movl   $0x80108a54,0x4(%esp)
80103222:	80 
80103223:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
8010322a:	e8 ee 1e 00 00       	call   8010511d <initlock>
  readsb(ROOTDEV, &sb);
8010322f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103232:	89 44 24 04          	mov    %eax,0x4(%esp)
80103236:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010323d:	e8 c0 e0 ff ff       	call   80101302 <readsb>
  log.start = sb.size - sb.nlog;
80103242:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103245:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103248:	29 c2                	sub    %eax,%edx
8010324a:	89 d0                	mov    %edx,%eax
8010324c:	a3 b4 22 11 80       	mov    %eax,0x801122b4
  log.size = sb.nlog;
80103251:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103254:	a3 b8 22 11 80       	mov    %eax,0x801122b8
  log.dev = ROOTDEV;
80103259:	c7 05 c4 22 11 80 01 	movl   $0x1,0x801122c4
80103260:	00 00 00 
  recover_from_log();
80103263:	e8 9a 01 00 00       	call   80103402 <recover_from_log>
}
80103268:	c9                   	leave  
80103269:	c3                   	ret    

8010326a <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010326a:	55                   	push   %ebp
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103277:	e9 8c 00 00 00       	jmp    80103308 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010327c:	8b 15 b4 22 11 80    	mov    0x801122b4,%edx
80103282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103285:	01 d0                	add    %edx,%eax
80103287:	83 c0 01             	add    $0x1,%eax
8010328a:	89 c2                	mov    %eax,%edx
8010328c:	a1 c4 22 11 80       	mov    0x801122c4,%eax
80103291:	89 54 24 04          	mov    %edx,0x4(%esp)
80103295:	89 04 24             	mov    %eax,(%esp)
80103298:	e8 09 cf ff ff       	call   801001a6 <bread>
8010329d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032a3:	83 c0 10             	add    $0x10,%eax
801032a6:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
801032ad:	89 c2                	mov    %eax,%edx
801032af:	a1 c4 22 11 80       	mov    0x801122c4,%eax
801032b4:	89 54 24 04          	mov    %edx,0x4(%esp)
801032b8:	89 04 24             	mov    %eax,(%esp)
801032bb:	e8 e6 ce ff ff       	call   801001a6 <bread>
801032c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032c6:	8d 50 18             	lea    0x18(%eax),%edx
801032c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032cc:	83 c0 18             	add    $0x18,%eax
801032cf:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801032d6:	00 
801032d7:	89 54 24 04          	mov    %edx,0x4(%esp)
801032db:	89 04 24             	mov    %eax,(%esp)
801032de:	e8 7e 21 00 00       	call   80105461 <memmove>
    bwrite(dbuf);  // write dst to disk
801032e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032e6:	89 04 24             	mov    %eax,(%esp)
801032e9:	e8 ef ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801032ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032f1:	89 04 24             	mov    %eax,(%esp)
801032f4:	e8 1e cf ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801032f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032fc:	89 04 24             	mov    %eax,(%esp)
801032ff:	e8 13 cf ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103304:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103308:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010330d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103310:	0f 8f 66 ff ff ff    	jg     8010327c <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103316:	c9                   	leave  
80103317:	c3                   	ret    

80103318 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103318:	55                   	push   %ebp
80103319:	89 e5                	mov    %esp,%ebp
8010331b:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010331e:	a1 b4 22 11 80       	mov    0x801122b4,%eax
80103323:	89 c2                	mov    %eax,%edx
80103325:	a1 c4 22 11 80       	mov    0x801122c4,%eax
8010332a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010332e:	89 04 24             	mov    %eax,(%esp)
80103331:	e8 70 ce ff ff       	call   801001a6 <bread>
80103336:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103339:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010333c:	83 c0 18             	add    $0x18,%eax
8010333f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103342:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103345:	8b 00                	mov    (%eax),%eax
80103347:	a3 c8 22 11 80       	mov    %eax,0x801122c8
  for (i = 0; i < log.lh.n; i++) {
8010334c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103353:	eb 1b                	jmp    80103370 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103355:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103358:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010335b:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010335f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103362:	83 c2 10             	add    $0x10,%edx
80103365:	89 04 95 8c 22 11 80 	mov    %eax,-0x7feedd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010336c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103370:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103375:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103378:	7f db                	jg     80103355 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
8010337a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010337d:	89 04 24             	mov    %eax,(%esp)
80103380:	e8 92 ce ff ff       	call   80100217 <brelse>
}
80103385:	c9                   	leave  
80103386:	c3                   	ret    

80103387 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103387:	55                   	push   %ebp
80103388:	89 e5                	mov    %esp,%ebp
8010338a:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010338d:	a1 b4 22 11 80       	mov    0x801122b4,%eax
80103392:	89 c2                	mov    %eax,%edx
80103394:	a1 c4 22 11 80       	mov    0x801122c4,%eax
80103399:	89 54 24 04          	mov    %edx,0x4(%esp)
8010339d:	89 04 24             	mov    %eax,(%esp)
801033a0:	e8 01 ce ff ff       	call   801001a6 <bread>
801033a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801033a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033ab:	83 c0 18             	add    $0x18,%eax
801033ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801033b1:	8b 15 c8 22 11 80    	mov    0x801122c8,%edx
801033b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033ba:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801033bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033c3:	eb 1b                	jmp    801033e0 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033c8:	83 c0 10             	add    $0x10,%eax
801033cb:	8b 0c 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%ecx
801033d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033d8:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801033dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033e0:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801033e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033e8:	7f db                	jg     801033c5 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801033ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033ed:	89 04 24             	mov    %eax,(%esp)
801033f0:	e8 e8 cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
801033f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033f8:	89 04 24             	mov    %eax,(%esp)
801033fb:	e8 17 ce ff ff       	call   80100217 <brelse>
}
80103400:	c9                   	leave  
80103401:	c3                   	ret    

80103402 <recover_from_log>:

static void
recover_from_log(void)
{
80103402:	55                   	push   %ebp
80103403:	89 e5                	mov    %esp,%ebp
80103405:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103408:	e8 0b ff ff ff       	call   80103318 <read_head>
  install_trans(); // if committed, copy from log to disk
8010340d:	e8 58 fe ff ff       	call   8010326a <install_trans>
  log.lh.n = 0;
80103412:	c7 05 c8 22 11 80 00 	movl   $0x0,0x801122c8
80103419:	00 00 00 
  write_head(); // clear the log
8010341c:	e8 66 ff ff ff       	call   80103387 <write_head>
}
80103421:	c9                   	leave  
80103422:	c3                   	ret    

80103423 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103423:	55                   	push   %ebp
80103424:	89 e5                	mov    %esp,%ebp
80103426:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103429:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
80103430:	e8 09 1d 00 00       	call   8010513e <acquire>
  while(1){
    if(log.committing){
80103435:	a1 c0 22 11 80       	mov    0x801122c0,%eax
8010343a:	85 c0                	test   %eax,%eax
8010343c:	74 16                	je     80103454 <begin_op+0x31>
      sleep(&log, &log.lock);
8010343e:	c7 44 24 04 80 22 11 	movl   $0x80112280,0x4(%esp)
80103445:	80 
80103446:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
8010344d:	e8 08 1a 00 00       	call   80104e5a <sleep>
80103452:	eb 4f                	jmp    801034a3 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103454:	8b 0d c8 22 11 80    	mov    0x801122c8,%ecx
8010345a:	a1 bc 22 11 80       	mov    0x801122bc,%eax
8010345f:	8d 50 01             	lea    0x1(%eax),%edx
80103462:	89 d0                	mov    %edx,%eax
80103464:	c1 e0 02             	shl    $0x2,%eax
80103467:	01 d0                	add    %edx,%eax
80103469:	01 c0                	add    %eax,%eax
8010346b:	01 c8                	add    %ecx,%eax
8010346d:	83 f8 1e             	cmp    $0x1e,%eax
80103470:	7e 16                	jle    80103488 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103472:	c7 44 24 04 80 22 11 	movl   $0x80112280,0x4(%esp)
80103479:	80 
8010347a:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
80103481:	e8 d4 19 00 00       	call   80104e5a <sleep>
80103486:	eb 1b                	jmp    801034a3 <begin_op+0x80>
    } else {
      log.outstanding += 1;
80103488:	a1 bc 22 11 80       	mov    0x801122bc,%eax
8010348d:	83 c0 01             	add    $0x1,%eax
80103490:	a3 bc 22 11 80       	mov    %eax,0x801122bc
      release(&log.lock);
80103495:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
8010349c:	e8 ff 1c 00 00       	call   801051a0 <release>
      break;
801034a1:	eb 02                	jmp    801034a5 <begin_op+0x82>
    }
  }
801034a3:	eb 90                	jmp    80103435 <begin_op+0x12>
}
801034a5:	c9                   	leave  
801034a6:	c3                   	ret    

801034a7 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034a7:	55                   	push   %ebp
801034a8:	89 e5                	mov    %esp,%ebp
801034aa:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801034ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801034b4:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
801034bb:	e8 7e 1c 00 00       	call   8010513e <acquire>
  log.outstanding -= 1;
801034c0:	a1 bc 22 11 80       	mov    0x801122bc,%eax
801034c5:	83 e8 01             	sub    $0x1,%eax
801034c8:	a3 bc 22 11 80       	mov    %eax,0x801122bc
  if(log.committing)
801034cd:	a1 c0 22 11 80       	mov    0x801122c0,%eax
801034d2:	85 c0                	test   %eax,%eax
801034d4:	74 0c                	je     801034e2 <end_op+0x3b>
    panic("log.committing");
801034d6:	c7 04 24 58 8a 10 80 	movl   $0x80108a58,(%esp)
801034dd:	e8 58 d0 ff ff       	call   8010053a <panic>
  if(log.outstanding == 0){
801034e2:	a1 bc 22 11 80       	mov    0x801122bc,%eax
801034e7:	85 c0                	test   %eax,%eax
801034e9:	75 13                	jne    801034fe <end_op+0x57>
    do_commit = 1;
801034eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801034f2:	c7 05 c0 22 11 80 01 	movl   $0x1,0x801122c0
801034f9:	00 00 00 
801034fc:	eb 0c                	jmp    8010350a <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801034fe:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
80103505:	e8 35 1a 00 00       	call   80104f3f <wakeup>
  }
  release(&log.lock);
8010350a:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
80103511:	e8 8a 1c 00 00       	call   801051a0 <release>

  if(do_commit){
80103516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010351a:	74 33                	je     8010354f <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010351c:	e8 de 00 00 00       	call   801035ff <commit>
    acquire(&log.lock);
80103521:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
80103528:	e8 11 1c 00 00       	call   8010513e <acquire>
    log.committing = 0;
8010352d:	c7 05 c0 22 11 80 00 	movl   $0x0,0x801122c0
80103534:	00 00 00 
    wakeup(&log);
80103537:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
8010353e:	e8 fc 19 00 00       	call   80104f3f <wakeup>
    release(&log.lock);
80103543:	c7 04 24 80 22 11 80 	movl   $0x80112280,(%esp)
8010354a:	e8 51 1c 00 00       	call   801051a0 <release>
  }
}
8010354f:	c9                   	leave  
80103550:	c3                   	ret    

80103551 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103551:	55                   	push   %ebp
80103552:	89 e5                	mov    %esp,%ebp
80103554:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010355e:	e9 8c 00 00 00       	jmp    801035ef <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103563:	8b 15 b4 22 11 80    	mov    0x801122b4,%edx
80103569:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010356c:	01 d0                	add    %edx,%eax
8010356e:	83 c0 01             	add    $0x1,%eax
80103571:	89 c2                	mov    %eax,%edx
80103573:	a1 c4 22 11 80       	mov    0x801122c4,%eax
80103578:	89 54 24 04          	mov    %edx,0x4(%esp)
8010357c:	89 04 24             	mov    %eax,(%esp)
8010357f:	e8 22 cc ff ff       	call   801001a6 <bread>
80103584:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
80103587:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010358a:	83 c0 10             	add    $0x10,%eax
8010358d:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
80103594:	89 c2                	mov    %eax,%edx
80103596:	a1 c4 22 11 80       	mov    0x801122c4,%eax
8010359b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010359f:	89 04 24             	mov    %eax,(%esp)
801035a2:	e8 ff cb ff ff       	call   801001a6 <bread>
801035a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801035aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ad:	8d 50 18             	lea    0x18(%eax),%edx
801035b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035b3:	83 c0 18             	add    $0x18,%eax
801035b6:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801035bd:	00 
801035be:	89 54 24 04          	mov    %edx,0x4(%esp)
801035c2:	89 04 24             	mov    %eax,(%esp)
801035c5:	e8 97 1e 00 00       	call   80105461 <memmove>
    bwrite(to);  // write the log
801035ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035cd:	89 04 24             	mov    %eax,(%esp)
801035d0:	e8 08 cc ff ff       	call   801001dd <bwrite>
    brelse(from); 
801035d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035d8:	89 04 24             	mov    %eax,(%esp)
801035db:	e8 37 cc ff ff       	call   80100217 <brelse>
    brelse(to);
801035e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035e3:	89 04 24             	mov    %eax,(%esp)
801035e6:	e8 2c cc ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035ef:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801035f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035f7:	0f 8f 66 ff ff ff    	jg     80103563 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801035fd:	c9                   	leave  
801035fe:	c3                   	ret    

801035ff <commit>:

static void
commit()
{
801035ff:	55                   	push   %ebp
80103600:	89 e5                	mov    %esp,%ebp
80103602:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103605:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010360a:	85 c0                	test   %eax,%eax
8010360c:	7e 1e                	jle    8010362c <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010360e:	e8 3e ff ff ff       	call   80103551 <write_log>
    write_head();    // Write header to disk -- the real commit
80103613:	e8 6f fd ff ff       	call   80103387 <write_head>
    install_trans(); // Now install writes to home locations
80103618:	e8 4d fc ff ff       	call   8010326a <install_trans>
    log.lh.n = 0; 
8010361d:	c7 05 c8 22 11 80 00 	movl   $0x0,0x801122c8
80103624:	00 00 00 
    write_head();    // Erase the transaction from the log
80103627:	e8 5b fd ff ff       	call   80103387 <write_head>
  }
}
8010362c:	c9                   	leave  
8010362d:	c3                   	ret    

8010362e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010362e:	55                   	push   %ebp
8010362f:	89 e5                	mov    %esp,%ebp
80103631:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103634:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103639:	83 f8 1d             	cmp    $0x1d,%eax
8010363c:	7f 12                	jg     80103650 <log_write+0x22>
8010363e:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103643:	8b 15 b8 22 11 80    	mov    0x801122b8,%edx
80103649:	83 ea 01             	sub    $0x1,%edx
8010364c:	39 d0                	cmp    %edx,%eax
8010364e:	7c 0c                	jl     8010365c <log_write+0x2e>
    panic("too big a transaction");
80103650:	c7 04 24 67 8a 10 80 	movl   $0x80108a67,(%esp)
80103657:	e8 de ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
8010365c:	a1 bc 22 11 80       	mov    0x801122bc,%eax
80103661:	85 c0                	test   %eax,%eax
80103663:	7f 0c                	jg     80103671 <log_write+0x43>
    panic("log_write outside of trans");
80103665:	c7 04 24 7d 8a 10 80 	movl   $0x80108a7d,(%esp)
8010366c:	e8 c9 ce ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
80103671:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103678:	eb 1f                	jmp    80103699 <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
8010367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010367d:	83 c0 10             	add    $0x10,%eax
80103680:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
80103687:	89 c2                	mov    %eax,%edx
80103689:	8b 45 08             	mov    0x8(%ebp),%eax
8010368c:	8b 40 08             	mov    0x8(%eax),%eax
8010368f:	39 c2                	cmp    %eax,%edx
80103691:	75 02                	jne    80103695 <log_write+0x67>
      break;
80103693:	eb 0e                	jmp    801036a3 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103695:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103699:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010369e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036a1:	7f d7                	jg     8010367a <log_write+0x4c>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
  }
  log.lh.sector[i] = b->sector;
801036a3:	8b 45 08             	mov    0x8(%ebp),%eax
801036a6:	8b 40 08             	mov    0x8(%eax),%eax
801036a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036ac:	83 c2 10             	add    $0x10,%edx
801036af:	89 04 95 8c 22 11 80 	mov    %eax,-0x7feedd74(,%edx,4)
  if (i == log.lh.n)
801036b6:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801036bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036be:	75 0d                	jne    801036cd <log_write+0x9f>
    log.lh.n++;
801036c0:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801036c5:	83 c0 01             	add    $0x1,%eax
801036c8:	a3 c8 22 11 80       	mov    %eax,0x801122c8
  b->flags |= B_DIRTY; // prevent eviction
801036cd:	8b 45 08             	mov    0x8(%ebp),%eax
801036d0:	8b 00                	mov    (%eax),%eax
801036d2:	83 c8 04             	or     $0x4,%eax
801036d5:	89 c2                	mov    %eax,%edx
801036d7:	8b 45 08             	mov    0x8(%ebp),%eax
801036da:	89 10                	mov    %edx,(%eax)
}
801036dc:	c9                   	leave  
801036dd:	c3                   	ret    

801036de <v2p>:
801036de:	55                   	push   %ebp
801036df:	89 e5                	mov    %esp,%ebp
801036e1:	8b 45 08             	mov    0x8(%ebp),%eax
801036e4:	05 00 00 00 80       	add    $0x80000000,%eax
801036e9:	5d                   	pop    %ebp
801036ea:	c3                   	ret    

801036eb <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801036eb:	55                   	push   %ebp
801036ec:	89 e5                	mov    %esp,%ebp
801036ee:	8b 45 08             	mov    0x8(%ebp),%eax
801036f1:	05 00 00 00 80       	add    $0x80000000,%eax
801036f6:	5d                   	pop    %ebp
801036f7:	c3                   	ret    

801036f8 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801036f8:	55                   	push   %ebp
801036f9:	89 e5                	mov    %esp,%ebp
801036fb:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801036fe:	8b 55 08             	mov    0x8(%ebp),%edx
80103701:	8b 45 0c             	mov    0xc(%ebp),%eax
80103704:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103707:	f0 87 02             	lock xchg %eax,(%edx)
8010370a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010370d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103710:	c9                   	leave  
80103711:	c3                   	ret    

80103712 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103712:	55                   	push   %ebp
80103713:	89 e5                	mov    %esp,%ebp
80103715:	83 e4 f0             	and    $0xfffffff0,%esp
80103718:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010371b:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103722:	80 
80103723:	c7 04 24 5c 54 11 80 	movl   $0x8011545c,(%esp)
8010372a:	e8 98 f2 ff ff       	call   801029c7 <kinit1>
  kvmalloc();      // kernel page table
8010372f:	e8 69 49 00 00       	call   8010809d <kvmalloc>
  mpinit();        // collect info about this machine
80103734:	e8 46 04 00 00       	call   80103b7f <mpinit>
  lapicinit();
80103739:	e8 f4 f5 ff ff       	call   80102d32 <lapicinit>
  seginit();       // set up segments
8010373e:	e8 ed 42 00 00       	call   80107a30 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103743:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103749:	0f b6 00             	movzbl (%eax),%eax
8010374c:	0f b6 c0             	movzbl %al,%eax
8010374f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103753:	c7 04 24 98 8a 10 80 	movl   $0x80108a98,(%esp)
8010375a:	e8 41 cc ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
8010375f:	e8 79 06 00 00       	call   80103ddd <picinit>
  ioapicinit();    // another interrupt controller
80103764:	e8 54 f1 ff ff       	call   801028bd <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103769:	e8 15 d3 ff ff       	call   80100a83 <consoleinit>
  uartinit();      // serial port
8010376e:	e8 0c 36 00 00       	call   80106d7f <uartinit>
  pinit();         // process table
80103773:	e8 7e 0c 00 00       	call   801043f6 <pinit>
  tvinit();        // trap vectors
80103778:	e8 1a 31 00 00       	call   80106897 <tvinit>
  binit();         // buffer cache
8010377d:	e8 b2 c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103782:	e8 94 d7 ff ff       	call   80100f1b <fileinit>
  iinit();         // inode cache
80103787:	e8 29 de ff ff       	call   801015b5 <iinit>
  ideinit();       // disk
8010378c:	e8 95 ed ff ff       	call   80102526 <ideinit>
  if(!ismp)
80103791:	a1 64 23 11 80       	mov    0x80112364,%eax
80103796:	85 c0                	test   %eax,%eax
80103798:	75 05                	jne    8010379f <main+0x8d>
    timerinit();   // uniprocessor timer
8010379a:	e8 43 30 00 00       	call   801067e2 <timerinit>
  startothers();   // start other processors
8010379f:	e8 7f 00 00 00       	call   80103823 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037a4:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037ab:	8e 
801037ac:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037b3:	e8 47 f2 ff ff       	call   801029ff <kinit2>
  userinit();      // first user process
801037b8:	e8 7c 0e 00 00       	call   80104639 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801037bd:	e8 1a 00 00 00       	call   801037dc <mpmain>

801037c2 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801037c2:	55                   	push   %ebp
801037c3:	89 e5                	mov    %esp,%ebp
801037c5:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801037c8:	e8 e7 48 00 00       	call   801080b4 <switchkvm>
  seginit();
801037cd:	e8 5e 42 00 00       	call   80107a30 <seginit>
  lapicinit();
801037d2:	e8 5b f5 ff ff       	call   80102d32 <lapicinit>
  mpmain();
801037d7:	e8 00 00 00 00       	call   801037dc <mpmain>

801037dc <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037dc:	55                   	push   %ebp
801037dd:	89 e5                	mov    %esp,%ebp
801037df:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801037e2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801037e8:	0f b6 00             	movzbl (%eax),%eax
801037eb:	0f b6 c0             	movzbl %al,%eax
801037ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801037f2:	c7 04 24 af 8a 10 80 	movl   $0x80108aaf,(%esp)
801037f9:	e8 a2 cb ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
801037fe:	e8 08 32 00 00       	call   80106a0b <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103803:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103809:	05 a8 00 00 00       	add    $0xa8,%eax
8010380e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103815:	00 
80103816:	89 04 24             	mov    %eax,(%esp)
80103819:	e8 da fe ff ff       	call   801036f8 <xchg>
  scheduler();     // start running processes
8010381e:	e8 8a 14 00 00       	call   80104cad <scheduler>

80103823 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103823:	55                   	push   %ebp
80103824:	89 e5                	mov    %esp,%ebp
80103826:	53                   	push   %ebx
80103827:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010382a:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103831:	e8 b5 fe ff ff       	call   801036eb <p2v>
80103836:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103839:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010383e:	89 44 24 08          	mov    %eax,0x8(%esp)
80103842:	c7 44 24 04 2c b5 10 	movl   $0x8010b52c,0x4(%esp)
80103849:	80 
8010384a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010384d:	89 04 24             	mov    %eax,(%esp)
80103850:	e8 0c 1c 00 00       	call   80105461 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103855:	c7 45 f4 80 23 11 80 	movl   $0x80112380,-0xc(%ebp)
8010385c:	e9 85 00 00 00       	jmp    801038e6 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
80103861:	e8 25 f6 ff ff       	call   80102e8b <cpunum>
80103866:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010386c:	05 80 23 11 80       	add    $0x80112380,%eax
80103871:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103874:	75 02                	jne    80103878 <startothers+0x55>
      continue;
80103876:	eb 67                	jmp    801038df <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103878:	e8 78 f2 ff ff       	call   80102af5 <kalloc>
8010387d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103880:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103883:	83 e8 04             	sub    $0x4,%eax
80103886:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103889:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010388f:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103891:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103894:	83 e8 08             	sub    $0x8,%eax
80103897:	c7 00 c2 37 10 80    	movl   $0x801037c2,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010389d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a0:	8d 58 f4             	lea    -0xc(%eax),%ebx
801038a3:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
801038aa:	e8 2f fe ff ff       	call   801036de <v2p>
801038af:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801038b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038b4:	89 04 24             	mov    %eax,(%esp)
801038b7:	e8 22 fe ff ff       	call   801036de <v2p>
801038bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038bf:	0f b6 12             	movzbl (%edx),%edx
801038c2:	0f b6 d2             	movzbl %dl,%edx
801038c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801038c9:	89 14 24             	mov    %edx,(%esp)
801038cc:	e8 3c f6 ff ff       	call   80102f0d <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801038d1:	90                   	nop
801038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801038db:	85 c0                	test   %eax,%eax
801038dd:	74 f3                	je     801038d2 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801038df:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801038e6:	a1 60 29 11 80       	mov    0x80112960,%eax
801038eb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801038f1:	05 80 23 11 80       	add    $0x80112380,%eax
801038f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038f9:	0f 87 62 ff ff ff    	ja     80103861 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801038ff:	83 c4 24             	add    $0x24,%esp
80103902:	5b                   	pop    %ebx
80103903:	5d                   	pop    %ebp
80103904:	c3                   	ret    

80103905 <p2v>:
80103905:	55                   	push   %ebp
80103906:	89 e5                	mov    %esp,%ebp
80103908:	8b 45 08             	mov    0x8(%ebp),%eax
8010390b:	05 00 00 00 80       	add    $0x80000000,%eax
80103910:	5d                   	pop    %ebp
80103911:	c3                   	ret    

80103912 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103912:	55                   	push   %ebp
80103913:	89 e5                	mov    %esp,%ebp
80103915:	83 ec 14             	sub    $0x14,%esp
80103918:	8b 45 08             	mov    0x8(%ebp),%eax
8010391b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010391f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103923:	89 c2                	mov    %eax,%edx
80103925:	ec                   	in     (%dx),%al
80103926:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103929:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010392d:	c9                   	leave  
8010392e:	c3                   	ret    

8010392f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010392f:	55                   	push   %ebp
80103930:	89 e5                	mov    %esp,%ebp
80103932:	83 ec 08             	sub    $0x8,%esp
80103935:	8b 55 08             	mov    0x8(%ebp),%edx
80103938:	8b 45 0c             	mov    0xc(%ebp),%eax
8010393b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010393f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103942:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103946:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010394a:	ee                   	out    %al,(%dx)
}
8010394b:	c9                   	leave  
8010394c:	c3                   	ret    

8010394d <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
8010394d:	55                   	push   %ebp
8010394e:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103950:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80103955:	89 c2                	mov    %eax,%edx
80103957:	b8 80 23 11 80       	mov    $0x80112380,%eax
8010395c:	29 c2                	sub    %eax,%edx
8010395e:	89 d0                	mov    %edx,%eax
80103960:	c1 f8 02             	sar    $0x2,%eax
80103963:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103969:	5d                   	pop    %ebp
8010396a:	c3                   	ret    

8010396b <sum>:

static uchar
sum(uchar *addr, int len)
{
8010396b:	55                   	push   %ebp
8010396c:	89 e5                	mov    %esp,%ebp
8010396e:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103971:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103978:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010397f:	eb 15                	jmp    80103996 <sum+0x2b>
    sum += addr[i];
80103981:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103984:	8b 45 08             	mov    0x8(%ebp),%eax
80103987:	01 d0                	add    %edx,%eax
80103989:	0f b6 00             	movzbl (%eax),%eax
8010398c:	0f b6 c0             	movzbl %al,%eax
8010398f:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103992:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103996:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103999:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010399c:	7c e3                	jl     80103981 <sum+0x16>
    sum += addr[i];
  return sum;
8010399e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801039a1:	c9                   	leave  
801039a2:	c3                   	ret    

801039a3 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039a3:	55                   	push   %ebp
801039a4:	89 e5                	mov    %esp,%ebp
801039a6:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801039a9:	8b 45 08             	mov    0x8(%ebp),%eax
801039ac:	89 04 24             	mov    %eax,(%esp)
801039af:	e8 51 ff ff ff       	call   80103905 <p2v>
801039b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801039b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801039ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039bd:	01 d0                	add    %edx,%eax
801039bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801039c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039c8:	eb 3f                	jmp    80103a09 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039ca:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801039d1:	00 
801039d2:	c7 44 24 04 c0 8a 10 	movl   $0x80108ac0,0x4(%esp)
801039d9:	80 
801039da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039dd:	89 04 24             	mov    %eax,(%esp)
801039e0:	e8 24 1a 00 00       	call   80105409 <memcmp>
801039e5:	85 c0                	test   %eax,%eax
801039e7:	75 1c                	jne    80103a05 <mpsearch1+0x62>
801039e9:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801039f0:	00 
801039f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f4:	89 04 24             	mov    %eax,(%esp)
801039f7:	e8 6f ff ff ff       	call   8010396b <sum>
801039fc:	84 c0                	test   %al,%al
801039fe:	75 05                	jne    80103a05 <mpsearch1+0x62>
      return (struct mp*)p;
80103a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a03:	eb 11                	jmp    80103a16 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a05:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a0c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a0f:	72 b9                	jb     801039ca <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103a11:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a16:	c9                   	leave  
80103a17:	c3                   	ret    

80103a18 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a18:	55                   	push   %ebp
80103a19:	89 e5                	mov    %esp,%ebp
80103a1b:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a1e:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a28:	83 c0 0f             	add    $0xf,%eax
80103a2b:	0f b6 00             	movzbl (%eax),%eax
80103a2e:	0f b6 c0             	movzbl %al,%eax
80103a31:	c1 e0 08             	shl    $0x8,%eax
80103a34:	89 c2                	mov    %eax,%edx
80103a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a39:	83 c0 0e             	add    $0xe,%eax
80103a3c:	0f b6 00             	movzbl (%eax),%eax
80103a3f:	0f b6 c0             	movzbl %al,%eax
80103a42:	09 d0                	or     %edx,%eax
80103a44:	c1 e0 04             	shl    $0x4,%eax
80103a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a4e:	74 21                	je     80103a71 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103a50:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a57:	00 
80103a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a5b:	89 04 24             	mov    %eax,(%esp)
80103a5e:	e8 40 ff ff ff       	call   801039a3 <mpsearch1>
80103a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a66:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a6a:	74 50                	je     80103abc <mpsearch+0xa4>
      return mp;
80103a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a6f:	eb 5f                	jmp    80103ad0 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a74:	83 c0 14             	add    $0x14,%eax
80103a77:	0f b6 00             	movzbl (%eax),%eax
80103a7a:	0f b6 c0             	movzbl %al,%eax
80103a7d:	c1 e0 08             	shl    $0x8,%eax
80103a80:	89 c2                	mov    %eax,%edx
80103a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a85:	83 c0 13             	add    $0x13,%eax
80103a88:	0f b6 00             	movzbl (%eax),%eax
80103a8b:	0f b6 c0             	movzbl %al,%eax
80103a8e:	09 d0                	or     %edx,%eax
80103a90:	c1 e0 0a             	shl    $0xa,%eax
80103a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a99:	2d 00 04 00 00       	sub    $0x400,%eax
80103a9e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103aa5:	00 
80103aa6:	89 04 24             	mov    %eax,(%esp)
80103aa9:	e8 f5 fe ff ff       	call   801039a3 <mpsearch1>
80103aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ab1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ab5:	74 05                	je     80103abc <mpsearch+0xa4>
      return mp;
80103ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103aba:	eb 14                	jmp    80103ad0 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103abc:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103ac3:	00 
80103ac4:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103acb:	e8 d3 fe ff ff       	call   801039a3 <mpsearch1>
}
80103ad0:	c9                   	leave  
80103ad1:	c3                   	ret    

80103ad2 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ad2:	55                   	push   %ebp
80103ad3:	89 e5                	mov    %esp,%ebp
80103ad5:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ad8:	e8 3b ff ff ff       	call   80103a18 <mpsearch>
80103add:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ae4:	74 0a                	je     80103af0 <mpconfig+0x1e>
80103ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae9:	8b 40 04             	mov    0x4(%eax),%eax
80103aec:	85 c0                	test   %eax,%eax
80103aee:	75 0a                	jne    80103afa <mpconfig+0x28>
    return 0;
80103af0:	b8 00 00 00 00       	mov    $0x0,%eax
80103af5:	e9 83 00 00 00       	jmp    80103b7d <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103afd:	8b 40 04             	mov    0x4(%eax),%eax
80103b00:	89 04 24             	mov    %eax,(%esp)
80103b03:	e8 fd fd ff ff       	call   80103905 <p2v>
80103b08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b0b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b12:	00 
80103b13:	c7 44 24 04 c5 8a 10 	movl   $0x80108ac5,0x4(%esp)
80103b1a:	80 
80103b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b1e:	89 04 24             	mov    %eax,(%esp)
80103b21:	e8 e3 18 00 00       	call   80105409 <memcmp>
80103b26:	85 c0                	test   %eax,%eax
80103b28:	74 07                	je     80103b31 <mpconfig+0x5f>
    return 0;
80103b2a:	b8 00 00 00 00       	mov    $0x0,%eax
80103b2f:	eb 4c                	jmp    80103b7d <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b34:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b38:	3c 01                	cmp    $0x1,%al
80103b3a:	74 12                	je     80103b4e <mpconfig+0x7c>
80103b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b3f:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b43:	3c 04                	cmp    $0x4,%al
80103b45:	74 07                	je     80103b4e <mpconfig+0x7c>
    return 0;
80103b47:	b8 00 00 00 00       	mov    $0x0,%eax
80103b4c:	eb 2f                	jmp    80103b7d <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b51:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103b55:	0f b7 c0             	movzwl %ax,%eax
80103b58:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b5f:	89 04 24             	mov    %eax,(%esp)
80103b62:	e8 04 fe ff ff       	call   8010396b <sum>
80103b67:	84 c0                	test   %al,%al
80103b69:	74 07                	je     80103b72 <mpconfig+0xa0>
    return 0;
80103b6b:	b8 00 00 00 00       	mov    $0x0,%eax
80103b70:	eb 0b                	jmp    80103b7d <mpconfig+0xab>
  *pmp = mp;
80103b72:	8b 45 08             	mov    0x8(%ebp),%eax
80103b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b78:	89 10                	mov    %edx,(%eax)
  return conf;
80103b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103b7d:	c9                   	leave  
80103b7e:	c3                   	ret    

80103b7f <mpinit>:

void
mpinit(void)
{
80103b7f:	55                   	push   %ebp
80103b80:	89 e5                	mov    %esp,%ebp
80103b82:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103b85:	c7 05 64 b6 10 80 80 	movl   $0x80112380,0x8010b664
80103b8c:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103b8f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103b92:	89 04 24             	mov    %eax,(%esp)
80103b95:	e8 38 ff ff ff       	call   80103ad2 <mpconfig>
80103b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ba1:	75 05                	jne    80103ba8 <mpinit+0x29>
    return;
80103ba3:	e9 9c 01 00 00       	jmp    80103d44 <mpinit+0x1c5>
  ismp = 1;
80103ba8:	c7 05 64 23 11 80 01 	movl   $0x1,0x80112364
80103baf:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bb5:	8b 40 24             	mov    0x24(%eax),%eax
80103bb8:	a3 7c 22 11 80       	mov    %eax,0x8011227c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bc0:	83 c0 2c             	add    $0x2c,%eax
80103bc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bc9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103bcd:	0f b7 d0             	movzwl %ax,%edx
80103bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bd3:	01 d0                	add    %edx,%eax
80103bd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bd8:	e9 f4 00 00 00       	jmp    80103cd1 <mpinit+0x152>
    switch(*p){
80103bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103be0:	0f b6 00             	movzbl (%eax),%eax
80103be3:	0f b6 c0             	movzbl %al,%eax
80103be6:	83 f8 04             	cmp    $0x4,%eax
80103be9:	0f 87 bf 00 00 00    	ja     80103cae <mpinit+0x12f>
80103bef:	8b 04 85 08 8b 10 80 	mov    -0x7fef74f8(,%eax,4),%eax
80103bf6:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bfb:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c01:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c05:	0f b6 d0             	movzbl %al,%edx
80103c08:	a1 60 29 11 80       	mov    0x80112960,%eax
80103c0d:	39 c2                	cmp    %eax,%edx
80103c0f:	74 2d                	je     80103c3e <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c14:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c18:	0f b6 d0             	movzbl %al,%edx
80103c1b:	a1 60 29 11 80       	mov    0x80112960,%eax
80103c20:	89 54 24 08          	mov    %edx,0x8(%esp)
80103c24:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c28:	c7 04 24 ca 8a 10 80 	movl   $0x80108aca,(%esp)
80103c2f:	e8 6c c7 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103c34:	c7 05 64 23 11 80 00 	movl   $0x0,0x80112364
80103c3b:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103c3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c41:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103c45:	0f b6 c0             	movzbl %al,%eax
80103c48:	83 e0 02             	and    $0x2,%eax
80103c4b:	85 c0                	test   %eax,%eax
80103c4d:	74 15                	je     80103c64 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103c4f:	a1 60 29 11 80       	mov    0x80112960,%eax
80103c54:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c5a:	05 80 23 11 80       	add    $0x80112380,%eax
80103c5f:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
80103c64:	8b 15 60 29 11 80    	mov    0x80112960,%edx
80103c6a:	a1 60 29 11 80       	mov    0x80112960,%eax
80103c6f:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103c75:	81 c2 80 23 11 80    	add    $0x80112380,%edx
80103c7b:	88 02                	mov    %al,(%edx)
      ncpu++;
80103c7d:	a1 60 29 11 80       	mov    0x80112960,%eax
80103c82:	83 c0 01             	add    $0x1,%eax
80103c85:	a3 60 29 11 80       	mov    %eax,0x80112960
      p += sizeof(struct mpproc);
80103c8a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103c8e:	eb 41                	jmp    80103cd1 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103c96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c99:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c9d:	a2 60 23 11 80       	mov    %al,0x80112360
      p += sizeof(struct mpioapic);
80103ca2:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ca6:	eb 29                	jmp    80103cd1 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ca8:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103cac:	eb 23                	jmp    80103cd1 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb1:	0f b6 00             	movzbl (%eax),%eax
80103cb4:	0f b6 c0             	movzbl %al,%eax
80103cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cbb:	c7 04 24 e8 8a 10 80 	movl   $0x80108ae8,(%esp)
80103cc2:	e8 d9 c6 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103cc7:	c7 05 64 23 11 80 00 	movl   $0x0,0x80112364
80103cce:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cd7:	0f 82 00 ff ff ff    	jb     80103bdd <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103cdd:	a1 64 23 11 80       	mov    0x80112364,%eax
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	75 1d                	jne    80103d03 <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103ce6:	c7 05 60 29 11 80 01 	movl   $0x1,0x80112960
80103ced:	00 00 00 
    lapic = 0;
80103cf0:	c7 05 7c 22 11 80 00 	movl   $0x0,0x8011227c
80103cf7:	00 00 00 
    ioapicid = 0;
80103cfa:	c6 05 60 23 11 80 00 	movb   $0x0,0x80112360
    return;
80103d01:	eb 41                	jmp    80103d44 <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103d03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d06:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d0a:	84 c0                	test   %al,%al
80103d0c:	74 36                	je     80103d44 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d0e:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103d15:	00 
80103d16:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103d1d:	e8 0d fc ff ff       	call   8010392f <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d22:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d29:	e8 e4 fb ff ff       	call   80103912 <inb>
80103d2e:	83 c8 01             	or     $0x1,%eax
80103d31:	0f b6 c0             	movzbl %al,%eax
80103d34:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d38:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d3f:	e8 eb fb ff ff       	call   8010392f <outb>
  }
}
80103d44:	c9                   	leave  
80103d45:	c3                   	ret    

80103d46 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d46:	55                   	push   %ebp
80103d47:	89 e5                	mov    %esp,%ebp
80103d49:	83 ec 08             	sub    $0x8,%esp
80103d4c:	8b 55 08             	mov    0x8(%ebp),%edx
80103d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d52:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103d56:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d59:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d5d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103d61:	ee                   	out    %al,(%dx)
}
80103d62:	c9                   	leave  
80103d63:	c3                   	ret    

80103d64 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103d64:	55                   	push   %ebp
80103d65:	89 e5                	mov    %esp,%ebp
80103d67:	83 ec 0c             	sub    $0xc,%esp
80103d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103d71:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103d75:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103d7b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103d7f:	0f b6 c0             	movzbl %al,%eax
80103d82:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d86:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103d8d:	e8 b4 ff ff ff       	call   80103d46 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103d92:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103d96:	66 c1 e8 08          	shr    $0x8,%ax
80103d9a:	0f b6 c0             	movzbl %al,%eax
80103d9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103da1:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103da8:	e8 99 ff ff ff       	call   80103d46 <outb>
}
80103dad:	c9                   	leave  
80103dae:	c3                   	ret    

80103daf <picenable>:

void
picenable(int irq)
{
80103daf:	55                   	push   %ebp
80103db0:	89 e5                	mov    %esp,%ebp
80103db2:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103db5:	8b 45 08             	mov    0x8(%ebp),%eax
80103db8:	ba 01 00 00 00       	mov    $0x1,%edx
80103dbd:	89 c1                	mov    %eax,%ecx
80103dbf:	d3 e2                	shl    %cl,%edx
80103dc1:	89 d0                	mov    %edx,%eax
80103dc3:	f7 d0                	not    %eax
80103dc5:	89 c2                	mov    %eax,%edx
80103dc7:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103dce:	21 d0                	and    %edx,%eax
80103dd0:	0f b7 c0             	movzwl %ax,%eax
80103dd3:	89 04 24             	mov    %eax,(%esp)
80103dd6:	e8 89 ff ff ff       	call   80103d64 <picsetmask>
}
80103ddb:	c9                   	leave  
80103ddc:	c3                   	ret    

80103ddd <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ddd:	55                   	push   %ebp
80103dde:	89 e5                	mov    %esp,%ebp
80103de0:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103de3:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103dea:	00 
80103deb:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103df2:	e8 4f ff ff ff       	call   80103d46 <outb>
  outb(IO_PIC2+1, 0xFF);
80103df7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103dfe:	00 
80103dff:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e06:	e8 3b ff ff ff       	call   80103d46 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103e0b:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e12:	00 
80103e13:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103e1a:	e8 27 ff ff ff       	call   80103d46 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103e1f:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103e26:	00 
80103e27:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e2e:	e8 13 ff ff ff       	call   80103d46 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103e33:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103e3a:	00 
80103e3b:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e42:	e8 ff fe ff ff       	call   80103d46 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103e47:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103e4e:	00 
80103e4f:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e56:	e8 eb fe ff ff       	call   80103d46 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103e5b:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e62:	00 
80103e63:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103e6a:	e8 d7 fe ff ff       	call   80103d46 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103e6f:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103e76:	00 
80103e77:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e7e:	e8 c3 fe ff ff       	call   80103d46 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103e83:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103e8a:	00 
80103e8b:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e92:	e8 af fe ff ff       	call   80103d46 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103e97:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103e9e:	00 
80103e9f:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ea6:	e8 9b fe ff ff       	call   80103d46 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103eab:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103eb2:	00 
80103eb3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103eba:	e8 87 fe ff ff       	call   80103d46 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103ebf:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103ec6:	00 
80103ec7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ece:	e8 73 fe ff ff       	call   80103d46 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103ed3:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103eda:	00 
80103edb:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103ee2:	e8 5f fe ff ff       	call   80103d46 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103ee7:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103eee:	00 
80103eef:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103ef6:	e8 4b fe ff ff       	call   80103d46 <outb>

  if(irqmask != 0xFFFF)
80103efb:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f02:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f06:	74 12                	je     80103f1a <picinit+0x13d>
    picsetmask(irqmask);
80103f08:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f0f:	0f b7 c0             	movzwl %ax,%eax
80103f12:	89 04 24             	mov    %eax,(%esp)
80103f15:	e8 4a fe ff ff       	call   80103d64 <picsetmask>
}
80103f1a:	c9                   	leave  
80103f1b:	c3                   	ret    

80103f1c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f1c:	55                   	push   %ebp
80103f1d:	89 e5                	mov    %esp,%ebp
80103f1f:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103f22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f29:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f32:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f35:	8b 10                	mov    (%eax),%edx
80103f37:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3a:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f3c:	e8 f6 cf ff ff       	call   80100f37 <filealloc>
80103f41:	8b 55 08             	mov    0x8(%ebp),%edx
80103f44:	89 02                	mov    %eax,(%edx)
80103f46:	8b 45 08             	mov    0x8(%ebp),%eax
80103f49:	8b 00                	mov    (%eax),%eax
80103f4b:	85 c0                	test   %eax,%eax
80103f4d:	0f 84 c8 00 00 00    	je     8010401b <pipealloc+0xff>
80103f53:	e8 df cf ff ff       	call   80100f37 <filealloc>
80103f58:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f5b:	89 02                	mov    %eax,(%edx)
80103f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f60:	8b 00                	mov    (%eax),%eax
80103f62:	85 c0                	test   %eax,%eax
80103f64:	0f 84 b1 00 00 00    	je     8010401b <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103f6a:	e8 86 eb ff ff       	call   80102af5 <kalloc>
80103f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f76:	75 05                	jne    80103f7d <pipealloc+0x61>
    goto bad;
80103f78:	e9 9e 00 00 00       	jmp    8010401b <pipealloc+0xff>
  p->readopen = 1;
80103f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f80:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103f87:	00 00 00 
  p->writeopen = 1;
80103f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f8d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103f94:	00 00 00 
  p->nwrite = 0;
80103f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f9a:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fa1:	00 00 00 
  p->nread = 0;
80103fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa7:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103fae:	00 00 00 
  initlock(&p->lock, "pipe");
80103fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb4:	c7 44 24 04 1c 8b 10 	movl   $0x80108b1c,0x4(%esp)
80103fbb:	80 
80103fbc:	89 04 24             	mov    %eax,(%esp)
80103fbf:	e8 59 11 00 00       	call   8010511d <initlock>
  (*f0)->type = FD_PIPE;
80103fc4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc7:	8b 00                	mov    (%eax),%eax
80103fc9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd2:	8b 00                	mov    (%eax),%eax
80103fd4:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdb:	8b 00                	mov    (%eax),%eax
80103fdd:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103fe1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe4:	8b 00                	mov    (%eax),%eax
80103fe6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fe9:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103fec:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fef:	8b 00                	mov    (%eax),%eax
80103ff1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ffa:	8b 00                	mov    (%eax),%eax
80103ffc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104000:	8b 45 0c             	mov    0xc(%ebp),%eax
80104003:	8b 00                	mov    (%eax),%eax
80104005:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104009:	8b 45 0c             	mov    0xc(%ebp),%eax
8010400c:	8b 00                	mov    (%eax),%eax
8010400e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104011:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104014:	b8 00 00 00 00       	mov    $0x0,%eax
80104019:	eb 42                	jmp    8010405d <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
8010401b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010401f:	74 0b                	je     8010402c <pipealloc+0x110>
    kfree((char*)p);
80104021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104024:	89 04 24             	mov    %eax,(%esp)
80104027:	e8 30 ea ff ff       	call   80102a5c <kfree>
  if(*f0)
8010402c:	8b 45 08             	mov    0x8(%ebp),%eax
8010402f:	8b 00                	mov    (%eax),%eax
80104031:	85 c0                	test   %eax,%eax
80104033:	74 0d                	je     80104042 <pipealloc+0x126>
    fileclose(*f0);
80104035:	8b 45 08             	mov    0x8(%ebp),%eax
80104038:	8b 00                	mov    (%eax),%eax
8010403a:	89 04 24             	mov    %eax,(%esp)
8010403d:	e8 9d cf ff ff       	call   80100fdf <fileclose>
  if(*f1)
80104042:	8b 45 0c             	mov    0xc(%ebp),%eax
80104045:	8b 00                	mov    (%eax),%eax
80104047:	85 c0                	test   %eax,%eax
80104049:	74 0d                	je     80104058 <pipealloc+0x13c>
    fileclose(*f1);
8010404b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010404e:	8b 00                	mov    (%eax),%eax
80104050:	89 04 24             	mov    %eax,(%esp)
80104053:	e8 87 cf ff ff       	call   80100fdf <fileclose>
  return -1;
80104058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010405d:	c9                   	leave  
8010405e:	c3                   	ret    

8010405f <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010405f:	55                   	push   %ebp
80104060:	89 e5                	mov    %esp,%ebp
80104062:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80104065:	8b 45 08             	mov    0x8(%ebp),%eax
80104068:	89 04 24             	mov    %eax,(%esp)
8010406b:	e8 ce 10 00 00       	call   8010513e <acquire>
  if(writable){
80104070:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104074:	74 1f                	je     80104095 <pipeclose+0x36>
    p->writeopen = 0;
80104076:	8b 45 08             	mov    0x8(%ebp),%eax
80104079:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104080:	00 00 00 
    wakeup(&p->nread);
80104083:	8b 45 08             	mov    0x8(%ebp),%eax
80104086:	05 34 02 00 00       	add    $0x234,%eax
8010408b:	89 04 24             	mov    %eax,(%esp)
8010408e:	e8 ac 0e 00 00       	call   80104f3f <wakeup>
80104093:	eb 1d                	jmp    801040b2 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80104095:	8b 45 08             	mov    0x8(%ebp),%eax
80104098:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010409f:	00 00 00 
    wakeup(&p->nwrite);
801040a2:	8b 45 08             	mov    0x8(%ebp),%eax
801040a5:	05 38 02 00 00       	add    $0x238,%eax
801040aa:	89 04 24             	mov    %eax,(%esp)
801040ad:	e8 8d 0e 00 00       	call   80104f3f <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801040b2:	8b 45 08             	mov    0x8(%ebp),%eax
801040b5:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801040bb:	85 c0                	test   %eax,%eax
801040bd:	75 25                	jne    801040e4 <pipeclose+0x85>
801040bf:	8b 45 08             	mov    0x8(%ebp),%eax
801040c2:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801040c8:	85 c0                	test   %eax,%eax
801040ca:	75 18                	jne    801040e4 <pipeclose+0x85>
    release(&p->lock);
801040cc:	8b 45 08             	mov    0x8(%ebp),%eax
801040cf:	89 04 24             	mov    %eax,(%esp)
801040d2:	e8 c9 10 00 00       	call   801051a0 <release>
    kfree((char*)p);
801040d7:	8b 45 08             	mov    0x8(%ebp),%eax
801040da:	89 04 24             	mov    %eax,(%esp)
801040dd:	e8 7a e9 ff ff       	call   80102a5c <kfree>
801040e2:	eb 0b                	jmp    801040ef <pipeclose+0x90>
  } else
    release(&p->lock);
801040e4:	8b 45 08             	mov    0x8(%ebp),%eax
801040e7:	89 04 24             	mov    %eax,(%esp)
801040ea:	e8 b1 10 00 00       	call   801051a0 <release>
}
801040ef:	c9                   	leave  
801040f0:	c3                   	ret    

801040f1 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801040f1:	55                   	push   %ebp
801040f2:	89 e5                	mov    %esp,%ebp
801040f4:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
801040f7:	8b 45 08             	mov    0x8(%ebp),%eax
801040fa:	89 04 24             	mov    %eax,(%esp)
801040fd:	e8 3c 10 00 00       	call   8010513e <acquire>
  for(i = 0; i < n; i++){
80104102:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104109:	e9 a8 00 00 00       	jmp    801041b6 <pipewrite+0xc5>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010410e:	eb 59                	jmp    80104169 <pipewrite+0x78>
      if(p->readopen == 0 || current->proc->killed){
80104110:	8b 45 08             	mov    0x8(%ebp),%eax
80104113:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104119:	85 c0                	test   %eax,%eax
8010411b:	74 0f                	je     8010412c <pipewrite+0x3b>
8010411d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104123:	8b 00                	mov    (%eax),%eax
80104125:	8b 40 60             	mov    0x60(%eax),%eax
80104128:	85 c0                	test   %eax,%eax
8010412a:	74 15                	je     80104141 <pipewrite+0x50>
        release(&p->lock);
8010412c:	8b 45 08             	mov    0x8(%ebp),%eax
8010412f:	89 04 24             	mov    %eax,(%esp)
80104132:	e8 69 10 00 00       	call   801051a0 <release>
        return -1;
80104137:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010413c:	e9 9f 00 00 00       	jmp    801041e0 <pipewrite+0xef>
      }
      wakeup(&p->nread);
80104141:	8b 45 08             	mov    0x8(%ebp),%eax
80104144:	05 34 02 00 00       	add    $0x234,%eax
80104149:	89 04 24             	mov    %eax,(%esp)
8010414c:	e8 ee 0d 00 00       	call   80104f3f <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104151:	8b 45 08             	mov    0x8(%ebp),%eax
80104154:	8b 55 08             	mov    0x8(%ebp),%edx
80104157:	81 c2 38 02 00 00    	add    $0x238,%edx
8010415d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104161:	89 14 24             	mov    %edx,(%esp)
80104164:	e8 f1 0c 00 00       	call   80104e5a <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104169:	8b 45 08             	mov    0x8(%ebp),%eax
8010416c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104172:	8b 45 08             	mov    0x8(%ebp),%eax
80104175:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010417b:	05 00 02 00 00       	add    $0x200,%eax
80104180:	39 c2                	cmp    %eax,%edx
80104182:	74 8c                	je     80104110 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104184:	8b 45 08             	mov    0x8(%ebp),%eax
80104187:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010418d:	8d 48 01             	lea    0x1(%eax),%ecx
80104190:	8b 55 08             	mov    0x8(%ebp),%edx
80104193:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104199:	25 ff 01 00 00       	and    $0x1ff,%eax
8010419e:	89 c1                	mov    %eax,%ecx
801041a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801041a6:	01 d0                	add    %edx,%eax
801041a8:	0f b6 10             	movzbl (%eax),%edx
801041ab:	8b 45 08             	mov    0x8(%ebp),%eax
801041ae:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801041b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801041b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b9:	3b 45 10             	cmp    0x10(%ebp),%eax
801041bc:	0f 8c 4c ff ff ff    	jl     8010410e <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801041c2:	8b 45 08             	mov    0x8(%ebp),%eax
801041c5:	05 34 02 00 00       	add    $0x234,%eax
801041ca:	89 04 24             	mov    %eax,(%esp)
801041cd:	e8 6d 0d 00 00       	call   80104f3f <wakeup>
  release(&p->lock);
801041d2:	8b 45 08             	mov    0x8(%ebp),%eax
801041d5:	89 04 24             	mov    %eax,(%esp)
801041d8:	e8 c3 0f 00 00       	call   801051a0 <release>
  return n;
801041dd:	8b 45 10             	mov    0x10(%ebp),%eax
}
801041e0:	c9                   	leave  
801041e1:	c3                   	ret    

801041e2 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801041e2:	55                   	push   %ebp
801041e3:	89 e5                	mov    %esp,%ebp
801041e5:	53                   	push   %ebx
801041e6:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
801041e9:	8b 45 08             	mov    0x8(%ebp),%eax
801041ec:	89 04 24             	mov    %eax,(%esp)
801041ef:	e8 4a 0f 00 00       	call   8010513e <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801041f4:	eb 3c                	jmp    80104232 <piperead+0x50>
    if(current->proc->killed){
801041f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041fc:	8b 00                	mov    (%eax),%eax
801041fe:	8b 40 60             	mov    0x60(%eax),%eax
80104201:	85 c0                	test   %eax,%eax
80104203:	74 15                	je     8010421a <piperead+0x38>
      release(&p->lock);
80104205:	8b 45 08             	mov    0x8(%ebp),%eax
80104208:	89 04 24             	mov    %eax,(%esp)
8010420b:	e8 90 0f 00 00       	call   801051a0 <release>
      return -1;
80104210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104215:	e9 b5 00 00 00       	jmp    801042cf <piperead+0xed>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010421a:	8b 45 08             	mov    0x8(%ebp),%eax
8010421d:	8b 55 08             	mov    0x8(%ebp),%edx
80104220:	81 c2 34 02 00 00    	add    $0x234,%edx
80104226:	89 44 24 04          	mov    %eax,0x4(%esp)
8010422a:	89 14 24             	mov    %edx,(%esp)
8010422d:	e8 28 0c 00 00       	call   80104e5a <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104232:	8b 45 08             	mov    0x8(%ebp),%eax
80104235:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010423b:	8b 45 08             	mov    0x8(%ebp),%eax
8010423e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104244:	39 c2                	cmp    %eax,%edx
80104246:	75 0d                	jne    80104255 <piperead+0x73>
80104248:	8b 45 08             	mov    0x8(%ebp),%eax
8010424b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104251:	85 c0                	test   %eax,%eax
80104253:	75 a1                	jne    801041f6 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104255:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010425c:	eb 4b                	jmp    801042a9 <piperead+0xc7>
    if(p->nread == p->nwrite)
8010425e:	8b 45 08             	mov    0x8(%ebp),%eax
80104261:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104267:	8b 45 08             	mov    0x8(%ebp),%eax
8010426a:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104270:	39 c2                	cmp    %eax,%edx
80104272:	75 02                	jne    80104276 <piperead+0x94>
      break;
80104274:	eb 3b                	jmp    801042b1 <piperead+0xcf>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104276:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104279:	8b 45 0c             	mov    0xc(%ebp),%eax
8010427c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010427f:	8b 45 08             	mov    0x8(%ebp),%eax
80104282:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104288:	8d 48 01             	lea    0x1(%eax),%ecx
8010428b:	8b 55 08             	mov    0x8(%ebp),%edx
8010428e:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104294:	25 ff 01 00 00       	and    $0x1ff,%eax
80104299:	89 c2                	mov    %eax,%edx
8010429b:	8b 45 08             	mov    0x8(%ebp),%eax
8010429e:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801042a3:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ac:	3b 45 10             	cmp    0x10(%ebp),%eax
801042af:	7c ad                	jl     8010425e <piperead+0x7c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801042b1:	8b 45 08             	mov    0x8(%ebp),%eax
801042b4:	05 38 02 00 00       	add    $0x238,%eax
801042b9:	89 04 24             	mov    %eax,(%esp)
801042bc:	e8 7e 0c 00 00       	call   80104f3f <wakeup>
  release(&p->lock);
801042c1:	8b 45 08             	mov    0x8(%ebp),%eax
801042c4:	89 04 24             	mov    %eax,(%esp)
801042c7:	e8 d4 0e 00 00       	call   801051a0 <release>
  return i;
801042cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042cf:	83 c4 24             	add    $0x24,%esp
801042d2:	5b                   	pop    %ebx
801042d3:	5d                   	pop    %ebp
801042d4:	c3                   	ret    

801042d5 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801042d5:	55                   	push   %ebp
801042d6:	89 e5                	mov    %esp,%ebp
801042d8:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042db:	9c                   	pushf  
801042dc:	58                   	pop    %eax
801042dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801042e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801042e3:	c9                   	leave  
801042e4:	c3                   	ret    

801042e5 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801042e5:	55                   	push   %ebp
801042e6:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801042e8:	fb                   	sti    
}
801042e9:	5d                   	pop    %ebp
801042ea:	c3                   	ret    

801042eb <thread_exit>:

static void wakeup1(void *chan);

void
thread_exit(void)
{
801042eb:	55                   	push   %ebp
801042ec:	89 e5                	mov    %esp,%ebp
801042ee:	83 ec 18             	sub    $0x18,%esp
  if (current == initproc)
801042f1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801042f8:	a1 68 b6 10 80       	mov    0x8010b668,%eax
801042fd:	39 c2                	cmp    %eax,%edx
801042ff:	75 0c                	jne    8010430d <thread_exit+0x22>
    panic("init exitting");
80104301:	c7 04 24 21 8b 10 80 	movl   $0x80108b21,(%esp)
80104308:	e8 2d c2 ff ff       	call   8010053a <panic>


  acquire(&ptable.lock);
8010430d:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104314:	e8 25 0e 00 00       	call   8010513e <acquire>

  wakeup1(current);
80104319:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010431f:	89 04 24             	mov    %eax,(%esp)
80104322:	e8 d4 0b 00 00       	call   80104efb <wakeup1>
  current->state = ZOMBIE_THREAD;
80104327:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010432d:	c7 40 74 06 00 00 00 	movl   $0x6,0x74(%eax)

  sched();
80104334:	e8 11 0a 00 00       	call   80104d4a <sched>
  panic("zombie thread exit");
80104339:	c7 04 24 2f 8b 10 80 	movl   $0x80108b2f,(%esp)
80104340:	e8 f5 c1 ff ff       	call   8010053a <panic>

80104345 <thread_join>:
}

void
thread_join(int thread_id)
{
80104345:	55                   	push   %ebp
80104346:	89 e5                	mov    %esp,%ebp
80104348:	83 ec 28             	sub    $0x28,%esp
  struct thread *t = &ptable.proc[thread_id];
8010434b:	8b 45 08             	mov    0x8(%ebp),%eax
8010434e:	c1 e0 03             	shl    $0x3,%eax
80104351:	89 c2                	mov    %eax,%edx
80104353:	c1 e2 04             	shl    $0x4,%edx
80104356:	01 d0                	add    %edx,%eax
80104358:	83 c0 30             	add    $0x30,%eax
8010435b:	05 80 29 11 80       	add    $0x80112980,%eax
80104360:	83 c0 04             	add    $0x4,%eax
80104363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  /*for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)*/

  if(t->proc != current->proc){
80104366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104369:	8b 10                	mov    (%eax),%edx
8010436b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104371:	8b 00                	mov    (%eax),%eax
80104373:	39 c2                	cmp    %eax,%edx
80104375:	74 02                	je     80104379 <thread_join+0x34>
    return;
80104377:	eb 7b                	jmp    801043f4 <thread_join+0xaf>
  }

  acquire(&ptable.lock);
80104379:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104380:	e8 b9 0d 00 00       	call   8010513e <acquire>
  if(t->state == ZOMBIE_THREAD){
80104385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104388:	8b 40 74             	mov    0x74(%eax),%eax
8010438b:	83 f8 06             	cmp    $0x6,%eax
8010438e:	75 45                	jne    801043d5 <thread_join+0x90>
    kfree(t->kstack);
80104390:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104393:	8b 40 70             	mov    0x70(%eax),%eax
80104396:	89 04 24             	mov    %eax,(%esp)
80104399:	e8 be e6 ff ff       	call   80102a5c <kfree>
    t->kstack = 0;
8010439e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a1:	c7 40 70 00 00 00 00 	movl   $0x0,0x70(%eax)
    t->state = UNUSED;
801043a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ab:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    t->tid = 0;
801043b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b5:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
    t->killed = 0;
801043bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bf:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801043c6:	00 00 00 
    release(&ptable.lock);
801043c9:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
801043d0:	e8 cb 0d 00 00       	call   801051a0 <release>
  }
  sleep(t, &ptable.lock);
801043d5:	c7 44 24 04 80 29 11 	movl   $0x80112980,0x4(%esp)
801043dc:	80 
801043dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e0:	89 04 24             	mov    %eax,(%esp)
801043e3:	e8 72 0a 00 00       	call   80104e5a <sleep>
  release(&ptable.lock);
801043e8:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
801043ef:	e8 ac 0d 00 00       	call   801051a0 <release>
}
801043f4:	c9                   	leave  
801043f5:	c3                   	ret    

801043f6 <pinit>:

void
pinit(void)
{
801043f6:	55                   	push   %ebp
801043f7:	89 e5                	mov    %esp,%ebp
801043f9:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801043fc:	c7 44 24 04 42 8b 10 	movl   $0x80108b42,0x4(%esp)
80104403:	80 
80104404:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
8010440b:	e8 0d 0d 00 00       	call   8010511d <initlock>
}
80104410:	c9                   	leave  
80104411:	c3                   	ret    

80104412 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct thread*
allocproc(void)
{
80104412:	55                   	push   %ebp
80104413:	89 e5                	mov    %esp,%ebp
80104415:	83 ec 28             	sub    $0x28,%esp
  struct thread *p;
  char *sp;

  acquire(&ptable.lock);
80104418:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
8010441f:	e8 1a 0d 00 00       	call   8010513e <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104424:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
8010442b:	eb 60                	jmp    8010448d <allocproc+0x7b>
    if(p->state == UNUSED)
8010442d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104430:	8b 40 74             	mov    0x74(%eax),%eax
80104433:	85 c0                	test   %eax,%eax
80104435:	75 4f                	jne    80104486 <allocproc+0x74>
      goto found;
80104437:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  // this needs to change to support more than one thread per proc
  p->proc = &p->temporarilyhere;
80104438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010443b:	8d 50 04             	lea    0x4(%eax),%edx
8010443e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104441:	89 10                	mov    %edx,(%eax)

  p->state = EMBRYO;
80104443:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104446:	c7 40 74 01 00 00 00 	movl   $0x1,0x74(%eax)
  p->proc->pid = nextpid++;
8010444d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104450:	8b 10                	mov    (%eax),%edx
80104452:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104457:	8d 48 01             	lea    0x1(%eax),%ecx
8010445a:	89 0d 04 b0 10 80    	mov    %ecx,0x8010b004
80104460:	89 42 04             	mov    %eax,0x4(%edx)
  release(&ptable.lock);
80104463:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
8010446a:	e8 31 0d 00 00       	call   801051a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010446f:	e8 81 e6 ff ff       	call   80102af5 <kalloc>
80104474:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104477:	89 42 70             	mov    %eax,0x70(%edx)
8010447a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447d:	8b 40 70             	mov    0x70(%eax),%eax
80104480:	85 c0                	test   %eax,%eax
80104482:	75 36                	jne    801044ba <allocproc+0xa8>
80104484:	eb 23                	jmp    801044a9 <allocproc+0x97>
{
  struct thread *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104486:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
8010448d:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
80104494:	72 97                	jb     8010442d <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104496:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
8010449d:	e8 fe 0c 00 00       	call   801051a0 <release>
  return 0;
801044a2:	b8 00 00 00 00       	mov    $0x0,%eax
801044a7:	eb 76                	jmp    8010451f <allocproc+0x10d>
  p->proc->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801044a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ac:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    return 0;
801044b3:	b8 00 00 00 00       	mov    $0x0,%eax
801044b8:	eb 65                	jmp    8010451f <allocproc+0x10d>
  }
  sp = p->kstack + KSTACKSIZE;
801044ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044bd:	8b 40 70             	mov    0x70(%eax),%eax
801044c0:	05 00 10 00 00       	add    $0x1000,%eax
801044c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801044c8:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801044cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044d2:	89 50 78             	mov    %edx,0x78(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801044d5:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801044d9:	ba 52 68 10 80       	mov    $0x80106852,%edx
801044de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044e1:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801044e3:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801044e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044ed:	89 50 7c             	mov    %edx,0x7c(%eax)
  memset(p->context, 0, sizeof *p->context);
801044f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f3:	8b 40 7c             	mov    0x7c(%eax),%eax
801044f6:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801044fd:	00 
801044fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104505:	00 
80104506:	89 04 24             	mov    %eax,(%esp)
80104509:	e8 84 0e 00 00       	call   80105392 <memset>
  p->context->eip = (uint)forkret;
8010450e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104511:	8b 40 7c             	mov    0x7c(%eax),%eax
80104514:	ba 2e 4e 10 80       	mov    $0x80104e2e,%edx
80104519:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010451c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010451f:	c9                   	leave  
80104520:	c3                   	ret    

80104521 <killsiblingthreads>:

void killsiblingthreads() {
80104521:	55                   	push   %ebp
80104522:	89 e5                	mov    %esp,%ebp
80104524:	83 ec 28             	sub    $0x28,%esp

  struct thread* p;
  int havesiblings = 0;
80104527:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  // set all siblings for death except self
  acquire(&ptable.lock);
8010452e:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104535:	e8 04 0c 00 00       	call   8010513e <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010453a:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104541:	eb 46                	jmp    80104589 <killsiblingthreads+0x68>
    if((p->proc == current->proc) && (p->tid != current->tid) && (p != initproc)){
80104543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104546:	8b 10                	mov    (%eax),%edx
80104548:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010454e:	8b 00                	mov    (%eax),%eax
80104550:	39 c2                	cmp    %eax,%edx
80104552:	75 2e                	jne    80104582 <killsiblingthreads+0x61>
80104554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104557:	8b 50 6c             	mov    0x6c(%eax),%edx
8010455a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104560:	8b 40 6c             	mov    0x6c(%eax),%eax
80104563:	39 c2                	cmp    %eax,%edx
80104565:	74 1b                	je     80104582 <killsiblingthreads+0x61>
80104567:	a1 68 b6 10 80       	mov    0x8010b668,%eax
8010456c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010456f:	74 11                	je     80104582 <killsiblingthreads+0x61>
      p->killed = 1;
80104571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104574:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
8010457b:	00 00 00 
      havesiblings++;
8010457e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  struct thread* p;
  int havesiblings = 0;

  // set all siblings for death except self
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104582:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104589:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
80104590:	72 b1                	jb     80104543 <killsiblingthreads+0x22>
      p->killed = 1;
      havesiblings++;
      /*sleep(p, &ptable.lock);*/
    }
  }
  release(&ptable.lock);
80104592:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104599:	e8 02 0c 00 00       	call   801051a0 <release>

  acquire(&ptable.lock);
8010459e:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
801045a5:	e8 94 0b 00 00       	call   8010513e <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045aa:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
801045b1:	eb 62                	jmp    80104615 <killsiblingthreads+0xf4>
      if(p->state == ZOMBIE_THREAD && p->tid != current->tid){
801045b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b6:	8b 40 74             	mov    0x74(%eax),%eax
801045b9:	83 f8 06             	cmp    $0x6,%eax
801045bc:	75 50                	jne    8010460e <killsiblingthreads+0xed>
801045be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c1:	8b 50 6c             	mov    0x6c(%eax),%edx
801045c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045ca:	8b 40 6c             	mov    0x6c(%eax),%eax
801045cd:	39 c2                	cmp    %eax,%edx
801045cf:	74 3d                	je     8010460e <killsiblingthreads+0xed>
        // Found one.
        kfree(p->kstack);
801045d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d4:	8b 40 70             	mov    0x70(%eax),%eax
801045d7:	89 04 24             	mov    %eax,(%esp)
801045da:	e8 7d e4 ff ff       	call   80102a5c <kfree>
        p->kstack = 0;
801045df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e2:	c7 40 70 00 00 00 00 	movl   $0x0,0x70(%eax)
        p->state = UNUSED;
801045e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ec:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
        p->tid = 0;
801045f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f6:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
        p->killed = 0;
801045fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104600:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104607:	00 00 00 
        havesiblings--;
8010460a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  release(&ptable.lock);

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010460e:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104615:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
8010461c:	72 95                	jb     801045b3 <killsiblingthreads+0x92>
        p->killed = 0;
        havesiblings--;
      }
    }
    // No point waiting if we don't have any siblings.
    if(!havesiblings){
8010461e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104622:	75 0e                	jne    80104632 <killsiblingthreads+0x111>
      release(&ptable.lock);
80104624:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
8010462b:	e8 70 0b 00 00       	call   801051a0 <release>
      return;
80104630:	eb 05                	jmp    80104637 <killsiblingthreads+0x116>
    }

  }
80104632:	e9 73 ff ff ff       	jmp    801045aa <killsiblingthreads+0x89>
}
80104637:	c9                   	leave  
80104638:	c3                   	ret    

80104639 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104639:	55                   	push   %ebp
8010463a:	89 e5                	mov    %esp,%ebp
8010463c:	53                   	push   %ebx
8010463d:	83 ec 24             	sub    $0x24,%esp
  struct thread *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104640:	e8 cd fd ff ff       	call   80104412 <allocproc>
80104645:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010464b:	a3 68 b6 10 80       	mov    %eax,0x8010b668
  if((p->proc->pgdir = setupkvm()) == 0)
80104650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104653:	8b 18                	mov    (%eax),%ebx
80104655:	e8 86 39 00 00       	call   80107fe0 <setupkvm>
8010465a:	89 43 08             	mov    %eax,0x8(%ebx)
8010465d:	8b 43 08             	mov    0x8(%ebx),%eax
80104660:	85 c0                	test   %eax,%eax
80104662:	75 0c                	jne    80104670 <userinit+0x37>
    panic("userinit: out of memory?");
80104664:	c7 04 24 49 8b 10 80 	movl   $0x80108b49,(%esp)
8010466b:	e8 ca be ff ff       	call   8010053a <panic>
  inituvm(p->proc->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104670:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104678:	8b 00                	mov    (%eax),%eax
8010467a:	8b 40 08             	mov    0x8(%eax),%eax
8010467d:	89 54 24 08          	mov    %edx,0x8(%esp)
80104681:	c7 44 24 04 00 b5 10 	movl   $0x8010b500,0x4(%esp)
80104688:	80 
80104689:	89 04 24             	mov    %eax,(%esp)
8010468c:	e8 a7 3b 00 00       	call   80108238 <inituvm>
  p->proc->sz = PGSIZE;
80104691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104694:	8b 00                	mov    (%eax),%eax
80104696:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010469c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010469f:	8b 40 78             	mov    0x78(%eax),%eax
801046a2:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801046a9:	00 
801046aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801046b1:	00 
801046b2:	89 04 24             	mov    %eax,(%esp)
801046b5:	e8 d8 0c 00 00       	call   80105392 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER; p->tf->ds = (SEG_UDATA << 3) | DPL_USER; p->tf->es = p->tf->ds;
801046ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bd:	8b 40 78             	mov    0x78(%eax),%eax
801046c0:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
801046c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c9:	8b 40 78             	mov    0x78(%eax),%eax
801046cc:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
801046d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d5:	8b 40 78             	mov    0x78(%eax),%eax
801046d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046db:	8b 52 78             	mov    0x78(%edx),%edx
801046de:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801046e2:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801046e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e9:	8b 40 78             	mov    0x78(%eax),%eax
801046ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046ef:	8b 52 78             	mov    0x78(%edx),%edx
801046f2:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801046f6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801046fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046fd:	8b 40 78             	mov    0x78(%eax),%eax
80104700:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470a:	8b 40 78             	mov    0x78(%eax),%eax
8010470d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104714:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104717:	8b 40 78             	mov    0x78(%eax),%eax
8010471a:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->proc->name, "initcode", sizeof(p->proc->name));
80104721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104724:	8b 00                	mov    (%eax),%eax
80104726:	83 c0 50             	add    $0x50,%eax
80104729:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104730:	00 
80104731:	c7 44 24 04 62 8b 10 	movl   $0x80108b62,0x4(%esp)
80104738:	80 
80104739:	89 04 24             	mov    %eax,(%esp)
8010473c:	e8 71 0e 00 00       	call   801055b2 <safestrcpy>
  p->proc->cwd = namei("/");
80104741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104744:	8b 18                	mov    (%eax),%ebx
80104746:	c7 04 24 6b 8b 10 80 	movl   $0x80108b6b,(%esp)
8010474d:	e8 c7 dc ff ff       	call   80102419 <namei>
80104752:	89 43 4c             	mov    %eax,0x4c(%ebx)

  p->state = RUNNABLE;
80104755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104758:	c7 40 74 03 00 00 00 	movl   $0x3,0x74(%eax)
}
8010475f:	83 c4 24             	add    $0x24,%esp
80104762:	5b                   	pop    %ebx
80104763:	5d                   	pop    %ebp
80104764:	c3                   	ret    

80104765 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104765:	55                   	push   %ebp
80104766:	89 e5                	mov    %esp,%ebp
80104768:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = current->proc->sz;
8010476b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104771:	8b 00                	mov    (%eax),%eax
80104773:	8b 00                	mov    (%eax),%eax
80104775:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104778:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010477c:	7e 36                	jle    801047b4 <growproc+0x4f>
    if((sz = allocuvm(current->proc->pgdir, sz, sz + n)) == 0)
8010477e:	8b 55 08             	mov    0x8(%ebp),%edx
80104781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104784:	01 c2                	add    %eax,%edx
80104786:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478c:	8b 00                	mov    (%eax),%eax
8010478e:	8b 40 08             	mov    0x8(%eax),%eax
80104791:	89 54 24 08          	mov    %edx,0x8(%esp)
80104795:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104798:	89 54 24 04          	mov    %edx,0x4(%esp)
8010479c:	89 04 24             	mov    %eax,(%esp)
8010479f:	e8 0a 3c 00 00       	call   801083ae <allocuvm>
801047a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047ab:	75 43                	jne    801047f0 <growproc+0x8b>
      return -1;
801047ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047b2:	eb 5e                	jmp    80104812 <growproc+0xad>
  } else if(n < 0){
801047b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801047b8:	79 36                	jns    801047f0 <growproc+0x8b>
    if((sz = deallocuvm(current->proc->pgdir, sz, sz + n)) == 0)
801047ba:	8b 55 08             	mov    0x8(%ebp),%edx
801047bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c0:	01 c2                	add    %eax,%edx
801047c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c8:	8b 00                	mov    (%eax),%eax
801047ca:	8b 40 08             	mov    0x8(%eax),%eax
801047cd:	89 54 24 08          	mov    %edx,0x8(%esp)
801047d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047d4:	89 54 24 04          	mov    %edx,0x4(%esp)
801047d8:	89 04 24             	mov    %eax,(%esp)
801047db:	e8 a8 3c 00 00       	call   80108488 <deallocuvm>
801047e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047e7:	75 07                	jne    801047f0 <growproc+0x8b>
      return -1;
801047e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047ee:	eb 22                	jmp    80104812 <growproc+0xad>
  }
  current->proc->sz = sz;
801047f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f6:	8b 00                	mov    (%eax),%eax
801047f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047fb:	89 10                	mov    %edx,(%eax)
  switchuvm(current->proc);
801047fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104803:	8b 00                	mov    (%eax),%eax
80104805:	89 04 24             	mov    %eax,(%esp)
80104808:	e8 c4 38 00 00       	call   801080d1 <switchuvm>
  return 0;
8010480d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104812:	c9                   	leave  
80104813:	c3                   	ret    

80104814 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104814:	55                   	push   %ebp
80104815:	89 e5                	mov    %esp,%ebp
80104817:	57                   	push   %edi
80104818:	56                   	push   %esi
80104819:	53                   	push   %ebx
8010481a:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct thread *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010481d:	e8 f0 fb ff ff       	call   80104412 <allocproc>
80104822:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104825:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104829:	75 0a                	jne    80104835 <fork+0x21>
    return -1;
8010482b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104830:	e9 65 01 00 00       	jmp    8010499a <fork+0x186>

  // Copy process state from p.
  if((np->proc->pgdir = copyuvm(current->proc->pgdir, current->proc->sz)) == 0){
80104835:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104838:	8b 18                	mov    (%eax),%ebx
8010483a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104840:	8b 00                	mov    (%eax),%eax
80104842:	8b 10                	mov    (%eax),%edx
80104844:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010484a:	8b 00                	mov    (%eax),%eax
8010484c:	8b 40 08             	mov    0x8(%eax),%eax
8010484f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104853:	89 04 24             	mov    %eax,(%esp)
80104856:	e8 c9 3d 00 00       	call   80108624 <copyuvm>
8010485b:	89 43 08             	mov    %eax,0x8(%ebx)
8010485e:	8b 43 08             	mov    0x8(%ebx),%eax
80104861:	85 c0                	test   %eax,%eax
80104863:	75 2c                	jne    80104891 <fork+0x7d>
    kfree(np->kstack);
80104865:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104868:	8b 40 70             	mov    0x70(%eax),%eax
8010486b:	89 04 24             	mov    %eax,(%esp)
8010486e:	e8 e9 e1 ff ff       	call   80102a5c <kfree>
    np->kstack = 0;
80104873:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104876:	c7 40 70 00 00 00 00 	movl   $0x0,0x70(%eax)
    np->state = UNUSED;
8010487d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104880:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    return -1;
80104887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010488c:	e9 09 01 00 00       	jmp    8010499a <fork+0x186>
  }
  np->proc->sz = current->proc->sz;
80104891:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104894:	8b 00                	mov    (%eax),%eax
80104896:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010489d:	8b 12                	mov    (%edx),%edx
8010489f:	8b 12                	mov    (%edx),%edx
801048a1:	89 10                	mov    %edx,(%eax)
  np->proc->parent = current->proc;
801048a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048a6:	8b 00                	mov    (%eax),%eax
801048a8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048af:	8b 12                	mov    (%edx),%edx
801048b1:	89 50 64             	mov    %edx,0x64(%eax)
  *np->tf = *current->tf;
801048b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048b7:	8b 50 78             	mov    0x78(%eax),%edx
801048ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c0:	8b 40 78             	mov    0x78(%eax),%eax
801048c3:	89 c3                	mov    %eax,%ebx
801048c5:	b8 13 00 00 00       	mov    $0x13,%eax
801048ca:	89 d7                	mov    %edx,%edi
801048cc:	89 de                	mov    %ebx,%esi
801048ce:	89 c1                	mov    %eax,%ecx
801048d0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801048d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048d5:	8b 40 78             	mov    0x78(%eax),%eax
801048d8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801048df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801048e6:	eb 3a                	jmp    80104922 <fork+0x10e>
    if(current->proc->ofile[i])
801048e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ee:	8b 00                	mov    (%eax),%eax
801048f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048f3:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801048f7:	85 c0                	test   %eax,%eax
801048f9:	74 23                	je     8010491e <fork+0x10a>
      np->proc->ofile[i] = filedup(current->proc->ofile[i]);
801048fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048fe:	8b 18                	mov    (%eax),%ebx
80104900:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104906:	8b 00                	mov    (%eax),%eax
80104908:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010490b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010490f:	89 04 24             	mov    %eax,(%esp)
80104912:	e8 80 c6 ff ff       	call   80100f97 <filedup>
80104917:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010491a:	89 44 93 0c          	mov    %eax,0xc(%ebx,%edx,4)
  *np->tf = *current->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010491e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104922:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104926:	7e c0                	jle    801048e8 <fork+0xd4>
    if(current->proc->ofile[i])
      np->proc->ofile[i] = filedup(current->proc->ofile[i]);
  np->proc->cwd = idup(current->proc->cwd);
80104928:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010492b:	8b 18                	mov    (%eax),%ebx
8010492d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104933:	8b 00                	mov    (%eax),%eax
80104935:	8b 40 4c             	mov    0x4c(%eax),%eax
80104938:	89 04 24             	mov    %eax,(%esp)
8010493b:	e8 fa ce ff ff       	call   8010183a <idup>
80104940:	89 43 4c             	mov    %eax,0x4c(%ebx)

  safestrcpy(np->proc->name, current->proc->name, sizeof(current->proc->name));
80104943:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104949:	8b 00                	mov    (%eax),%eax
8010494b:	8d 50 50             	lea    0x50(%eax),%edx
8010494e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104951:	8b 00                	mov    (%eax),%eax
80104953:	83 c0 50             	add    $0x50,%eax
80104956:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010495d:	00 
8010495e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104962:	89 04 24             	mov    %eax,(%esp)
80104965:	e8 48 0c 00 00       	call   801055b2 <safestrcpy>
 
  pid = np->proc->pid;
8010496a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010496d:	8b 00                	mov    (%eax),%eax
8010496f:	8b 40 04             	mov    0x4(%eax),%eax
80104972:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104975:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
8010497c:	e8 bd 07 00 00       	call   8010513e <acquire>
  np->state = RUNNABLE;
80104981:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104984:	c7 40 74 03 00 00 00 	movl   $0x3,0x74(%eax)
  release(&ptable.lock);
8010498b:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104992:	e8 09 08 00 00       	call   801051a0 <release>
  
  return pid;
80104997:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010499a:	83 c4 2c             	add    $0x2c,%esp
8010499d:	5b                   	pop    %ebx
8010499e:	5e                   	pop    %esi
8010499f:	5f                   	pop    %edi
801049a0:	5d                   	pop    %ebp
801049a1:	c3                   	ret    

801049a2 <clone>:

int 
clone(void (*function)(void), char* stack) {
801049a2:	55                   	push   %ebp
801049a3:	89 e5                	mov    %esp,%ebp
801049a5:	57                   	push   %edi
801049a6:	56                   	push   %esi
801049a7:	53                   	push   %ebx
801049a8:	83 ec 2c             	sub    $0x2c,%esp

  struct thread *nt;
  int tid;
  
  // allocate thread
  if ((nt = allocproc()) == 0)
801049ab:	e8 62 fa ff ff       	call   80104412 <allocproc>
801049b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801049b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801049b7:	75 0a                	jne    801049c3 <clone+0x21>
    return -1;
801049b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049be:	e9 85 00 00 00       	jmp    80104a48 <clone+0xa6>

  *nt->tf = *current->tf;
801049c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801049c6:	8b 50 78             	mov    0x78(%eax),%edx
801049c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049cf:	8b 40 78             	mov    0x78(%eax),%eax
801049d2:	89 c3                	mov    %eax,%ebx
801049d4:	b8 13 00 00 00       	mov    $0x13,%eax
801049d9:	89 d7                	mov    %edx,%edi
801049db:	89 de                	mov    %ebx,%esi
801049dd:	89 c1                	mov    %eax,%ecx
801049df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // point esp (stack pointer) to stack 
  nt->tf->esp = (uint)(stack);
801049e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801049e4:	8b 40 78             	mov    0x78(%eax),%eax
801049e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801049ea:	89 50 44             	mov    %edx,0x44(%eax)

  // point eip (instruction pointer) to function
  nt->tf->eip = (uint)function;
801049ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801049f0:	8b 40 78             	mov    0x78(%eax),%eax
801049f3:	8b 55 08             	mov    0x8(%ebp),%edx
801049f6:	89 50 38             	mov    %edx,0x38(%eax)

  // point process of this thread to current process creating this thread
  nt->proc = current->proc;
801049f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ff:	8b 10                	mov    (%eax),%edx
80104a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a04:	89 10                	mov    %edx,(%eax)

  // set the state of the thread
  acquire(&ptable.lock);
80104a06:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104a0d:	e8 2c 07 00 00       	call   8010513e <acquire>
  nt->state = RUNNABLE;
80104a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a15:	c7 40 74 03 00 00 00 	movl   $0x3,0x74(%eax)
  release(&ptable.lock);
80104a1c:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104a23:	e8 78 07 00 00       	call   801051a0 <release>

  // set index of process
  nt->tid = nexttid++;
80104a28:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104a2d:	8d 50 01             	lea    0x1(%eax),%edx
80104a30:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
80104a36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a39:	89 42 6c             	mov    %eax,0x6c(%edx)
  tid = nt->tid;
80104a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a3f:	8b 40 6c             	mov    0x6c(%eax),%eax
80104a42:	89 45 e0             	mov    %eax,-0x20(%ebp)

  return tid;
80104a45:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80104a48:	83 c4 2c             	add    $0x2c,%esp
80104a4b:	5b                   	pop    %ebx
80104a4c:	5e                   	pop    %esi
80104a4d:	5f                   	pop    %edi
80104a4e:	5d                   	pop    %ebp
80104a4f:	c3                   	ret    

80104a50 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	83 ec 28             	sub    $0x28,%esp
  struct thread *p;
  int fd;

  if(current == initproc)
80104a56:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a5d:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104a62:	39 c2                	cmp    %eax,%edx
80104a64:	75 0c                	jne    80104a72 <exit+0x22>
    panic("init exiting");
80104a66:	c7 04 24 6d 8b 10 80 	movl   $0x80108b6d,(%esp)
80104a6d:	e8 c8 ba ff ff       	call   8010053a <panic>

  killsiblingthreads();
80104a72:	e8 aa fa ff ff       	call   80104521 <killsiblingthreads>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104a77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104a7e:	eb 41                	jmp    80104ac1 <exit+0x71>
    if(current->proc->ofile[fd]){
80104a80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a86:	8b 00                	mov    (%eax),%eax
80104a88:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a8b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	74 2a                	je     80104abd <exit+0x6d>
      fileclose(current->proc->ofile[fd]);
80104a93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a99:	8b 00                	mov    (%eax),%eax
80104a9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a9e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80104aa2:	89 04 24             	mov    %eax,(%esp)
80104aa5:	e8 35 c5 ff ff       	call   80100fdf <fileclose>
      current->proc->ofile[fd] = 0;
80104aaa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab0:	8b 00                	mov    (%eax),%eax
80104ab2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ab5:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80104abc:	00 
    panic("init exiting");

  killsiblingthreads();

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104abd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104ac1:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104ac5:	7e b9                	jle    80104a80 <exit+0x30>
      fileclose(current->proc->ofile[fd]);
      current->proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104ac7:	e8 57 e9 ff ff       	call   80103423 <begin_op>
  iput(current->proc->cwd);
80104acc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ad2:	8b 00                	mov    (%eax),%eax
80104ad4:	8b 40 4c             	mov    0x4c(%eax),%eax
80104ad7:	89 04 24             	mov    %eax,(%esp)
80104ada:	e8 40 cf ff ff       	call   80101a1f <iput>
  end_op();
80104adf:	e8 c3 e9 ff ff       	call   801034a7 <end_op>
  current->proc->cwd = 0;
80104ae4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aea:	8b 00                	mov    (%eax),%eax
80104aec:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)

  acquire(&ptable.lock);
80104af3:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104afa:	e8 3f 06 00 00       	call   8010513e <acquire>

  // Parent might be sleeping in wait().
  wakeup1(current->proc->parent);
80104aff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b05:	8b 00                	mov    (%eax),%eax
80104b07:	8b 40 64             	mov    0x64(%eax),%eax
80104b0a:	89 04 24             	mov    %eax,(%esp)
80104b0d:	e8 e9 03 00 00       	call   80104efb <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b12:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104b19:	eb 45                	jmp    80104b60 <exit+0x110>
    if(p->proc->parent == current->proc){
80104b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1e:	8b 00                	mov    (%eax),%eax
80104b20:	8b 50 64             	mov    0x64(%eax),%edx
80104b23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b29:	8b 00                	mov    (%eax),%eax
80104b2b:	39 c2                	cmp    %eax,%edx
80104b2d:	75 2a                	jne    80104b59 <exit+0x109>
      p->proc->parent = initproc->proc;
80104b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b32:	8b 00                	mov    (%eax),%eax
80104b34:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
80104b3a:	8b 12                	mov    (%edx),%edx
80104b3c:	89 50 64             	mov    %edx,0x64(%eax)
      if(p->state == ZOMBIE)
80104b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b42:	8b 40 74             	mov    0x74(%eax),%eax
80104b45:	83 f8 05             	cmp    $0x5,%eax
80104b48:	75 0f                	jne    80104b59 <exit+0x109>
        wakeup1(initproc->proc);
80104b4a:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104b4f:	8b 00                	mov    (%eax),%eax
80104b51:	89 04 24             	mov    %eax,(%esp)
80104b54:	e8 a2 03 00 00       	call   80104efb <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(current->proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b59:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104b60:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
80104b67:	72 b2                	jb     80104b1b <exit+0xcb>
    }
  }

  /*cprintf("Should make all threads ZOMBIE\n");*/
  // Jump into the scheduler, never to return.
  current->state = ZOMBIE;
80104b69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b6f:	c7 40 74 05 00 00 00 	movl   $0x5,0x74(%eax)
  sched();
80104b76:	e8 cf 01 00 00       	call   80104d4a <sched>
  panic("zombie exit");
80104b7b:	c7 04 24 7a 8b 10 80 	movl   $0x80108b7a,(%esp)
80104b82:	e8 b3 b9 ff ff       	call   8010053a <panic>

80104b87 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{  
80104b87:	55                   	push   %ebp
80104b88:	89 e5                	mov    %esp,%ebp
80104b8a:	83 ec 28             	sub    $0x28,%esp
  struct thread *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104b8d:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104b94:	e8 a5 05 00 00       	call   8010513e <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104b99:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ba0:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104ba7:	e9 ad 00 00 00       	jmp    80104c59 <wait+0xd2>
      if(p->proc->parent != current->proc)
80104bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104baf:	8b 00                	mov    (%eax),%eax
80104bb1:	8b 50 64             	mov    0x64(%eax),%edx
80104bb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bba:	8b 00                	mov    (%eax),%eax
80104bbc:	39 c2                	cmp    %eax,%edx
80104bbe:	74 05                	je     80104bc5 <wait+0x3e>
        continue;
80104bc0:	e9 8d 00 00 00       	jmp    80104c52 <wait+0xcb>
      havekids = 1;
80104bc5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bcf:	8b 40 74             	mov    0x74(%eax),%eax
80104bd2:	83 f8 05             	cmp    $0x5,%eax
80104bd5:	75 7b                	jne    80104c52 <wait+0xcb>
        // Found one.
        pid = p->proc->pid;
80104bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bda:	8b 00                	mov    (%eax),%eax
80104bdc:	8b 40 04             	mov    0x4(%eax),%eax
80104bdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be5:	8b 40 70             	mov    0x70(%eax),%eax
80104be8:	89 04 24             	mov    %eax,(%esp)
80104beb:	e8 6c de ff ff       	call   80102a5c <kfree>
        p->kstack = 0;
80104bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf3:	c7 40 70 00 00 00 00 	movl   $0x0,0x70(%eax)
        freevm(p->proc->pgdir);
80104bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bfd:	8b 00                	mov    (%eax),%eax
80104bff:	8b 40 08             	mov    0x8(%eax),%eax
80104c02:	89 04 24             	mov    %eax,(%esp)
80104c05:	e8 3a 39 00 00       	call   80108544 <freevm>
        p->state = UNUSED;
80104c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c0d:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
        p->proc->pid = 0;
80104c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c17:	8b 00                	mov    (%eax),%eax
80104c19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->proc->parent = 0;
80104c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c23:	8b 00                	mov    (%eax),%eax
80104c25:	c7 40 64 00 00 00 00 	movl   $0x0,0x64(%eax)
        p->proc->name[0] = 0;
80104c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c2f:	8b 00                	mov    (%eax),%eax
80104c31:	c6 40 50 00          	movb   $0x0,0x50(%eax)
        p->proc->killed = 0;
80104c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c38:	8b 00                	mov    (%eax),%eax
80104c3a:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)
        release(&ptable.lock);
80104c41:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104c48:	e8 53 05 00 00       	call   801051a0 <release>
        return pid;
80104c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c50:	eb 59                	jmp    80104cab <wait+0x124>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c52:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104c59:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
80104c60:	0f 82 46 ff ff ff    	jb     80104bac <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || current->proc->killed){
80104c66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c6a:	74 0f                	je     80104c7b <wait+0xf4>
80104c6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c72:	8b 00                	mov    (%eax),%eax
80104c74:	8b 40 60             	mov    0x60(%eax),%eax
80104c77:	85 c0                	test   %eax,%eax
80104c79:	74 13                	je     80104c8e <wait+0x107>
      release(&ptable.lock);
80104c7b:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104c82:	e8 19 05 00 00       	call   801051a0 <release>
      return -1;
80104c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c8c:	eb 1d                	jmp    80104cab <wait+0x124>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(current->proc, &ptable.lock);  //DOC: wait-sleep
80104c8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c94:	8b 00                	mov    (%eax),%eax
80104c96:	c7 44 24 04 80 29 11 	movl   $0x80112980,0x4(%esp)
80104c9d:	80 
80104c9e:	89 04 24             	mov    %eax,(%esp)
80104ca1:	e8 b4 01 00 00       	call   80104e5a <sleep>
  }
80104ca6:	e9 ee fe ff ff       	jmp    80104b99 <wait+0x12>
}
80104cab:	c9                   	leave  
80104cac:	c3                   	ret    

80104cad <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104cad:	55                   	push   %ebp
80104cae:	89 e5                	mov    %esp,%ebp
80104cb0:	83 ec 28             	sub    $0x28,%esp
  struct thread *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104cb3:	e8 2d f6 ff ff       	call   801042e5 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104cb8:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104cbf:	e8 7a 04 00 00       	call   8010513e <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cc4:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104ccb:	eb 63                	jmp    80104d30 <scheduler+0x83>
      if(p->state != RUNNABLE)
80104ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd0:	8b 40 74             	mov    0x74(%eax),%eax
80104cd3:	83 f8 03             	cmp    $0x3,%eax
80104cd6:	74 02                	je     80104cda <scheduler+0x2d>
        continue;
80104cd8:	eb 4f                	jmp    80104d29 <scheduler+0x7c>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      current = p;
80104cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cdd:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p->proc);
80104ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce6:	8b 00                	mov    (%eax),%eax
80104ce8:	89 04 24             	mov    %eax,(%esp)
80104ceb:	e8 e1 33 00 00       	call   801080d1 <switchuvm>
      p->state = RUNNING;
80104cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf3:	c7 40 74 04 00 00 00 	movl   $0x4,0x74(%eax)
      swtch(&cpu->scheduler, current->context);
80104cfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d00:	8b 40 7c             	mov    0x7c(%eax),%eax
80104d03:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d0a:	83 c2 04             	add    $0x4,%edx
80104d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d11:	89 14 24             	mov    %edx,(%esp)
80104d14:	e8 0a 09 00 00       	call   80105623 <swtch>
      switchkvm();
80104d19:	e8 96 33 00 00       	call   801080b4 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      current = 0;
80104d1e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104d25:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d29:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104d30:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
80104d37:	72 94                	jb     80104ccd <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      current = 0;
    }
    release(&ptable.lock);
80104d39:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104d40:	e8 5b 04 00 00       	call   801051a0 <release>
  }
80104d45:	e9 69 ff ff ff       	jmp    80104cb3 <scheduler+0x6>

80104d4a <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104d4a:	55                   	push   %ebp
80104d4b:	89 e5                	mov    %esp,%ebp
80104d4d:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104d50:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104d57:	e8 0c 05 00 00       	call   80105268 <holding>
80104d5c:	85 c0                	test   %eax,%eax
80104d5e:	75 0c                	jne    80104d6c <sched+0x22>
    panic("sched ptable.lock");
80104d60:	c7 04 24 86 8b 10 80 	movl   $0x80108b86,(%esp)
80104d67:	e8 ce b7 ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104d6c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d72:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d78:	83 f8 01             	cmp    $0x1,%eax
80104d7b:	74 0c                	je     80104d89 <sched+0x3f>
    panic("sched locks");
80104d7d:	c7 04 24 98 8b 10 80 	movl   $0x80108b98,(%esp)
80104d84:	e8 b1 b7 ff ff       	call   8010053a <panic>
  if(current->state == RUNNING)
80104d89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d8f:	8b 40 74             	mov    0x74(%eax),%eax
80104d92:	83 f8 04             	cmp    $0x4,%eax
80104d95:	75 0c                	jne    80104da3 <sched+0x59>
    panic("sched running");
80104d97:	c7 04 24 a4 8b 10 80 	movl   $0x80108ba4,(%esp)
80104d9e:	e8 97 b7 ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104da3:	e8 2d f5 ff ff       	call   801042d5 <readeflags>
80104da8:	25 00 02 00 00       	and    $0x200,%eax
80104dad:	85 c0                	test   %eax,%eax
80104daf:	74 0c                	je     80104dbd <sched+0x73>
    panic("sched interruptible");
80104db1:	c7 04 24 b2 8b 10 80 	movl   $0x80108bb2,(%esp)
80104db8:	e8 7d b7 ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104dbd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dc3:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&current->context, cpu->scheduler);
80104dcc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104dd2:	8b 40 04             	mov    0x4(%eax),%eax
80104dd5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ddc:	83 c2 7c             	add    $0x7c,%edx
80104ddf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104de3:	89 14 24             	mov    %edx,(%esp)
80104de6:	e8 38 08 00 00       	call   80105623 <swtch>
  cpu->intena = intena;
80104deb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104df4:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104dfa:	c9                   	leave  
80104dfb:	c3                   	ret    

80104dfc <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104dfc:	55                   	push   %ebp
80104dfd:	89 e5                	mov    %esp,%ebp
80104dff:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104e02:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104e09:	e8 30 03 00 00       	call   8010513e <acquire>
  current->state = RUNNABLE;
80104e0e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e14:	c7 40 74 03 00 00 00 	movl   $0x3,0x74(%eax)
  sched();
80104e1b:	e8 2a ff ff ff       	call   80104d4a <sched>
  release(&ptable.lock);
80104e20:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104e27:	e8 74 03 00 00       	call   801051a0 <release>
}
80104e2c:	c9                   	leave  
80104e2d:	c3                   	ret    

80104e2e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104e2e:	55                   	push   %ebp
80104e2f:	89 e5                	mov    %esp,%ebp
80104e31:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104e34:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104e3b:	e8 60 03 00 00       	call   801051a0 <release>

  if (first) {
80104e40:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
80104e45:	85 c0                	test   %eax,%eax
80104e47:	74 0f                	je     80104e58 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104e49:	c7 05 0c b0 10 80 00 	movl   $0x0,0x8010b00c
80104e50:	00 00 00 
    initlog();
80104e53:	e8 bd e3 ff ff       	call   80103215 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104e58:	c9                   	leave  
80104e59:	c3                   	ret    

80104e5a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104e5a:	55                   	push   %ebp
80104e5b:	89 e5                	mov    %esp,%ebp
80104e5d:	83 ec 18             	sub    $0x18,%esp
  if(current == 0)
80104e60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e66:	85 c0                	test   %eax,%eax
80104e68:	75 0c                	jne    80104e76 <sleep+0x1c>
    panic("sleep");
80104e6a:	c7 04 24 c6 8b 10 80 	movl   $0x80108bc6,(%esp)
80104e71:	e8 c4 b6 ff ff       	call   8010053a <panic>

  if(lk == 0)
80104e76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104e7a:	75 0c                	jne    80104e88 <sleep+0x2e>
    panic("sleep without lk");
80104e7c:	c7 04 24 cc 8b 10 80 	movl   $0x80108bcc,(%esp)
80104e83:	e8 b2 b6 ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104e88:	81 7d 0c 80 29 11 80 	cmpl   $0x80112980,0xc(%ebp)
80104e8f:	74 17                	je     80104ea8 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104e91:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104e98:	e8 a1 02 00 00       	call   8010513e <acquire>
    release(lk);
80104e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ea0:	89 04 24             	mov    %eax,(%esp)
80104ea3:	e8 f8 02 00 00       	call   801051a0 <release>
  }

  // Go to sleep.
  current->chan = chan;
80104ea8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eae:	8b 55 08             	mov    0x8(%ebp),%edx
80104eb1:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  current->state = SLEEPING;
80104eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ebd:	c7 40 74 02 00 00 00 	movl   $0x2,0x74(%eax)
  sched();
80104ec4:	e8 81 fe ff ff       	call   80104d4a <sched>

  // Tidy up.
  current->chan = 0;
80104ec9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ecf:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104ed6:	00 00 00 

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104ed9:	81 7d 0c 80 29 11 80 	cmpl   $0x80112980,0xc(%ebp)
80104ee0:	74 17                	je     80104ef9 <sleep+0x9f>
    release(&ptable.lock);
80104ee2:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104ee9:	e8 b2 02 00 00       	call   801051a0 <release>
    acquire(lk);
80104eee:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ef1:	89 04 24             	mov    %eax,(%esp)
80104ef4:	e8 45 02 00 00       	call   8010513e <acquire>
  }
}
80104ef9:	c9                   	leave  
80104efa:	c3                   	ret    

80104efb <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104efb:	55                   	push   %ebp
80104efc:	89 e5                	mov    %esp,%ebp
80104efe:	83 ec 10             	sub    $0x10,%esp
  struct thread *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f01:	c7 45 fc b4 29 11 80 	movl   $0x801129b4,-0x4(%ebp)
80104f08:	eb 2a                	jmp    80104f34 <wakeup1+0x39>
    if(p->state == SLEEPING && p->chan == chan)
80104f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f0d:	8b 40 74             	mov    0x74(%eax),%eax
80104f10:	83 f8 02             	cmp    $0x2,%eax
80104f13:	75 18                	jne    80104f2d <wakeup1+0x32>
80104f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f18:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104f1e:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f21:	75 0a                	jne    80104f2d <wakeup1+0x32>
      p->state = RUNNABLE;
80104f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f26:	c7 40 74 03 00 00 00 	movl   $0x3,0x74(%eax)
static void
wakeup1(void *chan)
{
  struct thread *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f2d:	81 45 fc 88 00 00 00 	addl   $0x88,-0x4(%ebp)
80104f34:	81 7d fc b4 4b 11 80 	cmpl   $0x80114bb4,-0x4(%ebp)
80104f3b:	72 cd                	jb     80104f0a <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104f3d:	c9                   	leave  
80104f3e:	c3                   	ret    

80104f3f <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104f3f:	55                   	push   %ebp
80104f40:	89 e5                	mov    %esp,%ebp
80104f42:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104f45:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104f4c:	e8 ed 01 00 00       	call   8010513e <acquire>
  wakeup1(chan);
80104f51:	8b 45 08             	mov    0x8(%ebp),%eax
80104f54:	89 04 24             	mov    %eax,(%esp)
80104f57:	e8 9f ff ff ff       	call   80104efb <wakeup1>
  release(&ptable.lock);
80104f5c:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104f63:	e8 38 02 00 00       	call   801051a0 <release>
}
80104f68:	c9                   	leave  
80104f69:	c3                   	ret    

80104f6a <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104f6a:	55                   	push   %ebp
80104f6b:	89 e5                	mov    %esp,%ebp
80104f6d:	83 ec 28             	sub    $0x28,%esp
  struct thread *p;

  acquire(&ptable.lock);
80104f70:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104f77:	e8 c2 01 00 00       	call   8010513e <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f7c:	c7 45 f4 b4 29 11 80 	movl   $0x801129b4,-0xc(%ebp)
80104f83:	eb 48                	jmp    80104fcd <kill+0x63>
    if(p->proc->pid == pid){
80104f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f88:	8b 00                	mov    (%eax),%eax
80104f8a:	8b 40 04             	mov    0x4(%eax),%eax
80104f8d:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f90:	75 34                	jne    80104fc6 <kill+0x5c>
      p->proc->killed = 1;
80104f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f95:	8b 00                	mov    (%eax),%eax
80104f97:	c7 40 60 01 00 00 00 	movl   $0x1,0x60(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa1:	8b 40 74             	mov    0x74(%eax),%eax
80104fa4:	83 f8 02             	cmp    $0x2,%eax
80104fa7:	75 0a                	jne    80104fb3 <kill+0x49>
        p->state = RUNNABLE;
80104fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fac:	c7 40 74 03 00 00 00 	movl   $0x3,0x74(%eax)
      release(&ptable.lock);
80104fb3:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104fba:	e8 e1 01 00 00       	call   801051a0 <release>
      return 0;
80104fbf:	b8 00 00 00 00       	mov    $0x0,%eax
80104fc4:	eb 21                	jmp    80104fe7 <kill+0x7d>
kill(int pid)
{
  struct thread *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fc6:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104fcd:	81 7d f4 b4 4b 11 80 	cmpl   $0x80114bb4,-0xc(%ebp)
80104fd4:	72 af                	jb     80104f85 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104fd6:	c7 04 24 80 29 11 80 	movl   $0x80112980,(%esp)
80104fdd:	e8 be 01 00 00       	call   801051a0 <release>
  return -1;
80104fe2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fe7:	c9                   	leave  
80104fe8:	c3                   	ret    

80104fe9 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104fe9:	55                   	push   %ebp
80104fea:	89 e5                	mov    %esp,%ebp
80104fec:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct thread *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fef:	c7 45 f0 b4 29 11 80 	movl   $0x801129b4,-0x10(%ebp)
80104ff6:	e9 dd 00 00 00       	jmp    801050d8 <procdump+0xef>
    if(p->state == UNUSED)
80104ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ffe:	8b 40 74             	mov    0x74(%eax),%eax
80105001:	85 c0                	test   %eax,%eax
80105003:	75 05                	jne    8010500a <procdump+0x21>
      continue;
80105005:	e9 c7 00 00 00       	jmp    801050d1 <procdump+0xe8>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010500a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010500d:	8b 40 74             	mov    0x74(%eax),%eax
80105010:	83 f8 05             	cmp    $0x5,%eax
80105013:	77 23                	ja     80105038 <procdump+0x4f>
80105015:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105018:	8b 40 74             	mov    0x74(%eax),%eax
8010501b:	8b 04 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%eax
80105022:	85 c0                	test   %eax,%eax
80105024:	74 12                	je     80105038 <procdump+0x4f>
      state = states[p->state];
80105026:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105029:	8b 40 74             	mov    0x74(%eax),%eax
8010502c:	8b 04 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%eax
80105033:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105036:	eb 07                	jmp    8010503f <procdump+0x56>
    else
      state = "???";
80105038:	c7 45 ec dd 8b 10 80 	movl   $0x80108bdd,-0x14(%ebp)
    cprintf("%d %s %s", p->proc->pid, state, p->proc->name);
8010503f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105042:	8b 00                	mov    (%eax),%eax
80105044:	8d 50 50             	lea    0x50(%eax),%edx
80105047:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010504a:	8b 00                	mov    (%eax),%eax
8010504c:	8b 40 04             	mov    0x4(%eax),%eax
8010504f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105053:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105056:	89 54 24 08          	mov    %edx,0x8(%esp)
8010505a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010505e:	c7 04 24 e1 8b 10 80 	movl   $0x80108be1,(%esp)
80105065:	e8 36 b3 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
8010506a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010506d:	8b 40 74             	mov    0x74(%eax),%eax
80105070:	83 f8 02             	cmp    $0x2,%eax
80105073:	75 50                	jne    801050c5 <procdump+0xdc>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105075:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105078:	8b 40 7c             	mov    0x7c(%eax),%eax
8010507b:	8b 40 0c             	mov    0xc(%eax),%eax
8010507e:	83 c0 08             	add    $0x8,%eax
80105081:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80105084:	89 54 24 04          	mov    %edx,0x4(%esp)
80105088:	89 04 24             	mov    %eax,(%esp)
8010508b:	e8 5f 01 00 00       	call   801051ef <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80105090:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105097:	eb 1b                	jmp    801050b4 <procdump+0xcb>
        cprintf(" %p", pc[i]);
80105099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010509c:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801050a4:	c7 04 24 ea 8b 10 80 	movl   $0x80108bea,(%esp)
801050ab:	e8 f0 b2 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->proc->pid, state, p->proc->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801050b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801050b4:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801050b8:	7f 0b                	jg     801050c5 <procdump+0xdc>
801050ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050bd:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801050c1:	85 c0                	test   %eax,%eax
801050c3:	75 d4                	jne    80105099 <procdump+0xb0>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801050c5:	c7 04 24 ee 8b 10 80 	movl   $0x80108bee,(%esp)
801050cc:	e8 cf b2 ff ff       	call   801003a0 <cprintf>
  int i;
  struct thread *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050d1:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
801050d8:	81 7d f0 b4 4b 11 80 	cmpl   $0x80114bb4,-0x10(%ebp)
801050df:	0f 82 16 ff ff ff    	jb     80104ffb <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    

801050e7 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801050e7:	55                   	push   %ebp
801050e8:	89 e5                	mov    %esp,%ebp
801050ea:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801050ed:	9c                   	pushf  
801050ee:	58                   	pop    %eax
801050ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801050f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    

801050f7 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801050f7:	55                   	push   %ebp
801050f8:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801050fa:	fa                   	cli    
}
801050fb:	5d                   	pop    %ebp
801050fc:	c3                   	ret    

801050fd <sti>:

static inline void
sti(void)
{
801050fd:	55                   	push   %ebp
801050fe:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105100:	fb                   	sti    
}
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    

80105103 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105103:	55                   	push   %ebp
80105104:	89 e5                	mov    %esp,%ebp
80105106:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105109:	8b 55 08             	mov    0x8(%ebp),%edx
8010510c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010510f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105112:	f0 87 02             	lock xchg %eax,(%edx)
80105115:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105118:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010511b:	c9                   	leave  
8010511c:	c3                   	ret    

8010511d <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010511d:	55                   	push   %ebp
8010511e:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105120:	8b 45 08             	mov    0x8(%ebp),%eax
80105123:	8b 55 0c             	mov    0xc(%ebp),%edx
80105126:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105129:	8b 45 08             	mov    0x8(%ebp),%eax
8010512c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105132:	8b 45 08             	mov    0x8(%ebp),%eax
80105135:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010513c:	5d                   	pop    %ebp
8010513d:	c3                   	ret    

8010513e <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010513e:	55                   	push   %ebp
8010513f:	89 e5                	mov    %esp,%ebp
80105141:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105144:	e8 49 01 00 00       	call   80105292 <pushcli>
  if(holding(lk))
80105149:	8b 45 08             	mov    0x8(%ebp),%eax
8010514c:	89 04 24             	mov    %eax,(%esp)
8010514f:	e8 14 01 00 00       	call   80105268 <holding>
80105154:	85 c0                	test   %eax,%eax
80105156:	74 0c                	je     80105164 <acquire+0x26>
    panic("acquire");
80105158:	c7 04 24 1a 8c 10 80 	movl   $0x80108c1a,(%esp)
8010515f:	e8 d6 b3 ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105164:	90                   	nop
80105165:	8b 45 08             	mov    0x8(%ebp),%eax
80105168:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010516f:	00 
80105170:	89 04 24             	mov    %eax,(%esp)
80105173:	e8 8b ff ff ff       	call   80105103 <xchg>
80105178:	85 c0                	test   %eax,%eax
8010517a:	75 e9                	jne    80105165 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010517c:	8b 45 08             	mov    0x8(%ebp),%eax
8010517f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105186:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105189:	8b 45 08             	mov    0x8(%ebp),%eax
8010518c:	83 c0 0c             	add    $0xc,%eax
8010518f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105193:	8d 45 08             	lea    0x8(%ebp),%eax
80105196:	89 04 24             	mov    %eax,(%esp)
80105199:	e8 51 00 00 00       	call   801051ef <getcallerpcs>
}
8010519e:	c9                   	leave  
8010519f:	c3                   	ret    

801051a0 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801051a6:	8b 45 08             	mov    0x8(%ebp),%eax
801051a9:	89 04 24             	mov    %eax,(%esp)
801051ac:	e8 b7 00 00 00       	call   80105268 <holding>
801051b1:	85 c0                	test   %eax,%eax
801051b3:	75 0c                	jne    801051c1 <release+0x21>
    panic("release");
801051b5:	c7 04 24 22 8c 10 80 	movl   $0x80108c22,(%esp)
801051bc:	e8 79 b3 ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
801051c1:	8b 45 08             	mov    0x8(%ebp),%eax
801051c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801051cb:	8b 45 08             	mov    0x8(%ebp),%eax
801051ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801051d5:	8b 45 08             	mov    0x8(%ebp),%eax
801051d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051df:	00 
801051e0:	89 04 24             	mov    %eax,(%esp)
801051e3:	e8 1b ff ff ff       	call   80105103 <xchg>

  popcli();
801051e8:	e8 e9 00 00 00       	call   801052d6 <popcli>
}
801051ed:	c9                   	leave  
801051ee:	c3                   	ret    

801051ef <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801051ef:	55                   	push   %ebp
801051f0:	89 e5                	mov    %esp,%ebp
801051f2:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801051f5:	8b 45 08             	mov    0x8(%ebp),%eax
801051f8:	83 e8 08             	sub    $0x8,%eax
801051fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801051fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105205:	eb 38                	jmp    8010523f <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105207:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010520b:	74 38                	je     80105245 <getcallerpcs+0x56>
8010520d:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105214:	76 2f                	jbe    80105245 <getcallerpcs+0x56>
80105216:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010521a:	74 29                	je     80105245 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010521c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010521f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105226:	8b 45 0c             	mov    0xc(%ebp),%eax
80105229:	01 c2                	add    %eax,%edx
8010522b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010522e:	8b 40 04             	mov    0x4(%eax),%eax
80105231:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105233:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105236:	8b 00                	mov    (%eax),%eax
80105238:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010523b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010523f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105243:	7e c2                	jle    80105207 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105245:	eb 19                	jmp    80105260 <getcallerpcs+0x71>
    pcs[i] = 0;
80105247:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010524a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105251:	8b 45 0c             	mov    0xc(%ebp),%eax
80105254:	01 d0                	add    %edx,%eax
80105256:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010525c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105260:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105264:	7e e1                	jle    80105247 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105266:	c9                   	leave  
80105267:	c3                   	ret    

80105268 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105268:	55                   	push   %ebp
80105269:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010526b:	8b 45 08             	mov    0x8(%ebp),%eax
8010526e:	8b 00                	mov    (%eax),%eax
80105270:	85 c0                	test   %eax,%eax
80105272:	74 17                	je     8010528b <holding+0x23>
80105274:	8b 45 08             	mov    0x8(%ebp),%eax
80105277:	8b 50 08             	mov    0x8(%eax),%edx
8010527a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105280:	39 c2                	cmp    %eax,%edx
80105282:	75 07                	jne    8010528b <holding+0x23>
80105284:	b8 01 00 00 00       	mov    $0x1,%eax
80105289:	eb 05                	jmp    80105290 <holding+0x28>
8010528b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105290:	5d                   	pop    %ebp
80105291:	c3                   	ret    

80105292 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105292:	55                   	push   %ebp
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105298:	e8 4a fe ff ff       	call   801050e7 <readeflags>
8010529d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801052a0:	e8 52 fe ff ff       	call   801050f7 <cli>
  if(cpu->ncli++ == 0)
801052a5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801052ac:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801052b2:	8d 48 01             	lea    0x1(%eax),%ecx
801052b5:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801052bb:	85 c0                	test   %eax,%eax
801052bd:	75 15                	jne    801052d4 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801052bf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052c8:	81 e2 00 02 00 00    	and    $0x200,%edx
801052ce:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801052d4:	c9                   	leave  
801052d5:	c3                   	ret    

801052d6 <popcli>:

void
popcli(void)
{
801052d6:	55                   	push   %ebp
801052d7:	89 e5                	mov    %esp,%ebp
801052d9:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801052dc:	e8 06 fe ff ff       	call   801050e7 <readeflags>
801052e1:	25 00 02 00 00       	and    $0x200,%eax
801052e6:	85 c0                	test   %eax,%eax
801052e8:	74 0c                	je     801052f6 <popcli+0x20>
    panic("popcli - interruptible");
801052ea:	c7 04 24 2a 8c 10 80 	movl   $0x80108c2a,(%esp)
801052f1:	e8 44 b2 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
801052f6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052fc:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105302:	83 ea 01             	sub    $0x1,%edx
80105305:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010530b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105311:	85 c0                	test   %eax,%eax
80105313:	79 0c                	jns    80105321 <popcli+0x4b>
    panic("popcli");
80105315:	c7 04 24 41 8c 10 80 	movl   $0x80108c41,(%esp)
8010531c:	e8 19 b2 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105321:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105327:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010532d:	85 c0                	test   %eax,%eax
8010532f:	75 15                	jne    80105346 <popcli+0x70>
80105331:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105337:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010533d:	85 c0                	test   %eax,%eax
8010533f:	74 05                	je     80105346 <popcli+0x70>
    sti();
80105341:	e8 b7 fd ff ff       	call   801050fd <sti>
}
80105346:	c9                   	leave  
80105347:	c3                   	ret    

80105348 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105348:	55                   	push   %ebp
80105349:	89 e5                	mov    %esp,%ebp
8010534b:	57                   	push   %edi
8010534c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010534d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105350:	8b 55 10             	mov    0x10(%ebp),%edx
80105353:	8b 45 0c             	mov    0xc(%ebp),%eax
80105356:	89 cb                	mov    %ecx,%ebx
80105358:	89 df                	mov    %ebx,%edi
8010535a:	89 d1                	mov    %edx,%ecx
8010535c:	fc                   	cld    
8010535d:	f3 aa                	rep stos %al,%es:(%edi)
8010535f:	89 ca                	mov    %ecx,%edx
80105361:	89 fb                	mov    %edi,%ebx
80105363:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105366:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105369:	5b                   	pop    %ebx
8010536a:	5f                   	pop    %edi
8010536b:	5d                   	pop    %ebp
8010536c:	c3                   	ret    

8010536d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010536d:	55                   	push   %ebp
8010536e:	89 e5                	mov    %esp,%ebp
80105370:	57                   	push   %edi
80105371:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105372:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105375:	8b 55 10             	mov    0x10(%ebp),%edx
80105378:	8b 45 0c             	mov    0xc(%ebp),%eax
8010537b:	89 cb                	mov    %ecx,%ebx
8010537d:	89 df                	mov    %ebx,%edi
8010537f:	89 d1                	mov    %edx,%ecx
80105381:	fc                   	cld    
80105382:	f3 ab                	rep stos %eax,%es:(%edi)
80105384:	89 ca                	mov    %ecx,%edx
80105386:	89 fb                	mov    %edi,%ebx
80105388:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010538b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010538e:	5b                   	pop    %ebx
8010538f:	5f                   	pop    %edi
80105390:	5d                   	pop    %ebp
80105391:	c3                   	ret    

80105392 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105392:	55                   	push   %ebp
80105393:	89 e5                	mov    %esp,%ebp
80105395:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105398:	8b 45 08             	mov    0x8(%ebp),%eax
8010539b:	83 e0 03             	and    $0x3,%eax
8010539e:	85 c0                	test   %eax,%eax
801053a0:	75 49                	jne    801053eb <memset+0x59>
801053a2:	8b 45 10             	mov    0x10(%ebp),%eax
801053a5:	83 e0 03             	and    $0x3,%eax
801053a8:	85 c0                	test   %eax,%eax
801053aa:	75 3f                	jne    801053eb <memset+0x59>
    c &= 0xFF;
801053ac:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801053b3:	8b 45 10             	mov    0x10(%ebp),%eax
801053b6:	c1 e8 02             	shr    $0x2,%eax
801053b9:	89 c2                	mov    %eax,%edx
801053bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801053be:	c1 e0 18             	shl    $0x18,%eax
801053c1:	89 c1                	mov    %eax,%ecx
801053c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801053c6:	c1 e0 10             	shl    $0x10,%eax
801053c9:	09 c1                	or     %eax,%ecx
801053cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ce:	c1 e0 08             	shl    $0x8,%eax
801053d1:	09 c8                	or     %ecx,%eax
801053d3:	0b 45 0c             	or     0xc(%ebp),%eax
801053d6:	89 54 24 08          	mov    %edx,0x8(%esp)
801053da:	89 44 24 04          	mov    %eax,0x4(%esp)
801053de:	8b 45 08             	mov    0x8(%ebp),%eax
801053e1:	89 04 24             	mov    %eax,(%esp)
801053e4:	e8 84 ff ff ff       	call   8010536d <stosl>
801053e9:	eb 19                	jmp    80105404 <memset+0x72>
  } else
    stosb(dst, c, n);
801053eb:	8b 45 10             	mov    0x10(%ebp),%eax
801053ee:	89 44 24 08          	mov    %eax,0x8(%esp)
801053f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801053f9:	8b 45 08             	mov    0x8(%ebp),%eax
801053fc:	89 04 24             	mov    %eax,(%esp)
801053ff:	e8 44 ff ff ff       	call   80105348 <stosb>
  return dst;
80105404:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105407:	c9                   	leave  
80105408:	c3                   	ret    

80105409 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105409:	55                   	push   %ebp
8010540a:	89 e5                	mov    %esp,%ebp
8010540c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010540f:	8b 45 08             	mov    0x8(%ebp),%eax
80105412:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105415:	8b 45 0c             	mov    0xc(%ebp),%eax
80105418:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010541b:	eb 30                	jmp    8010544d <memcmp+0x44>
    if(*s1 != *s2)
8010541d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105420:	0f b6 10             	movzbl (%eax),%edx
80105423:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105426:	0f b6 00             	movzbl (%eax),%eax
80105429:	38 c2                	cmp    %al,%dl
8010542b:	74 18                	je     80105445 <memcmp+0x3c>
      return *s1 - *s2;
8010542d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105430:	0f b6 00             	movzbl (%eax),%eax
80105433:	0f b6 d0             	movzbl %al,%edx
80105436:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105439:	0f b6 00             	movzbl (%eax),%eax
8010543c:	0f b6 c0             	movzbl %al,%eax
8010543f:	29 c2                	sub    %eax,%edx
80105441:	89 d0                	mov    %edx,%eax
80105443:	eb 1a                	jmp    8010545f <memcmp+0x56>
    s1++, s2++;
80105445:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105449:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010544d:	8b 45 10             	mov    0x10(%ebp),%eax
80105450:	8d 50 ff             	lea    -0x1(%eax),%edx
80105453:	89 55 10             	mov    %edx,0x10(%ebp)
80105456:	85 c0                	test   %eax,%eax
80105458:	75 c3                	jne    8010541d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010545a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010545f:	c9                   	leave  
80105460:	c3                   	ret    

80105461 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105461:	55                   	push   %ebp
80105462:	89 e5                	mov    %esp,%ebp
80105464:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105467:	8b 45 0c             	mov    0xc(%ebp),%eax
8010546a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010546d:	8b 45 08             	mov    0x8(%ebp),%eax
80105470:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105473:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105476:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105479:	73 3d                	jae    801054b8 <memmove+0x57>
8010547b:	8b 45 10             	mov    0x10(%ebp),%eax
8010547e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105481:	01 d0                	add    %edx,%eax
80105483:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105486:	76 30                	jbe    801054b8 <memmove+0x57>
    s += n;
80105488:	8b 45 10             	mov    0x10(%ebp),%eax
8010548b:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010548e:	8b 45 10             	mov    0x10(%ebp),%eax
80105491:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105494:	eb 13                	jmp    801054a9 <memmove+0x48>
      *--d = *--s;
80105496:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010549a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010549e:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054a1:	0f b6 10             	movzbl (%eax),%edx
801054a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054a7:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801054a9:	8b 45 10             	mov    0x10(%ebp),%eax
801054ac:	8d 50 ff             	lea    -0x1(%eax),%edx
801054af:	89 55 10             	mov    %edx,0x10(%ebp)
801054b2:	85 c0                	test   %eax,%eax
801054b4:	75 e0                	jne    80105496 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801054b6:	eb 26                	jmp    801054de <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801054b8:	eb 17                	jmp    801054d1 <memmove+0x70>
      *d++ = *s++;
801054ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054bd:	8d 50 01             	lea    0x1(%eax),%edx
801054c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
801054c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054c6:	8d 4a 01             	lea    0x1(%edx),%ecx
801054c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801054cc:	0f b6 12             	movzbl (%edx),%edx
801054cf:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801054d1:	8b 45 10             	mov    0x10(%ebp),%eax
801054d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801054d7:	89 55 10             	mov    %edx,0x10(%ebp)
801054da:	85 c0                	test   %eax,%eax
801054dc:	75 dc                	jne    801054ba <memmove+0x59>
      *d++ = *s++;

  return dst;
801054de:	8b 45 08             	mov    0x8(%ebp),%eax
}
801054e1:	c9                   	leave  
801054e2:	c3                   	ret    

801054e3 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801054e3:	55                   	push   %ebp
801054e4:	89 e5                	mov    %esp,%ebp
801054e6:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801054e9:	8b 45 10             	mov    0x10(%ebp),%eax
801054ec:	89 44 24 08          	mov    %eax,0x8(%esp)
801054f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801054f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801054f7:	8b 45 08             	mov    0x8(%ebp),%eax
801054fa:	89 04 24             	mov    %eax,(%esp)
801054fd:	e8 5f ff ff ff       	call   80105461 <memmove>
}
80105502:	c9                   	leave  
80105503:	c3                   	ret    

80105504 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105504:	55                   	push   %ebp
80105505:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105507:	eb 0c                	jmp    80105515 <strncmp+0x11>
    n--, p++, q++;
80105509:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010550d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105511:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105515:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105519:	74 1a                	je     80105535 <strncmp+0x31>
8010551b:	8b 45 08             	mov    0x8(%ebp),%eax
8010551e:	0f b6 00             	movzbl (%eax),%eax
80105521:	84 c0                	test   %al,%al
80105523:	74 10                	je     80105535 <strncmp+0x31>
80105525:	8b 45 08             	mov    0x8(%ebp),%eax
80105528:	0f b6 10             	movzbl (%eax),%edx
8010552b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010552e:	0f b6 00             	movzbl (%eax),%eax
80105531:	38 c2                	cmp    %al,%dl
80105533:	74 d4                	je     80105509 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105535:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105539:	75 07                	jne    80105542 <strncmp+0x3e>
    return 0;
8010553b:	b8 00 00 00 00       	mov    $0x0,%eax
80105540:	eb 16                	jmp    80105558 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105542:	8b 45 08             	mov    0x8(%ebp),%eax
80105545:	0f b6 00             	movzbl (%eax),%eax
80105548:	0f b6 d0             	movzbl %al,%edx
8010554b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010554e:	0f b6 00             	movzbl (%eax),%eax
80105551:	0f b6 c0             	movzbl %al,%eax
80105554:	29 c2                	sub    %eax,%edx
80105556:	89 d0                	mov    %edx,%eax
}
80105558:	5d                   	pop    %ebp
80105559:	c3                   	ret    

8010555a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010555a:	55                   	push   %ebp
8010555b:	89 e5                	mov    %esp,%ebp
8010555d:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105560:	8b 45 08             	mov    0x8(%ebp),%eax
80105563:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105566:	90                   	nop
80105567:	8b 45 10             	mov    0x10(%ebp),%eax
8010556a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010556d:	89 55 10             	mov    %edx,0x10(%ebp)
80105570:	85 c0                	test   %eax,%eax
80105572:	7e 1e                	jle    80105592 <strncpy+0x38>
80105574:	8b 45 08             	mov    0x8(%ebp),%eax
80105577:	8d 50 01             	lea    0x1(%eax),%edx
8010557a:	89 55 08             	mov    %edx,0x8(%ebp)
8010557d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105580:	8d 4a 01             	lea    0x1(%edx),%ecx
80105583:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105586:	0f b6 12             	movzbl (%edx),%edx
80105589:	88 10                	mov    %dl,(%eax)
8010558b:	0f b6 00             	movzbl (%eax),%eax
8010558e:	84 c0                	test   %al,%al
80105590:	75 d5                	jne    80105567 <strncpy+0xd>
    ;
  while(n-- > 0)
80105592:	eb 0c                	jmp    801055a0 <strncpy+0x46>
    *s++ = 0;
80105594:	8b 45 08             	mov    0x8(%ebp),%eax
80105597:	8d 50 01             	lea    0x1(%eax),%edx
8010559a:	89 55 08             	mov    %edx,0x8(%ebp)
8010559d:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801055a0:	8b 45 10             	mov    0x10(%ebp),%eax
801055a3:	8d 50 ff             	lea    -0x1(%eax),%edx
801055a6:	89 55 10             	mov    %edx,0x10(%ebp)
801055a9:	85 c0                	test   %eax,%eax
801055ab:	7f e7                	jg     80105594 <strncpy+0x3a>
    *s++ = 0;
  return os;
801055ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055b0:	c9                   	leave  
801055b1:	c3                   	ret    

801055b2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801055b2:	55                   	push   %ebp
801055b3:	89 e5                	mov    %esp,%ebp
801055b5:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801055b8:	8b 45 08             	mov    0x8(%ebp),%eax
801055bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801055be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055c2:	7f 05                	jg     801055c9 <safestrcpy+0x17>
    return os;
801055c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055c7:	eb 31                	jmp    801055fa <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801055c9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801055cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801055d1:	7e 1e                	jle    801055f1 <safestrcpy+0x3f>
801055d3:	8b 45 08             	mov    0x8(%ebp),%eax
801055d6:	8d 50 01             	lea    0x1(%eax),%edx
801055d9:	89 55 08             	mov    %edx,0x8(%ebp)
801055dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801055df:	8d 4a 01             	lea    0x1(%edx),%ecx
801055e2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801055e5:	0f b6 12             	movzbl (%edx),%edx
801055e8:	88 10                	mov    %dl,(%eax)
801055ea:	0f b6 00             	movzbl (%eax),%eax
801055ed:	84 c0                	test   %al,%al
801055ef:	75 d8                	jne    801055c9 <safestrcpy+0x17>
    ;
  *s = 0;
801055f1:	8b 45 08             	mov    0x8(%ebp),%eax
801055f4:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801055f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055fa:	c9                   	leave  
801055fb:	c3                   	ret    

801055fc <strlen>:

int
strlen(const char *s)
{
801055fc:	55                   	push   %ebp
801055fd:	89 e5                	mov    %esp,%ebp
801055ff:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105602:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105609:	eb 04                	jmp    8010560f <strlen+0x13>
8010560b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010560f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105612:	8b 45 08             	mov    0x8(%ebp),%eax
80105615:	01 d0                	add    %edx,%eax
80105617:	0f b6 00             	movzbl (%eax),%eax
8010561a:	84 c0                	test   %al,%al
8010561c:	75 ed                	jne    8010560b <strlen+0xf>
    ;
  return n;
8010561e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105621:	c9                   	leave  
80105622:	c3                   	ret    

80105623 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105623:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105627:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010562b:	55                   	push   %ebp
  pushl %ebx
8010562c:	53                   	push   %ebx
  pushl %esi
8010562d:	56                   	push   %esi
  pushl %edi
8010562e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010562f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105631:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105633:	5f                   	pop    %edi
  popl %esi
80105634:	5e                   	pop    %esi
  popl %ebx
80105635:	5b                   	pop    %ebx
  popl %ebp
80105636:	5d                   	pop    %ebp
  ret
80105637:	c3                   	ret    

80105638 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105638:	55                   	push   %ebp
80105639:	89 e5                	mov    %esp,%ebp
  if(addr >= current->proc->sz || addr+4 > current->proc->sz)
8010563b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105641:	8b 00                	mov    (%eax),%eax
80105643:	8b 00                	mov    (%eax),%eax
80105645:	3b 45 08             	cmp    0x8(%ebp),%eax
80105648:	76 14                	jbe    8010565e <fetchint+0x26>
8010564a:	8b 45 08             	mov    0x8(%ebp),%eax
8010564d:	8d 50 04             	lea    0x4(%eax),%edx
80105650:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105656:	8b 00                	mov    (%eax),%eax
80105658:	8b 00                	mov    (%eax),%eax
8010565a:	39 c2                	cmp    %eax,%edx
8010565c:	76 07                	jbe    80105665 <fetchint+0x2d>
    return -1;
8010565e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105663:	eb 0f                	jmp    80105674 <fetchint+0x3c>
  *ip = *(int*)(addr);
80105665:	8b 45 08             	mov    0x8(%ebp),%eax
80105668:	8b 10                	mov    (%eax),%edx
8010566a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010566d:	89 10                	mov    %edx,(%eax)
  return 0;
8010566f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105674:	5d                   	pop    %ebp
80105675:	c3                   	ret    

80105676 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105676:	55                   	push   %ebp
80105677:	89 e5                	mov    %esp,%ebp
80105679:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= current->proc->sz)
8010567c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105682:	8b 00                	mov    (%eax),%eax
80105684:	8b 00                	mov    (%eax),%eax
80105686:	3b 45 08             	cmp    0x8(%ebp),%eax
80105689:	77 07                	ja     80105692 <fetchstr+0x1c>
    return -1;
8010568b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105690:	eb 48                	jmp    801056da <fetchstr+0x64>
  *pp = (char*)addr;
80105692:	8b 55 08             	mov    0x8(%ebp),%edx
80105695:	8b 45 0c             	mov    0xc(%ebp),%eax
80105698:	89 10                	mov    %edx,(%eax)
  ep = (char*)current->proc->sz;
8010569a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056a0:	8b 00                	mov    (%eax),%eax
801056a2:	8b 00                	mov    (%eax),%eax
801056a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801056a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801056aa:	8b 00                	mov    (%eax),%eax
801056ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
801056af:	eb 1c                	jmp    801056cd <fetchstr+0x57>
    if(*s == 0)
801056b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056b4:	0f b6 00             	movzbl (%eax),%eax
801056b7:	84 c0                	test   %al,%al
801056b9:	75 0e                	jne    801056c9 <fetchstr+0x53>
      return s - *pp;
801056bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056be:	8b 45 0c             	mov    0xc(%ebp),%eax
801056c1:	8b 00                	mov    (%eax),%eax
801056c3:	29 c2                	sub    %eax,%edx
801056c5:	89 d0                	mov    %edx,%eax
801056c7:	eb 11                	jmp    801056da <fetchstr+0x64>

  if(addr >= current->proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)current->proc->sz;
  for(s = *pp; s < ep; s++)
801056c9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801056d3:	72 dc                	jb     801056b1 <fetchstr+0x3b>
    if(*s == 0)
      return s - *pp;
  return -1;
801056d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056da:	c9                   	leave  
801056db:	c3                   	ret    

801056dc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801056dc:	55                   	push   %ebp
801056dd:	89 e5                	mov    %esp,%ebp
801056df:	83 ec 08             	sub    $0x8,%esp
  return fetchint(current->tf->esp + 4 + 4*n, ip);
801056e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056e8:	8b 40 78             	mov    0x78(%eax),%eax
801056eb:	8b 50 44             	mov    0x44(%eax),%edx
801056ee:	8b 45 08             	mov    0x8(%ebp),%eax
801056f1:	c1 e0 02             	shl    $0x2,%eax
801056f4:	01 d0                	add    %edx,%eax
801056f6:	8d 50 04             	lea    0x4(%eax),%edx
801056f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801056fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105700:	89 14 24             	mov    %edx,(%esp)
80105703:	e8 30 ff ff ff       	call   80105638 <fetchint>
}
80105708:	c9                   	leave  
80105709:	c3                   	ret    

8010570a <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010570a:	55                   	push   %ebp
8010570b:	89 e5                	mov    %esp,%ebp
8010570d:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105710:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105713:	89 44 24 04          	mov    %eax,0x4(%esp)
80105717:	8b 45 08             	mov    0x8(%ebp),%eax
8010571a:	89 04 24             	mov    %eax,(%esp)
8010571d:	e8 ba ff ff ff       	call   801056dc <argint>
80105722:	85 c0                	test   %eax,%eax
80105724:	79 07                	jns    8010572d <argptr+0x23>
    return -1;
80105726:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010572b:	eb 41                	jmp    8010576e <argptr+0x64>
  if((uint)i >= current->proc->sz || (uint)i+size > current->proc->sz)
8010572d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105730:	89 c2                	mov    %eax,%edx
80105732:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105738:	8b 00                	mov    (%eax),%eax
8010573a:	8b 00                	mov    (%eax),%eax
8010573c:	39 c2                	cmp    %eax,%edx
8010573e:	73 18                	jae    80105758 <argptr+0x4e>
80105740:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105743:	89 c2                	mov    %eax,%edx
80105745:	8b 45 10             	mov    0x10(%ebp),%eax
80105748:	01 c2                	add    %eax,%edx
8010574a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105750:	8b 00                	mov    (%eax),%eax
80105752:	8b 00                	mov    (%eax),%eax
80105754:	39 c2                	cmp    %eax,%edx
80105756:	76 07                	jbe    8010575f <argptr+0x55>
    return -1;
80105758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575d:	eb 0f                	jmp    8010576e <argptr+0x64>
  *pp = (char*)i;
8010575f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105762:	89 c2                	mov    %eax,%edx
80105764:	8b 45 0c             	mov    0xc(%ebp),%eax
80105767:	89 10                	mov    %edx,(%eax)
  return 0;
80105769:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010576e:	c9                   	leave  
8010576f:	c3                   	ret    

80105770 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105776:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105779:	89 44 24 04          	mov    %eax,0x4(%esp)
8010577d:	8b 45 08             	mov    0x8(%ebp),%eax
80105780:	89 04 24             	mov    %eax,(%esp)
80105783:	e8 54 ff ff ff       	call   801056dc <argint>
80105788:	85 c0                	test   %eax,%eax
8010578a:	79 07                	jns    80105793 <argstr+0x23>
    return -1;
8010578c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105791:	eb 12                	jmp    801057a5 <argstr+0x35>
  return fetchstr(addr, pp);
80105793:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105796:	8b 55 0c             	mov    0xc(%ebp),%edx
80105799:	89 54 24 04          	mov    %edx,0x4(%esp)
8010579d:	89 04 24             	mov    %eax,(%esp)
801057a0:	e8 d1 fe ff ff       	call   80105676 <fetchstr>
}
801057a5:	c9                   	leave  
801057a6:	c3                   	ret    

801057a7 <syscall>:
[SYS_thread_join] sys_thread_join,
};

void
syscall(void)
{
801057a7:	55                   	push   %ebp
801057a8:	89 e5                	mov    %esp,%ebp
801057aa:	53                   	push   %ebx
801057ab:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = current->tf->eax;
801057ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057b4:	8b 40 78             	mov    0x78(%eax),%eax
801057b7:	8b 40 1c             	mov    0x1c(%eax),%eax
801057ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801057bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057c1:	7e 30                	jle    801057f3 <syscall+0x4c>
801057c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c6:	83 f8 18             	cmp    $0x18,%eax
801057c9:	77 28                	ja     801057f3 <syscall+0x4c>
801057cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ce:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801057d5:	85 c0                	test   %eax,%eax
801057d7:	74 1a                	je     801057f3 <syscall+0x4c>
    current->tf->eax = syscalls[num]();
801057d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057df:	8b 58 78             	mov    0x78(%eax),%ebx
801057e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e5:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801057ec:	ff d0                	call   *%eax
801057ee:	89 43 1c             	mov    %eax,0x1c(%ebx)
801057f1:	eb 41                	jmp    80105834 <syscall+0x8d>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            current->proc->pid, current->proc->name, num);
801057f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057f9:	8b 00                	mov    (%eax),%eax
801057fb:	8d 48 50             	lea    0x50(%eax),%ecx
801057fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105804:	8b 00                	mov    (%eax),%eax

  num = current->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    current->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105806:	8b 40 04             	mov    0x4(%eax),%eax
80105809:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010580c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105810:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105814:	89 44 24 04          	mov    %eax,0x4(%esp)
80105818:	c7 04 24 48 8c 10 80 	movl   $0x80108c48,(%esp)
8010581f:	e8 7c ab ff ff       	call   801003a0 <cprintf>
            current->proc->pid, current->proc->name, num);
    current->tf->eax = -1;
80105824:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010582a:	8b 40 78             	mov    0x78(%eax),%eax
8010582d:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105834:	83 c4 24             	add    $0x24,%esp
80105837:	5b                   	pop    %ebx
80105838:	5d                   	pop    %ebp
80105839:	c3                   	ret    

8010583a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010583a:	55                   	push   %ebp
8010583b:	89 e5                	mov    %esp,%ebp
8010583d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105840:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105843:	89 44 24 04          	mov    %eax,0x4(%esp)
80105847:	8b 45 08             	mov    0x8(%ebp),%eax
8010584a:	89 04 24             	mov    %eax,(%esp)
8010584d:	e8 8a fe ff ff       	call   801056dc <argint>
80105852:	85 c0                	test   %eax,%eax
80105854:	79 07                	jns    8010585d <argfd+0x23>
    return -1;
80105856:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585b:	eb 4f                	jmp    801058ac <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=current->proc->ofile[fd]) == 0)
8010585d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105860:	85 c0                	test   %eax,%eax
80105862:	78 20                	js     80105884 <argfd+0x4a>
80105864:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105867:	83 f8 0f             	cmp    $0xf,%eax
8010586a:	7f 18                	jg     80105884 <argfd+0x4a>
8010586c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105872:	8b 00                	mov    (%eax),%eax
80105874:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105877:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
8010587b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010587e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105882:	75 07                	jne    8010588b <argfd+0x51>
    return -1;
80105884:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105889:	eb 21                	jmp    801058ac <argfd+0x72>
  if(pfd)
8010588b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010588f:	74 08                	je     80105899 <argfd+0x5f>
    *pfd = fd;
80105891:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105894:	8b 45 0c             	mov    0xc(%ebp),%eax
80105897:	89 10                	mov    %edx,(%eax)
  if(pf)
80105899:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010589d:	74 08                	je     801058a7 <argfd+0x6d>
    *pf = f;
8010589f:	8b 45 10             	mov    0x10(%ebp),%eax
801058a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058a5:	89 10                	mov    %edx,(%eax)
  return 0;
801058a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058ac:	c9                   	leave  
801058ad:	c3                   	ret    

801058ae <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801058ae:	55                   	push   %ebp
801058af:	89 e5                	mov    %esp,%ebp
801058b1:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801058b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801058bb:	eb 2e                	jmp    801058eb <fdalloc+0x3d>
    if(current->proc->ofile[fd] == 0){
801058bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c3:	8b 00                	mov    (%eax),%eax
801058c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058c8:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
801058cc:	85 c0                	test   %eax,%eax
801058ce:	75 17                	jne    801058e7 <fdalloc+0x39>
      current->proc->ofile[fd] = f;
801058d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058d6:	8b 00                	mov    (%eax),%eax
801058d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058db:	8b 4d 08             	mov    0x8(%ebp),%ecx
801058de:	89 4c 90 0c          	mov    %ecx,0xc(%eax,%edx,4)
      return fd;
801058e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058e5:	eb 0f                	jmp    801058f6 <fdalloc+0x48>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801058e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058eb:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801058ef:	7e cc                	jle    801058bd <fdalloc+0xf>
    if(current->proc->ofile[fd] == 0){
      current->proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801058f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f6:	c9                   	leave  
801058f7:	c3                   	ret    

801058f8 <sys_dup>:

int
sys_dup(void)
{
801058f8:	55                   	push   %ebp
801058f9:	89 e5                	mov    %esp,%ebp
801058fb:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801058fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105901:	89 44 24 08          	mov    %eax,0x8(%esp)
80105905:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010590c:	00 
8010590d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105914:	e8 21 ff ff ff       	call   8010583a <argfd>
80105919:	85 c0                	test   %eax,%eax
8010591b:	79 07                	jns    80105924 <sys_dup+0x2c>
    return -1;
8010591d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105922:	eb 29                	jmp    8010594d <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105924:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105927:	89 04 24             	mov    %eax,(%esp)
8010592a:	e8 7f ff ff ff       	call   801058ae <fdalloc>
8010592f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105932:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105936:	79 07                	jns    8010593f <sys_dup+0x47>
    return -1;
80105938:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593d:	eb 0e                	jmp    8010594d <sys_dup+0x55>
  filedup(f);
8010593f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105942:	89 04 24             	mov    %eax,(%esp)
80105945:	e8 4d b6 ff ff       	call   80100f97 <filedup>
  return fd;
8010594a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010594d:	c9                   	leave  
8010594e:	c3                   	ret    

8010594f <sys_read>:

int
sys_read(void)
{
8010594f:	55                   	push   %ebp
80105950:	89 e5                	mov    %esp,%ebp
80105952:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105955:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105958:	89 44 24 08          	mov    %eax,0x8(%esp)
8010595c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105963:	00 
80105964:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010596b:	e8 ca fe ff ff       	call   8010583a <argfd>
80105970:	85 c0                	test   %eax,%eax
80105972:	78 35                	js     801059a9 <sys_read+0x5a>
80105974:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105977:	89 44 24 04          	mov    %eax,0x4(%esp)
8010597b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105982:	e8 55 fd ff ff       	call   801056dc <argint>
80105987:	85 c0                	test   %eax,%eax
80105989:	78 1e                	js     801059a9 <sys_read+0x5a>
8010598b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010598e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105992:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105995:	89 44 24 04          	mov    %eax,0x4(%esp)
80105999:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801059a0:	e8 65 fd ff ff       	call   8010570a <argptr>
801059a5:	85 c0                	test   %eax,%eax
801059a7:	79 07                	jns    801059b0 <sys_read+0x61>
    return -1;
801059a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ae:	eb 19                	jmp    801059c9 <sys_read+0x7a>
  return fileread(f, p, n);
801059b0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801059b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801059b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801059bd:	89 54 24 04          	mov    %edx,0x4(%esp)
801059c1:	89 04 24             	mov    %eax,(%esp)
801059c4:	e8 3b b7 ff ff       	call   80101104 <fileread>
}
801059c9:	c9                   	leave  
801059ca:	c3                   	ret    

801059cb <sys_write>:

int
sys_write(void)
{
801059cb:	55                   	push   %ebp
801059cc:	89 e5                	mov    %esp,%ebp
801059ce:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d4:	89 44 24 08          	mov    %eax,0x8(%esp)
801059d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059df:	00 
801059e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059e7:	e8 4e fe ff ff       	call   8010583a <argfd>
801059ec:	85 c0                	test   %eax,%eax
801059ee:	78 35                	js     80105a25 <sys_write+0x5a>
801059f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801059f7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801059fe:	e8 d9 fc ff ff       	call   801056dc <argint>
80105a03:	85 c0                	test   %eax,%eax
80105a05:	78 1e                	js     80105a25 <sys_write+0x5a>
80105a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a0a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a11:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a1c:	e8 e9 fc ff ff       	call   8010570a <argptr>
80105a21:	85 c0                	test   %eax,%eax
80105a23:	79 07                	jns    80105a2c <sys_write+0x61>
    return -1;
80105a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a2a:	eb 19                	jmp    80105a45 <sys_write+0x7a>
  return filewrite(f, p, n);
80105a2c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105a2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a35:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105a39:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a3d:	89 04 24             	mov    %eax,(%esp)
80105a40:	e8 7b b7 ff ff       	call   801011c0 <filewrite>
}
80105a45:	c9                   	leave  
80105a46:	c3                   	ret    

80105a47 <sys_close>:

int
sys_close(void)
{
80105a47:	55                   	push   %ebp
80105a48:	89 e5                	mov    %esp,%ebp
80105a4a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105a4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a50:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a57:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a62:	e8 d3 fd ff ff       	call   8010583a <argfd>
80105a67:	85 c0                	test   %eax,%eax
80105a69:	79 07                	jns    80105a72 <sys_close+0x2b>
    return -1;
80105a6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a70:	eb 23                	jmp    80105a95 <sys_close+0x4e>
  current->proc->ofile[fd] = 0;
80105a72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a78:	8b 00                	mov    (%eax),%eax
80105a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a7d:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80105a84:	00 
  fileclose(f);
80105a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a88:	89 04 24             	mov    %eax,(%esp)
80105a8b:	e8 4f b5 ff ff       	call   80100fdf <fileclose>
  return 0;
80105a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    

80105a97 <sys_fstat>:

int
sys_fstat(void)
{
80105a97:	55                   	push   %ebp
80105a98:	89 e5                	mov    %esp,%ebp
80105a9a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aa0:	89 44 24 08          	mov    %eax,0x8(%esp)
80105aa4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105aab:	00 
80105aac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ab3:	e8 82 fd ff ff       	call   8010583a <argfd>
80105ab8:	85 c0                	test   %eax,%eax
80105aba:	78 1f                	js     80105adb <sys_fstat+0x44>
80105abc:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105ac3:	00 
80105ac4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105acb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ad2:	e8 33 fc ff ff       	call   8010570a <argptr>
80105ad7:	85 c0                	test   %eax,%eax
80105ad9:	79 07                	jns    80105ae2 <sys_fstat+0x4b>
    return -1;
80105adb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae0:	eb 12                	jmp    80105af4 <sys_fstat+0x5d>
  return filestat(f, st);
80105ae2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae8:	89 54 24 04          	mov    %edx,0x4(%esp)
80105aec:	89 04 24             	mov    %eax,(%esp)
80105aef:	e8 c1 b5 ff ff       	call   801010b5 <filestat>
}
80105af4:	c9                   	leave  
80105af5:	c3                   	ret    

80105af6 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105af6:	55                   	push   %ebp
80105af7:	89 e5                	mov    %esp,%ebp
80105af9:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105afc:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105aff:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b0a:	e8 61 fc ff ff       	call   80105770 <argstr>
80105b0f:	85 c0                	test   %eax,%eax
80105b11:	78 17                	js     80105b2a <sys_link+0x34>
80105b13:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105b16:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b21:	e8 4a fc ff ff       	call   80105770 <argstr>
80105b26:	85 c0                	test   %eax,%eax
80105b28:	79 0a                	jns    80105b34 <sys_link+0x3e>
    return -1;
80105b2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2f:	e9 42 01 00 00       	jmp    80105c76 <sys_link+0x180>

  begin_op();
80105b34:	e8 ea d8 ff ff       	call   80103423 <begin_op>
  if((ip = namei(old)) == 0){
80105b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105b3c:	89 04 24             	mov    %eax,(%esp)
80105b3f:	e8 d5 c8 ff ff       	call   80102419 <namei>
80105b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b4b:	75 0f                	jne    80105b5c <sys_link+0x66>
    end_op();
80105b4d:	e8 55 d9 ff ff       	call   801034a7 <end_op>
    return -1;
80105b52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b57:	e9 1a 01 00 00       	jmp    80105c76 <sys_link+0x180>
  }

  ilock(ip);
80105b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5f:	89 04 24             	mov    %eax,(%esp)
80105b62:	e8 05 bd ff ff       	call   8010186c <ilock>
  if(ip->type == T_DIR){
80105b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b6e:	66 83 f8 01          	cmp    $0x1,%ax
80105b72:	75 1a                	jne    80105b8e <sys_link+0x98>
    iunlockput(ip);
80105b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b77:	89 04 24             	mov    %eax,(%esp)
80105b7a:	e8 71 bf ff ff       	call   80101af0 <iunlockput>
    end_op();
80105b7f:	e8 23 d9 ff ff       	call   801034a7 <end_op>
    return -1;
80105b84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b89:	e9 e8 00 00 00       	jmp    80105c76 <sys_link+0x180>
  }

  ip->nlink++;
80105b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b91:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b95:	8d 50 01             	lea    0x1(%eax),%edx
80105b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b9b:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba2:	89 04 24             	mov    %eax,(%esp)
80105ba5:	e8 06 bb ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80105baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bad:	89 04 24             	mov    %eax,(%esp)
80105bb0:	e8 05 be ff ff       	call   801019ba <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105bb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bb8:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bbf:	89 04 24             	mov    %eax,(%esp)
80105bc2:	e8 74 c8 ff ff       	call   8010243b <nameiparent>
80105bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105bca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bce:	75 02                	jne    80105bd2 <sys_link+0xdc>
    goto bad;
80105bd0:	eb 68                	jmp    80105c3a <sys_link+0x144>
  ilock(dp);
80105bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd5:	89 04 24             	mov    %eax,(%esp)
80105bd8:	e8 8f bc ff ff       	call   8010186c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be0:	8b 10                	mov    (%eax),%edx
80105be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be5:	8b 00                	mov    (%eax),%eax
80105be7:	39 c2                	cmp    %eax,%edx
80105be9:	75 20                	jne    80105c0b <sys_link+0x115>
80105beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bee:	8b 40 04             	mov    0x4(%eax),%eax
80105bf1:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bf5:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bff:	89 04 24             	mov    %eax,(%esp)
80105c02:	e8 50 c5 ff ff       	call   80102157 <dirlink>
80105c07:	85 c0                	test   %eax,%eax
80105c09:	79 0d                	jns    80105c18 <sys_link+0x122>
    iunlockput(dp);
80105c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0e:	89 04 24             	mov    %eax,(%esp)
80105c11:	e8 da be ff ff       	call   80101af0 <iunlockput>
    goto bad;
80105c16:	eb 22                	jmp    80105c3a <sys_link+0x144>
  }
  iunlockput(dp);
80105c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1b:	89 04 24             	mov    %eax,(%esp)
80105c1e:	e8 cd be ff ff       	call   80101af0 <iunlockput>
  iput(ip);
80105c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c26:	89 04 24             	mov    %eax,(%esp)
80105c29:	e8 f1 bd ff ff       	call   80101a1f <iput>

  end_op();
80105c2e:	e8 74 d8 ff ff       	call   801034a7 <end_op>

  return 0;
80105c33:	b8 00 00 00 00       	mov    $0x0,%eax
80105c38:	eb 3c                	jmp    80105c76 <sys_link+0x180>

bad:
  ilock(ip);
80105c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3d:	89 04 24             	mov    %eax,(%esp)
80105c40:	e8 27 bc ff ff       	call   8010186c <ilock>
  ip->nlink--;
80105c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c48:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c4c:	8d 50 ff             	lea    -0x1(%eax),%edx
80105c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c52:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c59:	89 04 24             	mov    %eax,(%esp)
80105c5c:	e8 4f ba ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c64:	89 04 24             	mov    %eax,(%esp)
80105c67:	e8 84 be ff ff       	call   80101af0 <iunlockput>
  end_op();
80105c6c:	e8 36 d8 ff ff       	call   801034a7 <end_op>
  return -1;
80105c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c76:	c9                   	leave  
80105c77:	c3                   	ret    

80105c78 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105c78:	55                   	push   %ebp
80105c79:	89 e5                	mov    %esp,%ebp
80105c7b:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c7e:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105c85:	eb 4b                	jmp    80105cd2 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c8a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105c91:	00 
80105c92:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c96:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c99:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80105ca0:	89 04 24             	mov    %eax,(%esp)
80105ca3:	e8 d1 c0 ff ff       	call   80101d79 <readi>
80105ca8:	83 f8 10             	cmp    $0x10,%eax
80105cab:	74 0c                	je     80105cb9 <isdirempty+0x41>
      panic("isdirempty: readi");
80105cad:	c7 04 24 64 8c 10 80 	movl   $0x80108c64,(%esp)
80105cb4:	e8 81 a8 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80105cb9:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105cbd:	66 85 c0             	test   %ax,%ax
80105cc0:	74 07                	je     80105cc9 <isdirempty+0x51>
      return 0;
80105cc2:	b8 00 00 00 00       	mov    $0x0,%eax
80105cc7:	eb 1b                	jmp    80105ce4 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ccc:	83 c0 10             	add    $0x10,%eax
80105ccf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80105cd8:	8b 40 18             	mov    0x18(%eax),%eax
80105cdb:	39 c2                	cmp    %eax,%edx
80105cdd:	72 a8                	jb     80105c87 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105cdf:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105ce4:	c9                   	leave  
80105ce5:	c3                   	ret    

80105ce6 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105ce6:	55                   	push   %ebp
80105ce7:	89 e5                	mov    %esp,%ebp
80105ce9:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105cec:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105cef:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cf3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cfa:	e8 71 fa ff ff       	call   80105770 <argstr>
80105cff:	85 c0                	test   %eax,%eax
80105d01:	79 0a                	jns    80105d0d <sys_unlink+0x27>
    return -1;
80105d03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d08:	e9 af 01 00 00       	jmp    80105ebc <sys_unlink+0x1d6>

  begin_op();
80105d0d:	e8 11 d7 ff ff       	call   80103423 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105d12:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105d15:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105d18:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d1c:	89 04 24             	mov    %eax,(%esp)
80105d1f:	e8 17 c7 ff ff       	call   8010243b <nameiparent>
80105d24:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d2b:	75 0f                	jne    80105d3c <sys_unlink+0x56>
    end_op();
80105d2d:	e8 75 d7 ff ff       	call   801034a7 <end_op>
    return -1;
80105d32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d37:	e9 80 01 00 00       	jmp    80105ebc <sys_unlink+0x1d6>
  }

  ilock(dp);
80105d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d3f:	89 04 24             	mov    %eax,(%esp)
80105d42:	e8 25 bb ff ff       	call   8010186c <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105d47:	c7 44 24 04 76 8c 10 	movl   $0x80108c76,0x4(%esp)
80105d4e:	80 
80105d4f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d52:	89 04 24             	mov    %eax,(%esp)
80105d55:	e8 12 c3 ff ff       	call   8010206c <namecmp>
80105d5a:	85 c0                	test   %eax,%eax
80105d5c:	0f 84 45 01 00 00    	je     80105ea7 <sys_unlink+0x1c1>
80105d62:	c7 44 24 04 78 8c 10 	movl   $0x80108c78,0x4(%esp)
80105d69:	80 
80105d6a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d6d:	89 04 24             	mov    %eax,(%esp)
80105d70:	e8 f7 c2 ff ff       	call   8010206c <namecmp>
80105d75:	85 c0                	test   %eax,%eax
80105d77:	0f 84 2a 01 00 00    	je     80105ea7 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105d7d:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105d80:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d84:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105d87:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d8e:	89 04 24             	mov    %eax,(%esp)
80105d91:	e8 f8 c2 ff ff       	call   8010208e <dirlookup>
80105d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d9d:	75 05                	jne    80105da4 <sys_unlink+0xbe>
    goto bad;
80105d9f:	e9 03 01 00 00       	jmp    80105ea7 <sys_unlink+0x1c1>
  ilock(ip);
80105da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da7:	89 04 24             	mov    %eax,(%esp)
80105daa:	e8 bd ba ff ff       	call   8010186c <ilock>

  if(ip->nlink < 1)
80105daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db2:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105db6:	66 85 c0             	test   %ax,%ax
80105db9:	7f 0c                	jg     80105dc7 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105dbb:	c7 04 24 7b 8c 10 80 	movl   $0x80108c7b,(%esp)
80105dc2:	e8 73 a7 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dca:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105dce:	66 83 f8 01          	cmp    $0x1,%ax
80105dd2:	75 1f                	jne    80105df3 <sys_unlink+0x10d>
80105dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd7:	89 04 24             	mov    %eax,(%esp)
80105dda:	e8 99 fe ff ff       	call   80105c78 <isdirempty>
80105ddf:	85 c0                	test   %eax,%eax
80105de1:	75 10                	jne    80105df3 <sys_unlink+0x10d>
    iunlockput(ip);
80105de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de6:	89 04 24             	mov    %eax,(%esp)
80105de9:	e8 02 bd ff ff       	call   80101af0 <iunlockput>
    goto bad;
80105dee:	e9 b4 00 00 00       	jmp    80105ea7 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105df3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105dfa:	00 
80105dfb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e02:	00 
80105e03:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e06:	89 04 24             	mov    %eax,(%esp)
80105e09:	e8 84 f5 ff ff       	call   80105392 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e0e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105e11:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105e18:	00 
80105e19:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e1d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e20:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e27:	89 04 24             	mov    %eax,(%esp)
80105e2a:	e8 ae c0 ff ff       	call   80101edd <writei>
80105e2f:	83 f8 10             	cmp    $0x10,%eax
80105e32:	74 0c                	je     80105e40 <sys_unlink+0x15a>
    panic("unlink: writei");
80105e34:	c7 04 24 8d 8c 10 80 	movl   $0x80108c8d,(%esp)
80105e3b:	e8 fa a6 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e43:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e47:	66 83 f8 01          	cmp    $0x1,%ax
80105e4b:	75 1c                	jne    80105e69 <sys_unlink+0x183>
    dp->nlink--;
80105e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e50:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e54:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e5a:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e61:	89 04 24             	mov    %eax,(%esp)
80105e64:	e8 47 b8 ff ff       	call   801016b0 <iupdate>
  }
  iunlockput(dp);
80105e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e6c:	89 04 24             	mov    %eax,(%esp)
80105e6f:	e8 7c bc ff ff       	call   80101af0 <iunlockput>

  ip->nlink--;
80105e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e77:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e7b:	8d 50 ff             	lea    -0x1(%eax),%edx
80105e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e81:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e88:	89 04 24             	mov    %eax,(%esp)
80105e8b:	e8 20 b8 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e93:	89 04 24             	mov    %eax,(%esp)
80105e96:	e8 55 bc ff ff       	call   80101af0 <iunlockput>

  end_op();
80105e9b:	e8 07 d6 ff ff       	call   801034a7 <end_op>

  return 0;
80105ea0:	b8 00 00 00 00       	mov    $0x0,%eax
80105ea5:	eb 15                	jmp    80105ebc <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80105ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eaa:	89 04 24             	mov    %eax,(%esp)
80105ead:	e8 3e bc ff ff       	call   80101af0 <iunlockput>
  end_op();
80105eb2:	e8 f0 d5 ff ff       	call   801034a7 <end_op>
  return -1;
80105eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ebc:	c9                   	leave  
80105ebd:	c3                   	ret    

80105ebe <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105ebe:	55                   	push   %ebp
80105ebf:	89 e5                	mov    %esp,%ebp
80105ec1:	83 ec 48             	sub    $0x48,%esp
80105ec4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105ec7:	8b 55 10             	mov    0x10(%ebp),%edx
80105eca:	8b 45 14             	mov    0x14(%ebp),%eax
80105ecd:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105ed1:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105ed5:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105ed9:	8d 45 de             	lea    -0x22(%ebp),%eax
80105edc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80105ee3:	89 04 24             	mov    %eax,(%esp)
80105ee6:	e8 50 c5 ff ff       	call   8010243b <nameiparent>
80105eeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ef2:	75 0a                	jne    80105efe <create+0x40>
    return 0;
80105ef4:	b8 00 00 00 00       	mov    $0x0,%eax
80105ef9:	e9 7e 01 00 00       	jmp    8010607c <create+0x1be>
  ilock(dp);
80105efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f01:	89 04 24             	mov    %eax,(%esp)
80105f04:	e8 63 b9 ff ff       	call   8010186c <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105f09:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f10:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f13:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f1a:	89 04 24             	mov    %eax,(%esp)
80105f1d:	e8 6c c1 ff ff       	call   8010208e <dirlookup>
80105f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f29:	74 47                	je     80105f72 <create+0xb4>
    iunlockput(dp);
80105f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f2e:	89 04 24             	mov    %eax,(%esp)
80105f31:	e8 ba bb ff ff       	call   80101af0 <iunlockput>
    ilock(ip);
80105f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f39:	89 04 24             	mov    %eax,(%esp)
80105f3c:	e8 2b b9 ff ff       	call   8010186c <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105f41:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105f46:	75 15                	jne    80105f5d <create+0x9f>
80105f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f4b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f4f:	66 83 f8 02          	cmp    $0x2,%ax
80105f53:	75 08                	jne    80105f5d <create+0x9f>
      return ip;
80105f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f58:	e9 1f 01 00 00       	jmp    8010607c <create+0x1be>
    iunlockput(ip);
80105f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f60:	89 04 24             	mov    %eax,(%esp)
80105f63:	e8 88 bb ff ff       	call   80101af0 <iunlockput>
    return 0;
80105f68:	b8 00 00 00 00       	mov    $0x0,%eax
80105f6d:	e9 0a 01 00 00       	jmp    8010607c <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105f72:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f79:	8b 00                	mov    (%eax),%eax
80105f7b:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f7f:	89 04 24             	mov    %eax,(%esp)
80105f82:	e8 4a b6 ff ff       	call   801015d1 <ialloc>
80105f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f8e:	75 0c                	jne    80105f9c <create+0xde>
    panic("create: ialloc");
80105f90:	c7 04 24 9c 8c 10 80 	movl   $0x80108c9c,(%esp)
80105f97:	e8 9e a5 ff ff       	call   8010053a <panic>

  ilock(ip);
80105f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f9f:	89 04 24             	mov    %eax,(%esp)
80105fa2:	e8 c5 b8 ff ff       	call   8010186c <ilock>
  ip->major = major;
80105fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105faa:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105fae:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fb5:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105fb9:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc0:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc9:	89 04 24             	mov    %eax,(%esp)
80105fcc:	e8 df b6 ff ff       	call   801016b0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105fd1:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105fd6:	75 6a                	jne    80106042 <create+0x184>
    dp->nlink++;  // for ".."
80105fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fdb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105fdf:	8d 50 01             	lea    0x1(%eax),%edx
80105fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe5:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fec:	89 04 24             	mov    %eax,(%esp)
80105fef:	e8 bc b6 ff ff       	call   801016b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff7:	8b 40 04             	mov    0x4(%eax),%eax
80105ffa:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ffe:	c7 44 24 04 76 8c 10 	movl   $0x80108c76,0x4(%esp)
80106005:	80 
80106006:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106009:	89 04 24             	mov    %eax,(%esp)
8010600c:	e8 46 c1 ff ff       	call   80102157 <dirlink>
80106011:	85 c0                	test   %eax,%eax
80106013:	78 21                	js     80106036 <create+0x178>
80106015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106018:	8b 40 04             	mov    0x4(%eax),%eax
8010601b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010601f:	c7 44 24 04 78 8c 10 	movl   $0x80108c78,0x4(%esp)
80106026:	80 
80106027:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010602a:	89 04 24             	mov    %eax,(%esp)
8010602d:	e8 25 c1 ff ff       	call   80102157 <dirlink>
80106032:	85 c0                	test   %eax,%eax
80106034:	79 0c                	jns    80106042 <create+0x184>
      panic("create dots");
80106036:	c7 04 24 ab 8c 10 80 	movl   $0x80108cab,(%esp)
8010603d:	e8 f8 a4 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106042:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106045:	8b 40 04             	mov    0x4(%eax),%eax
80106048:	89 44 24 08          	mov    %eax,0x8(%esp)
8010604c:	8d 45 de             	lea    -0x22(%ebp),%eax
8010604f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106056:	89 04 24             	mov    %eax,(%esp)
80106059:	e8 f9 c0 ff ff       	call   80102157 <dirlink>
8010605e:	85 c0                	test   %eax,%eax
80106060:	79 0c                	jns    8010606e <create+0x1b0>
    panic("create: dirlink");
80106062:	c7 04 24 b7 8c 10 80 	movl   $0x80108cb7,(%esp)
80106069:	e8 cc a4 ff ff       	call   8010053a <panic>

  iunlockput(dp);
8010606e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106071:	89 04 24             	mov    %eax,(%esp)
80106074:	e8 77 ba ff ff       	call   80101af0 <iunlockput>

  return ip;
80106079:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010607c:	c9                   	leave  
8010607d:	c3                   	ret    

8010607e <sys_open>:

int
sys_open(void)
{
8010607e:	55                   	push   %ebp
8010607f:	89 e5                	mov    %esp,%ebp
80106081:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106084:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106087:	89 44 24 04          	mov    %eax,0x4(%esp)
8010608b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106092:	e8 d9 f6 ff ff       	call   80105770 <argstr>
80106097:	85 c0                	test   %eax,%eax
80106099:	78 17                	js     801060b2 <sys_open+0x34>
8010609b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010609e:	89 44 24 04          	mov    %eax,0x4(%esp)
801060a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060a9:	e8 2e f6 ff ff       	call   801056dc <argint>
801060ae:	85 c0                	test   %eax,%eax
801060b0:	79 0a                	jns    801060bc <sys_open+0x3e>
    return -1;
801060b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b7:	e9 5c 01 00 00       	jmp    80106218 <sys_open+0x19a>

  begin_op();
801060bc:	e8 62 d3 ff ff       	call   80103423 <begin_op>

  if(omode & O_CREATE){
801060c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060c4:	25 00 02 00 00       	and    $0x200,%eax
801060c9:	85 c0                	test   %eax,%eax
801060cb:	74 3b                	je     80106108 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
801060cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060d0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801060d7:	00 
801060d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801060df:	00 
801060e0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
801060e7:	00 
801060e8:	89 04 24             	mov    %eax,(%esp)
801060eb:	e8 ce fd ff ff       	call   80105ebe <create>
801060f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801060f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060f7:	75 6b                	jne    80106164 <sys_open+0xe6>
      end_op();
801060f9:	e8 a9 d3 ff ff       	call   801034a7 <end_op>
      return -1;
801060fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106103:	e9 10 01 00 00       	jmp    80106218 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80106108:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010610b:	89 04 24             	mov    %eax,(%esp)
8010610e:	e8 06 c3 ff ff       	call   80102419 <namei>
80106113:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106116:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010611a:	75 0f                	jne    8010612b <sys_open+0xad>
      end_op();
8010611c:	e8 86 d3 ff ff       	call   801034a7 <end_op>
      return -1;
80106121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106126:	e9 ed 00 00 00       	jmp    80106218 <sys_open+0x19a>
    }
    ilock(ip);
8010612b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612e:	89 04 24             	mov    %eax,(%esp)
80106131:	e8 36 b7 ff ff       	call   8010186c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106136:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106139:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010613d:	66 83 f8 01          	cmp    $0x1,%ax
80106141:	75 21                	jne    80106164 <sys_open+0xe6>
80106143:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106146:	85 c0                	test   %eax,%eax
80106148:	74 1a                	je     80106164 <sys_open+0xe6>
      iunlockput(ip);
8010614a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010614d:	89 04 24             	mov    %eax,(%esp)
80106150:	e8 9b b9 ff ff       	call   80101af0 <iunlockput>
      end_op();
80106155:	e8 4d d3 ff ff       	call   801034a7 <end_op>
      return -1;
8010615a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010615f:	e9 b4 00 00 00       	jmp    80106218 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106164:	e8 ce ad ff ff       	call   80100f37 <filealloc>
80106169:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010616c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106170:	74 14                	je     80106186 <sys_open+0x108>
80106172:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106175:	89 04 24             	mov    %eax,(%esp)
80106178:	e8 31 f7 ff ff       	call   801058ae <fdalloc>
8010617d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106180:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106184:	79 28                	jns    801061ae <sys_open+0x130>
    if(f)
80106186:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010618a:	74 0b                	je     80106197 <sys_open+0x119>
      fileclose(f);
8010618c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010618f:	89 04 24             	mov    %eax,(%esp)
80106192:	e8 48 ae ff ff       	call   80100fdf <fileclose>
    iunlockput(ip);
80106197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010619a:	89 04 24             	mov    %eax,(%esp)
8010619d:	e8 4e b9 ff ff       	call   80101af0 <iunlockput>
    end_op();
801061a2:	e8 00 d3 ff ff       	call   801034a7 <end_op>
    return -1;
801061a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ac:	eb 6a                	jmp    80106218 <sys_open+0x19a>
  }
  iunlock(ip);
801061ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b1:	89 04 24             	mov    %eax,(%esp)
801061b4:	e8 01 b8 ff ff       	call   801019ba <iunlock>
  end_op();
801061b9:	e8 e9 d2 ff ff       	call   801034a7 <end_op>

  f->type = FD_INODE;
801061be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c1:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801061c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061cd:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801061d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061d3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801061da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061dd:	83 e0 01             	and    $0x1,%eax
801061e0:	85 c0                	test   %eax,%eax
801061e2:	0f 94 c0             	sete   %al
801061e5:	89 c2                	mov    %eax,%edx
801061e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ea:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801061ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061f0:	83 e0 01             	and    $0x1,%eax
801061f3:	85 c0                	test   %eax,%eax
801061f5:	75 0a                	jne    80106201 <sys_open+0x183>
801061f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061fa:	83 e0 02             	and    $0x2,%eax
801061fd:	85 c0                	test   %eax,%eax
801061ff:	74 07                	je     80106208 <sys_open+0x18a>
80106201:	b8 01 00 00 00       	mov    $0x1,%eax
80106206:	eb 05                	jmp    8010620d <sys_open+0x18f>
80106208:	b8 00 00 00 00       	mov    $0x0,%eax
8010620d:	89 c2                	mov    %eax,%edx
8010620f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106212:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106215:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106218:	c9                   	leave  
80106219:	c3                   	ret    

8010621a <sys_mkdir>:

int
sys_mkdir(void)
{
8010621a:	55                   	push   %ebp
8010621b:	89 e5                	mov    %esp,%ebp
8010621d:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106220:	e8 fe d1 ff ff       	call   80103423 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106225:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106228:	89 44 24 04          	mov    %eax,0x4(%esp)
8010622c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106233:	e8 38 f5 ff ff       	call   80105770 <argstr>
80106238:	85 c0                	test   %eax,%eax
8010623a:	78 2c                	js     80106268 <sys_mkdir+0x4e>
8010623c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010623f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106246:	00 
80106247:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010624e:	00 
8010624f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106256:	00 
80106257:	89 04 24             	mov    %eax,(%esp)
8010625a:	e8 5f fc ff ff       	call   80105ebe <create>
8010625f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106262:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106266:	75 0c                	jne    80106274 <sys_mkdir+0x5a>
    end_op();
80106268:	e8 3a d2 ff ff       	call   801034a7 <end_op>
    return -1;
8010626d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106272:	eb 15                	jmp    80106289 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80106274:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106277:	89 04 24             	mov    %eax,(%esp)
8010627a:	e8 71 b8 ff ff       	call   80101af0 <iunlockput>
  end_op();
8010627f:	e8 23 d2 ff ff       	call   801034a7 <end_op>
  return 0;
80106284:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106289:	c9                   	leave  
8010628a:	c3                   	ret    

8010628b <sys_mknod>:

int
sys_mknod(void)
{
8010628b:	55                   	push   %ebp
8010628c:	89 e5                	mov    %esp,%ebp
8010628e:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106291:	e8 8d d1 ff ff       	call   80103423 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106296:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106299:	89 44 24 04          	mov    %eax,0x4(%esp)
8010629d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062a4:	e8 c7 f4 ff ff       	call   80105770 <argstr>
801062a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062b0:	78 5e                	js     80106310 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
801062b2:	8d 45 e8             	lea    -0x18(%ebp),%eax
801062b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801062b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801062c0:	e8 17 f4 ff ff       	call   801056dc <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801062c5:	85 c0                	test   %eax,%eax
801062c7:	78 47                	js     80106310 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801062c9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801062d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801062d7:	e8 00 f4 ff ff       	call   801056dc <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801062dc:	85 c0                	test   %eax,%eax
801062de:	78 30                	js     80106310 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801062e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062e3:	0f bf c8             	movswl %ax,%ecx
801062e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062e9:	0f bf d0             	movswl %ax,%edx
801062ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801062ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801062f3:	89 54 24 08          	mov    %edx,0x8(%esp)
801062f7:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801062fe:	00 
801062ff:	89 04 24             	mov    %eax,(%esp)
80106302:	e8 b7 fb ff ff       	call   80105ebe <create>
80106307:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010630a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010630e:	75 0c                	jne    8010631c <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106310:	e8 92 d1 ff ff       	call   801034a7 <end_op>
    return -1;
80106315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010631a:	eb 15                	jmp    80106331 <sys_mknod+0xa6>
  }
  iunlockput(ip);
8010631c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010631f:	89 04 24             	mov    %eax,(%esp)
80106322:	e8 c9 b7 ff ff       	call   80101af0 <iunlockput>
  end_op();
80106327:	e8 7b d1 ff ff       	call   801034a7 <end_op>
  return 0;
8010632c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106331:	c9                   	leave  
80106332:	c3                   	ret    

80106333 <sys_chdir>:

int
sys_chdir(void)
{
80106333:	55                   	push   %ebp
80106334:	89 e5                	mov    %esp,%ebp
80106336:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106339:	e8 e5 d0 ff ff       	call   80103423 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010633e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106341:	89 44 24 04          	mov    %eax,0x4(%esp)
80106345:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010634c:	e8 1f f4 ff ff       	call   80105770 <argstr>
80106351:	85 c0                	test   %eax,%eax
80106353:	78 14                	js     80106369 <sys_chdir+0x36>
80106355:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106358:	89 04 24             	mov    %eax,(%esp)
8010635b:	e8 b9 c0 ff ff       	call   80102419 <namei>
80106360:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106367:	75 0c                	jne    80106375 <sys_chdir+0x42>
    end_op();
80106369:	e8 39 d1 ff ff       	call   801034a7 <end_op>
    return -1;
8010636e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106373:	eb 65                	jmp    801063da <sys_chdir+0xa7>
  }
  ilock(ip);
80106375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106378:	89 04 24             	mov    %eax,(%esp)
8010637b:	e8 ec b4 ff ff       	call   8010186c <ilock>
  if(ip->type != T_DIR){
80106380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106383:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106387:	66 83 f8 01          	cmp    $0x1,%ax
8010638b:	74 17                	je     801063a4 <sys_chdir+0x71>
    iunlockput(ip);
8010638d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106390:	89 04 24             	mov    %eax,(%esp)
80106393:	e8 58 b7 ff ff       	call   80101af0 <iunlockput>
    end_op();
80106398:	e8 0a d1 ff ff       	call   801034a7 <end_op>
    return -1;
8010639d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a2:	eb 36                	jmp    801063da <sys_chdir+0xa7>
  }
  iunlock(ip);
801063a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a7:	89 04 24             	mov    %eax,(%esp)
801063aa:	e8 0b b6 ff ff       	call   801019ba <iunlock>
  iput(current->proc->cwd);
801063af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063b5:	8b 00                	mov    (%eax),%eax
801063b7:	8b 40 4c             	mov    0x4c(%eax),%eax
801063ba:	89 04 24             	mov    %eax,(%esp)
801063bd:	e8 5d b6 ff ff       	call   80101a1f <iput>
  end_op();
801063c2:	e8 e0 d0 ff ff       	call   801034a7 <end_op>
  current->proc->cwd = ip;
801063c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063cd:	8b 00                	mov    (%eax),%eax
801063cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063d2:	89 50 4c             	mov    %edx,0x4c(%eax)
  return 0;
801063d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063da:	c9                   	leave  
801063db:	c3                   	ret    

801063dc <sys_exec>:

int
sys_exec(void)
{
801063dc:	55                   	push   %ebp
801063dd:	89 e5                	mov    %esp,%ebp
801063df:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801063e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801063ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801063f3:	e8 78 f3 ff ff       	call   80105770 <argstr>
801063f8:	85 c0                	test   %eax,%eax
801063fa:	78 1a                	js     80106416 <sys_exec+0x3a>
801063fc:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106402:	89 44 24 04          	mov    %eax,0x4(%esp)
80106406:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010640d:	e8 ca f2 ff ff       	call   801056dc <argint>
80106412:	85 c0                	test   %eax,%eax
80106414:	79 0a                	jns    80106420 <sys_exec+0x44>
    return -1;
80106416:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010641b:	e9 c8 00 00 00       	jmp    801064e8 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80106420:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106427:	00 
80106428:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010642f:	00 
80106430:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106436:	89 04 24             	mov    %eax,(%esp)
80106439:	e8 54 ef ff ff       	call   80105392 <memset>
  for(i=0;; i++){
8010643e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106448:	83 f8 1f             	cmp    $0x1f,%eax
8010644b:	76 0a                	jbe    80106457 <sys_exec+0x7b>
      return -1;
8010644d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106452:	e9 91 00 00 00       	jmp    801064e8 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010645a:	c1 e0 02             	shl    $0x2,%eax
8010645d:	89 c2                	mov    %eax,%edx
8010645f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106465:	01 c2                	add    %eax,%edx
80106467:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010646d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106471:	89 14 24             	mov    %edx,(%esp)
80106474:	e8 bf f1 ff ff       	call   80105638 <fetchint>
80106479:	85 c0                	test   %eax,%eax
8010647b:	79 07                	jns    80106484 <sys_exec+0xa8>
      return -1;
8010647d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106482:	eb 64                	jmp    801064e8 <sys_exec+0x10c>
    if(uarg == 0){
80106484:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010648a:	85 c0                	test   %eax,%eax
8010648c:	75 26                	jne    801064b4 <sys_exec+0xd8>
      argv[i] = 0;
8010648e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106491:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106498:	00 00 00 00 
      break;
8010649c:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010649d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064a0:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801064a6:	89 54 24 04          	mov    %edx,0x4(%esp)
801064aa:	89 04 24             	mov    %eax,(%esp)
801064ad:	e8 3f a6 ff ff       	call   80100af1 <exec>
801064b2:	eb 34                	jmp    801064e8 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801064b4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801064ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064bd:	c1 e2 02             	shl    $0x2,%edx
801064c0:	01 c2                	add    %eax,%edx
801064c2:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801064c8:	89 54 24 04          	mov    %edx,0x4(%esp)
801064cc:	89 04 24             	mov    %eax,(%esp)
801064cf:	e8 a2 f1 ff ff       	call   80105676 <fetchstr>
801064d4:	85 c0                	test   %eax,%eax
801064d6:	79 07                	jns    801064df <sys_exec+0x103>
      return -1;
801064d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064dd:	eb 09                	jmp    801064e8 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801064df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801064e3:	e9 5d ff ff ff       	jmp    80106445 <sys_exec+0x69>
  return exec(path, argv);
}
801064e8:	c9                   	leave  
801064e9:	c3                   	ret    

801064ea <sys_pipe>:

int
sys_pipe(void)
{
801064ea:	55                   	push   %ebp
801064eb:	89 e5                	mov    %esp,%ebp
801064ed:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801064f0:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801064f7:	00 
801064f8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801064ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106506:	e8 ff f1 ff ff       	call   8010570a <argptr>
8010650b:	85 c0                	test   %eax,%eax
8010650d:	79 0a                	jns    80106519 <sys_pipe+0x2f>
    return -1;
8010650f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106514:	e9 9a 00 00 00       	jmp    801065b3 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
80106519:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010651c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106520:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106523:	89 04 24             	mov    %eax,(%esp)
80106526:	e8 f1 d9 ff ff       	call   80103f1c <pipealloc>
8010652b:	85 c0                	test   %eax,%eax
8010652d:	79 07                	jns    80106536 <sys_pipe+0x4c>
    return -1;
8010652f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106534:	eb 7d                	jmp    801065b3 <sys_pipe+0xc9>
  fd0 = -1;
80106536:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010653d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106540:	89 04 24             	mov    %eax,(%esp)
80106543:	e8 66 f3 ff ff       	call   801058ae <fdalloc>
80106548:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010654b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010654f:	78 14                	js     80106565 <sys_pipe+0x7b>
80106551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106554:	89 04 24             	mov    %eax,(%esp)
80106557:	e8 52 f3 ff ff       	call   801058ae <fdalloc>
8010655c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010655f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106563:	79 36                	jns    8010659b <sys_pipe+0xb1>
    if(fd0 >= 0)
80106565:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106569:	78 13                	js     8010657e <sys_pipe+0x94>
      current->proc->ofile[fd0] = 0;
8010656b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106571:	8b 00                	mov    (%eax),%eax
80106573:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106576:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
8010657d:	00 
    fileclose(rf);
8010657e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106581:	89 04 24             	mov    %eax,(%esp)
80106584:	e8 56 aa ff ff       	call   80100fdf <fileclose>
    fileclose(wf);
80106589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010658c:	89 04 24             	mov    %eax,(%esp)
8010658f:	e8 4b aa ff ff       	call   80100fdf <fileclose>
    return -1;
80106594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106599:	eb 18                	jmp    801065b3 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
8010659b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010659e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065a1:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801065a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801065a6:	8d 50 04             	lea    0x4(%eax),%edx
801065a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065ac:	89 02                	mov    %eax,(%edx)
  return 0;
801065ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065b3:	c9                   	leave  
801065b4:	c3                   	ret    

801065b5 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801065b5:	55                   	push   %ebp
801065b6:	89 e5                	mov    %esp,%ebp
801065b8:	83 ec 08             	sub    $0x8,%esp
  return fork();
801065bb:	e8 54 e2 ff ff       	call   80104814 <fork>
}
801065c0:	c9                   	leave  
801065c1:	c3                   	ret    

801065c2 <sys_clone>:

int
sys_clone(void) 
{
801065c2:	55                   	push   %ebp
801065c3:	89 e5                	mov    %esp,%ebp
801065c5:	83 ec 28             	sub    $0x28,%esp
  void (*function)(void);
  char* stack;

  if(argint(0,(int*)&function)<0)
801065c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801065cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065d6:	e8 01 f1 ff ff       	call   801056dc <argint>
801065db:	85 c0                	test   %eax,%eax
801065dd:	79 07                	jns    801065e6 <sys_clone+0x24>
    return -1;
801065df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e4:	eb 30                	jmp    80106616 <sys_clone+0x54>

  if(argint(1,(int*)&stack)<0)
801065e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801065ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801065f4:	e8 e3 f0 ff ff       	call   801056dc <argint>
801065f9:	85 c0                	test   %eax,%eax
801065fb:	79 07                	jns    80106604 <sys_clone+0x42>
    return -1;
801065fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106602:	eb 12                	jmp    80106616 <sys_clone+0x54>
  
  return clone(function,stack);
80106604:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010660a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010660e:	89 04 24             	mov    %eax,(%esp)
80106611:	e8 8c e3 ff ff       	call   801049a2 <clone>
}
80106616:	c9                   	leave  
80106617:	c3                   	ret    

80106618 <sys_exit>:

int
sys_exit(void)
{
80106618:	55                   	push   %ebp
80106619:	89 e5                	mov    %esp,%ebp
8010661b:	83 ec 08             	sub    $0x8,%esp
  exit();
8010661e:	e8 2d e4 ff ff       	call   80104a50 <exit>
  return 0;  // not reached
80106623:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106628:	c9                   	leave  
80106629:	c3                   	ret    

8010662a <sys_thread_exit>:

int
sys_thread_exit(void)
{
8010662a:	55                   	push   %ebp
8010662b:	89 e5                	mov    %esp,%ebp
8010662d:	83 ec 08             	sub    $0x8,%esp
  thread_exit();
80106630:	e8 b6 dc ff ff       	call   801042eb <thread_exit>
  return 0; // not reached
80106635:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010663a:	c9                   	leave  
8010663b:	c3                   	ret    

8010663c <sys_wait>:

int
sys_wait(void)
{
8010663c:	55                   	push   %ebp
8010663d:	89 e5                	mov    %esp,%ebp
8010663f:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106642:	e8 40 e5 ff ff       	call   80104b87 <wait>
}
80106647:	c9                   	leave  
80106648:	c3                   	ret    

80106649 <sys_thread_join>:

int sys_thread_join(void)
{
80106649:	55                   	push   %ebp
8010664a:	89 e5                	mov    %esp,%ebp
8010664c:	83 ec 28             	sub    $0x28,%esp
  int tid;

  if(argint(0,(int*)&tid)<0)
8010664f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106652:	89 44 24 04          	mov    %eax,0x4(%esp)
80106656:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010665d:	e8 7a f0 ff ff       	call   801056dc <argint>
80106662:	85 c0                	test   %eax,%eax
80106664:	79 0b                	jns    80106671 <sys_thread_join+0x28>
  thread_join(tid);
80106666:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106669:	89 04 24             	mov    %eax,(%esp)
8010666c:	e8 d4 dc ff ff       	call   80104345 <thread_join>
  return 0; // not reached
80106671:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106676:	c9                   	leave  
80106677:	c3                   	ret    

80106678 <sys_kill>:

int
sys_kill(void)
{
80106678:	55                   	push   %ebp
80106679:	89 e5                	mov    %esp,%ebp
8010667b:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010667e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106681:	89 44 24 04          	mov    %eax,0x4(%esp)
80106685:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010668c:	e8 4b f0 ff ff       	call   801056dc <argint>
80106691:	85 c0                	test   %eax,%eax
80106693:	79 07                	jns    8010669c <sys_kill+0x24>
    return -1;
80106695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010669a:	eb 0b                	jmp    801066a7 <sys_kill+0x2f>
  return kill(pid);
8010669c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010669f:	89 04 24             	mov    %eax,(%esp)
801066a2:	e8 c3 e8 ff ff       	call   80104f6a <kill>
}
801066a7:	c9                   	leave  
801066a8:	c3                   	ret    

801066a9 <sys_getpid>:

int
sys_getpid(void)
{
801066a9:	55                   	push   %ebp
801066aa:	89 e5                	mov    %esp,%ebp
  return current->proc->pid;
801066ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066b2:	8b 00                	mov    (%eax),%eax
801066b4:	8b 40 04             	mov    0x4(%eax),%eax
}
801066b7:	5d                   	pop    %ebp
801066b8:	c3                   	ret    

801066b9 <sys_sbrk>:

int
sys_sbrk(void)
{
801066b9:	55                   	push   %ebp
801066ba:	89 e5                	mov    %esp,%ebp
801066bc:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801066bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801066c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066cd:	e8 0a f0 ff ff       	call   801056dc <argint>
801066d2:	85 c0                	test   %eax,%eax
801066d4:	79 07                	jns    801066dd <sys_sbrk+0x24>
    return -1;
801066d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066db:	eb 26                	jmp    80106703 <sys_sbrk+0x4a>
  addr = current->proc->sz;
801066dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066e3:	8b 00                	mov    (%eax),%eax
801066e5:	8b 00                	mov    (%eax),%eax
801066e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801066ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066ed:	89 04 24             	mov    %eax,(%esp)
801066f0:	e8 70 e0 ff ff       	call   80104765 <growproc>
801066f5:	85 c0                	test   %eax,%eax
801066f7:	79 07                	jns    80106700 <sys_sbrk+0x47>
    return -1;
801066f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066fe:	eb 03                	jmp    80106703 <sys_sbrk+0x4a>
  return addr;
80106700:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106703:	c9                   	leave  
80106704:	c3                   	ret    

80106705 <sys_sleep>:

int
sys_sleep(void)
{
80106705:	55                   	push   %ebp
80106706:	89 e5                	mov    %esp,%ebp
80106708:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010670b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010670e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106712:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106719:	e8 be ef ff ff       	call   801056dc <argint>
8010671e:	85 c0                	test   %eax,%eax
80106720:	79 07                	jns    80106729 <sys_sleep+0x24>
    return -1;
80106722:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106727:	eb 6e                	jmp    80106797 <sys_sleep+0x92>
  acquire(&tickslock);
80106729:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80106730:	e8 09 ea ff ff       	call   8010513e <acquire>
  ticks0 = ticks;
80106735:	a1 00 54 11 80       	mov    0x80115400,%eax
8010673a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010673d:	eb 36                	jmp    80106775 <sys_sleep+0x70>
    if(current->proc->killed){
8010673f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106745:	8b 00                	mov    (%eax),%eax
80106747:	8b 40 60             	mov    0x60(%eax),%eax
8010674a:	85 c0                	test   %eax,%eax
8010674c:	74 13                	je     80106761 <sys_sleep+0x5c>
      release(&tickslock);
8010674e:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80106755:	e8 46 ea ff ff       	call   801051a0 <release>
      return -1;
8010675a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010675f:	eb 36                	jmp    80106797 <sys_sleep+0x92>
    }
    sleep(&ticks, &tickslock);
80106761:	c7 44 24 04 c0 4b 11 	movl   $0x80114bc0,0x4(%esp)
80106768:	80 
80106769:	c7 04 24 00 54 11 80 	movl   $0x80115400,(%esp)
80106770:	e8 e5 e6 ff ff       	call   80104e5a <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106775:	a1 00 54 11 80       	mov    0x80115400,%eax
8010677a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010677d:	89 c2                	mov    %eax,%edx
8010677f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106782:	39 c2                	cmp    %eax,%edx
80106784:	72 b9                	jb     8010673f <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106786:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
8010678d:	e8 0e ea ff ff       	call   801051a0 <release>
  return 0;
80106792:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106797:	c9                   	leave  
80106798:	c3                   	ret    

80106799 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106799:	55                   	push   %ebp
8010679a:	89 e5                	mov    %esp,%ebp
8010679c:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
8010679f:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
801067a6:	e8 93 e9 ff ff       	call   8010513e <acquire>
  xticks = ticks;
801067ab:	a1 00 54 11 80       	mov    0x80115400,%eax
801067b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801067b3:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
801067ba:	e8 e1 e9 ff ff       	call   801051a0 <release>
  return xticks;
801067bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801067c2:	c9                   	leave  
801067c3:	c3                   	ret    

801067c4 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801067c4:	55                   	push   %ebp
801067c5:	89 e5                	mov    %esp,%ebp
801067c7:	83 ec 08             	sub    $0x8,%esp
801067ca:	8b 55 08             	mov    0x8(%ebp),%edx
801067cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801067d0:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801067d4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067d7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801067db:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801067df:	ee                   	out    %al,(%dx)
}
801067e0:	c9                   	leave  
801067e1:	c3                   	ret    

801067e2 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801067e2:	55                   	push   %ebp
801067e3:	89 e5                	mov    %esp,%ebp
801067e5:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801067e8:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801067ef:	00 
801067f0:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801067f7:	e8 c8 ff ff ff       	call   801067c4 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801067fc:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106803:	00 
80106804:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010680b:	e8 b4 ff ff ff       	call   801067c4 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106810:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106817:	00 
80106818:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010681f:	e8 a0 ff ff ff       	call   801067c4 <outb>
  picenable(IRQ_TIMER);
80106824:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010682b:	e8 7f d5 ff ff       	call   80103daf <picenable>
}
80106830:	c9                   	leave  
80106831:	c3                   	ret    

80106832 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106832:	1e                   	push   %ds
  pushl %es
80106833:	06                   	push   %es
  pushl %fs
80106834:	0f a0                	push   %fs
  pushl %gs
80106836:	0f a8                	push   %gs
  pushal
80106838:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106839:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010683d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010683f:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106841:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106845:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106847:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106849:	54                   	push   %esp
  call trap
8010684a:	e8 d8 01 00 00       	call   80106a27 <trap>
  addl $4, %esp
8010684f:	83 c4 04             	add    $0x4,%esp

80106852 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106852:	61                   	popa   
  popl %gs
80106853:	0f a9                	pop    %gs
  popl %fs
80106855:	0f a1                	pop    %fs
  popl %es
80106857:	07                   	pop    %es
  popl %ds
80106858:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106859:	83 c4 08             	add    $0x8,%esp
  iret
8010685c:	cf                   	iret   

8010685d <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010685d:	55                   	push   %ebp
8010685e:	89 e5                	mov    %esp,%ebp
80106860:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106863:	8b 45 0c             	mov    0xc(%ebp),%eax
80106866:	83 e8 01             	sub    $0x1,%eax
80106869:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010686d:	8b 45 08             	mov    0x8(%ebp),%eax
80106870:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106874:	8b 45 08             	mov    0x8(%ebp),%eax
80106877:	c1 e8 10             	shr    $0x10,%eax
8010687a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010687e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106881:	0f 01 18             	lidtl  (%eax)
}
80106884:	c9                   	leave  
80106885:	c3                   	ret    

80106886 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106886:	55                   	push   %ebp
80106887:	89 e5                	mov    %esp,%ebp
80106889:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010688c:	0f 20 d0             	mov    %cr2,%eax
8010688f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106892:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106895:	c9                   	leave  
80106896:	c3                   	ret    

80106897 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106897:	55                   	push   %ebp
80106898:	89 e5                	mov    %esp,%ebp
8010689a:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010689d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801068a4:	e9 c3 00 00 00       	jmp    8010696c <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801068a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ac:	8b 04 85 a4 b0 10 80 	mov    -0x7fef4f5c(,%eax,4),%eax
801068b3:	89 c2                	mov    %eax,%edx
801068b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b8:	66 89 14 c5 00 4c 11 	mov    %dx,-0x7feeb400(,%eax,8)
801068bf:	80 
801068c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c3:	66 c7 04 c5 02 4c 11 	movw   $0x8,-0x7feeb3fe(,%eax,8)
801068ca:	80 08 00 
801068cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068d0:	0f b6 14 c5 04 4c 11 	movzbl -0x7feeb3fc(,%eax,8),%edx
801068d7:	80 
801068d8:	83 e2 e0             	and    $0xffffffe0,%edx
801068db:	88 14 c5 04 4c 11 80 	mov    %dl,-0x7feeb3fc(,%eax,8)
801068e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068e5:	0f b6 14 c5 04 4c 11 	movzbl -0x7feeb3fc(,%eax,8),%edx
801068ec:	80 
801068ed:	83 e2 1f             	and    $0x1f,%edx
801068f0:	88 14 c5 04 4c 11 80 	mov    %dl,-0x7feeb3fc(,%eax,8)
801068f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068fa:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
80106901:	80 
80106902:	83 e2 f0             	and    $0xfffffff0,%edx
80106905:	83 ca 0e             	or     $0xe,%edx
80106908:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
8010690f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106912:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
80106919:	80 
8010691a:	83 e2 ef             	and    $0xffffffef,%edx
8010691d:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
80106924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106927:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
8010692e:	80 
8010692f:	83 e2 9f             	and    $0xffffff9f,%edx
80106932:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
80106939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010693c:	0f b6 14 c5 05 4c 11 	movzbl -0x7feeb3fb(,%eax,8),%edx
80106943:	80 
80106944:	83 ca 80             	or     $0xffffff80,%edx
80106947:	88 14 c5 05 4c 11 80 	mov    %dl,-0x7feeb3fb(,%eax,8)
8010694e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106951:	8b 04 85 a4 b0 10 80 	mov    -0x7fef4f5c(,%eax,4),%eax
80106958:	c1 e8 10             	shr    $0x10,%eax
8010695b:	89 c2                	mov    %eax,%edx
8010695d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106960:	66 89 14 c5 06 4c 11 	mov    %dx,-0x7feeb3fa(,%eax,8)
80106967:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106968:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010696c:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106973:	0f 8e 30 ff ff ff    	jle    801068a9 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106979:	a1 a4 b1 10 80       	mov    0x8010b1a4,%eax
8010697e:	66 a3 00 4e 11 80    	mov    %ax,0x80114e00
80106984:	66 c7 05 02 4e 11 80 	movw   $0x8,0x80114e02
8010698b:	08 00 
8010698d:	0f b6 05 04 4e 11 80 	movzbl 0x80114e04,%eax
80106994:	83 e0 e0             	and    $0xffffffe0,%eax
80106997:	a2 04 4e 11 80       	mov    %al,0x80114e04
8010699c:	0f b6 05 04 4e 11 80 	movzbl 0x80114e04,%eax
801069a3:	83 e0 1f             	and    $0x1f,%eax
801069a6:	a2 04 4e 11 80       	mov    %al,0x80114e04
801069ab:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069b2:	83 c8 0f             	or     $0xf,%eax
801069b5:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069ba:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069c1:	83 e0 ef             	and    $0xffffffef,%eax
801069c4:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069c9:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069d0:	83 c8 60             	or     $0x60,%eax
801069d3:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069d8:	0f b6 05 05 4e 11 80 	movzbl 0x80114e05,%eax
801069df:	83 c8 80             	or     $0xffffff80,%eax
801069e2:	a2 05 4e 11 80       	mov    %al,0x80114e05
801069e7:	a1 a4 b1 10 80       	mov    0x8010b1a4,%eax
801069ec:	c1 e8 10             	shr    $0x10,%eax
801069ef:	66 a3 06 4e 11 80    	mov    %ax,0x80114e06
  
  initlock(&tickslock, "time");
801069f5:	c7 44 24 04 c8 8c 10 	movl   $0x80108cc8,0x4(%esp)
801069fc:	80 
801069fd:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80106a04:	e8 14 e7 ff ff       	call   8010511d <initlock>
}
80106a09:	c9                   	leave  
80106a0a:	c3                   	ret    

80106a0b <idtinit>:

void
idtinit(void)
{
80106a0b:	55                   	push   %ebp
80106a0c:	89 e5                	mov    %esp,%ebp
80106a0e:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106a11:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106a18:	00 
80106a19:	c7 04 24 00 4c 11 80 	movl   $0x80114c00,(%esp)
80106a20:	e8 38 fe ff ff       	call   8010685d <lidt>
}
80106a25:	c9                   	leave  
80106a26:	c3                   	ret    

80106a27 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106a27:	55                   	push   %ebp
80106a28:	89 e5                	mov    %esp,%ebp
80106a2a:	57                   	push   %edi
80106a2b:	56                   	push   %esi
80106a2c:	53                   	push   %ebx
80106a2d:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106a30:	8b 45 08             	mov    0x8(%ebp),%eax
80106a33:	8b 40 30             	mov    0x30(%eax),%eax
80106a36:	83 f8 40             	cmp    $0x40,%eax
80106a39:	75 6d                	jne    80106aa8 <trap+0x81>
    if(current->killed)
80106a3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a41:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106a47:	85 c0                	test   %eax,%eax
80106a49:	74 05                	je     80106a50 <trap+0x29>
      thread_exit();
80106a4b:	e8 9b d8 ff ff       	call   801042eb <thread_exit>
    if(current->proc->killed)
80106a50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a56:	8b 00                	mov    (%eax),%eax
80106a58:	8b 40 60             	mov    0x60(%eax),%eax
80106a5b:	85 c0                	test   %eax,%eax
80106a5d:	74 05                	je     80106a64 <trap+0x3d>
      exit();
80106a5f:	e8 ec df ff ff       	call   80104a50 <exit>
    current->tf = tf;
80106a64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a6a:	8b 55 08             	mov    0x8(%ebp),%edx
80106a6d:	89 50 78             	mov    %edx,0x78(%eax)
    syscall();
80106a70:	e8 32 ed ff ff       	call   801057a7 <syscall>
    if(current->proc->killed)
80106a75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a7b:	8b 00                	mov    (%eax),%eax
80106a7d:	8b 40 60             	mov    0x60(%eax),%eax
80106a80:	85 c0                	test   %eax,%eax
80106a82:	74 05                	je     80106a89 <trap+0x62>
      exit();
80106a84:	e8 c7 df ff ff       	call   80104a50 <exit>
    if(current->killed)
80106a89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a8f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106a95:	85 c0                	test   %eax,%eax
80106a97:	74 0a                	je     80106aa3 <trap+0x7c>
      thread_exit();
80106a99:	e8 4d d8 ff ff       	call   801042eb <thread_exit>
    return;
80106a9e:	e9 99 02 00 00       	jmp    80106d3c <trap+0x315>
80106aa3:	e9 94 02 00 00       	jmp    80106d3c <trap+0x315>
  }

  switch(tf->trapno){
80106aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80106aab:	8b 40 30             	mov    0x30(%eax),%eax
80106aae:	83 e8 20             	sub    $0x20,%eax
80106ab1:	83 f8 1f             	cmp    $0x1f,%eax
80106ab4:	0f 87 bc 00 00 00    	ja     80106b76 <trap+0x14f>
80106aba:	8b 04 85 70 8d 10 80 	mov    -0x7fef7290(,%eax,4),%eax
80106ac1:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106ac3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ac9:	0f b6 00             	movzbl (%eax),%eax
80106acc:	84 c0                	test   %al,%al
80106ace:	75 31                	jne    80106b01 <trap+0xda>
      acquire(&tickslock);
80106ad0:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80106ad7:	e8 62 e6 ff ff       	call   8010513e <acquire>
      ticks++;
80106adc:	a1 00 54 11 80       	mov    0x80115400,%eax
80106ae1:	83 c0 01             	add    $0x1,%eax
80106ae4:	a3 00 54 11 80       	mov    %eax,0x80115400
      wakeup(&ticks);
80106ae9:	c7 04 24 00 54 11 80 	movl   $0x80115400,(%esp)
80106af0:	e8 4a e4 ff ff       	call   80104f3f <wakeup>
      release(&tickslock);
80106af5:	c7 04 24 c0 4b 11 80 	movl   $0x80114bc0,(%esp)
80106afc:	e8 9f e6 ff ff       	call   801051a0 <release>
    }
    lapiceoi();
80106b01:	e8 dd c3 ff ff       	call   80102ee3 <lapiceoi>
    break;
80106b06:	e9 47 01 00 00       	jmp    80106c52 <trap+0x22b>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106b0b:	e8 e1 bb ff ff       	call   801026f1 <ideintr>
    lapiceoi();
80106b10:	e8 ce c3 ff ff       	call   80102ee3 <lapiceoi>
    break;
80106b15:	e9 38 01 00 00       	jmp    80106c52 <trap+0x22b>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106b1a:	e8 93 c1 ff ff       	call   80102cb2 <kbdintr>
    lapiceoi();
80106b1f:	e8 bf c3 ff ff       	call   80102ee3 <lapiceoi>
    break;
80106b24:	e9 29 01 00 00       	jmp    80106c52 <trap+0x22b>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106b29:	e8 03 04 00 00       	call   80106f31 <uartintr>
    lapiceoi();
80106b2e:	e8 b0 c3 ff ff       	call   80102ee3 <lapiceoi>
    break;
80106b33:	e9 1a 01 00 00       	jmp    80106c52 <trap+0x22b>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b38:	8b 45 08             	mov    0x8(%ebp),%eax
80106b3b:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80106b41:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b45:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106b48:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b4e:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b51:	0f b6 c0             	movzbl %al,%eax
80106b54:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106b58:	89 54 24 08          	mov    %edx,0x8(%esp)
80106b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b60:	c7 04 24 d0 8c 10 80 	movl   $0x80108cd0,(%esp)
80106b67:	e8 34 98 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106b6c:	e8 72 c3 ff ff       	call   80102ee3 <lapiceoi>
    break;
80106b71:	e9 dc 00 00 00       	jmp    80106c52 <trap+0x22b>
   
  //PAGEBREAK: 13
  default:
    if(current == 0 || (tf->cs&3) == 0){
80106b76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b7c:	85 c0                	test   %eax,%eax
80106b7e:	74 11                	je     80106b91 <trap+0x16a>
80106b80:	8b 45 08             	mov    0x8(%ebp),%eax
80106b83:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106b87:	0f b7 c0             	movzwl %ax,%eax
80106b8a:	83 e0 03             	and    $0x3,%eax
80106b8d:	85 c0                	test   %eax,%eax
80106b8f:	75 46                	jne    80106bd7 <trap+0x1b0>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106b91:	e8 f0 fc ff ff       	call   80106886 <rcr2>
80106b96:	8b 55 08             	mov    0x8(%ebp),%edx
80106b99:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106b9c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106ba3:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(current == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ba6:	0f b6 ca             	movzbl %dl,%ecx
80106ba9:	8b 55 08             	mov    0x8(%ebp),%edx
80106bac:	8b 52 30             	mov    0x30(%edx),%edx
80106baf:	89 44 24 10          	mov    %eax,0x10(%esp)
80106bb3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106bb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bbf:	c7 04 24 f4 8c 10 80 	movl   $0x80108cf4,(%esp)
80106bc6:	e8 d5 97 ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106bcb:	c7 04 24 26 8d 10 80 	movl   $0x80108d26,(%esp)
80106bd2:	e8 63 99 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106bd7:	e8 aa fc ff ff       	call   80106886 <rcr2>
80106bdc:	89 c2                	mov    %eax,%edx
80106bde:	8b 45 08             	mov    0x8(%ebp),%eax
80106be1:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            current->proc->pid, current->proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106be4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106bea:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106bed:	0f b6 f0             	movzbl %al,%esi
80106bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf3:	8b 58 34             	mov    0x34(%eax),%ebx
80106bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf9:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            current->proc->pid, current->proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106bfc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c02:	8b 00                	mov    (%eax),%eax
80106c04:	83 c0 50             	add    $0x50,%eax
80106c07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c10:	8b 00                	mov    (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106c12:	8b 40 04             	mov    0x4(%eax),%eax
80106c15:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106c19:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106c1d:	89 74 24 14          	mov    %esi,0x14(%esp)
80106c21:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106c25:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106c29:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106c2c:	89 74 24 08          	mov    %esi,0x8(%esp)
80106c30:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c34:	c7 04 24 2c 8d 10 80 	movl   $0x80108d2c,(%esp)
80106c3b:	e8 60 97 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            current->proc->pid, current->proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    current->proc->killed = 1;
80106c40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c46:	8b 00                	mov    (%eax),%eax
80106c48:	c7 40 60 01 00 00 00 	movl   $0x1,0x60(%eax)
80106c4f:	eb 01                	jmp    80106c52 <trap+0x22b>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106c51:	90                   	nop
  }

  // Force thread exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(current && current->killed && (tf->cs&3) == DPL_USER)
80106c52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c58:	85 c0                	test   %eax,%eax
80106c5a:	74 27                	je     80106c83 <trap+0x25c>
80106c5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c62:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106c68:	85 c0                	test   %eax,%eax
80106c6a:	74 17                	je     80106c83 <trap+0x25c>
80106c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c6f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106c73:	0f b7 c0             	movzwl %ax,%eax
80106c76:	83 e0 03             	and    $0x3,%eax
80106c79:	83 f8 03             	cmp    $0x3,%eax
80106c7c:	75 05                	jne    80106c83 <trap+0x25c>
    thread_exit();
80106c7e:	e8 68 d6 ff ff       	call   801042eb <thread_exit>

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(current && current->proc->killed && (tf->cs&3) == DPL_USER)
80106c83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c89:	85 c0                	test   %eax,%eax
80106c8b:	74 26                	je     80106cb3 <trap+0x28c>
80106c8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c93:	8b 00                	mov    (%eax),%eax
80106c95:	8b 40 60             	mov    0x60(%eax),%eax
80106c98:	85 c0                	test   %eax,%eax
80106c9a:	74 17                	je     80106cb3 <trap+0x28c>
80106c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c9f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ca3:	0f b7 c0             	movzwl %ax,%eax
80106ca6:	83 e0 03             	and    $0x3,%eax
80106ca9:	83 f8 03             	cmp    $0x3,%eax
80106cac:	75 05                	jne    80106cb3 <trap+0x28c>
    exit();
80106cae:	e8 9d dd ff ff       	call   80104a50 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(current && current->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106cb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cb9:	85 c0                	test   %eax,%eax
80106cbb:	74 1e                	je     80106cdb <trap+0x2b4>
80106cbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cc3:	8b 40 74             	mov    0x74(%eax),%eax
80106cc6:	83 f8 04             	cmp    $0x4,%eax
80106cc9:	75 10                	jne    80106cdb <trap+0x2b4>
80106ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cce:	8b 40 30             	mov    0x30(%eax),%eax
80106cd1:	83 f8 20             	cmp    $0x20,%eax
80106cd4:	75 05                	jne    80106cdb <trap+0x2b4>
    yield();
80106cd6:	e8 21 e1 ff ff       	call   80104dfc <yield>

  // Check if the process has been killed since we yielded
  if(current && current->proc->killed && (tf->cs&3) == DPL_USER)
80106cdb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ce1:	85 c0                	test   %eax,%eax
80106ce3:	74 26                	je     80106d0b <trap+0x2e4>
80106ce5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ceb:	8b 00                	mov    (%eax),%eax
80106ced:	8b 40 60             	mov    0x60(%eax),%eax
80106cf0:	85 c0                	test   %eax,%eax
80106cf2:	74 17                	je     80106d0b <trap+0x2e4>
80106cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80106cf7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106cfb:	0f b7 c0             	movzwl %ax,%eax
80106cfe:	83 e0 03             	and    $0x3,%eax
80106d01:	83 f8 03             	cmp    $0x3,%eax
80106d04:	75 05                	jne    80106d0b <trap+0x2e4>
    exit();
80106d06:	e8 45 dd ff ff       	call   80104a50 <exit>

  // Check if the thread has been killed since we yielded
  if(current && current->killed && (tf->cs&3) == DPL_USER)
80106d0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d11:	85 c0                	test   %eax,%eax
80106d13:	74 27                	je     80106d3c <trap+0x315>
80106d15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d1b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106d21:	85 c0                	test   %eax,%eax
80106d23:	74 17                	je     80106d3c <trap+0x315>
80106d25:	8b 45 08             	mov    0x8(%ebp),%eax
80106d28:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106d2c:	0f b7 c0             	movzwl %ax,%eax
80106d2f:	83 e0 03             	and    $0x3,%eax
80106d32:	83 f8 03             	cmp    $0x3,%eax
80106d35:	75 05                	jne    80106d3c <trap+0x315>
    thread_exit();
80106d37:	e8 af d5 ff ff       	call   801042eb <thread_exit>

}
80106d3c:	83 c4 3c             	add    $0x3c,%esp
80106d3f:	5b                   	pop    %ebx
80106d40:	5e                   	pop    %esi
80106d41:	5f                   	pop    %edi
80106d42:	5d                   	pop    %ebp
80106d43:	c3                   	ret    

80106d44 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106d44:	55                   	push   %ebp
80106d45:	89 e5                	mov    %esp,%ebp
80106d47:	83 ec 14             	sub    $0x14,%esp
80106d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d4d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d51:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106d55:	89 c2                	mov    %eax,%edx
80106d57:	ec                   	in     (%dx),%al
80106d58:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106d5b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106d5f:	c9                   	leave  
80106d60:	c3                   	ret    

80106d61 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106d61:	55                   	push   %ebp
80106d62:	89 e5                	mov    %esp,%ebp
80106d64:	83 ec 08             	sub    $0x8,%esp
80106d67:	8b 55 08             	mov    0x8(%ebp),%edx
80106d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d6d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106d71:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d74:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106d78:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106d7c:	ee                   	out    %al,(%dx)
}
80106d7d:	c9                   	leave  
80106d7e:	c3                   	ret    

80106d7f <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106d7f:	55                   	push   %ebp
80106d80:	89 e5                	mov    %esp,%ebp
80106d82:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106d85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106d8c:	00 
80106d8d:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106d94:	e8 c8 ff ff ff       	call   80106d61 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106d99:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106da0:	00 
80106da1:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106da8:	e8 b4 ff ff ff       	call   80106d61 <outb>
  outb(COM1+0, 115200/9600);
80106dad:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106db4:	00 
80106db5:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106dbc:	e8 a0 ff ff ff       	call   80106d61 <outb>
  outb(COM1+1, 0);
80106dc1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106dc8:	00 
80106dc9:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106dd0:	e8 8c ff ff ff       	call   80106d61 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106dd5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106ddc:	00 
80106ddd:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106de4:	e8 78 ff ff ff       	call   80106d61 <outb>
  outb(COM1+4, 0);
80106de9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106df0:	00 
80106df1:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106df8:	e8 64 ff ff ff       	call   80106d61 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106dfd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106e04:	00 
80106e05:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106e0c:	e8 50 ff ff ff       	call   80106d61 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106e11:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106e18:	e8 27 ff ff ff       	call   80106d44 <inb>
80106e1d:	3c ff                	cmp    $0xff,%al
80106e1f:	75 02                	jne    80106e23 <uartinit+0xa4>
    return;
80106e21:	eb 6a                	jmp    80106e8d <uartinit+0x10e>
  uart = 1;
80106e23:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106e2a:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106e2d:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106e34:	e8 0b ff ff ff       	call   80106d44 <inb>
  inb(COM1+0);
80106e39:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106e40:	e8 ff fe ff ff       	call   80106d44 <inb>
  picenable(IRQ_COM1);
80106e45:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106e4c:	e8 5e cf ff ff       	call   80103daf <picenable>
  ioapicenable(IRQ_COM1, 0);
80106e51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e58:	00 
80106e59:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106e60:	e8 0b bb ff ff       	call   80102970 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106e65:	c7 45 f4 f0 8d 10 80 	movl   $0x80108df0,-0xc(%ebp)
80106e6c:	eb 15                	jmp    80106e83 <uartinit+0x104>
    uartputc(*p);
80106e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e71:	0f b6 00             	movzbl (%eax),%eax
80106e74:	0f be c0             	movsbl %al,%eax
80106e77:	89 04 24             	mov    %eax,(%esp)
80106e7a:	e8 10 00 00 00       	call   80106e8f <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106e7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e86:	0f b6 00             	movzbl (%eax),%eax
80106e89:	84 c0                	test   %al,%al
80106e8b:	75 e1                	jne    80106e6e <uartinit+0xef>
    uartputc(*p);
}
80106e8d:	c9                   	leave  
80106e8e:	c3                   	ret    

80106e8f <uartputc>:

void
uartputc(int c)
{
80106e8f:	55                   	push   %ebp
80106e90:	89 e5                	mov    %esp,%ebp
80106e92:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106e95:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106e9a:	85 c0                	test   %eax,%eax
80106e9c:	75 02                	jne    80106ea0 <uartputc+0x11>
    return;
80106e9e:	eb 4b                	jmp    80106eeb <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ea0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ea7:	eb 10                	jmp    80106eb9 <uartputc+0x2a>
    microdelay(10);
80106ea9:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106eb0:	e8 53 c0 ff ff       	call   80102f08 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106eb5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106eb9:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106ebd:	7f 16                	jg     80106ed5 <uartputc+0x46>
80106ebf:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106ec6:	e8 79 fe ff ff       	call   80106d44 <inb>
80106ecb:	0f b6 c0             	movzbl %al,%eax
80106ece:	83 e0 20             	and    $0x20,%eax
80106ed1:	85 c0                	test   %eax,%eax
80106ed3:	74 d4                	je     80106ea9 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ed8:	0f b6 c0             	movzbl %al,%eax
80106edb:	89 44 24 04          	mov    %eax,0x4(%esp)
80106edf:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106ee6:	e8 76 fe ff ff       	call   80106d61 <outb>
}
80106eeb:	c9                   	leave  
80106eec:	c3                   	ret    

80106eed <uartgetc>:

static int
uartgetc(void)
{
80106eed:	55                   	push   %ebp
80106eee:	89 e5                	mov    %esp,%ebp
80106ef0:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106ef3:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106ef8:	85 c0                	test   %eax,%eax
80106efa:	75 07                	jne    80106f03 <uartgetc+0x16>
    return -1;
80106efc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f01:	eb 2c                	jmp    80106f2f <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106f03:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106f0a:	e8 35 fe ff ff       	call   80106d44 <inb>
80106f0f:	0f b6 c0             	movzbl %al,%eax
80106f12:	83 e0 01             	and    $0x1,%eax
80106f15:	85 c0                	test   %eax,%eax
80106f17:	75 07                	jne    80106f20 <uartgetc+0x33>
    return -1;
80106f19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f1e:	eb 0f                	jmp    80106f2f <uartgetc+0x42>
  return inb(COM1+0);
80106f20:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106f27:	e8 18 fe ff ff       	call   80106d44 <inb>
80106f2c:	0f b6 c0             	movzbl %al,%eax
}
80106f2f:	c9                   	leave  
80106f30:	c3                   	ret    

80106f31 <uartintr>:

void
uartintr(void)
{
80106f31:	55                   	push   %ebp
80106f32:	89 e5                	mov    %esp,%ebp
80106f34:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106f37:	c7 04 24 ed 6e 10 80 	movl   $0x80106eed,(%esp)
80106f3e:	e8 6a 98 ff ff       	call   801007ad <consoleintr>
}
80106f43:	c9                   	leave  
80106f44:	c3                   	ret    

80106f45 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106f45:	6a 00                	push   $0x0
  pushl $0
80106f47:	6a 00                	push   $0x0
  jmp alltraps
80106f49:	e9 e4 f8 ff ff       	jmp    80106832 <alltraps>

80106f4e <vector1>:
.globl vector1
vector1:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $1
80106f50:	6a 01                	push   $0x1
  jmp alltraps
80106f52:	e9 db f8 ff ff       	jmp    80106832 <alltraps>

80106f57 <vector2>:
.globl vector2
vector2:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $2
80106f59:	6a 02                	push   $0x2
  jmp alltraps
80106f5b:	e9 d2 f8 ff ff       	jmp    80106832 <alltraps>

80106f60 <vector3>:
.globl vector3
vector3:
  pushl $0
80106f60:	6a 00                	push   $0x0
  pushl $3
80106f62:	6a 03                	push   $0x3
  jmp alltraps
80106f64:	e9 c9 f8 ff ff       	jmp    80106832 <alltraps>

80106f69 <vector4>:
.globl vector4
vector4:
  pushl $0
80106f69:	6a 00                	push   $0x0
  pushl $4
80106f6b:	6a 04                	push   $0x4
  jmp alltraps
80106f6d:	e9 c0 f8 ff ff       	jmp    80106832 <alltraps>

80106f72 <vector5>:
.globl vector5
vector5:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $5
80106f74:	6a 05                	push   $0x5
  jmp alltraps
80106f76:	e9 b7 f8 ff ff       	jmp    80106832 <alltraps>

80106f7b <vector6>:
.globl vector6
vector6:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $6
80106f7d:	6a 06                	push   $0x6
  jmp alltraps
80106f7f:	e9 ae f8 ff ff       	jmp    80106832 <alltraps>

80106f84 <vector7>:
.globl vector7
vector7:
  pushl $0
80106f84:	6a 00                	push   $0x0
  pushl $7
80106f86:	6a 07                	push   $0x7
  jmp alltraps
80106f88:	e9 a5 f8 ff ff       	jmp    80106832 <alltraps>

80106f8d <vector8>:
.globl vector8
vector8:
  pushl $8
80106f8d:	6a 08                	push   $0x8
  jmp alltraps
80106f8f:	e9 9e f8 ff ff       	jmp    80106832 <alltraps>

80106f94 <vector9>:
.globl vector9
vector9:
  pushl $0
80106f94:	6a 00                	push   $0x0
  pushl $9
80106f96:	6a 09                	push   $0x9
  jmp alltraps
80106f98:	e9 95 f8 ff ff       	jmp    80106832 <alltraps>

80106f9d <vector10>:
.globl vector10
vector10:
  pushl $10
80106f9d:	6a 0a                	push   $0xa
  jmp alltraps
80106f9f:	e9 8e f8 ff ff       	jmp    80106832 <alltraps>

80106fa4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106fa4:	6a 0b                	push   $0xb
  jmp alltraps
80106fa6:	e9 87 f8 ff ff       	jmp    80106832 <alltraps>

80106fab <vector12>:
.globl vector12
vector12:
  pushl $12
80106fab:	6a 0c                	push   $0xc
  jmp alltraps
80106fad:	e9 80 f8 ff ff       	jmp    80106832 <alltraps>

80106fb2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106fb2:	6a 0d                	push   $0xd
  jmp alltraps
80106fb4:	e9 79 f8 ff ff       	jmp    80106832 <alltraps>

80106fb9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106fb9:	6a 0e                	push   $0xe
  jmp alltraps
80106fbb:	e9 72 f8 ff ff       	jmp    80106832 <alltraps>

80106fc0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106fc0:	6a 00                	push   $0x0
  pushl $15
80106fc2:	6a 0f                	push   $0xf
  jmp alltraps
80106fc4:	e9 69 f8 ff ff       	jmp    80106832 <alltraps>

80106fc9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106fc9:	6a 00                	push   $0x0
  pushl $16
80106fcb:	6a 10                	push   $0x10
  jmp alltraps
80106fcd:	e9 60 f8 ff ff       	jmp    80106832 <alltraps>

80106fd2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106fd2:	6a 11                	push   $0x11
  jmp alltraps
80106fd4:	e9 59 f8 ff ff       	jmp    80106832 <alltraps>

80106fd9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106fd9:	6a 00                	push   $0x0
  pushl $18
80106fdb:	6a 12                	push   $0x12
  jmp alltraps
80106fdd:	e9 50 f8 ff ff       	jmp    80106832 <alltraps>

80106fe2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106fe2:	6a 00                	push   $0x0
  pushl $19
80106fe4:	6a 13                	push   $0x13
  jmp alltraps
80106fe6:	e9 47 f8 ff ff       	jmp    80106832 <alltraps>

80106feb <vector20>:
.globl vector20
vector20:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $20
80106fed:	6a 14                	push   $0x14
  jmp alltraps
80106fef:	e9 3e f8 ff ff       	jmp    80106832 <alltraps>

80106ff4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106ff4:	6a 00                	push   $0x0
  pushl $21
80106ff6:	6a 15                	push   $0x15
  jmp alltraps
80106ff8:	e9 35 f8 ff ff       	jmp    80106832 <alltraps>

80106ffd <vector22>:
.globl vector22
vector22:
  pushl $0
80106ffd:	6a 00                	push   $0x0
  pushl $22
80106fff:	6a 16                	push   $0x16
  jmp alltraps
80107001:	e9 2c f8 ff ff       	jmp    80106832 <alltraps>

80107006 <vector23>:
.globl vector23
vector23:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $23
80107008:	6a 17                	push   $0x17
  jmp alltraps
8010700a:	e9 23 f8 ff ff       	jmp    80106832 <alltraps>

8010700f <vector24>:
.globl vector24
vector24:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $24
80107011:	6a 18                	push   $0x18
  jmp alltraps
80107013:	e9 1a f8 ff ff       	jmp    80106832 <alltraps>

80107018 <vector25>:
.globl vector25
vector25:
  pushl $0
80107018:	6a 00                	push   $0x0
  pushl $25
8010701a:	6a 19                	push   $0x19
  jmp alltraps
8010701c:	e9 11 f8 ff ff       	jmp    80106832 <alltraps>

80107021 <vector26>:
.globl vector26
vector26:
  pushl $0
80107021:	6a 00                	push   $0x0
  pushl $26
80107023:	6a 1a                	push   $0x1a
  jmp alltraps
80107025:	e9 08 f8 ff ff       	jmp    80106832 <alltraps>

8010702a <vector27>:
.globl vector27
vector27:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $27
8010702c:	6a 1b                	push   $0x1b
  jmp alltraps
8010702e:	e9 ff f7 ff ff       	jmp    80106832 <alltraps>

80107033 <vector28>:
.globl vector28
vector28:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $28
80107035:	6a 1c                	push   $0x1c
  jmp alltraps
80107037:	e9 f6 f7 ff ff       	jmp    80106832 <alltraps>

8010703c <vector29>:
.globl vector29
vector29:
  pushl $0
8010703c:	6a 00                	push   $0x0
  pushl $29
8010703e:	6a 1d                	push   $0x1d
  jmp alltraps
80107040:	e9 ed f7 ff ff       	jmp    80106832 <alltraps>

80107045 <vector30>:
.globl vector30
vector30:
  pushl $0
80107045:	6a 00                	push   $0x0
  pushl $30
80107047:	6a 1e                	push   $0x1e
  jmp alltraps
80107049:	e9 e4 f7 ff ff       	jmp    80106832 <alltraps>

8010704e <vector31>:
.globl vector31
vector31:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $31
80107050:	6a 1f                	push   $0x1f
  jmp alltraps
80107052:	e9 db f7 ff ff       	jmp    80106832 <alltraps>

80107057 <vector32>:
.globl vector32
vector32:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $32
80107059:	6a 20                	push   $0x20
  jmp alltraps
8010705b:	e9 d2 f7 ff ff       	jmp    80106832 <alltraps>

80107060 <vector33>:
.globl vector33
vector33:
  pushl $0
80107060:	6a 00                	push   $0x0
  pushl $33
80107062:	6a 21                	push   $0x21
  jmp alltraps
80107064:	e9 c9 f7 ff ff       	jmp    80106832 <alltraps>

80107069 <vector34>:
.globl vector34
vector34:
  pushl $0
80107069:	6a 00                	push   $0x0
  pushl $34
8010706b:	6a 22                	push   $0x22
  jmp alltraps
8010706d:	e9 c0 f7 ff ff       	jmp    80106832 <alltraps>

80107072 <vector35>:
.globl vector35
vector35:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $35
80107074:	6a 23                	push   $0x23
  jmp alltraps
80107076:	e9 b7 f7 ff ff       	jmp    80106832 <alltraps>

8010707b <vector36>:
.globl vector36
vector36:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $36
8010707d:	6a 24                	push   $0x24
  jmp alltraps
8010707f:	e9 ae f7 ff ff       	jmp    80106832 <alltraps>

80107084 <vector37>:
.globl vector37
vector37:
  pushl $0
80107084:	6a 00                	push   $0x0
  pushl $37
80107086:	6a 25                	push   $0x25
  jmp alltraps
80107088:	e9 a5 f7 ff ff       	jmp    80106832 <alltraps>

8010708d <vector38>:
.globl vector38
vector38:
  pushl $0
8010708d:	6a 00                	push   $0x0
  pushl $38
8010708f:	6a 26                	push   $0x26
  jmp alltraps
80107091:	e9 9c f7 ff ff       	jmp    80106832 <alltraps>

80107096 <vector39>:
.globl vector39
vector39:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $39
80107098:	6a 27                	push   $0x27
  jmp alltraps
8010709a:	e9 93 f7 ff ff       	jmp    80106832 <alltraps>

8010709f <vector40>:
.globl vector40
vector40:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $40
801070a1:	6a 28                	push   $0x28
  jmp alltraps
801070a3:	e9 8a f7 ff ff       	jmp    80106832 <alltraps>

801070a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801070a8:	6a 00                	push   $0x0
  pushl $41
801070aa:	6a 29                	push   $0x29
  jmp alltraps
801070ac:	e9 81 f7 ff ff       	jmp    80106832 <alltraps>

801070b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801070b1:	6a 00                	push   $0x0
  pushl $42
801070b3:	6a 2a                	push   $0x2a
  jmp alltraps
801070b5:	e9 78 f7 ff ff       	jmp    80106832 <alltraps>

801070ba <vector43>:
.globl vector43
vector43:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $43
801070bc:	6a 2b                	push   $0x2b
  jmp alltraps
801070be:	e9 6f f7 ff ff       	jmp    80106832 <alltraps>

801070c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $44
801070c5:	6a 2c                	push   $0x2c
  jmp alltraps
801070c7:	e9 66 f7 ff ff       	jmp    80106832 <alltraps>

801070cc <vector45>:
.globl vector45
vector45:
  pushl $0
801070cc:	6a 00                	push   $0x0
  pushl $45
801070ce:	6a 2d                	push   $0x2d
  jmp alltraps
801070d0:	e9 5d f7 ff ff       	jmp    80106832 <alltraps>

801070d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801070d5:	6a 00                	push   $0x0
  pushl $46
801070d7:	6a 2e                	push   $0x2e
  jmp alltraps
801070d9:	e9 54 f7 ff ff       	jmp    80106832 <alltraps>

801070de <vector47>:
.globl vector47
vector47:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $47
801070e0:	6a 2f                	push   $0x2f
  jmp alltraps
801070e2:	e9 4b f7 ff ff       	jmp    80106832 <alltraps>

801070e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $48
801070e9:	6a 30                	push   $0x30
  jmp alltraps
801070eb:	e9 42 f7 ff ff       	jmp    80106832 <alltraps>

801070f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801070f0:	6a 00                	push   $0x0
  pushl $49
801070f2:	6a 31                	push   $0x31
  jmp alltraps
801070f4:	e9 39 f7 ff ff       	jmp    80106832 <alltraps>

801070f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801070f9:	6a 00                	push   $0x0
  pushl $50
801070fb:	6a 32                	push   $0x32
  jmp alltraps
801070fd:	e9 30 f7 ff ff       	jmp    80106832 <alltraps>

80107102 <vector51>:
.globl vector51
vector51:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $51
80107104:	6a 33                	push   $0x33
  jmp alltraps
80107106:	e9 27 f7 ff ff       	jmp    80106832 <alltraps>

8010710b <vector52>:
.globl vector52
vector52:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $52
8010710d:	6a 34                	push   $0x34
  jmp alltraps
8010710f:	e9 1e f7 ff ff       	jmp    80106832 <alltraps>

80107114 <vector53>:
.globl vector53
vector53:
  pushl $0
80107114:	6a 00                	push   $0x0
  pushl $53
80107116:	6a 35                	push   $0x35
  jmp alltraps
80107118:	e9 15 f7 ff ff       	jmp    80106832 <alltraps>

8010711d <vector54>:
.globl vector54
vector54:
  pushl $0
8010711d:	6a 00                	push   $0x0
  pushl $54
8010711f:	6a 36                	push   $0x36
  jmp alltraps
80107121:	e9 0c f7 ff ff       	jmp    80106832 <alltraps>

80107126 <vector55>:
.globl vector55
vector55:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $55
80107128:	6a 37                	push   $0x37
  jmp alltraps
8010712a:	e9 03 f7 ff ff       	jmp    80106832 <alltraps>

8010712f <vector56>:
.globl vector56
vector56:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $56
80107131:	6a 38                	push   $0x38
  jmp alltraps
80107133:	e9 fa f6 ff ff       	jmp    80106832 <alltraps>

80107138 <vector57>:
.globl vector57
vector57:
  pushl $0
80107138:	6a 00                	push   $0x0
  pushl $57
8010713a:	6a 39                	push   $0x39
  jmp alltraps
8010713c:	e9 f1 f6 ff ff       	jmp    80106832 <alltraps>

80107141 <vector58>:
.globl vector58
vector58:
  pushl $0
80107141:	6a 00                	push   $0x0
  pushl $58
80107143:	6a 3a                	push   $0x3a
  jmp alltraps
80107145:	e9 e8 f6 ff ff       	jmp    80106832 <alltraps>

8010714a <vector59>:
.globl vector59
vector59:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $59
8010714c:	6a 3b                	push   $0x3b
  jmp alltraps
8010714e:	e9 df f6 ff ff       	jmp    80106832 <alltraps>

80107153 <vector60>:
.globl vector60
vector60:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $60
80107155:	6a 3c                	push   $0x3c
  jmp alltraps
80107157:	e9 d6 f6 ff ff       	jmp    80106832 <alltraps>

8010715c <vector61>:
.globl vector61
vector61:
  pushl $0
8010715c:	6a 00                	push   $0x0
  pushl $61
8010715e:	6a 3d                	push   $0x3d
  jmp alltraps
80107160:	e9 cd f6 ff ff       	jmp    80106832 <alltraps>

80107165 <vector62>:
.globl vector62
vector62:
  pushl $0
80107165:	6a 00                	push   $0x0
  pushl $62
80107167:	6a 3e                	push   $0x3e
  jmp alltraps
80107169:	e9 c4 f6 ff ff       	jmp    80106832 <alltraps>

8010716e <vector63>:
.globl vector63
vector63:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $63
80107170:	6a 3f                	push   $0x3f
  jmp alltraps
80107172:	e9 bb f6 ff ff       	jmp    80106832 <alltraps>

80107177 <vector64>:
.globl vector64
vector64:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $64
80107179:	6a 40                	push   $0x40
  jmp alltraps
8010717b:	e9 b2 f6 ff ff       	jmp    80106832 <alltraps>

80107180 <vector65>:
.globl vector65
vector65:
  pushl $0
80107180:	6a 00                	push   $0x0
  pushl $65
80107182:	6a 41                	push   $0x41
  jmp alltraps
80107184:	e9 a9 f6 ff ff       	jmp    80106832 <alltraps>

80107189 <vector66>:
.globl vector66
vector66:
  pushl $0
80107189:	6a 00                	push   $0x0
  pushl $66
8010718b:	6a 42                	push   $0x42
  jmp alltraps
8010718d:	e9 a0 f6 ff ff       	jmp    80106832 <alltraps>

80107192 <vector67>:
.globl vector67
vector67:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $67
80107194:	6a 43                	push   $0x43
  jmp alltraps
80107196:	e9 97 f6 ff ff       	jmp    80106832 <alltraps>

8010719b <vector68>:
.globl vector68
vector68:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $68
8010719d:	6a 44                	push   $0x44
  jmp alltraps
8010719f:	e9 8e f6 ff ff       	jmp    80106832 <alltraps>

801071a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801071a4:	6a 00                	push   $0x0
  pushl $69
801071a6:	6a 45                	push   $0x45
  jmp alltraps
801071a8:	e9 85 f6 ff ff       	jmp    80106832 <alltraps>

801071ad <vector70>:
.globl vector70
vector70:
  pushl $0
801071ad:	6a 00                	push   $0x0
  pushl $70
801071af:	6a 46                	push   $0x46
  jmp alltraps
801071b1:	e9 7c f6 ff ff       	jmp    80106832 <alltraps>

801071b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $71
801071b8:	6a 47                	push   $0x47
  jmp alltraps
801071ba:	e9 73 f6 ff ff       	jmp    80106832 <alltraps>

801071bf <vector72>:
.globl vector72
vector72:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $72
801071c1:	6a 48                	push   $0x48
  jmp alltraps
801071c3:	e9 6a f6 ff ff       	jmp    80106832 <alltraps>

801071c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801071c8:	6a 00                	push   $0x0
  pushl $73
801071ca:	6a 49                	push   $0x49
  jmp alltraps
801071cc:	e9 61 f6 ff ff       	jmp    80106832 <alltraps>

801071d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801071d1:	6a 00                	push   $0x0
  pushl $74
801071d3:	6a 4a                	push   $0x4a
  jmp alltraps
801071d5:	e9 58 f6 ff ff       	jmp    80106832 <alltraps>

801071da <vector75>:
.globl vector75
vector75:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $75
801071dc:	6a 4b                	push   $0x4b
  jmp alltraps
801071de:	e9 4f f6 ff ff       	jmp    80106832 <alltraps>

801071e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $76
801071e5:	6a 4c                	push   $0x4c
  jmp alltraps
801071e7:	e9 46 f6 ff ff       	jmp    80106832 <alltraps>

801071ec <vector77>:
.globl vector77
vector77:
  pushl $0
801071ec:	6a 00                	push   $0x0
  pushl $77
801071ee:	6a 4d                	push   $0x4d
  jmp alltraps
801071f0:	e9 3d f6 ff ff       	jmp    80106832 <alltraps>

801071f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801071f5:	6a 00                	push   $0x0
  pushl $78
801071f7:	6a 4e                	push   $0x4e
  jmp alltraps
801071f9:	e9 34 f6 ff ff       	jmp    80106832 <alltraps>

801071fe <vector79>:
.globl vector79
vector79:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $79
80107200:	6a 4f                	push   $0x4f
  jmp alltraps
80107202:	e9 2b f6 ff ff       	jmp    80106832 <alltraps>

80107207 <vector80>:
.globl vector80
vector80:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $80
80107209:	6a 50                	push   $0x50
  jmp alltraps
8010720b:	e9 22 f6 ff ff       	jmp    80106832 <alltraps>

80107210 <vector81>:
.globl vector81
vector81:
  pushl $0
80107210:	6a 00                	push   $0x0
  pushl $81
80107212:	6a 51                	push   $0x51
  jmp alltraps
80107214:	e9 19 f6 ff ff       	jmp    80106832 <alltraps>

80107219 <vector82>:
.globl vector82
vector82:
  pushl $0
80107219:	6a 00                	push   $0x0
  pushl $82
8010721b:	6a 52                	push   $0x52
  jmp alltraps
8010721d:	e9 10 f6 ff ff       	jmp    80106832 <alltraps>

80107222 <vector83>:
.globl vector83
vector83:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $83
80107224:	6a 53                	push   $0x53
  jmp alltraps
80107226:	e9 07 f6 ff ff       	jmp    80106832 <alltraps>

8010722b <vector84>:
.globl vector84
vector84:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $84
8010722d:	6a 54                	push   $0x54
  jmp alltraps
8010722f:	e9 fe f5 ff ff       	jmp    80106832 <alltraps>

80107234 <vector85>:
.globl vector85
vector85:
  pushl $0
80107234:	6a 00                	push   $0x0
  pushl $85
80107236:	6a 55                	push   $0x55
  jmp alltraps
80107238:	e9 f5 f5 ff ff       	jmp    80106832 <alltraps>

8010723d <vector86>:
.globl vector86
vector86:
  pushl $0
8010723d:	6a 00                	push   $0x0
  pushl $86
8010723f:	6a 56                	push   $0x56
  jmp alltraps
80107241:	e9 ec f5 ff ff       	jmp    80106832 <alltraps>

80107246 <vector87>:
.globl vector87
vector87:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $87
80107248:	6a 57                	push   $0x57
  jmp alltraps
8010724a:	e9 e3 f5 ff ff       	jmp    80106832 <alltraps>

8010724f <vector88>:
.globl vector88
vector88:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $88
80107251:	6a 58                	push   $0x58
  jmp alltraps
80107253:	e9 da f5 ff ff       	jmp    80106832 <alltraps>

80107258 <vector89>:
.globl vector89
vector89:
  pushl $0
80107258:	6a 00                	push   $0x0
  pushl $89
8010725a:	6a 59                	push   $0x59
  jmp alltraps
8010725c:	e9 d1 f5 ff ff       	jmp    80106832 <alltraps>

80107261 <vector90>:
.globl vector90
vector90:
  pushl $0
80107261:	6a 00                	push   $0x0
  pushl $90
80107263:	6a 5a                	push   $0x5a
  jmp alltraps
80107265:	e9 c8 f5 ff ff       	jmp    80106832 <alltraps>

8010726a <vector91>:
.globl vector91
vector91:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $91
8010726c:	6a 5b                	push   $0x5b
  jmp alltraps
8010726e:	e9 bf f5 ff ff       	jmp    80106832 <alltraps>

80107273 <vector92>:
.globl vector92
vector92:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $92
80107275:	6a 5c                	push   $0x5c
  jmp alltraps
80107277:	e9 b6 f5 ff ff       	jmp    80106832 <alltraps>

8010727c <vector93>:
.globl vector93
vector93:
  pushl $0
8010727c:	6a 00                	push   $0x0
  pushl $93
8010727e:	6a 5d                	push   $0x5d
  jmp alltraps
80107280:	e9 ad f5 ff ff       	jmp    80106832 <alltraps>

80107285 <vector94>:
.globl vector94
vector94:
  pushl $0
80107285:	6a 00                	push   $0x0
  pushl $94
80107287:	6a 5e                	push   $0x5e
  jmp alltraps
80107289:	e9 a4 f5 ff ff       	jmp    80106832 <alltraps>

8010728e <vector95>:
.globl vector95
vector95:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $95
80107290:	6a 5f                	push   $0x5f
  jmp alltraps
80107292:	e9 9b f5 ff ff       	jmp    80106832 <alltraps>

80107297 <vector96>:
.globl vector96
vector96:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $96
80107299:	6a 60                	push   $0x60
  jmp alltraps
8010729b:	e9 92 f5 ff ff       	jmp    80106832 <alltraps>

801072a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801072a0:	6a 00                	push   $0x0
  pushl $97
801072a2:	6a 61                	push   $0x61
  jmp alltraps
801072a4:	e9 89 f5 ff ff       	jmp    80106832 <alltraps>

801072a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801072a9:	6a 00                	push   $0x0
  pushl $98
801072ab:	6a 62                	push   $0x62
  jmp alltraps
801072ad:	e9 80 f5 ff ff       	jmp    80106832 <alltraps>

801072b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $99
801072b4:	6a 63                	push   $0x63
  jmp alltraps
801072b6:	e9 77 f5 ff ff       	jmp    80106832 <alltraps>

801072bb <vector100>:
.globl vector100
vector100:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $100
801072bd:	6a 64                	push   $0x64
  jmp alltraps
801072bf:	e9 6e f5 ff ff       	jmp    80106832 <alltraps>

801072c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801072c4:	6a 00                	push   $0x0
  pushl $101
801072c6:	6a 65                	push   $0x65
  jmp alltraps
801072c8:	e9 65 f5 ff ff       	jmp    80106832 <alltraps>

801072cd <vector102>:
.globl vector102
vector102:
  pushl $0
801072cd:	6a 00                	push   $0x0
  pushl $102
801072cf:	6a 66                	push   $0x66
  jmp alltraps
801072d1:	e9 5c f5 ff ff       	jmp    80106832 <alltraps>

801072d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $103
801072d8:	6a 67                	push   $0x67
  jmp alltraps
801072da:	e9 53 f5 ff ff       	jmp    80106832 <alltraps>

801072df <vector104>:
.globl vector104
vector104:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $104
801072e1:	6a 68                	push   $0x68
  jmp alltraps
801072e3:	e9 4a f5 ff ff       	jmp    80106832 <alltraps>

801072e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801072e8:	6a 00                	push   $0x0
  pushl $105
801072ea:	6a 69                	push   $0x69
  jmp alltraps
801072ec:	e9 41 f5 ff ff       	jmp    80106832 <alltraps>

801072f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801072f1:	6a 00                	push   $0x0
  pushl $106
801072f3:	6a 6a                	push   $0x6a
  jmp alltraps
801072f5:	e9 38 f5 ff ff       	jmp    80106832 <alltraps>

801072fa <vector107>:
.globl vector107
vector107:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $107
801072fc:	6a 6b                	push   $0x6b
  jmp alltraps
801072fe:	e9 2f f5 ff ff       	jmp    80106832 <alltraps>

80107303 <vector108>:
.globl vector108
vector108:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $108
80107305:	6a 6c                	push   $0x6c
  jmp alltraps
80107307:	e9 26 f5 ff ff       	jmp    80106832 <alltraps>

8010730c <vector109>:
.globl vector109
vector109:
  pushl $0
8010730c:	6a 00                	push   $0x0
  pushl $109
8010730e:	6a 6d                	push   $0x6d
  jmp alltraps
80107310:	e9 1d f5 ff ff       	jmp    80106832 <alltraps>

80107315 <vector110>:
.globl vector110
vector110:
  pushl $0
80107315:	6a 00                	push   $0x0
  pushl $110
80107317:	6a 6e                	push   $0x6e
  jmp alltraps
80107319:	e9 14 f5 ff ff       	jmp    80106832 <alltraps>

8010731e <vector111>:
.globl vector111
vector111:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $111
80107320:	6a 6f                	push   $0x6f
  jmp alltraps
80107322:	e9 0b f5 ff ff       	jmp    80106832 <alltraps>

80107327 <vector112>:
.globl vector112
vector112:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $112
80107329:	6a 70                	push   $0x70
  jmp alltraps
8010732b:	e9 02 f5 ff ff       	jmp    80106832 <alltraps>

80107330 <vector113>:
.globl vector113
vector113:
  pushl $0
80107330:	6a 00                	push   $0x0
  pushl $113
80107332:	6a 71                	push   $0x71
  jmp alltraps
80107334:	e9 f9 f4 ff ff       	jmp    80106832 <alltraps>

80107339 <vector114>:
.globl vector114
vector114:
  pushl $0
80107339:	6a 00                	push   $0x0
  pushl $114
8010733b:	6a 72                	push   $0x72
  jmp alltraps
8010733d:	e9 f0 f4 ff ff       	jmp    80106832 <alltraps>

80107342 <vector115>:
.globl vector115
vector115:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $115
80107344:	6a 73                	push   $0x73
  jmp alltraps
80107346:	e9 e7 f4 ff ff       	jmp    80106832 <alltraps>

8010734b <vector116>:
.globl vector116
vector116:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $116
8010734d:	6a 74                	push   $0x74
  jmp alltraps
8010734f:	e9 de f4 ff ff       	jmp    80106832 <alltraps>

80107354 <vector117>:
.globl vector117
vector117:
  pushl $0
80107354:	6a 00                	push   $0x0
  pushl $117
80107356:	6a 75                	push   $0x75
  jmp alltraps
80107358:	e9 d5 f4 ff ff       	jmp    80106832 <alltraps>

8010735d <vector118>:
.globl vector118
vector118:
  pushl $0
8010735d:	6a 00                	push   $0x0
  pushl $118
8010735f:	6a 76                	push   $0x76
  jmp alltraps
80107361:	e9 cc f4 ff ff       	jmp    80106832 <alltraps>

80107366 <vector119>:
.globl vector119
vector119:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $119
80107368:	6a 77                	push   $0x77
  jmp alltraps
8010736a:	e9 c3 f4 ff ff       	jmp    80106832 <alltraps>

8010736f <vector120>:
.globl vector120
vector120:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $120
80107371:	6a 78                	push   $0x78
  jmp alltraps
80107373:	e9 ba f4 ff ff       	jmp    80106832 <alltraps>

80107378 <vector121>:
.globl vector121
vector121:
  pushl $0
80107378:	6a 00                	push   $0x0
  pushl $121
8010737a:	6a 79                	push   $0x79
  jmp alltraps
8010737c:	e9 b1 f4 ff ff       	jmp    80106832 <alltraps>

80107381 <vector122>:
.globl vector122
vector122:
  pushl $0
80107381:	6a 00                	push   $0x0
  pushl $122
80107383:	6a 7a                	push   $0x7a
  jmp alltraps
80107385:	e9 a8 f4 ff ff       	jmp    80106832 <alltraps>

8010738a <vector123>:
.globl vector123
vector123:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $123
8010738c:	6a 7b                	push   $0x7b
  jmp alltraps
8010738e:	e9 9f f4 ff ff       	jmp    80106832 <alltraps>

80107393 <vector124>:
.globl vector124
vector124:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $124
80107395:	6a 7c                	push   $0x7c
  jmp alltraps
80107397:	e9 96 f4 ff ff       	jmp    80106832 <alltraps>

8010739c <vector125>:
.globl vector125
vector125:
  pushl $0
8010739c:	6a 00                	push   $0x0
  pushl $125
8010739e:	6a 7d                	push   $0x7d
  jmp alltraps
801073a0:	e9 8d f4 ff ff       	jmp    80106832 <alltraps>

801073a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801073a5:	6a 00                	push   $0x0
  pushl $126
801073a7:	6a 7e                	push   $0x7e
  jmp alltraps
801073a9:	e9 84 f4 ff ff       	jmp    80106832 <alltraps>

801073ae <vector127>:
.globl vector127
vector127:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $127
801073b0:	6a 7f                	push   $0x7f
  jmp alltraps
801073b2:	e9 7b f4 ff ff       	jmp    80106832 <alltraps>

801073b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $128
801073b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801073be:	e9 6f f4 ff ff       	jmp    80106832 <alltraps>

801073c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $129
801073c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801073ca:	e9 63 f4 ff ff       	jmp    80106832 <alltraps>

801073cf <vector130>:
.globl vector130
vector130:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $130
801073d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801073d6:	e9 57 f4 ff ff       	jmp    80106832 <alltraps>

801073db <vector131>:
.globl vector131
vector131:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $131
801073dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801073e2:	e9 4b f4 ff ff       	jmp    80106832 <alltraps>

801073e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $132
801073e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801073ee:	e9 3f f4 ff ff       	jmp    80106832 <alltraps>

801073f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $133
801073f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801073fa:	e9 33 f4 ff ff       	jmp    80106832 <alltraps>

801073ff <vector134>:
.globl vector134
vector134:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $134
80107401:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107406:	e9 27 f4 ff ff       	jmp    80106832 <alltraps>

8010740b <vector135>:
.globl vector135
vector135:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $135
8010740d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107412:	e9 1b f4 ff ff       	jmp    80106832 <alltraps>

80107417 <vector136>:
.globl vector136
vector136:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $136
80107419:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010741e:	e9 0f f4 ff ff       	jmp    80106832 <alltraps>

80107423 <vector137>:
.globl vector137
vector137:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $137
80107425:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010742a:	e9 03 f4 ff ff       	jmp    80106832 <alltraps>

8010742f <vector138>:
.globl vector138
vector138:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $138
80107431:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107436:	e9 f7 f3 ff ff       	jmp    80106832 <alltraps>

8010743b <vector139>:
.globl vector139
vector139:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $139
8010743d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107442:	e9 eb f3 ff ff       	jmp    80106832 <alltraps>

80107447 <vector140>:
.globl vector140
vector140:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $140
80107449:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010744e:	e9 df f3 ff ff       	jmp    80106832 <alltraps>

80107453 <vector141>:
.globl vector141
vector141:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $141
80107455:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010745a:	e9 d3 f3 ff ff       	jmp    80106832 <alltraps>

8010745f <vector142>:
.globl vector142
vector142:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $142
80107461:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107466:	e9 c7 f3 ff ff       	jmp    80106832 <alltraps>

8010746b <vector143>:
.globl vector143
vector143:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $143
8010746d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107472:	e9 bb f3 ff ff       	jmp    80106832 <alltraps>

80107477 <vector144>:
.globl vector144
vector144:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $144
80107479:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010747e:	e9 af f3 ff ff       	jmp    80106832 <alltraps>

80107483 <vector145>:
.globl vector145
vector145:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $145
80107485:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010748a:	e9 a3 f3 ff ff       	jmp    80106832 <alltraps>

8010748f <vector146>:
.globl vector146
vector146:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $146
80107491:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107496:	e9 97 f3 ff ff       	jmp    80106832 <alltraps>

8010749b <vector147>:
.globl vector147
vector147:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $147
8010749d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801074a2:	e9 8b f3 ff ff       	jmp    80106832 <alltraps>

801074a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $148
801074a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801074ae:	e9 7f f3 ff ff       	jmp    80106832 <alltraps>

801074b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $149
801074b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801074ba:	e9 73 f3 ff ff       	jmp    80106832 <alltraps>

801074bf <vector150>:
.globl vector150
vector150:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $150
801074c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801074c6:	e9 67 f3 ff ff       	jmp    80106832 <alltraps>

801074cb <vector151>:
.globl vector151
vector151:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $151
801074cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801074d2:	e9 5b f3 ff ff       	jmp    80106832 <alltraps>

801074d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $152
801074d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801074de:	e9 4f f3 ff ff       	jmp    80106832 <alltraps>

801074e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $153
801074e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801074ea:	e9 43 f3 ff ff       	jmp    80106832 <alltraps>

801074ef <vector154>:
.globl vector154
vector154:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $154
801074f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801074f6:	e9 37 f3 ff ff       	jmp    80106832 <alltraps>

801074fb <vector155>:
.globl vector155
vector155:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $155
801074fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107502:	e9 2b f3 ff ff       	jmp    80106832 <alltraps>

80107507 <vector156>:
.globl vector156
vector156:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $156
80107509:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010750e:	e9 1f f3 ff ff       	jmp    80106832 <alltraps>

80107513 <vector157>:
.globl vector157
vector157:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $157
80107515:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010751a:	e9 13 f3 ff ff       	jmp    80106832 <alltraps>

8010751f <vector158>:
.globl vector158
vector158:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $158
80107521:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107526:	e9 07 f3 ff ff       	jmp    80106832 <alltraps>

8010752b <vector159>:
.globl vector159
vector159:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $159
8010752d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107532:	e9 fb f2 ff ff       	jmp    80106832 <alltraps>

80107537 <vector160>:
.globl vector160
vector160:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $160
80107539:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010753e:	e9 ef f2 ff ff       	jmp    80106832 <alltraps>

80107543 <vector161>:
.globl vector161
vector161:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $161
80107545:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010754a:	e9 e3 f2 ff ff       	jmp    80106832 <alltraps>

8010754f <vector162>:
.globl vector162
vector162:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $162
80107551:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107556:	e9 d7 f2 ff ff       	jmp    80106832 <alltraps>

8010755b <vector163>:
.globl vector163
vector163:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $163
8010755d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107562:	e9 cb f2 ff ff       	jmp    80106832 <alltraps>

80107567 <vector164>:
.globl vector164
vector164:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $164
80107569:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010756e:	e9 bf f2 ff ff       	jmp    80106832 <alltraps>

80107573 <vector165>:
.globl vector165
vector165:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $165
80107575:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010757a:	e9 b3 f2 ff ff       	jmp    80106832 <alltraps>

8010757f <vector166>:
.globl vector166
vector166:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $166
80107581:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107586:	e9 a7 f2 ff ff       	jmp    80106832 <alltraps>

8010758b <vector167>:
.globl vector167
vector167:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $167
8010758d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107592:	e9 9b f2 ff ff       	jmp    80106832 <alltraps>

80107597 <vector168>:
.globl vector168
vector168:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $168
80107599:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010759e:	e9 8f f2 ff ff       	jmp    80106832 <alltraps>

801075a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $169
801075a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801075aa:	e9 83 f2 ff ff       	jmp    80106832 <alltraps>

801075af <vector170>:
.globl vector170
vector170:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $170
801075b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801075b6:	e9 77 f2 ff ff       	jmp    80106832 <alltraps>

801075bb <vector171>:
.globl vector171
vector171:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $171
801075bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801075c2:	e9 6b f2 ff ff       	jmp    80106832 <alltraps>

801075c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $172
801075c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801075ce:	e9 5f f2 ff ff       	jmp    80106832 <alltraps>

801075d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $173
801075d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801075da:	e9 53 f2 ff ff       	jmp    80106832 <alltraps>

801075df <vector174>:
.globl vector174
vector174:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $174
801075e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801075e6:	e9 47 f2 ff ff       	jmp    80106832 <alltraps>

801075eb <vector175>:
.globl vector175
vector175:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $175
801075ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801075f2:	e9 3b f2 ff ff       	jmp    80106832 <alltraps>

801075f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $176
801075f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801075fe:	e9 2f f2 ff ff       	jmp    80106832 <alltraps>

80107603 <vector177>:
.globl vector177
vector177:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $177
80107605:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010760a:	e9 23 f2 ff ff       	jmp    80106832 <alltraps>

8010760f <vector178>:
.globl vector178
vector178:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $178
80107611:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107616:	e9 17 f2 ff ff       	jmp    80106832 <alltraps>

8010761b <vector179>:
.globl vector179
vector179:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $179
8010761d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107622:	e9 0b f2 ff ff       	jmp    80106832 <alltraps>

80107627 <vector180>:
.globl vector180
vector180:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $180
80107629:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010762e:	e9 ff f1 ff ff       	jmp    80106832 <alltraps>

80107633 <vector181>:
.globl vector181
vector181:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $181
80107635:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010763a:	e9 f3 f1 ff ff       	jmp    80106832 <alltraps>

8010763f <vector182>:
.globl vector182
vector182:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $182
80107641:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107646:	e9 e7 f1 ff ff       	jmp    80106832 <alltraps>

8010764b <vector183>:
.globl vector183
vector183:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $183
8010764d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107652:	e9 db f1 ff ff       	jmp    80106832 <alltraps>

80107657 <vector184>:
.globl vector184
vector184:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $184
80107659:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010765e:	e9 cf f1 ff ff       	jmp    80106832 <alltraps>

80107663 <vector185>:
.globl vector185
vector185:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $185
80107665:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010766a:	e9 c3 f1 ff ff       	jmp    80106832 <alltraps>

8010766f <vector186>:
.globl vector186
vector186:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $186
80107671:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107676:	e9 b7 f1 ff ff       	jmp    80106832 <alltraps>

8010767b <vector187>:
.globl vector187
vector187:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $187
8010767d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107682:	e9 ab f1 ff ff       	jmp    80106832 <alltraps>

80107687 <vector188>:
.globl vector188
vector188:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $188
80107689:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010768e:	e9 9f f1 ff ff       	jmp    80106832 <alltraps>

80107693 <vector189>:
.globl vector189
vector189:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $189
80107695:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010769a:	e9 93 f1 ff ff       	jmp    80106832 <alltraps>

8010769f <vector190>:
.globl vector190
vector190:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $190
801076a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801076a6:	e9 87 f1 ff ff       	jmp    80106832 <alltraps>

801076ab <vector191>:
.globl vector191
vector191:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $191
801076ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801076b2:	e9 7b f1 ff ff       	jmp    80106832 <alltraps>

801076b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $192
801076b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801076be:	e9 6f f1 ff ff       	jmp    80106832 <alltraps>

801076c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $193
801076c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801076ca:	e9 63 f1 ff ff       	jmp    80106832 <alltraps>

801076cf <vector194>:
.globl vector194
vector194:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $194
801076d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801076d6:	e9 57 f1 ff ff       	jmp    80106832 <alltraps>

801076db <vector195>:
.globl vector195
vector195:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $195
801076dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801076e2:	e9 4b f1 ff ff       	jmp    80106832 <alltraps>

801076e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $196
801076e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801076ee:	e9 3f f1 ff ff       	jmp    80106832 <alltraps>

801076f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $197
801076f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801076fa:	e9 33 f1 ff ff       	jmp    80106832 <alltraps>

801076ff <vector198>:
.globl vector198
vector198:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $198
80107701:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107706:	e9 27 f1 ff ff       	jmp    80106832 <alltraps>

8010770b <vector199>:
.globl vector199
vector199:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $199
8010770d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107712:	e9 1b f1 ff ff       	jmp    80106832 <alltraps>

80107717 <vector200>:
.globl vector200
vector200:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $200
80107719:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010771e:	e9 0f f1 ff ff       	jmp    80106832 <alltraps>

80107723 <vector201>:
.globl vector201
vector201:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $201
80107725:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010772a:	e9 03 f1 ff ff       	jmp    80106832 <alltraps>

8010772f <vector202>:
.globl vector202
vector202:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $202
80107731:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107736:	e9 f7 f0 ff ff       	jmp    80106832 <alltraps>

8010773b <vector203>:
.globl vector203
vector203:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $203
8010773d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107742:	e9 eb f0 ff ff       	jmp    80106832 <alltraps>

80107747 <vector204>:
.globl vector204
vector204:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $204
80107749:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010774e:	e9 df f0 ff ff       	jmp    80106832 <alltraps>

80107753 <vector205>:
.globl vector205
vector205:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $205
80107755:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010775a:	e9 d3 f0 ff ff       	jmp    80106832 <alltraps>

8010775f <vector206>:
.globl vector206
vector206:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $206
80107761:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107766:	e9 c7 f0 ff ff       	jmp    80106832 <alltraps>

8010776b <vector207>:
.globl vector207
vector207:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $207
8010776d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107772:	e9 bb f0 ff ff       	jmp    80106832 <alltraps>

80107777 <vector208>:
.globl vector208
vector208:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $208
80107779:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010777e:	e9 af f0 ff ff       	jmp    80106832 <alltraps>

80107783 <vector209>:
.globl vector209
vector209:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $209
80107785:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010778a:	e9 a3 f0 ff ff       	jmp    80106832 <alltraps>

8010778f <vector210>:
.globl vector210
vector210:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $210
80107791:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107796:	e9 97 f0 ff ff       	jmp    80106832 <alltraps>

8010779b <vector211>:
.globl vector211
vector211:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $211
8010779d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801077a2:	e9 8b f0 ff ff       	jmp    80106832 <alltraps>

801077a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $212
801077a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801077ae:	e9 7f f0 ff ff       	jmp    80106832 <alltraps>

801077b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $213
801077b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801077ba:	e9 73 f0 ff ff       	jmp    80106832 <alltraps>

801077bf <vector214>:
.globl vector214
vector214:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $214
801077c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801077c6:	e9 67 f0 ff ff       	jmp    80106832 <alltraps>

801077cb <vector215>:
.globl vector215
vector215:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $215
801077cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801077d2:	e9 5b f0 ff ff       	jmp    80106832 <alltraps>

801077d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $216
801077d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801077de:	e9 4f f0 ff ff       	jmp    80106832 <alltraps>

801077e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $217
801077e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801077ea:	e9 43 f0 ff ff       	jmp    80106832 <alltraps>

801077ef <vector218>:
.globl vector218
vector218:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $218
801077f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801077f6:	e9 37 f0 ff ff       	jmp    80106832 <alltraps>

801077fb <vector219>:
.globl vector219
vector219:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $219
801077fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107802:	e9 2b f0 ff ff       	jmp    80106832 <alltraps>

80107807 <vector220>:
.globl vector220
vector220:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $220
80107809:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010780e:	e9 1f f0 ff ff       	jmp    80106832 <alltraps>

80107813 <vector221>:
.globl vector221
vector221:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $221
80107815:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010781a:	e9 13 f0 ff ff       	jmp    80106832 <alltraps>

8010781f <vector222>:
.globl vector222
vector222:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $222
80107821:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107826:	e9 07 f0 ff ff       	jmp    80106832 <alltraps>

8010782b <vector223>:
.globl vector223
vector223:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $223
8010782d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107832:	e9 fb ef ff ff       	jmp    80106832 <alltraps>

80107837 <vector224>:
.globl vector224
vector224:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $224
80107839:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010783e:	e9 ef ef ff ff       	jmp    80106832 <alltraps>

80107843 <vector225>:
.globl vector225
vector225:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $225
80107845:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010784a:	e9 e3 ef ff ff       	jmp    80106832 <alltraps>

8010784f <vector226>:
.globl vector226
vector226:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $226
80107851:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107856:	e9 d7 ef ff ff       	jmp    80106832 <alltraps>

8010785b <vector227>:
.globl vector227
vector227:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $227
8010785d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107862:	e9 cb ef ff ff       	jmp    80106832 <alltraps>

80107867 <vector228>:
.globl vector228
vector228:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $228
80107869:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010786e:	e9 bf ef ff ff       	jmp    80106832 <alltraps>

80107873 <vector229>:
.globl vector229
vector229:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $229
80107875:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010787a:	e9 b3 ef ff ff       	jmp    80106832 <alltraps>

8010787f <vector230>:
.globl vector230
vector230:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $230
80107881:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107886:	e9 a7 ef ff ff       	jmp    80106832 <alltraps>

8010788b <vector231>:
.globl vector231
vector231:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $231
8010788d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107892:	e9 9b ef ff ff       	jmp    80106832 <alltraps>

80107897 <vector232>:
.globl vector232
vector232:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $232
80107899:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010789e:	e9 8f ef ff ff       	jmp    80106832 <alltraps>

801078a3 <vector233>:
.globl vector233
vector233:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $233
801078a5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801078aa:	e9 83 ef ff ff       	jmp    80106832 <alltraps>

801078af <vector234>:
.globl vector234
vector234:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $234
801078b1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801078b6:	e9 77 ef ff ff       	jmp    80106832 <alltraps>

801078bb <vector235>:
.globl vector235
vector235:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $235
801078bd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801078c2:	e9 6b ef ff ff       	jmp    80106832 <alltraps>

801078c7 <vector236>:
.globl vector236
vector236:
  pushl $0
801078c7:	6a 00                	push   $0x0
  pushl $236
801078c9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801078ce:	e9 5f ef ff ff       	jmp    80106832 <alltraps>

801078d3 <vector237>:
.globl vector237
vector237:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $237
801078d5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801078da:	e9 53 ef ff ff       	jmp    80106832 <alltraps>

801078df <vector238>:
.globl vector238
vector238:
  pushl $0
801078df:	6a 00                	push   $0x0
  pushl $238
801078e1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801078e6:	e9 47 ef ff ff       	jmp    80106832 <alltraps>

801078eb <vector239>:
.globl vector239
vector239:
  pushl $0
801078eb:	6a 00                	push   $0x0
  pushl $239
801078ed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801078f2:	e9 3b ef ff ff       	jmp    80106832 <alltraps>

801078f7 <vector240>:
.globl vector240
vector240:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $240
801078f9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801078fe:	e9 2f ef ff ff       	jmp    80106832 <alltraps>

80107903 <vector241>:
.globl vector241
vector241:
  pushl $0
80107903:	6a 00                	push   $0x0
  pushl $241
80107905:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010790a:	e9 23 ef ff ff       	jmp    80106832 <alltraps>

8010790f <vector242>:
.globl vector242
vector242:
  pushl $0
8010790f:	6a 00                	push   $0x0
  pushl $242
80107911:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107916:	e9 17 ef ff ff       	jmp    80106832 <alltraps>

8010791b <vector243>:
.globl vector243
vector243:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $243
8010791d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107922:	e9 0b ef ff ff       	jmp    80106832 <alltraps>

80107927 <vector244>:
.globl vector244
vector244:
  pushl $0
80107927:	6a 00                	push   $0x0
  pushl $244
80107929:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010792e:	e9 ff ee ff ff       	jmp    80106832 <alltraps>

80107933 <vector245>:
.globl vector245
vector245:
  pushl $0
80107933:	6a 00                	push   $0x0
  pushl $245
80107935:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010793a:	e9 f3 ee ff ff       	jmp    80106832 <alltraps>

8010793f <vector246>:
.globl vector246
vector246:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $246
80107941:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107946:	e9 e7 ee ff ff       	jmp    80106832 <alltraps>

8010794b <vector247>:
.globl vector247
vector247:
  pushl $0
8010794b:	6a 00                	push   $0x0
  pushl $247
8010794d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107952:	e9 db ee ff ff       	jmp    80106832 <alltraps>

80107957 <vector248>:
.globl vector248
vector248:
  pushl $0
80107957:	6a 00                	push   $0x0
  pushl $248
80107959:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010795e:	e9 cf ee ff ff       	jmp    80106832 <alltraps>

80107963 <vector249>:
.globl vector249
vector249:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $249
80107965:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010796a:	e9 c3 ee ff ff       	jmp    80106832 <alltraps>

8010796f <vector250>:
.globl vector250
vector250:
  pushl $0
8010796f:	6a 00                	push   $0x0
  pushl $250
80107971:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107976:	e9 b7 ee ff ff       	jmp    80106832 <alltraps>

8010797b <vector251>:
.globl vector251
vector251:
  pushl $0
8010797b:	6a 00                	push   $0x0
  pushl $251
8010797d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107982:	e9 ab ee ff ff       	jmp    80106832 <alltraps>

80107987 <vector252>:
.globl vector252
vector252:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $252
80107989:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010798e:	e9 9f ee ff ff       	jmp    80106832 <alltraps>

80107993 <vector253>:
.globl vector253
vector253:
  pushl $0
80107993:	6a 00                	push   $0x0
  pushl $253
80107995:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010799a:	e9 93 ee ff ff       	jmp    80106832 <alltraps>

8010799f <vector254>:
.globl vector254
vector254:
  pushl $0
8010799f:	6a 00                	push   $0x0
  pushl $254
801079a1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801079a6:	e9 87 ee ff ff       	jmp    80106832 <alltraps>

801079ab <vector255>:
.globl vector255
vector255:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $255
801079ad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801079b2:	e9 7b ee ff ff       	jmp    80106832 <alltraps>

801079b7 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801079b7:	55                   	push   %ebp
801079b8:	89 e5                	mov    %esp,%ebp
801079ba:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801079bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801079c0:	83 e8 01             	sub    $0x1,%eax
801079c3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801079c7:	8b 45 08             	mov    0x8(%ebp),%eax
801079ca:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801079ce:	8b 45 08             	mov    0x8(%ebp),%eax
801079d1:	c1 e8 10             	shr    $0x10,%eax
801079d4:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801079d8:	8d 45 fa             	lea    -0x6(%ebp),%eax
801079db:	0f 01 10             	lgdtl  (%eax)
}
801079de:	c9                   	leave  
801079df:	c3                   	ret    

801079e0 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	83 ec 04             	sub    $0x4,%esp
801079e6:	8b 45 08             	mov    0x8(%ebp),%eax
801079e9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801079ed:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801079f1:	0f 00 d8             	ltr    %ax
}
801079f4:	c9                   	leave  
801079f5:	c3                   	ret    

801079f6 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801079f6:	55                   	push   %ebp
801079f7:	89 e5                	mov    %esp,%ebp
801079f9:	83 ec 04             	sub    $0x4,%esp
801079fc:	8b 45 08             	mov    0x8(%ebp),%eax
801079ff:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107a03:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107a07:	8e e8                	mov    %eax,%gs
}
80107a09:	c9                   	leave  
80107a0a:	c3                   	ret    

80107a0b <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107a0b:	55                   	push   %ebp
80107a0c:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a0e:	8b 45 08             	mov    0x8(%ebp),%eax
80107a11:	0f 22 d8             	mov    %eax,%cr3
}
80107a14:	5d                   	pop    %ebp
80107a15:	c3                   	ret    

80107a16 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107a16:	55                   	push   %ebp
80107a17:	89 e5                	mov    %esp,%ebp
80107a19:	8b 45 08             	mov    0x8(%ebp),%eax
80107a1c:	05 00 00 00 80       	add    $0x80000000,%eax
80107a21:	5d                   	pop    %ebp
80107a22:	c3                   	ret    

80107a23 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107a23:	55                   	push   %ebp
80107a24:	89 e5                	mov    %esp,%ebp
80107a26:	8b 45 08             	mov    0x8(%ebp),%eax
80107a29:	05 00 00 00 80       	add    $0x80000000,%eax
80107a2e:	5d                   	pop    %ebp
80107a2f:	c3                   	ret    

80107a30 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107a30:	55                   	push   %ebp
80107a31:	89 e5                	mov    %esp,%ebp
80107a33:	53                   	push   %ebx
80107a34:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107a37:	e8 4f b4 ff ff       	call   80102e8b <cpunum>
80107a3c:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107a42:	05 80 23 11 80       	add    $0x80112380,%eax
80107a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4d:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a56:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5f:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a66:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a6a:	83 e2 f0             	and    $0xfffffff0,%edx
80107a6d:	83 ca 0a             	or     $0xa,%edx
80107a70:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a76:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a7a:	83 ca 10             	or     $0x10,%edx
80107a7d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a83:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a87:	83 e2 9f             	and    $0xffffff9f,%edx
80107a8a:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a90:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a94:	83 ca 80             	or     $0xffffff80,%edx
80107a97:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107aa1:	83 ca 0f             	or     $0xf,%edx
80107aa4:	88 50 7e             	mov    %dl,0x7e(%eax)
80107aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aaa:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107aae:	83 e2 ef             	and    $0xffffffef,%edx
80107ab1:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab7:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107abb:	83 e2 df             	and    $0xffffffdf,%edx
80107abe:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac4:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ac8:	83 ca 40             	or     $0x40,%edx
80107acb:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad1:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ad5:	83 ca 80             	or     $0xffffff80,%edx
80107ad8:	88 50 7e             	mov    %dl,0x7e(%eax)
80107adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ade:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae5:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107aec:	ff ff 
80107aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af1:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107af8:	00 00 
80107afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107afd:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b07:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b0e:	83 e2 f0             	and    $0xfffffff0,%edx
80107b11:	83 ca 02             	or     $0x2,%edx
80107b14:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b24:	83 ca 10             	or     $0x10,%edx
80107b27:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b30:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b37:	83 e2 9f             	and    $0xffffff9f,%edx
80107b3a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b43:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b4a:	83 ca 80             	or     $0xffffff80,%edx
80107b4d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b56:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b5d:	83 ca 0f             	or     $0xf,%edx
80107b60:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b69:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b70:	83 e2 ef             	and    $0xffffffef,%edx
80107b73:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b7c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b83:	83 e2 df             	and    $0xffffffdf,%edx
80107b86:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b8f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b96:	83 ca 40             	or     $0x40,%edx
80107b99:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba2:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ba9:	83 ca 80             	or     $0xffffff80,%edx
80107bac:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb5:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bbf:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107bc6:	ff ff 
80107bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bcb:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107bd2:	00 00 
80107bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd7:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be1:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107be8:	83 e2 f0             	and    $0xfffffff0,%edx
80107beb:	83 ca 0a             	or     $0xa,%edx
80107bee:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107bfe:	83 ca 10             	or     $0x10,%edx
80107c01:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107c11:	83 ca 60             	or     $0x60,%edx
80107c14:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c1d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107c24:	83 ca 80             	or     $0xffffff80,%edx
80107c27:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c30:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c37:	83 ca 0f             	or     $0xf,%edx
80107c3a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c43:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c4a:	83 e2 ef             	and    $0xffffffef,%edx
80107c4d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c56:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c5d:	83 e2 df             	and    $0xffffffdf,%edx
80107c60:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c69:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c70:	83 ca 40             	or     $0x40,%edx
80107c73:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c83:	83 ca 80             	or     $0xffffff80,%edx
80107c86:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c8f:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c99:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107ca0:	ff ff 
80107ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca5:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107cac:	00 00 
80107cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb1:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cbb:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cc2:	83 e2 f0             	and    $0xfffffff0,%edx
80107cc5:	83 ca 02             	or     $0x2,%edx
80107cc8:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd1:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cd8:	83 ca 10             	or     $0x10,%edx
80107cdb:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce4:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ceb:	83 ca 60             	or     $0x60,%edx
80107cee:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf7:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cfe:	83 ca 80             	or     $0xffffff80,%edx
80107d01:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d11:	83 ca 0f             	or     $0xf,%edx
80107d14:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d1d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d24:	83 e2 ef             	and    $0xffffffef,%edx
80107d27:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d30:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d37:	83 e2 df             	and    $0xffffffdf,%edx
80107d3a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d43:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d4a:	83 ca 40             	or     $0x40,%edx
80107d4d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d56:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d5d:	83 ca 80             	or     $0xffffff80,%edx
80107d60:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d69:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d73:	05 b4 00 00 00       	add    $0xb4,%eax
80107d78:	89 c3                	mov    %eax,%ebx
80107d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7d:	05 b4 00 00 00       	add    $0xb4,%eax
80107d82:	c1 e8 10             	shr    $0x10,%eax
80107d85:	89 c1                	mov    %eax,%ecx
80107d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8a:	05 b4 00 00 00       	add    $0xb4,%eax
80107d8f:	c1 e8 18             	shr    $0x18,%eax
80107d92:	89 c2                	mov    %eax,%edx
80107d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d97:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107d9e:	00 00 
80107da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da3:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dad:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db6:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107dbd:	83 e1 f0             	and    $0xfffffff0,%ecx
80107dc0:	83 c9 02             	or     $0x2,%ecx
80107dc3:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dcc:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107dd3:	83 c9 10             	or     $0x10,%ecx
80107dd6:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ddf:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107de6:	83 e1 9f             	and    $0xffffff9f,%ecx
80107de9:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df2:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107df9:	83 c9 80             	or     $0xffffff80,%ecx
80107dfc:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e05:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107e0c:	83 e1 f0             	and    $0xfffffff0,%ecx
80107e0f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e18:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107e1f:	83 e1 ef             	and    $0xffffffef,%ecx
80107e22:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e2b:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107e32:	83 e1 df             	and    $0xffffffdf,%ecx
80107e35:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e3e:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107e45:	83 c9 40             	or     $0x40,%ecx
80107e48:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e51:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107e58:	83 c9 80             	or     $0xffffff80,%ecx
80107e5b:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e64:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e6d:	83 c0 70             	add    $0x70,%eax
80107e70:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107e77:	00 
80107e78:	89 04 24             	mov    %eax,(%esp)
80107e7b:	e8 37 fb ff ff       	call   801079b7 <lgdt>
  loadgs(SEG_KCPU << 3);
80107e80:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107e87:	e8 6a fb ff ff       	call   801079f6 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e8f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  current = 0;
80107e95:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107e9c:	00 00 00 00 
}
80107ea0:	83 c4 24             	add    $0x24,%esp
80107ea3:	5b                   	pop    %ebx
80107ea4:	5d                   	pop    %ebp
80107ea5:	c3                   	ret    

80107ea6 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107ea6:	55                   	push   %ebp
80107ea7:	89 e5                	mov    %esp,%ebp
80107ea9:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107eac:	8b 45 0c             	mov    0xc(%ebp),%eax
80107eaf:	c1 e8 16             	shr    $0x16,%eax
80107eb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80107ebc:	01 d0                	add    %edx,%eax
80107ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ec4:	8b 00                	mov    (%eax),%eax
80107ec6:	83 e0 01             	and    $0x1,%eax
80107ec9:	85 c0                	test   %eax,%eax
80107ecb:	74 17                	je     80107ee4 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ed0:	8b 00                	mov    (%eax),%eax
80107ed2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ed7:	89 04 24             	mov    %eax,(%esp)
80107eda:	e8 44 fb ff ff       	call   80107a23 <p2v>
80107edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ee2:	eb 4b                	jmp    80107f2f <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107ee4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107ee8:	74 0e                	je     80107ef8 <walkpgdir+0x52>
80107eea:	e8 06 ac ff ff       	call   80102af5 <kalloc>
80107eef:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ef2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ef6:	75 07                	jne    80107eff <walkpgdir+0x59>
      return 0;
80107ef8:	b8 00 00 00 00       	mov    $0x0,%eax
80107efd:	eb 47                	jmp    80107f46 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107eff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f06:	00 
80107f07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107f0e:	00 
80107f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f12:	89 04 24             	mov    %eax,(%esp)
80107f15:	e8 78 d4 ff ff       	call   80105392 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1d:	89 04 24             	mov    %eax,(%esp)
80107f20:	e8 f1 fa ff ff       	call   80107a16 <v2p>
80107f25:	83 c8 07             	or     $0x7,%eax
80107f28:	89 c2                	mov    %eax,%edx
80107f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f2d:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f32:	c1 e8 0c             	shr    $0xc,%eax
80107f35:	25 ff 03 00 00       	and    $0x3ff,%eax
80107f3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f44:	01 d0                	add    %edx,%eax
}
80107f46:	c9                   	leave  
80107f47:	c3                   	ret    

80107f48 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107f48:	55                   	push   %ebp
80107f49:	89 e5                	mov    %esp,%ebp
80107f4b:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107f59:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f5c:	8b 45 10             	mov    0x10(%ebp),%eax
80107f5f:	01 d0                	add    %edx,%eax
80107f61:	83 e8 01             	sub    $0x1,%eax
80107f64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107f6c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107f73:	00 
80107f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f77:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f7e:	89 04 24             	mov    %eax,(%esp)
80107f81:	e8 20 ff ff ff       	call   80107ea6 <walkpgdir>
80107f86:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f89:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f8d:	75 07                	jne    80107f96 <mappages+0x4e>
      return -1;
80107f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f94:	eb 48                	jmp    80107fde <mappages+0x96>
    if(*pte & PTE_P)
80107f96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f99:	8b 00                	mov    (%eax),%eax
80107f9b:	83 e0 01             	and    $0x1,%eax
80107f9e:	85 c0                	test   %eax,%eax
80107fa0:	74 0c                	je     80107fae <mappages+0x66>
      panic("remap");
80107fa2:	c7 04 24 f8 8d 10 80 	movl   $0x80108df8,(%esp)
80107fa9:	e8 8c 85 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
80107fae:	8b 45 18             	mov    0x18(%ebp),%eax
80107fb1:	0b 45 14             	or     0x14(%ebp),%eax
80107fb4:	83 c8 01             	or     $0x1,%eax
80107fb7:	89 c2                	mov    %eax,%edx
80107fb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fbc:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107fc4:	75 08                	jne    80107fce <mappages+0x86>
      break;
80107fc6:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107fc7:	b8 00 00 00 00       	mov    $0x0,%eax
80107fcc:	eb 10                	jmp    80107fde <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107fce:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107fd5:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107fdc:	eb 8e                	jmp    80107f6c <mappages+0x24>
  return 0;
}
80107fde:	c9                   	leave  
80107fdf:	c3                   	ret    

80107fe0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107fe0:	55                   	push   %ebp
80107fe1:	89 e5                	mov    %esp,%ebp
80107fe3:	53                   	push   %ebx
80107fe4:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107fe7:	e8 09 ab ff ff       	call   80102af5 <kalloc>
80107fec:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107ff3:	75 0a                	jne    80107fff <setupkvm+0x1f>
    return 0;
80107ff5:	b8 00 00 00 00       	mov    $0x0,%eax
80107ffa:	e9 98 00 00 00       	jmp    80108097 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107fff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108006:	00 
80108007:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010800e:	00 
8010800f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108012:	89 04 24             	mov    %eax,(%esp)
80108015:	e8 78 d3 ff ff       	call   80105392 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010801a:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80108021:	e8 fd f9 ff ff       	call   80107a23 <p2v>
80108026:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010802b:	76 0c                	jbe    80108039 <setupkvm+0x59>
    panic("PHYSTOP too high");
8010802d:	c7 04 24 fe 8d 10 80 	movl   $0x80108dfe,(%esp)
80108034:	e8 01 85 ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108039:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80108040:	eb 49                	jmp    8010808b <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108045:	8b 48 0c             	mov    0xc(%eax),%ecx
80108048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804b:	8b 50 04             	mov    0x4(%eax),%edx
8010804e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108051:	8b 58 08             	mov    0x8(%eax),%ebx
80108054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108057:	8b 40 04             	mov    0x4(%eax),%eax
8010805a:	29 c3                	sub    %eax,%ebx
8010805c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805f:	8b 00                	mov    (%eax),%eax
80108061:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108065:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108069:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010806d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108071:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108074:	89 04 24             	mov    %eax,(%esp)
80108077:	e8 cc fe ff ff       	call   80107f48 <mappages>
8010807c:	85 c0                	test   %eax,%eax
8010807e:	79 07                	jns    80108087 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108080:	b8 00 00 00 00       	mov    $0x0,%eax
80108085:	eb 10                	jmp    80108097 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108087:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010808b:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80108092:	72 ae                	jb     80108042 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108094:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108097:	83 c4 34             	add    $0x34,%esp
8010809a:	5b                   	pop    %ebx
8010809b:	5d                   	pop    %ebp
8010809c:	c3                   	ret    

8010809d <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010809d:	55                   	push   %ebp
8010809e:	89 e5                	mov    %esp,%ebp
801080a0:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801080a3:	e8 38 ff ff ff       	call   80107fe0 <setupkvm>
801080a8:	a3 58 54 11 80       	mov    %eax,0x80115458
  switchkvm();
801080ad:	e8 02 00 00 00       	call   801080b4 <switchkvm>
}
801080b2:	c9                   	leave  
801080b3:	c3                   	ret    

801080b4 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801080b4:	55                   	push   %ebp
801080b5:	89 e5                	mov    %esp,%ebp
801080b7:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801080ba:	a1 58 54 11 80       	mov    0x80115458,%eax
801080bf:	89 04 24             	mov    %eax,(%esp)
801080c2:	e8 4f f9 ff ff       	call   80107a16 <v2p>
801080c7:	89 04 24             	mov    %eax,(%esp)
801080ca:	e8 3c f9 ff ff       	call   80107a0b <lcr3>
}
801080cf:	c9                   	leave  
801080d0:	c3                   	ret    

801080d1 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801080d1:	55                   	push   %ebp
801080d2:	89 e5                	mov    %esp,%ebp
801080d4:	53                   	push   %ebx
801080d5:	83 ec 14             	sub    $0x14,%esp
  pushcli();
801080d8:	e8 b5 d1 ff ff       	call   80105292 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801080dd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801080e3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801080ea:	83 c2 08             	add    $0x8,%edx
801080ed:	89 d3                	mov    %edx,%ebx
801080ef:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801080f6:	83 c2 08             	add    $0x8,%edx
801080f9:	c1 ea 10             	shr    $0x10,%edx
801080fc:	89 d1                	mov    %edx,%ecx
801080fe:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108105:	83 c2 08             	add    $0x8,%edx
80108108:	c1 ea 18             	shr    $0x18,%edx
8010810b:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108112:	67 00 
80108114:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
8010811b:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80108121:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108128:	83 e1 f0             	and    $0xfffffff0,%ecx
8010812b:	83 c9 09             	or     $0x9,%ecx
8010812e:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108134:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010813b:	83 c9 10             	or     $0x10,%ecx
8010813e:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108144:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010814b:	83 e1 9f             	and    $0xffffff9f,%ecx
8010814e:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108154:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010815b:	83 c9 80             	or     $0xffffff80,%ecx
8010815e:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108164:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010816b:	83 e1 f0             	and    $0xfffffff0,%ecx
8010816e:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108174:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010817b:	83 e1 ef             	and    $0xffffffef,%ecx
8010817e:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108184:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010818b:	83 e1 df             	and    $0xffffffdf,%ecx
8010818e:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108194:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010819b:	83 c9 40             	or     $0x40,%ecx
8010819e:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801081a4:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801081ab:	83 e1 7f             	and    $0x7f,%ecx
801081ae:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801081b4:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801081ba:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081c0:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801081c7:	83 e2 ef             	and    $0xffffffef,%edx
801081ca:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801081d0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081d6:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)current->kstack + KSTACKSIZE;
801081dc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081e2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801081e9:	8b 52 70             	mov    0x70(%edx),%edx
801081ec:	81 c2 00 10 00 00    	add    $0x1000,%edx
801081f2:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801081f5:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801081fc:	e8 df f7 ff ff       	call   801079e0 <ltr>
  if(p->pgdir == 0)
80108201:	8b 45 08             	mov    0x8(%ebp),%eax
80108204:	8b 40 08             	mov    0x8(%eax),%eax
80108207:	85 c0                	test   %eax,%eax
80108209:	75 0c                	jne    80108217 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
8010820b:	c7 04 24 0f 8e 10 80 	movl   $0x80108e0f,(%esp)
80108212:	e8 23 83 ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108217:	8b 45 08             	mov    0x8(%ebp),%eax
8010821a:	8b 40 08             	mov    0x8(%eax),%eax
8010821d:	89 04 24             	mov    %eax,(%esp)
80108220:	e8 f1 f7 ff ff       	call   80107a16 <v2p>
80108225:	89 04 24             	mov    %eax,(%esp)
80108228:	e8 de f7 ff ff       	call   80107a0b <lcr3>
  popcli();
8010822d:	e8 a4 d0 ff ff       	call   801052d6 <popcli>
}
80108232:	83 c4 14             	add    $0x14,%esp
80108235:	5b                   	pop    %ebx
80108236:	5d                   	pop    %ebp
80108237:	c3                   	ret    

80108238 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108238:	55                   	push   %ebp
80108239:	89 e5                	mov    %esp,%ebp
8010823b:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010823e:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108245:	76 0c                	jbe    80108253 <inituvm+0x1b>
    panic("inituvm: more than a page");
80108247:	c7 04 24 23 8e 10 80 	movl   $0x80108e23,(%esp)
8010824e:	e8 e7 82 ff ff       	call   8010053a <panic>
  mem = kalloc();
80108253:	e8 9d a8 ff ff       	call   80102af5 <kalloc>
80108258:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010825b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108262:	00 
80108263:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010826a:	00 
8010826b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826e:	89 04 24             	mov    %eax,(%esp)
80108271:	e8 1c d1 ff ff       	call   80105392 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108279:	89 04 24             	mov    %eax,(%esp)
8010827c:	e8 95 f7 ff ff       	call   80107a16 <v2p>
80108281:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108288:	00 
80108289:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010828d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108294:	00 
80108295:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010829c:	00 
8010829d:	8b 45 08             	mov    0x8(%ebp),%eax
801082a0:	89 04 24             	mov    %eax,(%esp)
801082a3:	e8 a0 fc ff ff       	call   80107f48 <mappages>
  memmove(mem, init, sz);
801082a8:	8b 45 10             	mov    0x10(%ebp),%eax
801082ab:	89 44 24 08          	mov    %eax,0x8(%esp)
801082af:	8b 45 0c             	mov    0xc(%ebp),%eax
801082b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801082b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b9:	89 04 24             	mov    %eax,(%esp)
801082bc:	e8 a0 d1 ff ff       	call   80105461 <memmove>
}
801082c1:	c9                   	leave  
801082c2:	c3                   	ret    

801082c3 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801082c3:	55                   	push   %ebp
801082c4:	89 e5                	mov    %esp,%ebp
801082c6:	53                   	push   %ebx
801082c7:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801082ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801082cd:	25 ff 0f 00 00       	and    $0xfff,%eax
801082d2:	85 c0                	test   %eax,%eax
801082d4:	74 0c                	je     801082e2 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801082d6:	c7 04 24 40 8e 10 80 	movl   $0x80108e40,(%esp)
801082dd:	e8 58 82 ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
801082e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082e9:	e9 a9 00 00 00       	jmp    80108397 <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801082ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801082f4:	01 d0                	add    %edx,%eax
801082f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801082fd:	00 
801082fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80108302:	8b 45 08             	mov    0x8(%ebp),%eax
80108305:	89 04 24             	mov    %eax,(%esp)
80108308:	e8 99 fb ff ff       	call   80107ea6 <walkpgdir>
8010830d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108310:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108314:	75 0c                	jne    80108322 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108316:	c7 04 24 63 8e 10 80 	movl   $0x80108e63,(%esp)
8010831d:	e8 18 82 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108322:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108325:	8b 00                	mov    (%eax),%eax
80108327:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010832c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010832f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108332:	8b 55 18             	mov    0x18(%ebp),%edx
80108335:	29 c2                	sub    %eax,%edx
80108337:	89 d0                	mov    %edx,%eax
80108339:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010833e:	77 0f                	ja     8010834f <loaduvm+0x8c>
      n = sz - i;
80108340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108343:	8b 55 18             	mov    0x18(%ebp),%edx
80108346:	29 c2                	sub    %eax,%edx
80108348:	89 d0                	mov    %edx,%eax
8010834a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010834d:	eb 07                	jmp    80108356 <loaduvm+0x93>
    else
      n = PGSIZE;
8010834f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108359:	8b 55 14             	mov    0x14(%ebp),%edx
8010835c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010835f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108362:	89 04 24             	mov    %eax,(%esp)
80108365:	e8 b9 f6 ff ff       	call   80107a23 <p2v>
8010836a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010836d:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108371:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108375:	89 44 24 04          	mov    %eax,0x4(%esp)
80108379:	8b 45 10             	mov    0x10(%ebp),%eax
8010837c:	89 04 24             	mov    %eax,(%esp)
8010837f:	e8 f5 99 ff ff       	call   80101d79 <readi>
80108384:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108387:	74 07                	je     80108390 <loaduvm+0xcd>
      return -1;
80108389:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010838e:	eb 18                	jmp    801083a8 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108390:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010839a:	3b 45 18             	cmp    0x18(%ebp),%eax
8010839d:	0f 82 4b ff ff ff    	jb     801082ee <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801083a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801083a8:	83 c4 24             	add    $0x24,%esp
801083ab:	5b                   	pop    %ebx
801083ac:	5d                   	pop    %ebp
801083ad:	c3                   	ret    

801083ae <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801083ae:	55                   	push   %ebp
801083af:	89 e5                	mov    %esp,%ebp
801083b1:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801083b4:	8b 45 10             	mov    0x10(%ebp),%eax
801083b7:	85 c0                	test   %eax,%eax
801083b9:	79 0a                	jns    801083c5 <allocuvm+0x17>
    return 0;
801083bb:	b8 00 00 00 00       	mov    $0x0,%eax
801083c0:	e9 c1 00 00 00       	jmp    80108486 <allocuvm+0xd8>
  if(newsz < oldsz)
801083c5:	8b 45 10             	mov    0x10(%ebp),%eax
801083c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083cb:	73 08                	jae    801083d5 <allocuvm+0x27>
    return oldsz;
801083cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801083d0:	e9 b1 00 00 00       	jmp    80108486 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
801083d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801083d8:	05 ff 0f 00 00       	add    $0xfff,%eax
801083dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801083e5:	e9 8d 00 00 00       	jmp    80108477 <allocuvm+0xc9>
    mem = kalloc();
801083ea:	e8 06 a7 ff ff       	call   80102af5 <kalloc>
801083ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801083f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801083f6:	75 2c                	jne    80108424 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801083f8:	c7 04 24 81 8e 10 80 	movl   $0x80108e81,(%esp)
801083ff:	e8 9c 7f ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108404:	8b 45 0c             	mov    0xc(%ebp),%eax
80108407:	89 44 24 08          	mov    %eax,0x8(%esp)
8010840b:	8b 45 10             	mov    0x10(%ebp),%eax
8010840e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108412:	8b 45 08             	mov    0x8(%ebp),%eax
80108415:	89 04 24             	mov    %eax,(%esp)
80108418:	e8 6b 00 00 00       	call   80108488 <deallocuvm>
      return 0;
8010841d:	b8 00 00 00 00       	mov    $0x0,%eax
80108422:	eb 62                	jmp    80108486 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108424:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010842b:	00 
8010842c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108433:	00 
80108434:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108437:	89 04 24             	mov    %eax,(%esp)
8010843a:	e8 53 cf ff ff       	call   80105392 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010843f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108442:	89 04 24             	mov    %eax,(%esp)
80108445:	e8 cc f5 ff ff       	call   80107a16 <v2p>
8010844a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010844d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108454:	00 
80108455:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108459:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108460:	00 
80108461:	89 54 24 04          	mov    %edx,0x4(%esp)
80108465:	8b 45 08             	mov    0x8(%ebp),%eax
80108468:	89 04 24             	mov    %eax,(%esp)
8010846b:	e8 d8 fa ff ff       	call   80107f48 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108470:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108477:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010847a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010847d:	0f 82 67 ff ff ff    	jb     801083ea <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108483:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108486:	c9                   	leave  
80108487:	c3                   	ret    

80108488 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108488:	55                   	push   %ebp
80108489:	89 e5                	mov    %esp,%ebp
8010848b:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010848e:	8b 45 10             	mov    0x10(%ebp),%eax
80108491:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108494:	72 08                	jb     8010849e <deallocuvm+0x16>
    return oldsz;
80108496:	8b 45 0c             	mov    0xc(%ebp),%eax
80108499:	e9 a4 00 00 00       	jmp    80108542 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
8010849e:	8b 45 10             	mov    0x10(%ebp),%eax
801084a1:	05 ff 0f 00 00       	add    $0xfff,%eax
801084a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801084ae:	e9 80 00 00 00       	jmp    80108533 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
801084b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801084bd:	00 
801084be:	89 44 24 04          	mov    %eax,0x4(%esp)
801084c2:	8b 45 08             	mov    0x8(%ebp),%eax
801084c5:	89 04 24             	mov    %eax,(%esp)
801084c8:	e8 d9 f9 ff ff       	call   80107ea6 <walkpgdir>
801084cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801084d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084d4:	75 09                	jne    801084df <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
801084d6:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801084dd:	eb 4d                	jmp    8010852c <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
801084df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084e2:	8b 00                	mov    (%eax),%eax
801084e4:	83 e0 01             	and    $0x1,%eax
801084e7:	85 c0                	test   %eax,%eax
801084e9:	74 41                	je     8010852c <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801084eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084ee:	8b 00                	mov    (%eax),%eax
801084f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801084f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084fc:	75 0c                	jne    8010850a <deallocuvm+0x82>
        panic("kfree");
801084fe:	c7 04 24 99 8e 10 80 	movl   $0x80108e99,(%esp)
80108505:	e8 30 80 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
8010850a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010850d:	89 04 24             	mov    %eax,(%esp)
80108510:	e8 0e f5 ff ff       	call   80107a23 <p2v>
80108515:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108518:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010851b:	89 04 24             	mov    %eax,(%esp)
8010851e:	e8 39 a5 ff ff       	call   80102a5c <kfree>
      *pte = 0;
80108523:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010852c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108533:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108536:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108539:	0f 82 74 ff ff ff    	jb     801084b3 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010853f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108542:	c9                   	leave  
80108543:	c3                   	ret    

80108544 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108544:	55                   	push   %ebp
80108545:	89 e5                	mov    %esp,%ebp
80108547:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
8010854a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010854e:	75 0c                	jne    8010855c <freevm+0x18>
    panic("freevm: no pgdir");
80108550:	c7 04 24 9f 8e 10 80 	movl   $0x80108e9f,(%esp)
80108557:	e8 de 7f ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010855c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108563:	00 
80108564:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010856b:	80 
8010856c:	8b 45 08             	mov    0x8(%ebp),%eax
8010856f:	89 04 24             	mov    %eax,(%esp)
80108572:	e8 11 ff ff ff       	call   80108488 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108577:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010857e:	eb 48                	jmp    801085c8 <freevm+0x84>
    if(pgdir[i] & PTE_P){
80108580:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108583:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010858a:	8b 45 08             	mov    0x8(%ebp),%eax
8010858d:	01 d0                	add    %edx,%eax
8010858f:	8b 00                	mov    (%eax),%eax
80108591:	83 e0 01             	and    $0x1,%eax
80108594:	85 c0                	test   %eax,%eax
80108596:	74 2c                	je     801085c4 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010859b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085a2:	8b 45 08             	mov    0x8(%ebp),%eax
801085a5:	01 d0                	add    %edx,%eax
801085a7:	8b 00                	mov    (%eax),%eax
801085a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085ae:	89 04 24             	mov    %eax,(%esp)
801085b1:	e8 6d f4 ff ff       	call   80107a23 <p2v>
801085b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801085b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085bc:	89 04 24             	mov    %eax,(%esp)
801085bf:	e8 98 a4 ff ff       	call   80102a5c <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801085c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801085c8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801085cf:	76 af                	jbe    80108580 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801085d1:	8b 45 08             	mov    0x8(%ebp),%eax
801085d4:	89 04 24             	mov    %eax,(%esp)
801085d7:	e8 80 a4 ff ff       	call   80102a5c <kfree>
}
801085dc:	c9                   	leave  
801085dd:	c3                   	ret    

801085de <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801085de:	55                   	push   %ebp
801085df:	89 e5                	mov    %esp,%ebp
801085e1:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801085e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801085eb:	00 
801085ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801085ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801085f3:	8b 45 08             	mov    0x8(%ebp),%eax
801085f6:	89 04 24             	mov    %eax,(%esp)
801085f9:	e8 a8 f8 ff ff       	call   80107ea6 <walkpgdir>
801085fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108605:	75 0c                	jne    80108613 <clearpteu+0x35>
    panic("clearpteu");
80108607:	c7 04 24 b0 8e 10 80 	movl   $0x80108eb0,(%esp)
8010860e:	e8 27 7f ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80108613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108616:	8b 00                	mov    (%eax),%eax
80108618:	83 e0 fb             	and    $0xfffffffb,%eax
8010861b:	89 c2                	mov    %eax,%edx
8010861d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108620:	89 10                	mov    %edx,(%eax)
}
80108622:	c9                   	leave  
80108623:	c3                   	ret    

80108624 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108624:	55                   	push   %ebp
80108625:	89 e5                	mov    %esp,%ebp
80108627:	53                   	push   %ebx
80108628:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010862b:	e8 b0 f9 ff ff       	call   80107fe0 <setupkvm>
80108630:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108633:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108637:	75 0a                	jne    80108643 <copyuvm+0x1f>
    return 0;
80108639:	b8 00 00 00 00       	mov    $0x0,%eax
8010863e:	e9 fd 00 00 00       	jmp    80108740 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108643:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010864a:	e9 d0 00 00 00       	jmp    8010871f <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010864f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108652:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108659:	00 
8010865a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010865e:	8b 45 08             	mov    0x8(%ebp),%eax
80108661:	89 04 24             	mov    %eax,(%esp)
80108664:	e8 3d f8 ff ff       	call   80107ea6 <walkpgdir>
80108669:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010866c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108670:	75 0c                	jne    8010867e <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108672:	c7 04 24 ba 8e 10 80 	movl   $0x80108eba,(%esp)
80108679:	e8 bc 7e ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
8010867e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108681:	8b 00                	mov    (%eax),%eax
80108683:	83 e0 01             	and    $0x1,%eax
80108686:	85 c0                	test   %eax,%eax
80108688:	75 0c                	jne    80108696 <copyuvm+0x72>
      panic("copyuvm: page not present");
8010868a:	c7 04 24 d4 8e 10 80 	movl   $0x80108ed4,(%esp)
80108691:	e8 a4 7e ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108696:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108699:	8b 00                	mov    (%eax),%eax
8010869b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801086a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086a6:	8b 00                	mov    (%eax),%eax
801086a8:	25 ff 0f 00 00       	and    $0xfff,%eax
801086ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801086b0:	e8 40 a4 ff ff       	call   80102af5 <kalloc>
801086b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801086b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801086bc:	75 02                	jne    801086c0 <copyuvm+0x9c>
      goto bad;
801086be:	eb 70                	jmp    80108730 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
801086c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801086c3:	89 04 24             	mov    %eax,(%esp)
801086c6:	e8 58 f3 ff ff       	call   80107a23 <p2v>
801086cb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801086d2:	00 
801086d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801086d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801086da:	89 04 24             	mov    %eax,(%esp)
801086dd:	e8 7f cd ff ff       	call   80105461 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801086e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801086e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801086e8:	89 04 24             	mov    %eax,(%esp)
801086eb:	e8 26 f3 ff ff       	call   80107a16 <v2p>
801086f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801086f3:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801086f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
801086fb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108702:	00 
80108703:	89 54 24 04          	mov    %edx,0x4(%esp)
80108707:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010870a:	89 04 24             	mov    %eax,(%esp)
8010870d:	e8 36 f8 ff ff       	call   80107f48 <mappages>
80108712:	85 c0                	test   %eax,%eax
80108714:	79 02                	jns    80108718 <copyuvm+0xf4>
      goto bad;
80108716:	eb 18                	jmp    80108730 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108718:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010871f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108722:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108725:	0f 82 24 ff ff ff    	jb     8010864f <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
8010872b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010872e:	eb 10                	jmp    80108740 <copyuvm+0x11c>

bad:
  freevm(d);
80108730:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108733:	89 04 24             	mov    %eax,(%esp)
80108736:	e8 09 fe ff ff       	call   80108544 <freevm>
  return 0;
8010873b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108740:	83 c4 44             	add    $0x44,%esp
80108743:	5b                   	pop    %ebx
80108744:	5d                   	pop    %ebp
80108745:	c3                   	ret    

80108746 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108746:	55                   	push   %ebp
80108747:	89 e5                	mov    %esp,%ebp
80108749:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010874c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108753:	00 
80108754:	8b 45 0c             	mov    0xc(%ebp),%eax
80108757:	89 44 24 04          	mov    %eax,0x4(%esp)
8010875b:	8b 45 08             	mov    0x8(%ebp),%eax
8010875e:	89 04 24             	mov    %eax,(%esp)
80108761:	e8 40 f7 ff ff       	call   80107ea6 <walkpgdir>
80108766:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010876c:	8b 00                	mov    (%eax),%eax
8010876e:	83 e0 01             	and    $0x1,%eax
80108771:	85 c0                	test   %eax,%eax
80108773:	75 07                	jne    8010877c <uva2ka+0x36>
    return 0;
80108775:	b8 00 00 00 00       	mov    $0x0,%eax
8010877a:	eb 25                	jmp    801087a1 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010877c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010877f:	8b 00                	mov    (%eax),%eax
80108781:	83 e0 04             	and    $0x4,%eax
80108784:	85 c0                	test   %eax,%eax
80108786:	75 07                	jne    8010878f <uva2ka+0x49>
    return 0;
80108788:	b8 00 00 00 00       	mov    $0x0,%eax
8010878d:	eb 12                	jmp    801087a1 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010878f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108792:	8b 00                	mov    (%eax),%eax
80108794:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108799:	89 04 24             	mov    %eax,(%esp)
8010879c:	e8 82 f2 ff ff       	call   80107a23 <p2v>
}
801087a1:	c9                   	leave  
801087a2:	c3                   	ret    

801087a3 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801087a3:	55                   	push   %ebp
801087a4:	89 e5                	mov    %esp,%ebp
801087a6:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801087a9:	8b 45 10             	mov    0x10(%ebp),%eax
801087ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801087af:	e9 87 00 00 00       	jmp    8010883b <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
801087b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801087b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801087bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801087bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801087c6:	8b 45 08             	mov    0x8(%ebp),%eax
801087c9:	89 04 24             	mov    %eax,(%esp)
801087cc:	e8 75 ff ff ff       	call   80108746 <uva2ka>
801087d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801087d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801087d8:	75 07                	jne    801087e1 <copyout+0x3e>
      return -1;
801087da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087df:	eb 69                	jmp    8010884a <copyout+0xa7>
    n = PGSIZE - (va - va0);
801087e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801087e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801087e7:	29 c2                	sub    %eax,%edx
801087e9:	89 d0                	mov    %edx,%eax
801087eb:	05 00 10 00 00       	add    $0x1000,%eax
801087f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801087f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087f6:	3b 45 14             	cmp    0x14(%ebp),%eax
801087f9:	76 06                	jbe    80108801 <copyout+0x5e>
      n = len;
801087fb:	8b 45 14             	mov    0x14(%ebp),%eax
801087fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108801:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108804:	8b 55 0c             	mov    0xc(%ebp),%edx
80108807:	29 c2                	sub    %eax,%edx
80108809:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010880c:	01 c2                	add    %eax,%edx
8010880e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108811:	89 44 24 08          	mov    %eax,0x8(%esp)
80108815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108818:	89 44 24 04          	mov    %eax,0x4(%esp)
8010881c:	89 14 24             	mov    %edx,(%esp)
8010881f:	e8 3d cc ff ff       	call   80105461 <memmove>
    len -= n;
80108824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108827:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010882a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010882d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108830:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108833:	05 00 10 00 00       	add    $0x1000,%eax
80108838:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010883b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010883f:	0f 85 6f ff ff ff    	jne    801087b4 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108845:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010884a:	c9                   	leave  
8010884b:	c3                   	ret    
