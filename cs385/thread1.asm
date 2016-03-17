
_thread1:     file format elf32-i386


Disassembly of section .text:

00000000 <f>:
#include"types.h"
#include"user.h"

void f(void) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  printf(1,"Hello world!\n");
   6:	c7 44 24 04 56 08 00 	movl   $0x856,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 70 04 00 00       	call   48a <printf>
  while(1);
  1a:	eb fe                	jmp    1a <f+0x1a>

0000001c <main>:
}

int main(int argc, char** argv) {
  1c:	55                   	push   %ebp
  1d:	89 e5                	mov    %esp,%ebp
  1f:	83 e4 f0             	and    $0xfffffff0,%esp
  22:	83 ec 10             	sub    $0x10,%esp
  thread_create(f);
  25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2c:	e8 76 02 00 00       	call   2a7 <thread_create>
  printf(1,"Hello from main!\n");
  31:	c7 44 24 04 64 08 00 	movl   $0x864,0x4(%esp)
  38:	00 
  39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  40:	e8 45 04 00 00       	call   48a <printf>
  while(1);
  45:	eb fe                	jmp    45 <main+0x29>

00000047 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  47:	55                   	push   %ebp
  48:	89 e5                	mov    %esp,%ebp
  4a:	57                   	push   %edi
  4b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  4f:	8b 55 10             	mov    0x10(%ebp),%edx
  52:	8b 45 0c             	mov    0xc(%ebp),%eax
  55:	89 cb                	mov    %ecx,%ebx
  57:	89 df                	mov    %ebx,%edi
  59:	89 d1                	mov    %edx,%ecx
  5b:	fc                   	cld    
  5c:	f3 aa                	rep stos %al,%es:(%edi)
  5e:	89 ca                	mov    %ecx,%edx
  60:	89 fb                	mov    %edi,%ebx
  62:	89 5d 08             	mov    %ebx,0x8(%ebp)
  65:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  68:	5b                   	pop    %ebx
  69:	5f                   	pop    %edi
  6a:	5d                   	pop    %ebp
  6b:	c3                   	ret    

0000006c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  72:	8b 45 08             	mov    0x8(%ebp),%eax
  75:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  78:	90                   	nop
  79:	8b 45 08             	mov    0x8(%ebp),%eax
  7c:	8d 50 01             	lea    0x1(%eax),%edx
  7f:	89 55 08             	mov    %edx,0x8(%ebp)
  82:	8b 55 0c             	mov    0xc(%ebp),%edx
  85:	8d 4a 01             	lea    0x1(%edx),%ecx
  88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8b:	0f b6 12             	movzbl (%edx),%edx
  8e:	88 10                	mov    %dl,(%eax)
  90:	0f b6 00             	movzbl (%eax),%eax
  93:	84 c0                	test   %al,%al
  95:	75 e2                	jne    79 <strcpy+0xd>
    ;
  return os;
  97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  9a:	c9                   	leave  
  9b:	c3                   	ret    

0000009c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9c:	55                   	push   %ebp
  9d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  9f:	eb 08                	jmp    a9 <strcmp+0xd>
    p++, q++;
  a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	84 c0                	test   %al,%al
  b1:	74 10                	je     c3 <strcmp+0x27>
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	0f b6 10             	movzbl (%eax),%edx
  b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	38 c2                	cmp    %al,%dl
  c1:	74 de                	je     a1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  c3:	8b 45 08             	mov    0x8(%ebp),%eax
  c6:	0f b6 00             	movzbl (%eax),%eax
  c9:	0f b6 d0             	movzbl %al,%edx
  cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  cf:	0f b6 00             	movzbl (%eax),%eax
  d2:	0f b6 c0             	movzbl %al,%eax
  d5:	29 c2                	sub    %eax,%edx
  d7:	89 d0                	mov    %edx,%eax
}
  d9:	5d                   	pop    %ebp
  da:	c3                   	ret    

000000db <strlen>:

