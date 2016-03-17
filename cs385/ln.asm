
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 88 08 00 	movl   $0x888,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 99 04 00 00       	call   4bc <printf>
    exit();
  23:	e8 fc 02 00 00       	call   324 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 40 03 00 00       	call   384 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 9b 08 00 	movl   $0x89b,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 48 04 00 00       	call   4bc <printf>
  exit();
  74:	e8 ab 02 00 00       	call   324 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  aa:	90                   	nop
  ab:	8b 45 08             	mov    0x8(%ebp),%eax
  ae:	8d 50 01             	lea    0x1(%eax),%edx
  b1:	89 55 08             	mov    %edx,0x8(%ebp)
  b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  bd:	0f b6 12             	movzbl (%edx),%edx
  c0:	88 10                	mov    %dl,(%eax)
  c2:	0f b6 00             	movzbl (%eax),%eax
  c5:	84 c0                	test   %al,%al
  c7:	75 e2                	jne    ab <strcpy+0xd>
    ;
  return os;
  c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d1:	eb 08                	jmp    db <strcmp+0xd>
    p++, q++;
  d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	0f b6 00             	movzbl (%eax),%eax
  e1:	84 c0                	test   %al,%al
  e3:	74 10                	je     f5 <strcmp+0x27>
  e5:	8b 45 08             	mov    0x8(%ebp),%eax
  e8:	0f b6 10             	movzbl (%eax),%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	38 c2                	cmp    %al,%dl
  f3:	74 de                	je     d3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	0f b6 d0             	movzbl %al,%edx
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	0f b6 00             	movzbl (%eax),%eax
 104:	0f b6 c0             	movzbl %al,%eax
 107:	29 c2                	sub    %eax,%edx
 109:	89 d0                	mov    %edx,%eax
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    

0000010d <strlen>:

uint
strlen(char *s)
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 113:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 11a:	eb 04                	jmp    120 <strlen+0x13>
 11c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 120:	8b 55 fc             	mov    -0x4(%ebp),%edx
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	01 d0                	add    %edx,%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	84 c0                	test   %al,%al
 12d:	75 ed                	jne    11c <strlen+0xf>
    ;
  return n;
 12f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <memset>:

void*
memset(void *dst, int c, uint n)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 13a:	8b 45 10             	mov    0x10(%ebp),%eax
 13d:	89 44 24 08          	mov    %eax,0x8(%esp)
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	89 44 24 04          	mov    %eax,0x4(%esp)
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	89 04 24             	mov    %eax,(%esp)
 14e:	e8 26 ff ff ff       	call   79 <stosb>
  return dst;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
}
 156:	c9                   	leave  
 157:	c3                   	ret    

00000158 <strchr>:

char*
strchr(const char *s, char c)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	83 ec 04             	sub    $0x4,%esp
 15e:	8b 45 0c             	mov    0xc(%ebp),%eax
 161:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 164:	eb 14                	jmp    17a <strchr+0x22>
    if(*s == c)
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	0f b6 00             	movzbl (%eax),%eax
 16c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 16f:	75 05                	jne    176 <strchr+0x1e>
      return (char*)s;
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	eb 13                	jmp    189 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 176:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	0f b6 00             	movzbl (%eax),%eax
 180:	84 c0                	test   %al,%al
 182:	75 e2                	jne    166 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 184:	b8 00 00 00 00       	mov    $0x0,%eax
}
 189:	c9                   	leave  
 18a:	c3                   	ret    

0000018b <gets>:

char*
gets(char *buf, int max)
{
 18b:	55                   	push   %ebp
 18c:	89 e5                	mov    %esp,%ebp
 18e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 191:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 198:	eb 4c                	jmp    1e6 <gets+0x5b>
    cc = read(0, &c, 1);
 19a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a1:	00 
 1a2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b0:	e8 87 01 00 00       	call   33c <read>
 1b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1bc:	7f 02                	jg     1c0 <gets+0x35>
      break;
 1be:	eb 31                	jmp    1f1 <gets+0x66>
    buf[i++] = c;
 1c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c3:	8d 50 01             	lea    0x1(%eax),%edx
 1c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c9:	89 c2                	mov    %eax,%edx
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	01 c2                	add    %eax,%edx
 1d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1da:	3c 0a                	cmp    $0xa,%al
 1dc:	74 13                	je     1f1 <gets+0x66>
 1de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e2:	3c 0d                	cmp    $0xd,%al
 1e4:	74 0b                	je     1f1 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e9:	83 c0 01             	add    $0x1,%eax
 1ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ef:	7c a9                	jl     19a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	01 d0                	add    %edx,%eax
 1f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <stat>:

int
stat(char *n, struct stat *st)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 207:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20e:	00 
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	89 04 24             	mov    %eax,(%esp)
 215:	e8 4a 01 00 00       	call   364 <open>
 21a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 221:	79 07                	jns    22a <stat+0x29>
    return -1;
 223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 228:	eb 23                	jmp    24d <stat+0x4c>
  r = fstat(fd, st);
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 44 24 04          	mov    %eax,0x4(%esp)
 231:	8b 45 f4             	mov    -0xc(%ebp),%eax
 234:	89 04 24             	mov    %eax,(%esp)
 237:	e8 40 01 00 00       	call   37c <fstat>
 23c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 23f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 242:	89 04 24             	mov    %eax,(%esp)
 245:	e8 02 01 00 00       	call   34c <close>
  return r;
 24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 24d:	c9                   	leave  
 24e:	c3                   	ret    

0000024f <atoi>:

int
atoi(const char *s)
{
 24f:	55                   	push   %ebp
 250:	89 e5                	mov    %esp,%ebp
 252:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25c:	eb 25                	jmp    283 <atoi+0x34>
    n = n*10 + *s++ - '0';
 25e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 261:	89 d0                	mov    %edx,%eax
 263:	c1 e0 02             	shl    $0x2,%eax
 266:	01 d0                	add    %edx,%eax
 268:	01 c0                	add    %eax,%eax
 26a:	89 c1                	mov    %eax,%ecx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	8d 50 01             	lea    0x1(%eax),%edx
 272:	89 55 08             	mov    %edx,0x8(%ebp)
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	0f be c0             	movsbl %al,%eax
 27b:	01 c8                	add    %ecx,%eax
 27d:	83 e8 30             	sub    $0x30,%eax
 280:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	0f b6 00             	movzbl (%eax),%eax
 289:	3c 2f                	cmp    $0x2f,%al
 28b:	7e 0a                	jle    297 <atoi+0x48>
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	0f b6 00             	movzbl (%eax),%eax
 293:	3c 39                	cmp    $0x39,%al
 295:	7e c7                	jle    25e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 297:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ae:	eb 17                	jmp    2c7 <memmove+0x2b>
    *dst++ = *src++;
 2b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b3:	8d 50 01             	lea    0x1(%eax),%edx
 2b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2bc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2bf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c2:	0f b6 12             	movzbl (%edx),%edx
 2c5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c7:	8b 45 10             	mov    0x10(%ebp),%eax
 2ca:	8d 50 ff             	lea    -0x1(%eax),%edx
 2cd:	89 55 10             	mov    %edx,0x10(%ebp)
 2d0:	85 c0                	test   %eax,%eax
 2d2:	7f dc                	jg     2b0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d7:	c9                   	leave  
 2d8:	c3                   	ret    

000002d9 <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp
 2dc:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 2df:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 2e6:	e8 bd 04 00 00       	call   7a8 <malloc>
 2eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 2ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f1:	05 fc ff 0f 00       	add    $0xffffc,%eax
 2f6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 2f9:	ba cc 03 00 00       	mov    $0x3cc,%edx
 2fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 301:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 303:	8b 45 f4             	mov    -0xc(%ebp),%eax
 306:	05 fc ff 0f 00       	add    $0xffffc,%eax
 30b:	89 44 24 04          	mov    %eax,0x4(%esp)
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	89 04 24             	mov    %eax,(%esp)
 315:	e8 aa 00 00 00       	call   3c4 <clone>
}
 31a:	c9                   	leave  
 31b:	c3                   	ret    

0000031c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31c:	b8 01 00 00 00       	mov    $0x1,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <exit>:
SYSCALL(exit)
 324:	b8 02 00 00 00       	mov    $0x2,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <wait>:
SYSCALL(wait)
 32c:	b8 03 00 00 00       	mov    $0x3,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <pipe>:
SYSCALL(pipe)
 334:	b8 04 00 00 00       	mov    $0x4,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <read>:
SYSCALL(read)
 33c:	b8 05 00 00 00       	mov    $0x5,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <write>:
SYSCALL(write)
 344:	b8 10 00 00 00       	mov    $0x10,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <close>:
SYSCALL(close)
 34c:	b8 15 00 00 00       	mov    $0x15,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <kill>:
SYSCALL(kill)
 354:	b8 06 00 00 00       	mov    $0x6,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <exec>:
SYSCALL(exec)
 35c:	b8 07 00 00 00       	mov    $0x7,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <open>:
SYSCALL(open)
 364:	b8 0f 00 00 00       	mov    $0xf,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <mknod>:
SYSCALL(mknod)
 36c:	b8 11 00 00 00       	mov    $0x11,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <unlink>:
SYSCALL(unlink)
 374:	b8 12 00 00 00       	mov    $0x12,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <fstat>:
SYSCALL(fstat)
 37c:	b8 08 00 00 00       	mov    $0x8,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <link>:
SYSCALL(link)
 384:	b8 13 00 00 00       	mov    $0x13,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <mkdir>:
SYSCALL(mkdir)
 38c:	b8 14 00 00 00       	mov    $0x14,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <chdir>:
SYSCALL(chdir)
 394:	b8 09 00 00 00       	mov    $0x9,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <dup>:
SYSCALL(dup)
 39c:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <getpid>:
SYSCALL(getpid)
 3a4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <sbrk>:
SYSCALL(sbrk)
 3ac:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <sleep>:
SYSCALL(sleep)
 3b4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <uptime>:
SYSCALL(uptime)
 3bc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <clone>:
SYSCALL(clone)
 3c4:	b8 16 00 00 00       	mov    $0x16,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <thread_exit>:
SYSCALL(thread_exit)
 3cc:	b8 17 00 00 00       	mov    $0x17,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <thread_join>:
SYSCALL(thread_join)
 3d4:	b8 18 00 00 00       	mov    $0x18,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3dc:	55                   	push   %ebp
 3dd:	89 e5                	mov    %esp,%ebp
 3df:	83 ec 18             	sub    $0x18,%esp
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ef:	00 
 3f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	89 04 24             	mov    %eax,(%esp)
 3fd:	e8 42 ff ff ff       	call   344 <write>
}
 402:	c9                   	leave  
 403:	c3                   	ret    

