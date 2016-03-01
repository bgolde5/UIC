
_thread3:     file format elf32-i386


Disassembly of section .text:

00000000 <f>:
#include"types.h"
#include"user.h"

int shared = 1;

void f(void) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  while(shared<10000000) shared++;
   6:	eb 0d                	jmp    15 <f+0x15>
   8:	a1 60 0b 00 00       	mov    0xb60,%eax
   d:	83 c0 01             	add    $0x1,%eax
  10:	a3 60 0b 00 00       	mov    %eax,0xb60
  15:	a1 60 0b 00 00       	mov    0xb60,%eax
  1a:	3d 7f 96 98 00       	cmp    $0x98967f,%eax
  1f:	7e e7                	jle    8 <f+0x8>
  printf(1,"Done looping\n");
  21:	c7 44 24 04 b7 08 00 	movl   $0x8b7,0x4(%esp)
  28:	00 
  29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  30:	e8 b6 04 00 00       	call   4eb <printf>
}
  35:	c9                   	leave  
  36:	c3                   	ret    

00000037 <main>:

int main(int argc, char** argv) {
  37:	55                   	push   %ebp
  38:	89 e5                	mov    %esp,%ebp
  3a:	83 e4 f0             	and    $0xfffffff0,%esp
  3d:	83 ec 20             	sub    $0x20,%esp
  thread_create(f);
  40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  47:	e8 bc 02 00 00       	call   308 <thread_create>
  
  int last = shared;
  4c:	a1 60 0b 00 00       	mov    0xb60,%eax
  51:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  while(shared<10000000) {
  55:	eb 14                	jmp    6b <main+0x34>
    if(last!=shared) {
  57:	a1 60 0b 00 00       	mov    0xb60,%eax
  5c:	39 44 24 1c          	cmp    %eax,0x1c(%esp)
  60:	74 09                	je     6b <main+0x34>
      last = shared;
  62:	a1 60 0b 00 00       	mov    0xb60,%eax
  67:	89 44 24 1c          	mov    %eax,0x1c(%esp)

int main(int argc, char** argv) {
  thread_create(f);
  
  int last = shared;
  while(shared<10000000) {
  6b:	a1 60 0b 00 00       	mov    0xb60,%eax
  70:	3d 7f 96 98 00       	cmp    $0x98967f,%eax
  75:	7e e0                	jle    57 <main+0x20>
    if(last!=shared) {
      last = shared;
//      printf(1,"shared = %d\n",last);
    }
  }
  printf(1,"Main is done!\n"); 
  77:	c7 44 24 04 c5 08 00 	movl   $0x8c5,0x4(%esp)
  7e:	00 
  7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  86:	e8 60 04 00 00       	call   4eb <printf>

  // a little artificial wait: this is a completely bogus way of resolving
  // the race condition where the main thread may exit before f().
  int i=1000000000;
  8b:	c7 44 24 18 00 ca 9a 	movl   $0x3b9aca00,0x18(%esp)
  92:	3b 
  while(i--);
  93:	90                   	nop
  94:	8b 44 24 18          	mov    0x18(%esp),%eax
  98:	8d 50 ff             	lea    -0x1(%eax),%edx
  9b:	89 54 24 18          	mov    %edx,0x18(%esp)
  9f:	85 c0                	test   %eax,%eax
  a1:	75 f1                	jne    94 <main+0x5d>

  exit();
  a3:	e8 ab 02 00 00       	call   353 <exit>

000000a8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	57                   	push   %edi
  ac:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b0:	8b 55 10             	mov    0x10(%ebp),%edx
  b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  b6:	89 cb                	mov    %ecx,%ebx
  b8:	89 df                	mov    %ebx,%edi
  ba:	89 d1                	mov    %edx,%ecx
  bc:	fc                   	cld    
  bd:	f3 aa                	rep stos %al,%es:(%edi)
  bf:	89 ca                	mov    %ecx,%edx
  c1:	89 fb                	mov    %edi,%ebx
  c3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c9:	5b                   	pop    %ebx
  ca:	5f                   	pop    %edi
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    

000000cd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  cd:	55                   	push   %ebp
  ce:	89 e5                	mov    %esp,%ebp
  d0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  d9:	90                   	nop
  da:	8b 45 08             	mov    0x8(%ebp),%eax
  dd:	8d 50 01             	lea    0x1(%eax),%edx
  e0:	89 55 08             	mov    %edx,0x8(%ebp)
  e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  e9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ec:	0f b6 12             	movzbl (%edx),%edx
  ef:	88 10                	mov    %dl,(%eax)
  f1:	0f b6 00             	movzbl (%eax),%eax
  f4:	84 c0                	test   %al,%al
  f6:	75 e2                	jne    da <strcpy+0xd>
    ;
  return os;
  f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 100:	eb 08                	jmp    10a <strcmp+0xd>
    p++, q++;
 102:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 106:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	0f b6 00             	movzbl (%eax),%eax
 110:	84 c0                	test   %al,%al
 112:	74 10                	je     124 <strcmp+0x27>
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	0f b6 10             	movzbl (%eax),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	0f b6 00             	movzbl (%eax),%eax
 120:	38 c2                	cmp    %al,%dl
 122:	74 de                	je     102 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	0f b6 d0             	movzbl %al,%edx
 12d:	8b 45 0c             	mov    0xc(%ebp),%eax
 130:	0f b6 00             	movzbl (%eax),%eax
 133:	0f b6 c0             	movzbl %al,%eax
 136:	29 c2                	sub    %eax,%edx
 138:	89 d0                	mov    %edx,%eax
}
 13a:	5d                   	pop    %ebp
 13b:	c3                   	ret    

0000013c <strlen>:

uint
strlen(char *s)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 142:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 149:	eb 04                	jmp    14f <strlen+0x13>
 14b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 14f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 152:	8b 45 08             	mov    0x8(%ebp),%eax
 155:	01 d0                	add    %edx,%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	84 c0                	test   %al,%al
 15c:	75 ed                	jne    14b <strlen+0xf>
    ;
  return n;
 15e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 161:	c9                   	leave  
 162:	c3                   	ret    

00000163 <memset>:

void*
memset(void *dst, int c, uint n)
{
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
 166:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 169:	8b 45 10             	mov    0x10(%ebp),%eax
 16c:	89 44 24 08          	mov    %eax,0x8(%esp)
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	89 44 24 04          	mov    %eax,0x4(%esp)
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	89 04 24             	mov    %eax,(%esp)
 17d:	e8 26 ff ff ff       	call   a8 <stosb>
  return dst;
 182:	8b 45 08             	mov    0x8(%ebp),%eax
}
 185:	c9                   	leave  
 186:	c3                   	ret    

00000187 <strchr>:

char*
strchr(const char *s, char c)
{
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	8b 45 0c             	mov    0xc(%ebp),%eax
 190:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 193:	eb 14                	jmp    1a9 <strchr+0x22>
    if(*s == c)
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 19e:	75 05                	jne    1a5 <strchr+0x1e>
      return (char*)s;
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	eb 13                	jmp    1b8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	0f b6 00             	movzbl (%eax),%eax
 1af:	84 c0                	test   %al,%al
 1b1:	75 e2                	jne    195 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <gets>:

char*
gets(char *buf, int max)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
 1bd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1c7:	eb 4c                	jmp    215 <gets+0x5b>
    cc = read(0, &c, 1);
 1c9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1d0:	00 
 1d1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1df:	e8 87 01 00 00       	call   36b <read>
 1e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1eb:	7f 02                	jg     1ef <gets+0x35>
      break;
 1ed:	eb 31                	jmp    220 <gets+0x66>
    buf[i++] = c;
 1ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f2:	8d 50 01             	lea    0x1(%eax),%edx
 1f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1f8:	89 c2                	mov    %eax,%edx
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	01 c2                	add    %eax,%edx
 1ff:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 203:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 205:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 209:	3c 0a                	cmp    $0xa,%al
 20b:	74 13                	je     220 <gets+0x66>
 20d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 211:	3c 0d                	cmp    $0xd,%al
 213:	74 0b                	je     220 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 215:	8b 45 f4             	mov    -0xc(%ebp),%eax
 218:	83 c0 01             	add    $0x1,%eax
 21b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 21e:	7c a9                	jl     1c9 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 220:	8b 55 f4             	mov    -0xc(%ebp),%edx
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	01 d0                	add    %edx,%eax
 228:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 22e:	c9                   	leave  
 22f:	c3                   	ret    

00000230 <stat>:

int
stat(char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 236:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 23d:	00 
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	89 04 24             	mov    %eax,(%esp)
 244:	e8 4a 01 00 00       	call   393 <open>
 249:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 24c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 250:	79 07                	jns    259 <stat+0x29>
    return -1;
 252:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 257:	eb 23                	jmp    27c <stat+0x4c>
  r = fstat(fd, st);
 259:	8b 45 0c             	mov    0xc(%ebp),%eax
 25c:	89 44 24 04          	mov    %eax,0x4(%esp)
 260:	8b 45 f4             	mov    -0xc(%ebp),%eax
 263:	89 04 24             	mov    %eax,(%esp)
 266:	e8 40 01 00 00       	call   3ab <fstat>
 26b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 26e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 271:	89 04 24             	mov    %eax,(%esp)
 274:	e8 02 01 00 00       	call   37b <close>
  return r;
 279:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 27c:	c9                   	leave  
 27d:	c3                   	ret    

0000027e <atoi>:

int
atoi(const char *s)
{
 27e:	55                   	push   %ebp
 27f:	89 e5                	mov    %esp,%ebp
 281:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 284:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 28b:	eb 25                	jmp    2b2 <atoi+0x34>
    n = n*10 + *s++ - '0';
 28d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 290:	89 d0                	mov    %edx,%eax
 292:	c1 e0 02             	shl    $0x2,%eax
 295:	01 d0                	add    %edx,%eax
 297:	01 c0                	add    %eax,%eax
 299:	89 c1                	mov    %eax,%ecx
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	8d 50 01             	lea    0x1(%eax),%edx
 2a1:	89 55 08             	mov    %edx,0x8(%ebp)
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	0f be c0             	movsbl %al,%eax
 2aa:	01 c8                	add    %ecx,%eax
 2ac:	83 e8 30             	sub    $0x30,%eax
 2af:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	0f b6 00             	movzbl (%eax),%eax
 2b8:	3c 2f                	cmp    $0x2f,%al
 2ba:	7e 0a                	jle    2c6 <atoi+0x48>
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	0f b6 00             	movzbl (%eax),%eax
 2c2:	3c 39                	cmp    $0x39,%al
 2c4:	7e c7                	jle    28d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c9:	c9                   	leave  
 2ca:	c3                   	ret    

000002cb <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
 2ce:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2da:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2dd:	eb 17                	jmp    2f6 <memmove+0x2b>
    *dst++ = *src++;
 2df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e2:	8d 50 01             	lea    0x1(%eax),%edx
 2e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2e8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2eb:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ee:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2f1:	0f b6 12             	movzbl (%edx),%edx
 2f4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f6:	8b 45 10             	mov    0x10(%ebp),%eax
 2f9:	8d 50 ff             	lea    -0x1(%eax),%edx
 2fc:	89 55 10             	mov    %edx,0x10(%ebp)
 2ff:	85 c0                	test   %eax,%eax
 301:	7f dc                	jg     2df <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 303:	8b 45 08             	mov    0x8(%ebp),%eax
}
 306:	c9                   	leave  
 307:	c3                   	ret    

00000308 <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 308:	55                   	push   %ebp
 309:	89 e5                	mov    %esp,%ebp
 30b:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 30e:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 315:	e8 bd 04 00 00       	call   7d7 <malloc>
 31a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 31d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 320:	05 fc ff 0f 00       	add    $0xffffc,%eax
 325:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 328:	ba fb 03 00 00       	mov    $0x3fb,%edx
 32d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 330:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 332:	8b 45 f4             	mov    -0xc(%ebp),%eax
 335:	05 fc ff 0f 00       	add    $0xffffc,%eax
 33a:	89 44 24 04          	mov    %eax,0x4(%esp)
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	89 04 24             	mov    %eax,(%esp)
 344:	e8 aa 00 00 00       	call   3f3 <clone>
}
 349:	c9                   	leave  
 34a:	c3                   	ret    

0000034b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34b:	b8 01 00 00 00       	mov    $0x1,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <exit>:
SYSCALL(exit)
 353:	b8 02 00 00 00       	mov    $0x2,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <wait>:
SYSCALL(wait)
 35b:	b8 03 00 00 00       	mov    $0x3,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <pipe>:
SYSCALL(pipe)
 363:	b8 04 00 00 00       	mov    $0x4,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <read>:
SYSCALL(read)
 36b:	b8 05 00 00 00       	mov    $0x5,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <write>:
SYSCALL(write)
 373:	b8 10 00 00 00       	mov    $0x10,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <close>:
SYSCALL(close)
 37b:	b8 15 00 00 00       	mov    $0x15,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <kill>:
SYSCALL(kill)
 383:	b8 06 00 00 00       	mov    $0x6,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <exec>:
SYSCALL(exec)
 38b:	b8 07 00 00 00       	mov    $0x7,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <open>:
SYSCALL(open)
 393:	b8 0f 00 00 00       	mov    $0xf,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <mknod>:
SYSCALL(mknod)
 39b:	b8 11 00 00 00       	mov    $0x11,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <unlink>:
SYSCALL(unlink)
 3a3:	b8 12 00 00 00       	mov    $0x12,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <fstat>:
SYSCALL(fstat)
 3ab:	b8 08 00 00 00       	mov    $0x8,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <link>:
SYSCALL(link)
 3b3:	b8 13 00 00 00       	mov    $0x13,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <mkdir>:
SYSCALL(mkdir)
 3bb:	b8 14 00 00 00       	mov    $0x14,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <chdir>:
SYSCALL(chdir)
 3c3:	b8 09 00 00 00       	mov    $0x9,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <dup>:
SYSCALL(dup)
 3cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <getpid>:
SYSCALL(getpid)
 3d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <sbrk>:
SYSCALL(sbrk)
 3db:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <sleep>:
SYSCALL(sleep)
 3e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <uptime>:
SYSCALL(uptime)
 3eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <clone>:
SYSCALL(clone)
 3f3:	b8 16 00 00 00       	mov    $0x16,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <thread_exit>:
SYSCALL(thread_exit)
 3fb:	b8 17 00 00 00       	mov    $0x17,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <thread_join>:
SYSCALL(thread_join)
 403:	b8 18 00 00 00       	mov    $0x18,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 40b:	55                   	push   %ebp
 40c:	89 e5                	mov    %esp,%ebp
 40e:	83 ec 18             	sub    $0x18,%esp
 411:	8b 45 0c             	mov    0xc(%ebp),%eax
 414:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 417:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 41e:	00 
 41f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 422:	89 44 24 04          	mov    %eax,0x4(%esp)
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	89 04 24             	mov    %eax,(%esp)
 42c:	e8 42 ff ff ff       	call   373 <write>
}
 431:	c9                   	leave  
 432:	c3                   	ret    

00000433 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp
 436:	56                   	push   %esi
 437:	53                   	push   %ebx
 438:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 43b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 442:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 446:	74 17                	je     45f <printint+0x2c>
 448:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 44c:	79 11                	jns    45f <printint+0x2c>
    neg = 1;
 44e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 455:	8b 45 0c             	mov    0xc(%ebp),%eax
 458:	f7 d8                	neg    %eax
 45a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45d:	eb 06                	jmp    465 <printint+0x32>
  } else {
    x = xx;
 45f:	8b 45 0c             	mov    0xc(%ebp),%eax
 462:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 465:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 46c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 46f:	8d 41 01             	lea    0x1(%ecx),%eax
 472:	89 45 f4             	mov    %eax,-0xc(%ebp)
 475:	8b 5d 10             	mov    0x10(%ebp),%ebx
 478:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47b:	ba 00 00 00 00       	mov    $0x0,%edx
 480:	f7 f3                	div    %ebx
 482:	89 d0                	mov    %edx,%eax
 484:	0f b6 80 64 0b 00 00 	movzbl 0xb64(%eax),%eax
 48b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 48f:	8b 75 10             	mov    0x10(%ebp),%esi
 492:	8b 45 ec             	mov    -0x14(%ebp),%eax
 495:	ba 00 00 00 00       	mov    $0x0,%edx
 49a:	f7 f6                	div    %esi
 49c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a3:	75 c7                	jne    46c <printint+0x39>
  if(neg)
 4a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a9:	74 10                	je     4bb <printint+0x88>
    buf[i++] = '-';
 4ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ae:	8d 50 01             	lea    0x1(%eax),%edx
 4b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b9:	eb 1f                	jmp    4da <printint+0xa7>
 4bb:	eb 1d                	jmp    4da <printint+0xa7>
    putc(fd, buf[i]);
 4bd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c3:	01 d0                	add    %edx,%eax
 4c5:	0f b6 00             	movzbl (%eax),%eax
 4c8:	0f be c0             	movsbl %al,%eax
 4cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cf:	8b 45 08             	mov    0x8(%ebp),%eax
 4d2:	89 04 24             	mov    %eax,(%esp)
 4d5:	e8 31 ff ff ff       	call   40b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4da:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e2:	79 d9                	jns    4bd <printint+0x8a>
    putc(fd, buf[i]);
}
 4e4:	83 c4 30             	add    $0x30,%esp
 4e7:	5b                   	pop    %ebx
 4e8:	5e                   	pop    %esi
 4e9:	5d                   	pop    %ebp
 4ea:	c3                   	ret    

000004eb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4eb:	55                   	push   %ebp
 4ec:	89 e5                	mov    %esp,%ebp
 4ee:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f8:	8d 45 0c             	lea    0xc(%ebp),%eax
 4fb:	83 c0 04             	add    $0x4,%eax
 4fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 508:	e9 7c 01 00 00       	jmp    689 <printf+0x19e>
    c = fmt[i] & 0xff;
 50d:	8b 55 0c             	mov    0xc(%ebp),%edx
 510:	8b 45 f0             	mov    -0x10(%ebp),%eax
 513:	01 d0                	add    %edx,%eax
 515:	0f b6 00             	movzbl (%eax),%eax
 518:	0f be c0             	movsbl %al,%eax
 51b:	25 ff 00 00 00       	and    $0xff,%eax
 520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 523:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 527:	75 2c                	jne    555 <printf+0x6a>
      if(c == '%'){
 529:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 52d:	75 0c                	jne    53b <printf+0x50>
        state = '%';
 52f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 536:	e9 4a 01 00 00       	jmp    685 <printf+0x19a>
      } else {
        putc(fd, c);
 53b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53e:	0f be c0             	movsbl %al,%eax
 541:	89 44 24 04          	mov    %eax,0x4(%esp)
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	89 04 24             	mov    %eax,(%esp)
 54b:	e8 bb fe ff ff       	call   40b <putc>
 550:	e9 30 01 00 00       	jmp    685 <printf+0x19a>
      }
    } else if(state == '%'){
 555:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 559:	0f 85 26 01 00 00    	jne    685 <printf+0x19a>
      if(c == 'd'){
 55f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 563:	75 2d                	jne    592 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 565:	8b 45 e8             	mov    -0x18(%ebp),%eax
 568:	8b 00                	mov    (%eax),%eax
 56a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 571:	00 
 572:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 579:	00 
 57a:	89 44 24 04          	mov    %eax,0x4(%esp)
 57e:	8b 45 08             	mov    0x8(%ebp),%eax
 581:	89 04 24             	mov    %eax,(%esp)
 584:	e8 aa fe ff ff       	call   433 <printint>
        ap++;
 589:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58d:	e9 ec 00 00 00       	jmp    67e <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 592:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 596:	74 06                	je     59e <printf+0xb3>
 598:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 59c:	75 2d                	jne    5cb <printf+0xe0>
        printint(fd, *ap, 16, 0);
 59e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a1:	8b 00                	mov    (%eax),%eax
 5a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5aa:	00 
 5ab:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5b2:	00 
 5b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 71 fe ff ff       	call   433 <printint>
        ap++;
 5c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c6:	e9 b3 00 00 00       	jmp    67e <printf+0x193>
      } else if(c == 's'){
 5cb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5cf:	75 45                	jne    616 <printf+0x12b>
        s = (char*)*ap;
 5d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d4:	8b 00                	mov    (%eax),%eax
 5d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e1:	75 09                	jne    5ec <printf+0x101>
          s = "(null)";
 5e3:	c7 45 f4 d4 08 00 00 	movl   $0x8d4,-0xc(%ebp)
        while(*s != 0){
 5ea:	eb 1e                	jmp    60a <printf+0x11f>
 5ec:	eb 1c                	jmp    60a <printf+0x11f>
          putc(fd, *s);
 5ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f1:	0f b6 00             	movzbl (%eax),%eax
 5f4:	0f be c0             	movsbl %al,%eax
 5f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fb:	8b 45 08             	mov    0x8(%ebp),%eax
 5fe:	89 04 24             	mov    %eax,(%esp)
 601:	e8 05 fe ff ff       	call   40b <putc>
          s++;
 606:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 60a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60d:	0f b6 00             	movzbl (%eax),%eax
 610:	84 c0                	test   %al,%al
 612:	75 da                	jne    5ee <printf+0x103>
 614:	eb 68                	jmp    67e <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 616:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 61a:	75 1d                	jne    639 <printf+0x14e>
        putc(fd, *ap);
 61c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	0f be c0             	movsbl %al,%eax
 624:	89 44 24 04          	mov    %eax,0x4(%esp)
 628:	8b 45 08             	mov    0x8(%ebp),%eax
 62b:	89 04 24             	mov    %eax,(%esp)
 62e:	e8 d8 fd ff ff       	call   40b <putc>
        ap++;
 633:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 637:	eb 45                	jmp    67e <printf+0x193>
      } else if(c == '%'){
 639:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 63d:	75 17                	jne    656 <printf+0x16b>
        putc(fd, c);
 63f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 642:	0f be c0             	movsbl %al,%eax
 645:	89 44 24 04          	mov    %eax,0x4(%esp)
 649:	8b 45 08             	mov    0x8(%ebp),%eax
 64c:	89 04 24             	mov    %eax,(%esp)
 64f:	e8 b7 fd ff ff       	call   40b <putc>
 654:	eb 28                	jmp    67e <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 656:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 65d:	00 
 65e:	8b 45 08             	mov    0x8(%ebp),%eax
 661:	89 04 24             	mov    %eax,(%esp)
 664:	e8 a2 fd ff ff       	call   40b <putc>
        putc(fd, c);
 669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66c:	0f be c0             	movsbl %al,%eax
 66f:	89 44 24 04          	mov    %eax,0x4(%esp)
 673:	8b 45 08             	mov    0x8(%ebp),%eax
 676:	89 04 24             	mov    %eax,(%esp)
 679:	e8 8d fd ff ff       	call   40b <putc>
      }
      state = 0;
 67e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 685:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 689:	8b 55 0c             	mov    0xc(%ebp),%edx
 68c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 68f:	01 d0                	add    %edx,%eax
 691:	0f b6 00             	movzbl (%eax),%eax
 694:	84 c0                	test   %al,%al
 696:	0f 85 71 fe ff ff    	jne    50d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 69c:	c9                   	leave  
 69d:	c3                   	ret    

0000069e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69e:	55                   	push   %ebp
 69f:	89 e5                	mov    %esp,%ebp
 6a1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	83 e8 08             	sub    $0x8,%eax
 6aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ad:	a1 80 0b 00 00       	mov    0xb80,%eax
 6b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b5:	eb 24                	jmp    6db <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bf:	77 12                	ja     6d3 <free+0x35>
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c7:	77 24                	ja     6ed <free+0x4f>
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d1:	77 1a                	ja     6ed <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 00                	mov    (%eax),%eax
 6d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e1:	76 d4                	jbe    6b7 <free+0x19>
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6eb:	76 ca                	jbe    6b7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	8b 40 04             	mov    0x4(%eax),%eax
 6f3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	01 c2                	add    %eax,%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	39 c2                	cmp    %eax,%edx
 706:	75 24                	jne    72c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 708:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70b:	8b 50 04             	mov    0x4(%eax),%edx
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 00                	mov    (%eax),%eax
 713:	8b 40 04             	mov    0x4(%eax),%eax
 716:	01 c2                	add    %eax,%edx
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	8b 10                	mov    (%eax),%edx
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	89 10                	mov    %edx,(%eax)
 72a:	eb 0a                	jmp    736 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 10                	mov    (%eax),%edx
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 40 04             	mov    0x4(%eax),%eax
 73c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	01 d0                	add    %edx,%eax
 748:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74b:	75 20                	jne    76d <free+0xcf>
    p->s.size += bp->s.size;
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 50 04             	mov    0x4(%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	8b 40 04             	mov    0x4(%eax),%eax
 759:	01 c2                	add    %eax,%edx
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	8b 10                	mov    (%eax),%edx
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	89 10                	mov    %edx,(%eax)
 76b:	eb 08                	jmp    775 <free+0xd7>
  } else
    p->s.ptr = bp;
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 55 f8             	mov    -0x8(%ebp),%edx
 773:	89 10                	mov    %edx,(%eax)
  freep = p;
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	a3 80 0b 00 00       	mov    %eax,0xb80
}
 77d:	c9                   	leave  
 77e:	c3                   	ret    

0000077f <morecore>:

static Header*
morecore(uint nu)
{
 77f:	55                   	push   %ebp
 780:	89 e5                	mov    %esp,%ebp
 782:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 785:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 78c:	77 07                	ja     795 <morecore+0x16>
    nu = 4096;
 78e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 795:	8b 45 08             	mov    0x8(%ebp),%eax
 798:	c1 e0 03             	shl    $0x3,%eax
 79b:	89 04 24             	mov    %eax,(%esp)
 79e:	e8 38 fc ff ff       	call   3db <sbrk>
 7a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7a6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7aa:	75 07                	jne    7b3 <morecore+0x34>
    return 0;
 7ac:	b8 00 00 00 00       	mov    $0x0,%eax
 7b1:	eb 22                	jmp    7d5 <morecore+0x56>
  hp = (Header*)p;
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bc:	8b 55 08             	mov    0x8(%ebp),%edx
 7bf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c5:	83 c0 08             	add    $0x8,%eax
 7c8:	89 04 24             	mov    %eax,(%esp)
 7cb:	e8 ce fe ff ff       	call   69e <free>
  return freep;
 7d0:	a1 80 0b 00 00       	mov    0xb80,%eax
}
 7d5:	c9                   	leave  
 7d6:	c3                   	ret    

000007d7 <malloc>:

void*
malloc(uint nbytes)
{
 7d7:	55                   	push   %ebp
 7d8:	89 e5                	mov    %esp,%ebp
 7da:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7dd:	8b 45 08             	mov    0x8(%ebp),%eax
 7e0:	83 c0 07             	add    $0x7,%eax
 7e3:	c1 e8 03             	shr    $0x3,%eax
 7e6:	83 c0 01             	add    $0x1,%eax
 7e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ec:	a1 80 0b 00 00       	mov    0xb80,%eax
 7f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f8:	75 23                	jne    81d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7fa:	c7 45 f0 78 0b 00 00 	movl   $0xb78,-0x10(%ebp)
 801:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804:	a3 80 0b 00 00       	mov    %eax,0xb80
 809:	a1 80 0b 00 00       	mov    0xb80,%eax
 80e:	a3 78 0b 00 00       	mov    %eax,0xb78
    base.s.size = 0;
 813:	c7 05 7c 0b 00 00 00 	movl   $0x0,0xb7c
 81a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	8b 00                	mov    (%eax),%eax
 822:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 828:	8b 40 04             	mov    0x4(%eax),%eax
 82b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 82e:	72 4d                	jb     87d <malloc+0xa6>
      if(p->s.size == nunits)
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8b 40 04             	mov    0x4(%eax),%eax
 836:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 839:	75 0c                	jne    847 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	8b 10                	mov    (%eax),%edx
 840:	8b 45 f0             	mov    -0x10(%ebp),%eax
 843:	89 10                	mov    %edx,(%eax)
 845:	eb 26                	jmp    86d <malloc+0x96>
      else {
        p->s.size -= nunits;
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 850:	89 c2                	mov    %eax,%edx
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 858:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85b:	8b 40 04             	mov    0x4(%eax),%eax
 85e:	c1 e0 03             	shl    $0x3,%eax
 861:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 55 ec             	mov    -0x14(%ebp),%edx
 86a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 86d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 870:	a3 80 0b 00 00       	mov    %eax,0xb80
      return (void*)(p + 1);
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	83 c0 08             	add    $0x8,%eax
 87b:	eb 38                	jmp    8b5 <malloc+0xde>
    }
    if(p == freep)
 87d:	a1 80 0b 00 00       	mov    0xb80,%eax
 882:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 885:	75 1b                	jne    8a2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 887:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88a:	89 04 24             	mov    %eax,(%esp)
 88d:	e8 ed fe ff ff       	call   77f <morecore>
 892:	89 45 f4             	mov    %eax,-0xc(%ebp)
 895:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 899:	75 07                	jne    8a2 <malloc+0xcb>
        return 0;
 89b:	b8 00 00 00 00       	mov    $0x0,%eax
 8a0:	eb 13                	jmp    8b5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ab:	8b 00                	mov    (%eax),%eax
 8ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8b0:	e9 70 ff ff ff       	jmp    825 <malloc+0x4e>
}
 8b5:	c9                   	leave  
 8b6:	c3                   	ret    