uint
strlen(char *s)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e8:	eb 04                	jmp    ee <strlen+0x13>
  ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	01 d0                	add    %edx,%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	84 c0                	test   %al,%al
  fb:	75 ed                	jne    ea <strlen+0xf>
    ;
  return n;
  fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <memset>:

void*
memset(void *dst, int c, uint n)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 108:	8b 45 10             	mov    0x10(%ebp),%eax
 10b:	89 44 24 08          	mov    %eax,0x8(%esp)
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	89 44 24 04          	mov    %eax,0x4(%esp)
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	89 04 24             	mov    %eax,(%esp)
 11c:	e8 26 ff ff ff       	call   47 <stosb>
  return dst;
 121:	8b 45 08             	mov    0x8(%ebp),%eax
}
 124:	c9                   	leave  
 125:	c3                   	ret    

00000126 <strchr>:

char*
strchr(const char *s, char c)
{
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
 129:	83 ec 04             	sub    $0x4,%esp
 12c:	8b 45 0c             	mov    0xc(%ebp),%eax
 12f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 132:	eb 14                	jmp    148 <strchr+0x22>
    if(*s == c)
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	0f b6 00             	movzbl (%eax),%eax
 13a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 13d:	75 05                	jne    144 <strchr+0x1e>
      return (char*)s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	eb 13                	jmp    157 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 144:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 152:	b8 00 00 00 00       	mov    $0x0,%eax
}
 157:	c9                   	leave  
 158:	c3                   	ret    

00000159 <gets>:

char*
gets(char *buf, int max)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
 15c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 166:	eb 4c                	jmp    1b4 <gets+0x5b>
    cc = read(0, &c, 1);
 168:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 16f:	00 
 170:	8d 45 ef             	lea    -0x11(%ebp),%eax
 173:	89 44 24 04          	mov    %eax,0x4(%esp)
 177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 17e:	e8 87 01 00 00       	call   30a <read>
 183:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 186:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 18a:	7f 02                	jg     18e <gets+0x35>
      break;
 18c:	eb 31                	jmp    1bf <gets+0x66>
    buf[i++] = c;
 18e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 191:	8d 50 01             	lea    0x1(%eax),%edx
 194:	89 55 f4             	mov    %edx,-0xc(%ebp)
 197:	89 c2                	mov    %eax,%edx
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	01 c2                	add    %eax,%edx
 19e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a8:	3c 0a                	cmp    $0xa,%al
 1aa:	74 13                	je     1bf <gets+0x66>
 1ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b0:	3c 0d                	cmp    $0xd,%al
 1b2:	74 0b                	je     1bf <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b7:	83 c0 01             	add    $0x1,%eax
 1ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1bd:	7c a9                	jl     168 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	01 d0                	add    %edx,%eax
 1c7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1cd:	c9                   	leave  
 1ce:	c3                   	ret    

000001cf <stat>:

int
stat(char *n, struct stat *st)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1dc:	00 
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	89 04 24             	mov    %eax,(%esp)
 1e3:	e8 4a 01 00 00       	call   332 <open>
 1e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ef:	79 07                	jns    1f8 <stat+0x29>
    return -1;
 1f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f6:	eb 23                	jmp    21b <stat+0x4c>
  r = fstat(fd, st);
 1f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 202:	89 04 24             	mov    %eax,(%esp)
 205:	e8 40 01 00 00       	call   34a <fstat>
 20a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 20d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 210:	89 04 24             	mov    %eax,(%esp)
 213:	e8 02 01 00 00       	call   31a <close>
  return r;
 218:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 21b:	c9                   	leave  
 21c:	c3                   	ret    

0000021d <atoi>:

int
atoi(const char *s)
{
 21d:	55                   	push   %ebp
 21e:	89 e5                	mov    %esp,%ebp
 220:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 22a:	eb 25                	jmp    251 <atoi+0x34>
    n = n*10 + *s++ - '0';
 22c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 22f:	89 d0                	mov    %edx,%eax
 231:	c1 e0 02             	shl    $0x2,%eax
 234:	01 d0                	add    %edx,%eax
 236:	01 c0                	add    %eax,%eax
 238:	89 c1                	mov    %eax,%ecx
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	8d 50 01             	lea    0x1(%eax),%edx
 240:	89 55 08             	mov    %edx,0x8(%ebp)
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	0f be c0             	movsbl %al,%eax
 249:	01 c8                	add    %ecx,%eax
 24b:	83 e8 30             	sub    $0x30,%eax
 24e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2f                	cmp    $0x2f,%al
 259:	7e 0a                	jle    265 <atoi+0x48>
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	0f b6 00             	movzbl (%eax),%eax
 261:	3c 39                	cmp    $0x39,%al
 263:	7e c7                	jle    22c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 265:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 268:	c9                   	leave  
 269:	c3                   	ret    

0000026a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
 26d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 276:	8b 45 0c             	mov    0xc(%ebp),%eax
 279:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 27c:	eb 17                	jmp    295 <memmove+0x2b>
    *dst++ = *src++;
 27e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 281:	8d 50 01             	lea    0x1(%eax),%edx
 284:	89 55 fc             	mov    %edx,-0x4(%ebp)
 287:	8b 55 f8             	mov    -0x8(%ebp),%edx
 28a:	8d 4a 01             	lea    0x1(%edx),%ecx
 28d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 290:	0f b6 12             	movzbl (%edx),%edx
 293:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 295:	8b 45 10             	mov    0x10(%ebp),%eax
 298:	8d 50 ff             	lea    -0x1(%eax),%edx
 29b:	89 55 10             	mov    %edx,0x10(%ebp)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7f dc                	jg     27e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a5:	c9                   	leave  
 2a6:	c3                   	ret    

000002a7 <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 2a7:	55                   	push   %ebp
 2a8:	89 e5                	mov    %esp,%ebp
 2aa:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 2ad:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 2b4:	e8 bd 04 00 00       	call   776 <malloc>
 2b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 2bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bf:	05 fc ff 0f 00       	add    $0xffffc,%eax
 2c4:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 2c7:	ba 9a 03 00 00       	mov    $0x39a,%edx
 2cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2cf:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 2d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d4:	05 fc ff 0f 00       	add    $0xffffc,%eax
 2d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	89 04 24             	mov    %eax,(%esp)
 2e3:	e8 aa 00 00 00       	call   392 <clone>
}
 2e8:	c9                   	leave  
 2e9:	c3                   	ret    

000002ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ea:	b8 01 00 00 00       	mov    $0x1,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <exit>:
SYSCALL(exit)
 2f2:	b8 02 00 00 00       	mov    $0x2,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <wait>:
SYSCALL(wait)
 2fa:	b8 03 00 00 00       	mov    $0x3,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <pipe>:
SYSCALL(pipe)
 302:	b8 04 00 00 00       	mov    $0x4,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <read>:
SYSCALL(read)
 30a:	b8 05 00 00 00       	mov    $0x5,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <write>:
SYSCALL(write)
 312:	b8 10 00 00 00       	mov    $0x10,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <close>:
SYSCALL(close)
 31a:	b8 15 00 00 00       	mov    $0x15,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <kill>:
SYSCALL(kill)
 322:	b8 06 00 00 00       	mov    $0x6,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <exec>:
SYSCALL(exec)
 32a:	b8 07 00 00 00       	mov    $0x7,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <open>:
SYSCALL(open)
 332:	b8 0f 00 00 00       	mov    $0xf,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <mknod>:
SYSCALL(mknod)
 33a:	b8 11 00 00 00       	mov    $0x11,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <unlink>:
SYSCALL(unlink)
 342:	b8 12 00 00 00       	mov    $0x12,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <fstat>:
SYSCALL(fstat)
 34a:	b8 08 00 00 00       	mov    $0x8,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <link>:
SYSCALL(link)
 352:	b8 13 00 00 00       	mov    $0x13,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <mkdir>:
SYSCALL(mkdir)
 35a:	b8 14 00 00 00       	mov    $0x14,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <chdir>:
SYSCALL(chdir)
 362:	b8 09 00 00 00       	mov    $0x9,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <dup>:
SYSCALL(dup)
 36a:	b8 0a 00 00 00       	mov    $0xa,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <getpid>:
SYSCALL(getpid)
 372:	b8 0b 00 00 00       	mov    $0xb,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <sbrk>:
SYSCALL(sbrk)
 37a:	b8 0c 00 00 00       	mov    $0xc,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <sleep>:
SYSCALL(sleep)
 382:	b8 0d 00 00 00       	mov    $0xd,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <uptime>:
SYSCALL(uptime)
 38a:	b8 0e 00 00 00       	mov    $0xe,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <clone>:
SYSCALL(clone)
 392:	b8 16 00 00 00       	mov    $0x16,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <thread_exit>:
SYSCALL(thread_exit)
 39a:	b8 17 00 00 00       	mov    $0x17,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <thread_join>:
SYSCALL(thread_join)
 3a2:	b8 18 00 00 00       	mov    $0x18,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
 3ad:	83 ec 18             	sub    $0x18,%esp
 3b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3bd:	00 
 3be:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c5:	8b 45 08             	mov    0x8(%ebp),%eax
 3c8:	89 04 24             	mov    %eax,(%esp)
 3cb:	e8 42 ff ff ff       	call   312 <write>
}
 3d0:	c9                   	leave  
 3d1:	c3                   	ret    

000003d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d2:	55                   	push   %ebp
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	56                   	push   %esi
 3d6:	53                   	push   %ebx
 3d7:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e5:	74 17                	je     3fe <printint+0x2c>
 3e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3eb:	79 11                	jns    3fe <printint+0x2c>
    neg = 1;
 3ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f7:	f7 d8                	neg    %eax
 3f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3fc:	eb 06                	jmp    404 <printint+0x32>
  } else {
    x = xx;
 3fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 401:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 40b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 40e:	8d 41 01             	lea    0x1(%ecx),%eax
 411:	89 45 f4             	mov    %eax,-0xc(%ebp)
 414:	8b 5d 10             	mov    0x10(%ebp),%ebx
 417:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41a:	ba 00 00 00 00       	mov    $0x0,%edx
 41f:	f7 f3                	div    %ebx
 421:	89 d0                	mov    %edx,%eax
 423:	0f b6 80 00 0b 00 00 	movzbl 0xb00(%eax),%eax
 42a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 42e:	8b 75 10             	mov    0x10(%ebp),%esi
 431:	8b 45 ec             	mov    -0x14(%ebp),%eax
 434:	ba 00 00 00 00       	mov    $0x0,%edx
 439:	f7 f6                	div    %esi
 43b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 442:	75 c7                	jne    40b <printint+0x39>
  if(neg)
 444:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 448:	74 10                	je     45a <printint+0x88>
    buf[i++] = '-';
 44a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44d:	8d 50 01             	lea    0x1(%eax),%edx
 450:	89 55 f4             	mov    %edx,-0xc(%ebp)
 453:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 458:	eb 1f                	jmp    479 <printint+0xa7>
 45a:	eb 1d                	jmp    479 <printint+0xa7>
    putc(fd, buf[i]);
 45c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	01 d0                	add    %edx,%eax
 464:	0f b6 00             	movzbl (%eax),%eax
 467:	0f be c0             	movsbl %al,%eax
 46a:	89 44 24 04          	mov    %eax,0x4(%esp)
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	89 04 24             	mov    %eax,(%esp)
 474:	e8 31 ff ff ff       	call   3aa <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 479:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 47d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 481:	79 d9                	jns    45c <printint+0x8a>
    putc(fd, buf[i]);
}
 483:	83 c4 30             	add    $0x30,%esp
 486:	5b                   	pop    %ebx
 487:	5e                   	pop    %esi
 488:	5d                   	pop    %ebp
 489:	c3                   	ret    

