
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 76 08 00 	movl   $0x876,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 87 04 00 00       	call   4aa <printf>
    exit();
  23:	e8 ea 02 00 00       	call   312 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 f1 01 00 00       	call   23d <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 ee 02 00 00       	call   342 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  60:	7c d0                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  62:	e8 ab 02 00 00       	call   312 <exit>

00000067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	57                   	push   %edi
  6b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6f:	8b 55 10             	mov    0x10(%ebp),%edx
  72:	8b 45 0c             	mov    0xc(%ebp),%eax
  75:	89 cb                	mov    %ecx,%ebx
  77:	89 df                	mov    %ebx,%edi
  79:	89 d1                	mov    %edx,%ecx
  7b:	fc                   	cld    
  7c:	f3 aa                	rep stos %al,%es:(%edi)
  7e:	89 ca                	mov    %ecx,%edx
  80:	89 fb                	mov    %edi,%ebx
  82:	89 5d 08             	mov    %ebx,0x8(%ebp)
  85:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  88:	5b                   	pop    %ebx
  89:	5f                   	pop    %edi
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  92:	8b 45 08             	mov    0x8(%ebp),%eax
  95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  98:	90                   	nop
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	8d 50 01             	lea    0x1(%eax),%edx
  9f:	89 55 08             	mov    %edx,0x8(%ebp)
  a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ab:	0f b6 12             	movzbl (%edx),%edx
  ae:	88 10                	mov    %dl,(%eax)
  b0:	0f b6 00             	movzbl (%eax),%eax
  b3:	84 c0                	test   %al,%al
  b5:	75 e2                	jne    99 <strcpy+0xd>
    ;
  return os;
  b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ba:	c9                   	leave  
  bb:	c3                   	ret    

000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  bf:	eb 08                	jmp    c9 <strcmp+0xd>
    p++, q++;
  c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	0f b6 00             	movzbl (%eax),%eax
  cf:	84 c0                	test   %al,%al
  d1:	74 10                	je     e3 <strcmp+0x27>
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	0f b6 10             	movzbl (%eax),%edx
  d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	38 c2                	cmp    %al,%dl
  e1:	74 de                	je     c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 00             	movzbl (%eax),%eax
  e9:	0f b6 d0             	movzbl %al,%edx
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 c0             	movzbl %al,%eax
  f5:	29 c2                	sub    %eax,%edx
  f7:	89 d0                	mov    %edx,%eax
}
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    

000000fb <strlen>:

uint
strlen(char *s)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 108:	eb 04                	jmp    10e <strlen+0x13>
 10a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	01 d0                	add    %edx,%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	84 c0                	test   %al,%al
 11b:	75 ed                	jne    10a <strlen+0xf>
    ;
  return n;
 11d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <memset>:

void*
memset(void *dst, int c, uint n)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 128:	8b 45 10             	mov    0x10(%ebp),%eax
 12b:	89 44 24 08          	mov    %eax,0x8(%esp)
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	89 44 24 04          	mov    %eax,0x4(%esp)
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	89 04 24             	mov    %eax,(%esp)
 13c:	e8 26 ff ff ff       	call   67 <stosb>
  return dst;
 141:	8b 45 08             	mov    0x8(%ebp),%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <strchr>:

char*
strchr(const char *s, char c)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 152:	eb 14                	jmp    168 <strchr+0x22>
    if(*s == c)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15d:	75 05                	jne    164 <strchr+0x1e>
      return (char*)s;
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	eb 13                	jmp    177 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	84 c0                	test   %al,%al
 170:	75 e2                	jne    154 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 172:	b8 00 00 00 00       	mov    $0x0,%eax
}
 177:	c9                   	leave  
 178:	c3                   	ret    

00000179 <gets>:

char*
gets(char *buf, int max)
{
 179:	55                   	push   %ebp
 17a:	89 e5                	mov    %esp,%ebp
 17c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 186:	eb 4c                	jmp    1d4 <gets+0x5b>
    cc = read(0, &c, 1);
 188:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 18f:	00 
 190:	8d 45 ef             	lea    -0x11(%ebp),%eax
 193:	89 44 24 04          	mov    %eax,0x4(%esp)
 197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 19e:	e8 87 01 00 00       	call   32a <read>
 1a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1aa:	7f 02                	jg     1ae <gets+0x35>
      break;
 1ac:	eb 31                	jmp    1df <gets+0x66>
    buf[i++] = c;
 1ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b1:	8d 50 01             	lea    0x1(%eax),%edx
 1b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b7:	89 c2                	mov    %eax,%edx
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	01 c2                	add    %eax,%edx
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0a                	cmp    $0xa,%al
 1ca:	74 13                	je     1df <gets+0x66>
 1cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d0:	3c 0d                	cmp    $0xd,%al
 1d2:	74 0b                	je     1df <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d7:	83 c0 01             	add    $0x1,%eax
 1da:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1dd:	7c a9                	jl     188 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1df:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	01 d0                	add    %edx,%eax
 1e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <stat>:

int
stat(char *n, struct stat *st)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fc:	00 
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	89 04 24             	mov    %eax,(%esp)
 203:	e8 4a 01 00 00       	call   352 <open>
 208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20f:	79 07                	jns    218 <stat+0x29>
    return -1;
 211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 216:	eb 23                	jmp    23b <stat+0x4c>
  r = fstat(fd, st);
 218:	8b 45 0c             	mov    0xc(%ebp),%eax
 21b:	89 44 24 04          	mov    %eax,0x4(%esp)
 21f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 222:	89 04 24             	mov    %eax,(%esp)
 225:	e8 40 01 00 00       	call   36a <fstat>
 22a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 230:	89 04 24             	mov    %eax,(%esp)
 233:	e8 02 01 00 00       	call   33a <close>
  return r;
 238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <atoi>:

int
atoi(const char *s)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24a:	eb 25                	jmp    271 <atoi+0x34>
    n = n*10 + *s++ - '0';
 24c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24f:	89 d0                	mov    %edx,%eax
 251:	c1 e0 02             	shl    $0x2,%eax
 254:	01 d0                	add    %edx,%eax
 256:	01 c0                	add    %eax,%eax
 258:	89 c1                	mov    %eax,%ecx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 08             	mov    %edx,0x8(%ebp)
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	0f be c0             	movsbl %al,%eax
 269:	01 c8                	add    %ecx,%eax
 26b:	83 e8 30             	sub    $0x30,%eax
 26e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	3c 2f                	cmp    $0x2f,%al
 279:	7e 0a                	jle    285 <atoi+0x48>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	0f b6 00             	movzbl (%eax),%eax
 281:	3c 39                	cmp    $0x39,%al
 283:	7e c7                	jle    24c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 296:	8b 45 0c             	mov    0xc(%ebp),%eax
 299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29c:	eb 17                	jmp    2b5 <memmove+0x2b>
    *dst++ = *src++;
 29e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a1:	8d 50 01             	lea    0x1(%eax),%edx
 2a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2aa:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b0:	0f b6 12             	movzbl (%edx),%edx
 2b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b5:	8b 45 10             	mov    0x10(%ebp),%eax
 2b8:	8d 50 ff             	lea    -0x1(%eax),%edx
 2bb:	89 55 10             	mov    %edx,0x10(%ebp)
 2be:	85 c0                	test   %eax,%eax
 2c0:	7f dc                	jg     29e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 2cd:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 2d4:	e8 bd 04 00 00       	call   796 <malloc>
 2d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 2dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2df:	05 fc ff 0f 00       	add    $0xffffc,%eax
 2e4:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 2e7:	ba ba 03 00 00       	mov    $0x3ba,%edx
 2ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2ef:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	05 fc ff 0f 00       	add    $0xffffc,%eax
 2f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	89 04 24             	mov    %eax,(%esp)
 303:	e8 aa 00 00 00       	call   3b2 <clone>
}
 308:	c9                   	leave  
 309:	c3                   	ret    

0000030a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 30a:	b8 01 00 00 00       	mov    $0x1,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <exit>:
SYSCALL(exit)
 312:	b8 02 00 00 00       	mov    $0x2,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <wait>:
SYSCALL(wait)
 31a:	b8 03 00 00 00       	mov    $0x3,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <pipe>:
SYSCALL(pipe)
 322:	b8 04 00 00 00       	mov    $0x4,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <read>:
SYSCALL(read)
 32a:	b8 05 00 00 00       	mov    $0x5,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <write>:
SYSCALL(write)
 332:	b8 10 00 00 00       	mov    $0x10,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <close>:
SYSCALL(close)
 33a:	b8 15 00 00 00       	mov    $0x15,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <kill>:
SYSCALL(kill)
 342:	b8 06 00 00 00       	mov    $0x6,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <exec>:
SYSCALL(exec)
 34a:	b8 07 00 00 00       	mov    $0x7,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <open>:
SYSCALL(open)
 352:	b8 0f 00 00 00       	mov    $0xf,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <mknod>:
SYSCALL(mknod)
 35a:	b8 11 00 00 00       	mov    $0x11,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <unlink>:
SYSCALL(unlink)
 362:	b8 12 00 00 00       	mov    $0x12,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <fstat>:
SYSCALL(fstat)
 36a:	b8 08 00 00 00       	mov    $0x8,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <link>:
SYSCALL(link)
 372:	b8 13 00 00 00       	mov    $0x13,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <mkdir>:
SYSCALL(mkdir)
 37a:	b8 14 00 00 00       	mov    $0x14,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <chdir>:
SYSCALL(chdir)
 382:	b8 09 00 00 00       	mov    $0x9,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <dup>:
SYSCALL(dup)
 38a:	b8 0a 00 00 00       	mov    $0xa,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <getpid>:
SYSCALL(getpid)
 392:	b8 0b 00 00 00       	mov    $0xb,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <sbrk>:
SYSCALL(sbrk)
 39a:	b8 0c 00 00 00       	mov    $0xc,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <sleep>:
SYSCALL(sleep)
 3a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <uptime>:
SYSCALL(uptime)
 3aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <clone>:
SYSCALL(clone)
 3b2:	b8 16 00 00 00       	mov    $0x16,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <thread_exit>:
SYSCALL(thread_exit)
 3ba:	b8 17 00 00 00       	mov    $0x17,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <thread_join>:
SYSCALL(thread_join)
 3c2:	b8 18 00 00 00       	mov    $0x18,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ca:	55                   	push   %ebp
 3cb:	89 e5                	mov    %esp,%ebp
 3cd:	83 ec 18             	sub    $0x18,%esp
 3d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3d6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3dd:	00 
 3de:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	89 04 24             	mov    %eax,(%esp)
 3eb:	e8 42 ff ff ff       	call   332 <write>
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	56                   	push   %esi
 3f6:	53                   	push   %ebx
 3f7:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 401:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 405:	74 17                	je     41e <printint+0x2c>
 407:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 40b:	79 11                	jns    41e <printint+0x2c>
    neg = 1;
 40d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 414:	8b 45 0c             	mov    0xc(%ebp),%eax
 417:	f7 d8                	neg    %eax
 419:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41c:	eb 06                	jmp    424 <printint+0x32>
  } else {
    x = xx;
 41e:	8b 45 0c             	mov    0xc(%ebp),%eax
 421:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 424:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 42b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 42e:	8d 41 01             	lea    0x1(%ecx),%eax
 431:	89 45 f4             	mov    %eax,-0xc(%ebp)
 434:	8b 5d 10             	mov    0x10(%ebp),%ebx
 437:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43a:	ba 00 00 00 00       	mov    $0x0,%edx
 43f:	f7 f3                	div    %ebx
 441:	89 d0                	mov    %edx,%eax
 443:	0f b6 80 f8 0a 00 00 	movzbl 0xaf8(%eax),%eax
 44a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 44e:	8b 75 10             	mov    0x10(%ebp),%esi
 451:	8b 45 ec             	mov    -0x14(%ebp),%eax
 454:	ba 00 00 00 00       	mov    $0x0,%edx
 459:	f7 f6                	div    %esi
 45b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 462:	75 c7                	jne    42b <printint+0x39>
  if(neg)
 464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 468:	74 10                	je     47a <printint+0x88>
    buf[i++] = '-';
 46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46d:	8d 50 01             	lea    0x1(%eax),%edx
 470:	89 55 f4             	mov    %edx,-0xc(%ebp)
 473:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 478:	eb 1f                	jmp    499 <printint+0xa7>
 47a:	eb 1d                	jmp    499 <printint+0xa7>
    putc(fd, buf[i]);
 47c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 47f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 482:	01 d0                	add    %edx,%eax
 484:	0f b6 00             	movzbl (%eax),%eax
 487:	0f be c0             	movsbl %al,%eax
 48a:	89 44 24 04          	mov    %eax,0x4(%esp)
 48e:	8b 45 08             	mov    0x8(%ebp),%eax
 491:	89 04 24             	mov    %eax,(%esp)
 494:	e8 31 ff ff ff       	call   3ca <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 499:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 49d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a1:	79 d9                	jns    47c <printint+0x8a>
    putc(fd, buf[i]);
}
 4a3:	83 c4 30             	add    $0x30,%esp
 4a6:	5b                   	pop    %ebx
 4a7:	5e                   	pop    %esi
 4a8:	5d                   	pop    %ebp
 4a9:	c3                   	ret    