00000404 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	56                   	push   %esi
 408:	53                   	push   %ebx
 409:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 40c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 413:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 417:	74 17                	je     430 <printint+0x2c>
 419:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 41d:	79 11                	jns    430 <printint+0x2c>
    neg = 1;
 41f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 426:	8b 45 0c             	mov    0xc(%ebp),%eax
 429:	f7 d8                	neg    %eax
 42b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42e:	eb 06                	jmp    436 <printint+0x32>
  } else {
    x = xx;
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 436:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 43d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 440:	8d 41 01             	lea    0x1(%ecx),%eax
 443:	89 45 f4             	mov    %eax,-0xc(%ebp)
 446:	8b 5d 10             	mov    0x10(%ebp),%ebx
 449:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44c:	ba 00 00 00 00       	mov    $0x0,%edx
 451:	f7 f3                	div    %ebx
 453:	89 d0                	mov    %edx,%eax
 455:	0f b6 80 1c 0b 00 00 	movzbl 0xb1c(%eax),%eax
 45c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 460:	8b 75 10             	mov    0x10(%ebp),%esi
 463:	8b 45 ec             	mov    -0x14(%ebp),%eax
 466:	ba 00 00 00 00       	mov    $0x0,%edx
 46b:	f7 f6                	div    %esi
 46d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 470:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 474:	75 c7                	jne    43d <printint+0x39>
  if(neg)
 476:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47a:	74 10                	je     48c <printint+0x88>
    buf[i++] = '-';
 47c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47f:	8d 50 01             	lea    0x1(%eax),%edx
 482:	89 55 f4             	mov    %edx,-0xc(%ebp)
 485:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 48a:	eb 1f                	jmp    4ab <printint+0xa7>
 48c:	eb 1d                	jmp    4ab <printint+0xa7>
    putc(fd, buf[i]);
 48e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 491:	8b 45 f4             	mov    -0xc(%ebp),%eax
 494:	01 d0                	add    %edx,%eax
 496:	0f b6 00             	movzbl (%eax),%eax
 499:	0f be c0             	movsbl %al,%eax
 49c:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
 4a3:	89 04 24             	mov    %eax,(%esp)
 4a6:	e8 31 ff ff ff       	call   3dc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ab:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b3:	79 d9                	jns    48e <printint+0x8a>
    putc(fd, buf[i]);
}
 4b5:	83 c4 30             	add    $0x30,%esp
 4b8:	5b                   	pop    %ebx
 4b9:	5e                   	pop    %esi
 4ba:	5d                   	pop    %ebp
 4bb:	c3                   	ret    

