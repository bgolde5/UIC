
_thread4:     file format elf32-i386


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
   8:	a1 34 0b 00 00       	mov    0xb34,%eax
   d:	83 c0 01             	add    $0x1,%eax
  10:	a3 34 0b 00 00       	mov    %eax,0xb34
  15:	a1 34 0b 00 00       	mov    0xb34,%eax
  1a:	3d 7f 96 98 00       	cmp    $0x98967f,%eax
  1f:	7e e7                	jle    8 <f+0x8>
  printf(1,"Done looping\n");
  21:	c7 44 24 04 8d 08 00 	movl   $0x88d,0x4(%esp)
  28:	00 
  29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  30:	e8 8c 04 00 00       	call   4c1 <printf>
}
  35:	c9                   	leave  
  36:	c3                   	ret    

00000037 <main>:

int main(int argc, char** argv) {
  37:	55                   	push   %ebp
  38:	89 e5                	mov    %esp,%ebp
  3a:	83 e4 f0             	and    $0xfffffff0,%esp
  3d:	83 ec 20             	sub    $0x20,%esp
  int t = thread_create(f);
  40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  47:	e8 92 02 00 00       	call   2de <thread_create>
  4c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  thread_join(t);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 7d 03 00 00       	call   3d9 <thread_join>
  printf(1,"shared = %d\n",shared);
  5c:	a1 34 0b 00 00       	mov    0xb34,%eax
  61:	89 44 24 08          	mov    %eax,0x8(%esp)
  65:	c7 44 24 04 9b 08 00 	movl   $0x89b,0x4(%esp)
  6c:	00 
  6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  74:	e8 48 04 00 00       	call   4c1 <printf>

  exit();
  79:	e8 ab 02 00 00       	call   329 <exit>

0000007e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	57                   	push   %edi
  82:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  86:	8b 55 10             	mov    0x10(%ebp),%edx
  89:	8b 45 0c             	mov    0xc(%ebp),%eax
  8c:	89 cb                	mov    %ecx,%ebx
  8e:	89 df                	mov    %ebx,%edi
  90:	89 d1                	mov    %edx,%ecx
  92:	fc                   	cld    
  93:	f3 aa                	rep stos %al,%es:(%edi)
  95:	89 ca                	mov    %ecx,%edx
  97:	89 fb                	mov    %edi,%ebx
  99:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9f:	5b                   	pop    %ebx
  a0:	5f                   	pop    %edi
  a1:	5d                   	pop    %ebp
  a2:	c3                   	ret    

000000a3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a3:	55                   	push   %ebp
  a4:	89 e5                	mov    %esp,%ebp
  a6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  af:	90                   	nop
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	8d 50 01             	lea    0x1(%eax),%edx
  b6:	89 55 08             	mov    %edx,0x8(%ebp)
  b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  c2:	0f b6 12             	movzbl (%edx),%edx
  c5:	88 10                	mov    %dl,(%eax)
  c7:	0f b6 00             	movzbl (%eax),%eax
  ca:	84 c0                	test   %al,%al
  cc:	75 e2                	jne    b0 <strcpy+0xd>
    ;
  return os;
  ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d1:	c9                   	leave  
  d2:	c3                   	ret    

000000d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d6:	eb 08                	jmp    e0 <strcmp+0xd>
    p++, q++;
  d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  dc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	0f b6 00             	movzbl (%eax),%eax
  e6:	84 c0                	test   %al,%al
  e8:	74 10                	je     fa <strcmp+0x27>
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	0f b6 10             	movzbl (%eax),%edx
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	38 c2                	cmp    %al,%dl
  f8:	74 de                	je     d8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 d0             	movzbl %al,%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	0f b6 c0             	movzbl %al,%eax
 10c:	29 c2                	sub    %eax,%edx
 10e:	89 d0                	mov    %edx,%eax
}
 110:	5d                   	pop    %ebp
 111:	c3                   	ret    