000004aa <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4aa:	55                   	push   %ebp
 4ab:	89 e5                	mov    %esp,%ebp
 4ad:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b7:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ba:	83 c0 04             	add    $0x4,%eax
 4bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c7:	e9 7c 01 00 00       	jmp    648 <printf+0x19e>
    c = fmt[i] & 0xff;
 4cc:	8b 55 0c             	mov    0xc(%ebp),%edx
 4cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d2:	01 d0                	add    %edx,%eax
 4d4:	0f b6 00             	movzbl (%eax),%eax
 4d7:	0f be c0             	movsbl %al,%eax
 4da:	25 ff 00 00 00       	and    $0xff,%eax
 4df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e6:	75 2c                	jne    514 <printf+0x6a>
      if(c == '%'){
 4e8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ec:	75 0c                	jne    4fa <printf+0x50>
        state = '%';
 4ee:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4f5:	e9 4a 01 00 00       	jmp    644 <printf+0x19a>
      } else {
        putc(fd, c);
 4fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4fd:	0f be c0             	movsbl %al,%eax
 500:	89 44 24 04          	mov    %eax,0x4(%esp)
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	89 04 24             	mov    %eax,(%esp)
 50a:	e8 bb fe ff ff       	call   3ca <putc>
 50f:	e9 30 01 00 00       	jmp    644 <printf+0x19a>
      }
    } else if(state == '%'){
 514:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 518:	0f 85 26 01 00 00    	jne    644 <printf+0x19a>
      if(c == 'd'){
 51e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 522:	75 2d                	jne    551 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 524:	8b 45 e8             	mov    -0x18(%ebp),%eax
 527:	8b 00                	mov    (%eax),%eax
 529:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 530:	00 
 531:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 538:	00 
 539:	89 44 24 04          	mov    %eax,0x4(%esp)
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	89 04 24             	mov    %eax,(%esp)
 543:	e8 aa fe ff ff       	call   3f2 <printint>
        ap++;
 548:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54c:	e9 ec 00 00 00       	jmp    63d <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 551:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 555:	74 06                	je     55d <printf+0xb3>
 557:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 55b:	75 2d                	jne    58a <printf+0xe0>
        printint(fd, *ap, 16, 0);
 55d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 560:	8b 00                	mov    (%eax),%eax
 562:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 569:	00 
 56a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 571:	00 
 572:	89 44 24 04          	mov    %eax,0x4(%esp)
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	89 04 24             	mov    %eax,(%esp)
 57c:	e8 71 fe ff ff       	call   3f2 <printint>
        ap++;
 581:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 585:	e9 b3 00 00 00       	jmp    63d <printf+0x193>
      } else if(c == 's'){
 58a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 58e:	75 45                	jne    5d5 <printf+0x12b>
        s = (char*)*ap;
 590:	8b 45 e8             	mov    -0x18(%ebp),%eax
 593:	8b 00                	mov    (%eax),%eax
 595:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 598:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 59c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a0:	75 09                	jne    5ab <printf+0x101>
          s = "(null)";
 5a2:	c7 45 f4 8a 08 00 00 	movl   $0x88a,-0xc(%ebp)
        while(*s != 0){
 5a9:	eb 1e                	jmp    5c9 <printf+0x11f>
 5ab:	eb 1c                	jmp    5c9 <printf+0x11f>
          putc(fd, *s);
 5ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b0:	0f b6 00             	movzbl (%eax),%eax
 5b3:	0f be c0             	movsbl %al,%eax
 5b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	89 04 24             	mov    %eax,(%esp)
 5c0:	e8 05 fe ff ff       	call   3ca <putc>
          s++;
 5c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cc:	0f b6 00             	movzbl (%eax),%eax
 5cf:	84 c0                	test   %al,%al
 5d1:	75 da                	jne    5ad <printf+0x103>
 5d3:	eb 68                	jmp    63d <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d9:	75 1d                	jne    5f8 <printf+0x14e>
        putc(fd, *ap);
 5db:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5de:	8b 00                	mov    (%eax),%eax
 5e0:	0f be c0             	movsbl %al,%eax
 5e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ea:	89 04 24             	mov    %eax,(%esp)
 5ed:	e8 d8 fd ff ff       	call   3ca <putc>
        ap++;
 5f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f6:	eb 45                	jmp    63d <printf+0x193>
      } else if(c == '%'){
 5f8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fc:	75 17                	jne    615 <printf+0x16b>
        putc(fd, c);
 5fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 601:	0f be c0             	movsbl %al,%eax
 604:	89 44 24 04          	mov    %eax,0x4(%esp)
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	89 04 24             	mov    %eax,(%esp)
 60e:	e8 b7 fd ff ff       	call   3ca <putc>
 613:	eb 28                	jmp    63d <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 615:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 61c:	00 
 61d:	8b 45 08             	mov    0x8(%ebp),%eax
 620:	89 04 24             	mov    %eax,(%esp)
 623:	e8 a2 fd ff ff       	call   3ca <putc>
        putc(fd, c);
 628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 62b:	0f be c0             	movsbl %al,%eax
 62e:	89 44 24 04          	mov    %eax,0x4(%esp)
 632:	8b 45 08             	mov    0x8(%ebp),%eax
 635:	89 04 24             	mov    %eax,(%esp)
 638:	e8 8d fd ff ff       	call   3ca <putc>
      }
      state = 0;
 63d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 644:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 648:	8b 55 0c             	mov    0xc(%ebp),%edx
 64b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64e:	01 d0                	add    %edx,%eax
 650:	0f b6 00             	movzbl (%eax),%eax
 653:	84 c0                	test   %al,%al
 655:	0f 85 71 fe ff ff    	jne    4cc <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 65b:	c9                   	leave  
 65c:	c3                   	ret    

0000065d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65d:	55                   	push   %ebp
 65e:	89 e5                	mov    %esp,%ebp
 660:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 663:	8b 45 08             	mov    0x8(%ebp),%eax
 666:	83 e8 08             	sub    $0x8,%eax
 669:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66c:	a1 14 0b 00 00       	mov    0xb14,%eax
 671:	89 45 fc             	mov    %eax,-0x4(%ebp)
 674:	eb 24                	jmp    69a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 00                	mov    (%eax),%eax
 67b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67e:	77 12                	ja     692 <free+0x35>
 680:	8b 45 f8             	mov    -0x8(%ebp),%eax
 683:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 686:	77 24                	ja     6ac <free+0x4f>
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 690:	77 1a                	ja     6ac <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a0:	76 d4                	jbe    676 <free+0x19>
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 00                	mov    (%eax),%eax
 6a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6aa:	76 ca                	jbe    676 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	8b 40 04             	mov    0x4(%eax),%eax
 6b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	01 c2                	add    %eax,%edx
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 00                	mov    (%eax),%eax
 6c3:	39 c2                	cmp    %eax,%edx
 6c5:	75 24                	jne    6eb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 50 04             	mov    0x4(%eax),%edx
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	8b 40 04             	mov    0x4(%eax),%eax
 6d5:	01 c2                	add    %eax,%edx
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	8b 10                	mov    (%eax),%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	89 10                	mov    %edx,(%eax)
 6e9:	eb 0a                	jmp    6f5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 10                	mov    (%eax),%edx
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 40 04             	mov    0x4(%eax),%eax
 6fb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	01 d0                	add    %edx,%eax
 707:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70a:	75 20                	jne    72c <free+0xcf>
    p->s.size += bp->s.size;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 50 04             	mov    0x4(%eax),%edx
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	8b 40 04             	mov    0x4(%eax),%eax
 718:	01 c2                	add    %eax,%edx
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 720:	8b 45 f8             	mov    -0x8(%ebp),%eax
 723:	8b 10                	mov    (%eax),%edx
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	89 10                	mov    %edx,(%eax)
 72a:	eb 08                	jmp    734 <free+0xd7>
  } else
    p->s.ptr = bp;
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 732:	89 10                	mov    %edx,(%eax)
  freep = p;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	a3 14 0b 00 00       	mov    %eax,0xb14
}
 73c:	c9                   	leave  
 73d:	c3                   	ret    