000004bc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c9:	8d 45 0c             	lea    0xc(%ebp),%eax
 4cc:	83 c0 04             	add    $0x4,%eax
 4cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d9:	e9 7c 01 00 00       	jmp    65a <printf+0x19e>
    c = fmt[i] & 0xff;
 4de:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e4:	01 d0                	add    %edx,%eax
 4e6:	0f b6 00             	movzbl (%eax),%eax
 4e9:	0f be c0             	movsbl %al,%eax
 4ec:	25 ff 00 00 00       	and    $0xff,%eax
 4f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f8:	75 2c                	jne    526 <printf+0x6a>
      if(c == '%'){
 4fa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4fe:	75 0c                	jne    50c <printf+0x50>
        state = '%';
 500:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 507:	e9 4a 01 00 00       	jmp    656 <printf+0x19a>
      } else {
        putc(fd, c);
 50c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50f:	0f be c0             	movsbl %al,%eax
 512:	89 44 24 04          	mov    %eax,0x4(%esp)
 516:	8b 45 08             	mov    0x8(%ebp),%eax
 519:	89 04 24             	mov    %eax,(%esp)
 51c:	e8 bb fe ff ff       	call   3dc <putc>
 521:	e9 30 01 00 00       	jmp    656 <printf+0x19a>
      }
    } else if(state == '%'){
 526:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 52a:	0f 85 26 01 00 00    	jne    656 <printf+0x19a>
      if(c == 'd'){
 530:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 534:	75 2d                	jne    563 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 536:	8b 45 e8             	mov    -0x18(%ebp),%eax
 539:	8b 00                	mov    (%eax),%eax
 53b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 542:	00 
 543:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 54a:	00 
 54b:	89 44 24 04          	mov    %eax,0x4(%esp)
 54f:	8b 45 08             	mov    0x8(%ebp),%eax
 552:	89 04 24             	mov    %eax,(%esp)
 555:	e8 aa fe ff ff       	call   404 <printint>
        ap++;
 55a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55e:	e9 ec 00 00 00       	jmp    64f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 563:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 567:	74 06                	je     56f <printf+0xb3>
 569:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 56d:	75 2d                	jne    59c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 56f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 572:	8b 00                	mov    (%eax),%eax
 574:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 57b:	00 
 57c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 583:	00 
 584:	89 44 24 04          	mov    %eax,0x4(%esp)
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	89 04 24             	mov    %eax,(%esp)
 58e:	e8 71 fe ff ff       	call   404 <printint>
        ap++;
 593:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 597:	e9 b3 00 00 00       	jmp    64f <printf+0x193>
      } else if(c == 's'){
 59c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a0:	75 45                	jne    5e7 <printf+0x12b>
        s = (char*)*ap;
 5a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a5:	8b 00                	mov    (%eax),%eax
 5a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b2:	75 09                	jne    5bd <printf+0x101>
          s = "(null)";
 5b4:	c7 45 f4 af 08 00 00 	movl   $0x8af,-0xc(%ebp)
        while(*s != 0){
 5bb:	eb 1e                	jmp    5db <printf+0x11f>
 5bd:	eb 1c                	jmp    5db <printf+0x11f>
          putc(fd, *s);
 5bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c2:	0f b6 00             	movzbl (%eax),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 05 fe ff ff       	call   3dc <putc>
          s++;
 5d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5de:	0f b6 00             	movzbl (%eax),%eax
 5e1:	84 c0                	test   %al,%al
 5e3:	75 da                	jne    5bf <printf+0x103>
 5e5:	eb 68                	jmp    64f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5eb:	75 1d                	jne    60a <printf+0x14e>
        putc(fd, *ap);
 5ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	0f be c0             	movsbl %al,%eax
 5f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	89 04 24             	mov    %eax,(%esp)
 5ff:	e8 d8 fd ff ff       	call   3dc <putc>
        ap++;
 604:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 608:	eb 45                	jmp    64f <printf+0x193>
      } else if(c == '%'){
 60a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60e:	75 17                	jne    627 <printf+0x16b>
        putc(fd, c);
 610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 613:	0f be c0             	movsbl %al,%eax
 616:	89 44 24 04          	mov    %eax,0x4(%esp)
 61a:	8b 45 08             	mov    0x8(%ebp),%eax
 61d:	89 04 24             	mov    %eax,(%esp)
 620:	e8 b7 fd ff ff       	call   3dc <putc>
 625:	eb 28                	jmp    64f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 627:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 62e:	00 
 62f:	8b 45 08             	mov    0x8(%ebp),%eax
 632:	89 04 24             	mov    %eax,(%esp)
 635:	e8 a2 fd ff ff       	call   3dc <putc>
        putc(fd, c);
 63a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63d:	0f be c0             	movsbl %al,%eax
 640:	89 44 24 04          	mov    %eax,0x4(%esp)
 644:	8b 45 08             	mov    0x8(%ebp),%eax
 647:	89 04 24             	mov    %eax,(%esp)
 64a:	e8 8d fd ff ff       	call   3dc <putc>
      }
      state = 0;
 64f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 656:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65a:	8b 55 0c             	mov    0xc(%ebp),%edx
 65d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 660:	01 d0                	add    %edx,%eax
 662:	0f b6 00             	movzbl (%eax),%eax
 665:	84 c0                	test   %al,%al
 667:	0f 85 71 fe ff ff    	jne    4de <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 66d:	c9                   	leave  
 66e:	c3                   	ret    

0000066f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66f:	55                   	push   %ebp
 670:	89 e5                	mov    %esp,%ebp
 672:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	83 e8 08             	sub    $0x8,%eax
 67b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67e:	a1 38 0b 00 00       	mov    0xb38,%eax
 683:	89 45 fc             	mov    %eax,-0x4(%ebp)
 686:	eb 24                	jmp    6ac <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 690:	77 12                	ja     6a4 <free+0x35>
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 698:	77 24                	ja     6be <free+0x4f>
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a2:	77 1a                	ja     6be <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 00                	mov    (%eax),%eax
 6a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b2:	76 d4                	jbe    688 <free+0x19>
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bc:	76 ca                	jbe    688 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	8b 40 04             	mov    0x4(%eax),%eax
 6c4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ce:	01 c2                	add    %eax,%edx
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	39 c2                	cmp    %eax,%edx
 6d7:	75 24                	jne    6fd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dc:	8b 50 04             	mov    0x4(%eax),%edx
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	8b 00                	mov    (%eax),%eax
 6e4:	8b 40 04             	mov    0x4(%eax),%eax
 6e7:	01 c2                	add    %eax,%edx
 6e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ec:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 00                	mov    (%eax),%eax
 6f4:	8b 10                	mov    (%eax),%edx
 6f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f9:	89 10                	mov    %edx,(%eax)
 6fb:	eb 0a                	jmp    707 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 10                	mov    (%eax),%edx
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 40 04             	mov    0x4(%eax),%eax
 70d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	01 d0                	add    %edx,%eax
 719:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71c:	75 20                	jne    73e <free+0xcf>
    p->s.size += bp->s.size;
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 50 04             	mov    0x4(%eax),%edx
 724:	8b 45 f8             	mov    -0x8(%ebp),%eax
 727:	8b 40 04             	mov    0x4(%eax),%eax
 72a:	01 c2                	add    %eax,%edx
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	8b 10                	mov    (%eax),%edx
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	89 10                	mov    %edx,(%eax)
 73c:	eb 08                	jmp    746 <free+0xd7>
  } else
    p->s.ptr = bp;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 55 f8             	mov    -0x8(%ebp),%edx
 744:	89 10                	mov    %edx,(%eax)
  freep = p;
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	a3 38 0b 00 00       	mov    %eax,0xb38
}
 74e:	c9                   	leave  
 74f:	c3                   	ret    