0000048a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 48a:	55                   	push   %ebp
 48b:	89 e5                	mov    %esp,%ebp
 48d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 490:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 497:	8d 45 0c             	lea    0xc(%ebp),%eax
 49a:	83 c0 04             	add    $0x4,%eax
 49d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a7:	e9 7c 01 00 00       	jmp    628 <printf+0x19e>
    c = fmt[i] & 0xff;
 4ac:	8b 55 0c             	mov    0xc(%ebp),%edx
 4af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b2:	01 d0                	add    %edx,%eax
 4b4:	0f b6 00             	movzbl (%eax),%eax
 4b7:	0f be c0             	movsbl %al,%eax
 4ba:	25 ff 00 00 00       	and    $0xff,%eax
 4bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c6:	75 2c                	jne    4f4 <printf+0x6a>
      if(c == '%'){
 4c8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4cc:	75 0c                	jne    4da <printf+0x50>
        state = '%';
 4ce:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d5:	e9 4a 01 00 00       	jmp    624 <printf+0x19a>
      } else {
        putc(fd, c);
 4da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4dd:	0f be c0             	movsbl %al,%eax
 4e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	89 04 24             	mov    %eax,(%esp)
 4ea:	e8 bb fe ff ff       	call   3aa <putc>
 4ef:	e9 30 01 00 00       	jmp    624 <printf+0x19a>
      }
    } else if(state == '%'){
 4f4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f8:	0f 85 26 01 00 00    	jne    624 <printf+0x19a>
      if(c == 'd'){
 4fe:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 502:	75 2d                	jne    531 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 504:	8b 45 e8             	mov    -0x18(%ebp),%eax
 507:	8b 00                	mov    (%eax),%eax
 509:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 510:	00 
 511:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 518:	00 
 519:	89 44 24 04          	mov    %eax,0x4(%esp)
 51d:	8b 45 08             	mov    0x8(%ebp),%eax
 520:	89 04 24             	mov    %eax,(%esp)
 523:	e8 aa fe ff ff       	call   3d2 <printint>
        ap++;
 528:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52c:	e9 ec 00 00 00       	jmp    61d <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 531:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 535:	74 06                	je     53d <printf+0xb3>
 537:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 53b:	75 2d                	jne    56a <printf+0xe0>
        printint(fd, *ap, 16, 0);
 53d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 540:	8b 00                	mov    (%eax),%eax
 542:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 549:	00 
 54a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 551:	00 
 552:	89 44 24 04          	mov    %eax,0x4(%esp)
 556:	8b 45 08             	mov    0x8(%ebp),%eax
 559:	89 04 24             	mov    %eax,(%esp)
 55c:	e8 71 fe ff ff       	call   3d2 <printint>
        ap++;
 561:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 565:	e9 b3 00 00 00       	jmp    61d <printf+0x193>
      } else if(c == 's'){
 56a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56e:	75 45                	jne    5b5 <printf+0x12b>
        s = (char*)*ap;
 570:	8b 45 e8             	mov    -0x18(%ebp),%eax
 573:	8b 00                	mov    (%eax),%eax
 575:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 578:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 57c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 580:	75 09                	jne    58b <printf+0x101>
          s = "(null)";
 582:	c7 45 f4 76 08 00 00 	movl   $0x876,-0xc(%ebp)
        while(*s != 0){
 589:	eb 1e                	jmp    5a9 <printf+0x11f>
 58b:	eb 1c                	jmp    5a9 <printf+0x11f>
          putc(fd, *s);
 58d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 590:	0f b6 00             	movzbl (%eax),%eax
 593:	0f be c0             	movsbl %al,%eax
 596:	89 44 24 04          	mov    %eax,0x4(%esp)
 59a:	8b 45 08             	mov    0x8(%ebp),%eax
 59d:	89 04 24             	mov    %eax,(%esp)
 5a0:	e8 05 fe ff ff       	call   3aa <putc>
          s++;
 5a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ac:	0f b6 00             	movzbl (%eax),%eax
 5af:	84 c0                	test   %al,%al
 5b1:	75 da                	jne    58d <printf+0x103>
 5b3:	eb 68                	jmp    61d <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b9:	75 1d                	jne    5d8 <printf+0x14e>
        putc(fd, *ap);
 5bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5be:	8b 00                	mov    (%eax),%eax
 5c0:	0f be c0             	movsbl %al,%eax
 5c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	89 04 24             	mov    %eax,(%esp)
 5cd:	e8 d8 fd ff ff       	call   3aa <putc>
        ap++;
 5d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d6:	eb 45                	jmp    61d <printf+0x193>
      } else if(c == '%'){
 5d8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5dc:	75 17                	jne    5f5 <printf+0x16b>
        putc(fd, c);
 5de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e1:	0f be c0             	movsbl %al,%eax
 5e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e8:	8b 45 08             	mov    0x8(%ebp),%eax
 5eb:	89 04 24             	mov    %eax,(%esp)
 5ee:	e8 b7 fd ff ff       	call   3aa <putc>
 5f3:	eb 28                	jmp    61d <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5fc:	00 
 5fd:	8b 45 08             	mov    0x8(%ebp),%eax
 600:	89 04 24             	mov    %eax,(%esp)
 603:	e8 a2 fd ff ff       	call   3aa <putc>
        putc(fd, c);
 608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	89 44 24 04          	mov    %eax,0x4(%esp)
 612:	8b 45 08             	mov    0x8(%ebp),%eax
 615:	89 04 24             	mov    %eax,(%esp)
 618:	e8 8d fd ff ff       	call   3aa <putc>
      }
      state = 0;
 61d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 624:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 628:	8b 55 0c             	mov    0xc(%ebp),%edx
 62b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62e:	01 d0                	add    %edx,%eax
 630:	0f b6 00             	movzbl (%eax),%eax
 633:	84 c0                	test   %al,%al
 635:	0f 85 71 fe ff ff    	jne    4ac <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 63b:	c9                   	leave  
 63c:	c3                   	ret    

0000063d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	83 e8 08             	sub    $0x8,%eax
 649:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64c:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 651:	89 45 fc             	mov    %eax,-0x4(%ebp)
 654:	eb 24                	jmp    67a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65e:	77 12                	ja     672 <free+0x35>
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 666:	77 24                	ja     68c <free+0x4f>
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 670:	77 1a                	ja     68c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 680:	76 d4                	jbe    656 <free+0x19>
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68a:	76 ca                	jbe    656 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	8b 40 04             	mov    0x4(%eax),%eax
 692:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	01 c2                	add    %eax,%edx
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	39 c2                	cmp    %eax,%edx
 6a5:	75 24                	jne    6cb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 50 04             	mov    0x4(%eax),%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	8b 40 04             	mov    0x4(%eax),%eax
 6b5:	01 c2                	add    %eax,%edx
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	8b 10                	mov    (%eax),%edx
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	89 10                	mov    %edx,(%eax)
 6c9:	eb 0a                	jmp    6d5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 10                	mov    (%eax),%edx
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 40 04             	mov    0x4(%eax),%eax
 6db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	01 d0                	add    %edx,%eax
 6e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ea:	75 20                	jne    70c <free+0xcf>
    p->s.size += bp->s.size;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 50 04             	mov    0x4(%eax),%edx
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 40 04             	mov    0x4(%eax),%eax
 6f8:	01 c2                	add    %eax,%edx
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	8b 10                	mov    (%eax),%edx
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	89 10                	mov    %edx,(%eax)
 70a:	eb 08                	jmp    714 <free+0xd7>
  } else
    p->s.ptr = bp;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 712:	89 10                	mov    %edx,(%eax)
  freep = p;
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	a3 1c 0b 00 00       	mov    %eax,0xb1c
}
 71c:	c9                   	leave  
 71d:	c3                   	ret    