0000073e <morecore>:

static Header*
morecore(uint nu)
{
 73e:	55                   	push   %ebp
 73f:	89 e5                	mov    %esp,%ebp
 741:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 744:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 74b:	77 07                	ja     754 <morecore+0x16>
    nu = 4096;
 74d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	c1 e0 03             	shl    $0x3,%eax
 75a:	89 04 24             	mov    %eax,(%esp)
 75d:	e8 38 fc ff ff       	call   39a <sbrk>
 762:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 765:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 769:	75 07                	jne    772 <morecore+0x34>
    return 0;
 76b:	b8 00 00 00 00       	mov    $0x0,%eax
 770:	eb 22                	jmp    794 <morecore+0x56>
  hp = (Header*)p;
 772:	8b 45 f4             	mov    -0xc(%ebp),%eax
 775:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	8b 55 08             	mov    0x8(%ebp),%edx
 77e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 781:	8b 45 f0             	mov    -0x10(%ebp),%eax
 784:	83 c0 08             	add    $0x8,%eax
 787:	89 04 24             	mov    %eax,(%esp)
 78a:	e8 ce fe ff ff       	call   65d <free>
  return freep;
 78f:	a1 14 0b 00 00       	mov    0xb14,%eax
}
 794:	c9                   	leave  
 795:	c3                   	ret    