00000112 <strlen>:

uint
strlen(char *s)
{
 112:	55                   	push   %ebp
 113:	89 e5                	mov    %esp,%ebp
 115:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 11f:	eb 04                	jmp    125 <strlen+0x13>
 121:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 125:	8b 55 fc             	mov    -0x4(%ebp),%edx
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	01 d0                	add    %edx,%eax
 12d:	0f b6 00             	movzbl (%eax),%eax
 130:	84 c0                	test   %al,%al
 132:	75 ed                	jne    121 <strlen+0xf>
    ;
  return n;
 134:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 137:	c9                   	leave  
 138:	c3                   	ret    

00000139 <memset>:

void*
memset(void *dst, int c, uint n)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 13f:	8b 45 10             	mov    0x10(%ebp),%eax
 142:	89 44 24 08          	mov    %eax,0x8(%esp)
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	89 44 24 04          	mov    %eax,0x4(%esp)
 14d:	8b 45 08             	mov    0x8(%ebp),%eax
 150:	89 04 24             	mov    %eax,(%esp)
 153:	e8 26 ff ff ff       	call   7e <stosb>
  return dst;
 158:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15b:	c9                   	leave  
 15c:	c3                   	ret    

0000015d <strchr>:

char*
strchr(const char *s, char c)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	83 ec 04             	sub    $0x4,%esp
 163:	8b 45 0c             	mov    0xc(%ebp),%eax
 166:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 169:	eb 14                	jmp    17f <strchr+0x22>
    if(*s == c)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 00             	movzbl (%eax),%eax
 171:	3a 45 fc             	cmp    -0x4(%ebp),%al
 174:	75 05                	jne    17b <strchr+0x1e>
      return (char*)s;
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	eb 13                	jmp    18e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	84 c0                	test   %al,%al
 187:	75 e2                	jne    16b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 189:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18e:	c9                   	leave  
 18f:	c3                   	ret    

00000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 19d:	eb 4c                	jmp    1eb <gets+0x5b>
    cc = read(0, &c, 1);
 19f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a6:	00 
 1a7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b5:	e8 87 01 00 00       	call   341 <read>
 1ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c1:	7f 02                	jg     1c5 <gets+0x35>
      break;
 1c3:	eb 31                	jmp    1f6 <gets+0x66>
    buf[i++] = c;
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	8d 50 01             	lea    0x1(%eax),%edx
 1cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ce:	89 c2                	mov    %eax,%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 c2                	add    %eax,%edx
 1d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1db:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1df:	3c 0a                	cmp    $0xa,%al
 1e1:	74 13                	je     1f6 <gets+0x66>
 1e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e7:	3c 0d                	cmp    $0xd,%al
 1e9:	74 0b                	je     1f6 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ee:	83 c0 01             	add    $0x1,%eax
 1f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f4:	7c a9                	jl     19f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	01 d0                	add    %edx,%eax
 1fe:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 201:	8b 45 08             	mov    0x8(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <stat>:

int
stat(char *n, struct stat *st)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 213:	00 
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	89 04 24             	mov    %eax,(%esp)
 21a:	e8 4a 01 00 00       	call   369 <open>
 21f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 226:	79 07                	jns    22f <stat+0x29>
    return -1;
 228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22d:	eb 23                	jmp    252 <stat+0x4c>
  r = fstat(fd, st);
 22f:	8b 45 0c             	mov    0xc(%ebp),%eax
 232:	89 44 24 04          	mov    %eax,0x4(%esp)
 236:	8b 45 f4             	mov    -0xc(%ebp),%eax
 239:	89 04 24             	mov    %eax,(%esp)
 23c:	e8 40 01 00 00       	call   381 <fstat>
 241:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 244:	8b 45 f4             	mov    -0xc(%ebp),%eax
 247:	89 04 24             	mov    %eax,(%esp)
 24a:	e8 02 01 00 00       	call   351 <close>
  return r;
 24f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 252:	c9                   	leave  
 253:	c3                   	ret    

00000254 <atoi>:

int
atoi(const char *s)
{
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 261:	eb 25                	jmp    288 <atoi+0x34>
    n = n*10 + *s++ - '0';
 263:	8b 55 fc             	mov    -0x4(%ebp),%edx
 266:	89 d0                	mov    %edx,%eax
 268:	c1 e0 02             	shl    $0x2,%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	01 c0                	add    %eax,%eax
 26f:	89 c1                	mov    %eax,%ecx
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	8d 50 01             	lea    0x1(%eax),%edx
 277:	89 55 08             	mov    %edx,0x8(%ebp)
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	0f be c0             	movsbl %al,%eax
 280:	01 c8                	add    %ecx,%eax
 282:	83 e8 30             	sub    $0x30,%eax
 285:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	3c 2f                	cmp    $0x2f,%al
 290:	7e 0a                	jle    29c <atoi+0x48>
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	0f b6 00             	movzbl (%eax),%eax
 298:	3c 39                	cmp    $0x39,%al
 29a:	7e c7                	jle    263 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29f:	c9                   	leave  
 2a0:	c3                   	ret    

000002a1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a1:	55                   	push   %ebp
 2a2:	89 e5                	mov    %esp,%ebp
 2a4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b3:	eb 17                	jmp    2cc <memmove+0x2b>
    *dst++ = *src++;
 2b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b8:	8d 50 01             	lea    0x1(%eax),%edx
 2bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2be:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c1:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c7:	0f b6 12             	movzbl (%edx),%edx
 2ca:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2cc:	8b 45 10             	mov    0x10(%ebp),%eax
 2cf:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d2:	89 55 10             	mov    %edx,0x10(%ebp)
 2d5:	85 c0                	test   %eax,%eax
 2d7:	7f dc                	jg     2b5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 2e4:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 2eb:	e8 bd 04 00 00       	call   7ad <malloc>
 2f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 2f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f6:	05 fc ff 0f 00       	add    $0xffffc,%eax
 2fb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 2fe:	ba d1 03 00 00       	mov    $0x3d1,%edx
 303:	8b 45 f0             	mov    -0x10(%ebp),%eax
 306:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 308:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30b:	05 fc ff 0f 00       	add    $0xffffc,%eax
 310:	89 44 24 04          	mov    %eax,0x4(%esp)
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	89 04 24             	mov    %eax,(%esp)
 31a:	e8 aa 00 00 00       	call   3c9 <clone>
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 321:	b8 01 00 00 00       	mov    $0x1,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <exit>:
SYSCALL(exit)
 329:	b8 02 00 00 00       	mov    $0x2,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <wait>:
SYSCALL(wait)
 331:	b8 03 00 00 00       	mov    $0x3,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <pipe>:
SYSCALL(pipe)
 339:	b8 04 00 00 00       	mov    $0x4,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <read>:
SYSCALL(read)
 341:	b8 05 00 00 00       	mov    $0x5,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <write>:
SYSCALL(write)
 349:	b8 10 00 00 00       	mov    $0x10,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <close>:
SYSCALL(close)
 351:	b8 15 00 00 00       	mov    $0x15,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <kill>:
SYSCALL(kill)
 359:	b8 06 00 00 00       	mov    $0x6,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <exec>:
SYSCALL(exec)
 361:	b8 07 00 00 00       	mov    $0x7,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <open>:
SYSCALL(open)
 369:	b8 0f 00 00 00       	mov    $0xf,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <mknod>:
SYSCALL(mknod)
 371:	b8 11 00 00 00       	mov    $0x11,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <unlink>:
SYSCALL(unlink)
 379:	b8 12 00 00 00       	mov    $0x12,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <fstat>:
SYSCALL(fstat)
 381:	b8 08 00 00 00       	mov    $0x8,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <link>:
SYSCALL(link)
 389:	b8 13 00 00 00       	mov    $0x13,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <mkdir>:
SYSCALL(mkdir)
 391:	b8 14 00 00 00       	mov    $0x14,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <chdir>:
SYSCALL(chdir)
 399:	b8 09 00 00 00       	mov    $0x9,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <dup>:
SYSCALL(dup)
 3a1:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <getpid>:
SYSCALL(getpid)
 3a9:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <sbrk>:
SYSCALL(sbrk)
 3b1:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <sleep>:
SYSCALL(sleep)
 3b9:	b8 0d 00 00 00       	mov    $0xd,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <uptime>:
SYSCALL(uptime)
 3c1:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <clone>:
SYSCALL(clone)
 3c9:	b8 16 00 00 00       	mov    $0x16,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <thread_exit>:
SYSCALL(thread_exit)
 3d1:	b8 17 00 00 00       	mov    $0x17,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <thread_join>:
SYSCALL(thread_join)
 3d9:	b8 18 00 00 00       	mov    $0x18,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e1:	55                   	push   %ebp
 3e2:	89 e5                	mov    %esp,%ebp
 3e4:	83 ec 18             	sub    $0x18,%esp
 3e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ea:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3f4:	00 
 3f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	89 04 24             	mov    %eax,(%esp)
 402:	e8 42 ff ff ff       	call   349 <write>
}
 407:	c9                   	leave  
 408:	c3                   	ret    

00000409 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	56                   	push   %esi
 40d:	53                   	push   %ebx
 40e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 411:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 418:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 41c:	74 17                	je     435 <printint+0x2c>
 41e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 422:	79 11                	jns    435 <printint+0x2c>
    neg = 1;
 424:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 42b:	8b 45 0c             	mov    0xc(%ebp),%eax
 42e:	f7 d8                	neg    %eax
 430:	89 45 ec             	mov    %eax,-0x14(%ebp)
 433:	eb 06                	jmp    43b <printint+0x32>
  } else {
    x = xx;
 435:	8b 45 0c             	mov    0xc(%ebp),%eax
 438:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 43b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 442:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 445:	8d 41 01             	lea    0x1(%ecx),%eax
 448:	89 45 f4             	mov    %eax,-0xc(%ebp)
 44b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 44e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 451:	ba 00 00 00 00       	mov    $0x0,%edx
 456:	f7 f3                	div    %ebx
 458:	89 d0                	mov    %edx,%eax
 45a:	0f b6 80 38 0b 00 00 	movzbl 0xb38(%eax),%eax
 461:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 465:	8b 75 10             	mov    0x10(%ebp),%esi
 468:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46b:	ba 00 00 00 00       	mov    $0x0,%edx
 470:	f7 f6                	div    %esi
 472:	89 45 ec             	mov    %eax,-0x14(%ebp)
 475:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 479:	75 c7                	jne    442 <printint+0x39>
  if(neg)
 47b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47f:	74 10                	je     491 <printint+0x88>
    buf[i++] = '-';
 481:	8b 45 f4             	mov    -0xc(%ebp),%eax
 484:	8d 50 01             	lea    0x1(%eax),%edx
 487:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 48f:	eb 1f                	jmp    4b0 <printint+0xa7>
 491:	eb 1d                	jmp    4b0 <printint+0xa7>
    putc(fd, buf[i]);
 493:	8d 55 dc             	lea    -0x24(%ebp),%edx
 496:	8b 45 f4             	mov    -0xc(%ebp),%eax
 499:	01 d0                	add    %edx,%eax
 49b:	0f b6 00             	movzbl (%eax),%eax
 49e:	0f be c0             	movsbl %al,%eax
 4a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	89 04 24             	mov    %eax,(%esp)
 4ab:	e8 31 ff ff ff       	call   3e1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4b0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b8:	79 d9                	jns    493 <printint+0x8a>
    putc(fd, buf[i]);
}
 4ba:	83 c4 30             	add    $0x30,%esp
 4bd:	5b                   	pop    %ebx
 4be:	5e                   	pop    %esi
 4bf:	5d                   	pop    %ebp
 4c0:	c3                   	ret    

000004c1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c1:	55                   	push   %ebp
 4c2:	89 e5                	mov    %esp,%ebp
 4c4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ce:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d1:	83 c0 04             	add    $0x4,%eax
 4d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4de:	e9 7c 01 00 00       	jmp    65f <printf+0x19e>
    c = fmt[i] & 0xff;
 4e3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e9:	01 d0                	add    %edx,%eax
 4eb:	0f b6 00             	movzbl (%eax),%eax
 4ee:	0f be c0             	movsbl %al,%eax
 4f1:	25 ff 00 00 00       	and    $0xff,%eax
 4f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4fd:	75 2c                	jne    52b <printf+0x6a>
      if(c == '%'){
 4ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 503:	75 0c                	jne    511 <printf+0x50>
        state = '%';
 505:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 50c:	e9 4a 01 00 00       	jmp    65b <printf+0x19a>
      } else {
        putc(fd, c);
 511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 514:	0f be c0             	movsbl %al,%eax
 517:	89 44 24 04          	mov    %eax,0x4(%esp)
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	89 04 24             	mov    %eax,(%esp)
 521:	e8 bb fe ff ff       	call   3e1 <putc>
 526:	e9 30 01 00 00       	jmp    65b <printf+0x19a>
      }
    } else if(state == '%'){
 52b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 52f:	0f 85 26 01 00 00    	jne    65b <printf+0x19a>
      if(c == 'd'){
 535:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 539:	75 2d                	jne    568 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 53b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53e:	8b 00                	mov    (%eax),%eax
 540:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 547:	00 
 548:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 54f:	00 
 550:	89 44 24 04          	mov    %eax,0x4(%esp)
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	89 04 24             	mov    %eax,(%esp)
 55a:	e8 aa fe ff ff       	call   409 <printint>
        ap++;
 55f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 563:	e9 ec 00 00 00       	jmp    654 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 568:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 56c:	74 06                	je     574 <printf+0xb3>
 56e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 572:	75 2d                	jne    5a1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 574:	8b 45 e8             	mov    -0x18(%ebp),%eax
 577:	8b 00                	mov    (%eax),%eax
 579:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 580:	00 
 581:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 588:	00 
 589:	89 44 24 04          	mov    %eax,0x4(%esp)
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	89 04 24             	mov    %eax,(%esp)
 593:	e8 71 fe ff ff       	call   409 <printint>
        ap++;
 598:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59c:	e9 b3 00 00 00       	jmp    654 <printf+0x193>
      } else if(c == 's'){
 5a1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a5:	75 45                	jne    5ec <printf+0x12b>
        s = (char*)*ap;
 5a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5aa:	8b 00                	mov    (%eax),%eax
 5ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b7:	75 09                	jne    5c2 <printf+0x101>
          s = "(null)";
 5b9:	c7 45 f4 a8 08 00 00 	movl   $0x8a8,-0xc(%ebp)
        while(*s != 0){
 5c0:	eb 1e                	jmp    5e0 <printf+0x11f>
 5c2:	eb 1c                	jmp    5e0 <printf+0x11f>
          putc(fd, *s);
 5c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c7:	0f b6 00             	movzbl (%eax),%eax
 5ca:	0f be c0             	movsbl %al,%eax
 5cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	89 04 24             	mov    %eax,(%esp)
 5d7:	e8 05 fe ff ff       	call   3e1 <putc>
          s++;
 5dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e3:	0f b6 00             	movzbl (%eax),%eax
 5e6:	84 c0                	test   %al,%al
 5e8:	75 da                	jne    5c4 <printf+0x103>
 5ea:	eb 68                	jmp    654 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ec:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5f0:	75 1d                	jne    60f <printf+0x14e>
        putc(fd, *ap);
 5f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f5:	8b 00                	mov    (%eax),%eax
 5f7:	0f be c0             	movsbl %al,%eax
 5fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	89 04 24             	mov    %eax,(%esp)
 604:	e8 d8 fd ff ff       	call   3e1 <putc>
        ap++;
 609:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60d:	eb 45                	jmp    654 <printf+0x193>
      } else if(c == '%'){
 60f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 613:	75 17                	jne    62c <printf+0x16b>
        putc(fd, c);
 615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 618:	0f be c0             	movsbl %al,%eax
 61b:	89 44 24 04          	mov    %eax,0x4(%esp)
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	89 04 24             	mov    %eax,(%esp)
 625:	e8 b7 fd ff ff       	call   3e1 <putc>
 62a:	eb 28                	jmp    654 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 633:	00 
 634:	8b 45 08             	mov    0x8(%ebp),%eax
 637:	89 04 24             	mov    %eax,(%esp)
 63a:	e8 a2 fd ff ff       	call   3e1 <putc>
        putc(fd, c);
 63f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 642:	0f be c0             	movsbl %al,%eax
 645:	89 44 24 04          	mov    %eax,0x4(%esp)
 649:	8b 45 08             	mov    0x8(%ebp),%eax
 64c:	89 04 24             	mov    %eax,(%esp)
 64f:	e8 8d fd ff ff       	call   3e1 <putc>
      }
      state = 0;
 654:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 65b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65f:	8b 55 0c             	mov    0xc(%ebp),%edx
 662:	8b 45 f0             	mov    -0x10(%ebp),%eax
 665:	01 d0                	add    %edx,%eax
 667:	0f b6 00             	movzbl (%eax),%eax
 66a:	84 c0                	test   %al,%al
 66c:	0f 85 71 fe ff ff    	jne    4e3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 672:	c9                   	leave  
 673:	c3                   	ret    

00000674 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 674:	55                   	push   %ebp
 675:	89 e5                	mov    %esp,%ebp
 677:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67a:	8b 45 08             	mov    0x8(%ebp),%eax
 67d:	83 e8 08             	sub    $0x8,%eax
 680:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 683:	a1 54 0b 00 00       	mov    0xb54,%eax
 688:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68b:	eb 24                	jmp    6b1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 695:	77 12                	ja     6a9 <free+0x35>
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69d:	77 24                	ja     6c3 <free+0x4f>
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a7:	77 1a                	ja     6c3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b7:	76 d4                	jbe    68d <free+0x19>
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c1:	76 ca                	jbe    68d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	8b 40 04             	mov    0x4(%eax),%eax
 6c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	01 c2                	add    %eax,%edx
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	39 c2                	cmp    %eax,%edx
 6dc:	75 24                	jne    702 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	8b 50 04             	mov    0x4(%eax),%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	8b 40 04             	mov    0x4(%eax),%eax
 6ec:	01 c2                	add    %eax,%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	8b 10                	mov    (%eax),%edx
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	89 10                	mov    %edx,(%eax)
 700:	eb 0a                	jmp    70c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 10                	mov    (%eax),%edx
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 40 04             	mov    0x4(%eax),%eax
 712:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	01 d0                	add    %edx,%eax
 71e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 721:	75 20                	jne    743 <free+0xcf>
    p->s.size += bp->s.size;
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 50 04             	mov    0x4(%eax),%edx
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	8b 40 04             	mov    0x4(%eax),%eax
 72f:	01 c2                	add    %eax,%edx
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	8b 10                	mov    (%eax),%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	89 10                	mov    %edx,(%eax)
 741:	eb 08                	jmp    74b <free+0xd7>
  } else
    p->s.ptr = bp;
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 55 f8             	mov    -0x8(%ebp),%edx
 749:	89 10                	mov    %edx,(%eax)
  freep = p;
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	a3 54 0b 00 00       	mov    %eax,0xb54
}
 753:	c9                   	leave  
 754:	c3                   	ret    