0000071e <morecore>:

static Header*
morecore(uint nu)
{
 71e:	55                   	push   %ebp
 71f:	89 e5                	mov    %esp,%ebp
 721:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 724:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 72b:	77 07                	ja     734 <morecore+0x16>
    nu = 4096;
 72d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 734:	8b 45 08             	mov    0x8(%ebp),%eax
 737:	c1 e0 03             	shl    $0x3,%eax
 73a:	89 04 24             	mov    %eax,(%esp)
 73d:	e8 38 fc ff ff       	call   37a <sbrk>
 742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 745:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 749:	75 07                	jne    752 <morecore+0x34>
    return 0;
 74b:	b8 00 00 00 00       	mov    $0x0,%eax
 750:	eb 22                	jmp    774 <morecore+0x56>
  hp = (Header*)p;
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 758:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75b:	8b 55 08             	mov    0x8(%ebp),%edx
 75e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 761:	8b 45 f0             	mov    -0x10(%ebp),%eax
 764:	83 c0 08             	add    $0x8,%eax
 767:	89 04 24             	mov    %eax,(%esp)
 76a:	e8 ce fe ff ff       	call   63d <free>
  return freep;
 76f:	a1 1c 0b 00 00       	mov    0xb1c,%eax
}
 774:	c9                   	leave  
 775:	c3                   	ret    