00000796 <malloc>:

void*
malloc(uint nbytes)
{
 796:	55                   	push   %ebp
 797:	89 e5                	mov    %esp,%ebp
 799:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79c:	8b 45 08             	mov    0x8(%ebp),%eax
 79f:	83 c0 07             	add    $0x7,%eax
 7a2:	c1 e8 03             	shr    $0x3,%eax
 7a5:	83 c0 01             	add    $0x1,%eax
 7a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ab:	a1 14 0b 00 00       	mov    0xb14,%eax
 7b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b7:	75 23                	jne    7dc <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b9:	c7 45 f0 0c 0b 00 00 	movl   $0xb0c,-0x10(%ebp)
 7c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c3:	a3 14 0b 00 00       	mov    %eax,0xb14
 7c8:	a1 14 0b 00 00       	mov    0xb14,%eax
 7cd:	a3 0c 0b 00 00       	mov    %eax,0xb0c
    base.s.size = 0;
 7d2:	c7 05 10 0b 00 00 00 	movl   $0x0,0xb10
 7d9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	8b 00                	mov    (%eax),%eax
 7e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	8b 40 04             	mov    0x4(%eax),%eax
 7ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ed:	72 4d                	jb     83c <malloc+0xa6>
      if(p->s.size == nunits)
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	8b 40 04             	mov    0x4(%eax),%eax
 7f5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f8:	75 0c                	jne    806 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	8b 10                	mov    (%eax),%edx
 7ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 802:	89 10                	mov    %edx,(%eax)
 804:	eb 26                	jmp    82c <malloc+0x96>
      else {
        p->s.size -= nunits;
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	8b 40 04             	mov    0x4(%eax),%eax
 80c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 80f:	89 c2                	mov    %eax,%edx
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	c1 e0 03             	shl    $0x3,%eax
 820:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 55 ec             	mov    -0x14(%ebp),%edx
 829:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 82c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82f:	a3 14 0b 00 00       	mov    %eax,0xb14
      return (void*)(p + 1);
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	83 c0 08             	add    $0x8,%eax
 83a:	eb 38                	jmp    874 <malloc+0xde>
    }
    if(p == freep)
 83c:	a1 14 0b 00 00       	mov    0xb14,%eax
 841:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 844:	75 1b                	jne    861 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 846:	8b 45 ec             	mov    -0x14(%ebp),%eax
 849:	89 04 24             	mov    %eax,(%esp)
 84c:	e8 ed fe ff ff       	call   73e <morecore>
 851:	89 45 f4             	mov    %eax,-0xc(%ebp)
 854:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 858:	75 07                	jne    861 <malloc+0xcb>
        return 0;
 85a:	b8 00 00 00 00       	mov    $0x0,%eax
 85f:	eb 13                	jmp    874 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	89 45 f0             	mov    %eax,-0x10(%ebp)
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 00                	mov    (%eax),%eax
 86c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 86f:	e9 70 ff ff ff       	jmp    7e4 <malloc+0x4e>
}
 874:	c9                   	leave  
 875:	c3                   	ret    