00000755 <morecore>:

static Header*
morecore(uint nu)
{
 755:	55                   	push   %ebp
 756:	89 e5                	mov    %esp,%ebp
 758:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 75b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 762:	77 07                	ja     76b <morecore+0x16>
    nu = 4096;
 764:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	c1 e0 03             	shl    $0x3,%eax
 771:	89 04 24             	mov    %eax,(%esp)
 774:	e8 38 fc ff ff       	call   3b1 <sbrk>
 779:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 77c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 780:	75 07                	jne    789 <morecore+0x34>
    return 0;
 782:	b8 00 00 00 00       	mov    $0x0,%eax
 787:	eb 22                	jmp    7ab <morecore+0x56>
  hp = (Header*)p;
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	8b 55 08             	mov    0x8(%ebp),%edx
 795:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	83 c0 08             	add    $0x8,%eax
 79e:	89 04 24             	mov    %eax,(%esp)
 7a1:	e8 ce fe ff ff       	call   674 <free>
  return freep;
 7a6:	a1 54 0b 00 00       	mov    0xb54,%eax
}
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <malloc>:

void*
malloc(uint nbytes)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	83 c0 07             	add    $0x7,%eax
 7b9:	c1 e8 03             	shr    $0x3,%eax
 7bc:	83 c0 01             	add    $0x1,%eax
 7bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c2:	a1 54 0b 00 00       	mov    0xb54,%eax
 7c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ce:	75 23                	jne    7f3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d0:	c7 45 f0 4c 0b 00 00 	movl   $0xb4c,-0x10(%ebp)
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	a3 54 0b 00 00       	mov    %eax,0xb54
 7df:	a1 54 0b 00 00       	mov    0xb54,%eax
 7e4:	a3 4c 0b 00 00       	mov    %eax,0xb4c
    base.s.size = 0;
 7e9:	c7 05 50 0b 00 00 00 	movl   $0x0,0xb50
 7f0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f6:	8b 00                	mov    (%eax),%eax
 7f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	8b 40 04             	mov    0x4(%eax),%eax
 801:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 804:	72 4d                	jb     853 <malloc+0xa6>
      if(p->s.size == nunits)
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	8b 40 04             	mov    0x4(%eax),%eax
 80c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80f:	75 0c                	jne    81d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 f0             	mov    -0x10(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
 81b:	eb 26                	jmp    843 <malloc+0x96>
      else {
        p->s.size -= nunits;
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	2b 45 ec             	sub    -0x14(%ebp),%eax
 826:	89 c2                	mov    %eax,%edx
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	c1 e0 03             	shl    $0x3,%eax
 837:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 840:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 843:	8b 45 f0             	mov    -0x10(%ebp),%eax
 846:	a3 54 0b 00 00       	mov    %eax,0xb54
      return (void*)(p + 1);
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	83 c0 08             	add    $0x8,%eax
 851:	eb 38                	jmp    88b <malloc+0xde>
    }
    if(p == freep)
 853:	a1 54 0b 00 00       	mov    0xb54,%eax
 858:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 85b:	75 1b                	jne    878 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 85d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 860:	89 04 24             	mov    %eax,(%esp)
 863:	e8 ed fe ff ff       	call   755 <morecore>
 868:	89 45 f4             	mov    %eax,-0xc(%ebp)
 86b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86f:	75 07                	jne    878 <malloc+0xcb>
        return 0;
 871:	b8 00 00 00 00       	mov    $0x0,%eax
 876:	eb 13                	jmp    88b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 00                	mov    (%eax),%eax
 883:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 886:	e9 70 ff ff ff       	jmp    7fb <malloc+0x4e>
}
 88b:	c9                   	leave  
 88c:	c3                   	ret    