00000776 <malloc>:

void*
malloc(uint nbytes)
{
 776:	55                   	push   %ebp
 777:	89 e5                	mov    %esp,%ebp
 779:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77c:	8b 45 08             	mov    0x8(%ebp),%eax
 77f:	83 c0 07             	add    $0x7,%eax
 782:	c1 e8 03             	shr    $0x3,%eax
 785:	83 c0 01             	add    $0x1,%eax
 788:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 78b:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 790:	89 45 f0             	mov    %eax,-0x10(%ebp)
 793:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 797:	75 23                	jne    7bc <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 799:	c7 45 f0 14 0b 00 00 	movl   $0xb14,-0x10(%ebp)
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	a3 1c 0b 00 00       	mov    %eax,0xb1c
 7a8:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 7ad:	a3 14 0b 00 00       	mov    %eax,0xb14
    base.s.size = 0;
 7b2:	c7 05 18 0b 00 00 00 	movl   $0x0,0xb18
 7b9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	8b 00                	mov    (%eax),%eax
 7c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cd:	72 4d                	jb     81c <malloc+0xa6>
      if(p->s.size == nunits)
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d8:	75 0c                	jne    7e6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8b 10                	mov    (%eax),%edx
 7df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e2:	89 10                	mov    %edx,(%eax)
 7e4:	eb 26                	jmp    80c <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ef:	89 c2                	mov    %eax,%edx
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	c1 e0 03             	shl    $0x3,%eax
 800:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	8b 55 ec             	mov    -0x14(%ebp),%edx
 809:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	a3 1c 0b 00 00       	mov    %eax,0xb1c
      return (void*)(p + 1);
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	83 c0 08             	add    $0x8,%eax
 81a:	eb 38                	jmp    854 <malloc+0xde>
    }
    if(p == freep)
 81c:	a1 1c 0b 00 00       	mov    0xb1c,%eax
 821:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 824:	75 1b                	jne    841 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 826:	8b 45 ec             	mov    -0x14(%ebp),%eax
 829:	89 04 24             	mov    %eax,(%esp)
 82c:	e8 ed fe ff ff       	call   71e <morecore>
 831:	89 45 f4             	mov    %eax,-0xc(%ebp)
 834:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 838:	75 07                	jne    841 <malloc+0xcb>
        return 0;
 83a:	b8 00 00 00 00       	mov    $0x0,%eax
 83f:	eb 13                	jmp    854 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	89 45 f0             	mov    %eax,-0x10(%ebp)
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8b 00                	mov    (%eax),%eax
 84c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 84f:	e9 70 ff ff ff       	jmp    7c4 <malloc+0x4e>
}
 854:	c9                   	leave  
 855:	c3                   	ret    