00000750 <morecore>:

static Header*
morecore(uint nu)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 756:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 75d:	77 07                	ja     766 <morecore+0x16>
    nu = 4096;
 75f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	c1 e0 03             	shl    $0x3,%eax
 76c:	89 04 24             	mov    %eax,(%esp)
 76f:	e8 38 fc ff ff       	call   3ac <sbrk>
 774:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 777:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 77b:	75 07                	jne    784 <morecore+0x34>
    return 0;
 77d:	b8 00 00 00 00       	mov    $0x0,%eax
 782:	eb 22                	jmp    7a6 <morecore+0x56>
  hp = (Header*)p;
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 78a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78d:	8b 55 08             	mov    0x8(%ebp),%edx
 790:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	83 c0 08             	add    $0x8,%eax
 799:	89 04 24             	mov    %eax,(%esp)
 79c:	e8 ce fe ff ff       	call   66f <free>
  return freep;
 7a1:	a1 38 0b 00 00       	mov    0xb38,%eax
}
 7a6:	c9                   	leave  
 7a7:	c3                   	ret    

000007a8 <malloc>:

void*
malloc(uint nbytes)
{
 7a8:	55                   	push   %ebp
 7a9:	89 e5                	mov    %esp,%ebp
 7ab:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ae:	8b 45 08             	mov    0x8(%ebp),%eax
 7b1:	83 c0 07             	add    $0x7,%eax
 7b4:	c1 e8 03             	shr    $0x3,%eax
 7b7:	83 c0 01             	add    $0x1,%eax
 7ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7bd:	a1 38 0b 00 00       	mov    0xb38,%eax
 7c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c9:	75 23                	jne    7ee <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7cb:	c7 45 f0 30 0b 00 00 	movl   $0xb30,-0x10(%ebp)
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d5:	a3 38 0b 00 00       	mov    %eax,0xb38
 7da:	a1 38 0b 00 00       	mov    0xb38,%eax
 7df:	a3 30 0b 00 00       	mov    %eax,0xb30
    base.s.size = 0;
 7e4:	c7 05 34 0b 00 00 00 	movl   $0x0,0xb34
 7eb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 40 04             	mov    0x4(%eax),%eax
 7fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ff:	72 4d                	jb     84e <malloc+0xa6>
      if(p->s.size == nunits)
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 40 04             	mov    0x4(%eax),%eax
 807:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80a:	75 0c                	jne    818 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 10                	mov    (%eax),%edx
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	89 10                	mov    %edx,(%eax)
 816:	eb 26                	jmp    83e <malloc+0x96>
      else {
        p->s.size -= nunits;
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 821:	89 c2                	mov    %eax,%edx
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 40 04             	mov    0x4(%eax),%eax
 82f:	c1 e0 03             	shl    $0x3,%eax
 832:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 841:	a3 38 0b 00 00       	mov    %eax,0xb38
      return (void*)(p + 1);
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	83 c0 08             	add    $0x8,%eax
 84c:	eb 38                	jmp    886 <malloc+0xde>
    }
    if(p == freep)
 84e:	a1 38 0b 00 00       	mov    0xb38,%eax
 853:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 856:	75 1b                	jne    873 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 858:	8b 45 ec             	mov    -0x14(%ebp),%eax
 85b:	89 04 24             	mov    %eax,(%esp)
 85e:	e8 ed fe ff ff       	call   750 <morecore>
 863:	89 45 f4             	mov    %eax,-0xc(%ebp)
 866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86a:	75 07                	jne    873 <malloc+0xcb>
        return 0;
 86c:	b8 00 00 00 00       	mov    $0x0,%eax
 871:	eb 13                	jmp    886 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	89 45 f0             	mov    %eax,-0x10(%ebp)
 879:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87c:	8b 00                	mov    (%eax),%eax
 87e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 881:	e9 70 ff ff ff       	jmp    7f6 <malloc+0x4e>
}
 886:	c9                   	leave  
 887:	c3                   	ret    
