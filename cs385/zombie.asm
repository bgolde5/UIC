
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 b8 02 00 00       	call   2c6 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 40 03 00 00       	call   35e <sleep>
  exit();
  1e:	e8 ab 02 00 00       	call   2ce <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4e:	8b 45 08             	mov    0x8(%ebp),%eax
  51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  54:	90                   	nop
  55:	8b 45 08             	mov    0x8(%ebp),%eax
  58:	8d 50 01             	lea    0x1(%eax),%edx
  5b:	89 55 08             	mov    %edx,0x8(%ebp)
  5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  61:	8d 4a 01             	lea    0x1(%edx),%ecx
  64:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  67:	0f b6 12             	movzbl (%edx),%edx
  6a:	88 10                	mov    %dl,(%eax)
  6c:	0f b6 00             	movzbl (%eax),%eax
  6f:	84 c0                	test   %al,%al
  71:	75 e2                	jne    55 <strcpy+0xd>
    ;
  return os;
  73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  76:	c9                   	leave  
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7b:	eb 08                	jmp    85 <strcmp+0xd>
    p++, q++;
  7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  81:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	0f b6 00             	movzbl (%eax),%eax
  8b:	84 c0                	test   %al,%al
  8d:	74 10                	je     9f <strcmp+0x27>
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 10             	movzbl (%eax),%edx
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	0f b6 00             	movzbl (%eax),%eax
  9b:	38 c2                	cmp    %al,%dl
  9d:	74 de                	je     7d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	0f b6 d0             	movzbl %al,%edx
  a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	0f b6 c0             	movzbl %al,%eax
  b1:	29 c2                	sub    %eax,%edx
  b3:	89 d0                	mov    %edx,%eax
}
  b5:	5d                   	pop    %ebp
  b6:	c3                   	ret    

000000b7 <strlen>:

uint
strlen(char *s)
{
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c4:	eb 04                	jmp    ca <strlen+0x13>
  c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	01 d0                	add    %edx,%eax
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	84 c0                	test   %al,%al
  d7:	75 ed                	jne    c6 <strlen+0xf>
    ;
  return n;
  d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  e4:	8b 45 10             	mov    0x10(%ebp),%eax
  e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	89 04 24             	mov    %eax,(%esp)
  f8:	e8 26 ff ff ff       	call   23 <stosb>
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 4c                	jmp    190 <gets+0x5b>
    cc = read(0, &c, 1);
 144:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14b:	00 
 14c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14f:	89 44 24 04          	mov    %eax,0x4(%esp)
 153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15a:	e8 87 01 00 00       	call   2e6 <read>
 15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 166:	7f 02                	jg     16a <gets+0x35>
      break;
 168:	eb 31                	jmp    19b <gets+0x66>
    buf[i++] = c;
 16a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16d:	8d 50 01             	lea    0x1(%eax),%edx
 170:	89 55 f4             	mov    %edx,-0xc(%ebp)
 173:	89 c2                	mov    %eax,%edx
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	01 c2                	add    %eax,%edx
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 180:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 184:	3c 0a                	cmp    $0xa,%al
 186:	74 13                	je     19b <gets+0x66>
 188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18c:	3c 0d                	cmp    $0xd,%al
 18e:	74 0b                	je     19b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 190:	8b 45 f4             	mov    -0xc(%ebp),%eax
 193:	83 c0 01             	add    $0x1,%eax
 196:	3b 45 0c             	cmp    0xc(%ebp),%eax
 199:	7c a9                	jl     144 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <stat>:

int
stat(char *n, struct stat *st)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b8:	00 
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	89 04 24             	mov    %eax,(%esp)
 1bf:	e8 4a 01 00 00       	call   30e <open>
 1c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1cb:	79 07                	jns    1d4 <stat+0x29>
    return -1;
 1cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d2:	eb 23                	jmp    1f7 <stat+0x4c>
  r = fstat(fd, st);
 1d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1de:	89 04 24             	mov    %eax,(%esp)
 1e1:	e8 40 01 00 00       	call   326 <fstat>
 1e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 02 01 00 00       	call   2f6 <close>
  return r;
 1f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <atoi>:

int
atoi(const char *s)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 206:	eb 25                	jmp    22d <atoi+0x34>
    n = n*10 + *s++ - '0';
 208:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20b:	89 d0                	mov    %edx,%eax
 20d:	c1 e0 02             	shl    $0x2,%eax
 210:	01 d0                	add    %edx,%eax
 212:	01 c0                	add    %eax,%eax
 214:	89 c1                	mov    %eax,%ecx
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 08             	mov    %edx,0x8(%ebp)
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	0f be c0             	movsbl %al,%eax
 225:	01 c8                	add    %ecx,%eax
 227:	83 e8 30             	sub    $0x30,%eax
 22a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 2f                	cmp    $0x2f,%al
 235:	7e 0a                	jle    241 <atoi+0x48>
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	3c 39                	cmp    $0x39,%al
 23f:	7e c7                	jle    208 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
 249:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 252:	8b 45 0c             	mov    0xc(%ebp),%eax
 255:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 258:	eb 17                	jmp    271 <memmove+0x2b>
    *dst++ = *src++;
 25a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 fc             	mov    %edx,-0x4(%ebp)
 263:	8b 55 f8             	mov    -0x8(%ebp),%edx
 266:	8d 4a 01             	lea    0x1(%edx),%ecx
 269:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 26c:	0f b6 12             	movzbl (%edx),%edx
 26f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 271:	8b 45 10             	mov    0x10(%ebp),%eax
 274:	8d 50 ff             	lea    -0x1(%eax),%edx
 277:	89 55 10             	mov    %edx,0x10(%ebp)
 27a:	85 c0                	test   %eax,%eax
 27c:	7f dc                	jg     25a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 289:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 290:	e8 bd 04 00 00       	call   752 <malloc>
 295:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 298:	8b 45 f4             	mov    -0xc(%ebp),%eax
 29b:	05 fc ff 0f 00       	add    $0xffffc,%eax
 2a0:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 2a3:	ba 76 03 00 00       	mov    $0x376,%edx
 2a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2ab:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 2ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b0:	05 fc ff 0f 00       	add    $0xffffc,%eax
 2b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 aa 00 00 00       	call   36e <clone>
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c6:	b8 01 00 00 00       	mov    $0x1,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <exit>:
SYSCALL(exit)
 2ce:	b8 02 00 00 00       	mov    $0x2,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <wait>:
SYSCALL(wait)
 2d6:	b8 03 00 00 00       	mov    $0x3,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <pipe>:
SYSCALL(pipe)
 2de:	b8 04 00 00 00       	mov    $0x4,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <read>:
SYSCALL(read)
 2e6:	b8 05 00 00 00       	mov    $0x5,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <write>:
SYSCALL(write)
 2ee:	b8 10 00 00 00       	mov    $0x10,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <close>:
SYSCALL(close)
 2f6:	b8 15 00 00 00       	mov    $0x15,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <kill>:
SYSCALL(kill)
 2fe:	b8 06 00 00 00       	mov    $0x6,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <exec>:
SYSCALL(exec)
 306:	b8 07 00 00 00       	mov    $0x7,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <open>:
SYSCALL(open)
 30e:	b8 0f 00 00 00       	mov    $0xf,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <mknod>:
SYSCALL(mknod)
 316:	b8 11 00 00 00       	mov    $0x11,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <unlink>:
SYSCALL(unlink)
 31e:	b8 12 00 00 00       	mov    $0x12,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <fstat>:
SYSCALL(fstat)
 326:	b8 08 00 00 00       	mov    $0x8,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <link>:
SYSCALL(link)
 32e:	b8 13 00 00 00       	mov    $0x13,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <mkdir>:
SYSCALL(mkdir)
 336:	b8 14 00 00 00       	mov    $0x14,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <chdir>:
SYSCALL(chdir)
 33e:	b8 09 00 00 00       	mov    $0x9,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <dup>:
SYSCALL(dup)
 346:	b8 0a 00 00 00       	mov    $0xa,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <getpid>:
SYSCALL(getpid)
 34e:	b8 0b 00 00 00       	mov    $0xb,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <sbrk>:
SYSCALL(sbrk)
 356:	b8 0c 00 00 00       	mov    $0xc,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <sleep>:
SYSCALL(sleep)
 35e:	b8 0d 00 00 00       	mov    $0xd,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <uptime>:
SYSCALL(uptime)
 366:	b8 0e 00 00 00       	mov    $0xe,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <clone>:
SYSCALL(clone)
 36e:	b8 16 00 00 00       	mov    $0x16,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <thread_exit>:
SYSCALL(thread_exit)
 376:	b8 17 00 00 00       	mov    $0x17,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <thread_join>:
SYSCALL(thread_join)
 37e:	b8 18 00 00 00       	mov    $0x18,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp
 389:	83 ec 18             	sub    $0x18,%esp
 38c:	8b 45 0c             	mov    0xc(%ebp),%eax
 38f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 392:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 399:	00 
 39a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39d:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	89 04 24             	mov    %eax,(%esp)
 3a7:	e8 42 ff ff ff       	call   2ee <write>
}
 3ac:	c9                   	leave  
 3ad:	c3                   	ret    

000003ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ae:	55                   	push   %ebp
 3af:	89 e5                	mov    %esp,%ebp
 3b1:	56                   	push   %esi
 3b2:	53                   	push   %ebx
 3b3:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3bd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c1:	74 17                	je     3da <printint+0x2c>
 3c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c7:	79 11                	jns    3da <printint+0x2c>
    neg = 1;
 3c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d3:	f7 d8                	neg    %eax
 3d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d8:	eb 06                	jmp    3e0 <printint+0x32>
  } else {
    x = xx;
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3ea:	8d 41 01             	lea    0x1(%ecx),%eax
 3ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f6:	ba 00 00 00 00       	mov    $0x0,%edx
 3fb:	f7 f3                	div    %ebx
 3fd:	89 d0                	mov    %edx,%eax
 3ff:	0f b6 80 a0 0a 00 00 	movzbl 0xaa0(%eax),%eax
 406:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 40a:	8b 75 10             	mov    0x10(%ebp),%esi
 40d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 410:	ba 00 00 00 00       	mov    $0x0,%edx
 415:	f7 f6                	div    %esi
 417:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41e:	75 c7                	jne    3e7 <printint+0x39>
  if(neg)
 420:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 424:	74 10                	je     436 <printint+0x88>
    buf[i++] = '-';
 426:	8b 45 f4             	mov    -0xc(%ebp),%eax
 429:	8d 50 01             	lea    0x1(%eax),%edx
 42c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 434:	eb 1f                	jmp    455 <printint+0xa7>
 436:	eb 1d                	jmp    455 <printint+0xa7>
    putc(fd, buf[i]);
 438:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43e:	01 d0                	add    %edx,%eax
 440:	0f b6 00             	movzbl (%eax),%eax
 443:	0f be c0             	movsbl %al,%eax
 446:	89 44 24 04          	mov    %eax,0x4(%esp)
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	89 04 24             	mov    %eax,(%esp)
 450:	e8 31 ff ff ff       	call   386 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 455:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45d:	79 d9                	jns    438 <printint+0x8a>
    putc(fd, buf[i]);
}
 45f:	83 c4 30             	add    $0x30,%esp
 462:	5b                   	pop    %ebx
 463:	5e                   	pop    %esi
 464:	5d                   	pop    %ebp
 465:	c3                   	ret    

00000466 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 466:	55                   	push   %ebp
 467:	89 e5                	mov    %esp,%ebp
 469:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 46c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 473:	8d 45 0c             	lea    0xc(%ebp),%eax
 476:	83 c0 04             	add    $0x4,%eax
 479:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 47c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 483:	e9 7c 01 00 00       	jmp    604 <printf+0x19e>
    c = fmt[i] & 0xff;
 488:	8b 55 0c             	mov    0xc(%ebp),%edx
 48b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 48e:	01 d0                	add    %edx,%eax
 490:	0f b6 00             	movzbl (%eax),%eax
 493:	0f be c0             	movsbl %al,%eax
 496:	25 ff 00 00 00       	and    $0xff,%eax
 49b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 49e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a2:	75 2c                	jne    4d0 <printf+0x6a>
      if(c == '%'){
 4a4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a8:	75 0c                	jne    4b6 <printf+0x50>
        state = '%';
 4aa:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b1:	e9 4a 01 00 00       	jmp    600 <printf+0x19a>
      } else {
        putc(fd, c);
 4b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b9:	0f be c0             	movsbl %al,%eax
 4bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	89 04 24             	mov    %eax,(%esp)
 4c6:	e8 bb fe ff ff       	call   386 <putc>
 4cb:	e9 30 01 00 00       	jmp    600 <printf+0x19a>
      }
    } else if(state == '%'){
 4d0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4d4:	0f 85 26 01 00 00    	jne    600 <printf+0x19a>
      if(c == 'd'){
 4da:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4de:	75 2d                	jne    50d <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e3:	8b 00                	mov    (%eax),%eax
 4e5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4ec:	00 
 4ed:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4f4:	00 
 4f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f9:	8b 45 08             	mov    0x8(%ebp),%eax
 4fc:	89 04 24             	mov    %eax,(%esp)
 4ff:	e8 aa fe ff ff       	call   3ae <printint>
        ap++;
 504:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 508:	e9 ec 00 00 00       	jmp    5f9 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 50d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 511:	74 06                	je     519 <printf+0xb3>
 513:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 517:	75 2d                	jne    546 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 519:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51c:	8b 00                	mov    (%eax),%eax
 51e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 525:	00 
 526:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 52d:	00 
 52e:	89 44 24 04          	mov    %eax,0x4(%esp)
 532:	8b 45 08             	mov    0x8(%ebp),%eax
 535:	89 04 24             	mov    %eax,(%esp)
 538:	e8 71 fe ff ff       	call   3ae <printint>
        ap++;
 53d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 541:	e9 b3 00 00 00       	jmp    5f9 <printf+0x193>
      } else if(c == 's'){
 546:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 54a:	75 45                	jne    591 <printf+0x12b>
        s = (char*)*ap;
 54c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54f:	8b 00                	mov    (%eax),%eax
 551:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 554:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55c:	75 09                	jne    567 <printf+0x101>
          s = "(null)";
 55e:	c7 45 f4 32 08 00 00 	movl   $0x832,-0xc(%ebp)
        while(*s != 0){
 565:	eb 1e                	jmp    585 <printf+0x11f>
 567:	eb 1c                	jmp    585 <printf+0x11f>
          putc(fd, *s);
 569:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56c:	0f b6 00             	movzbl (%eax),%eax
 56f:	0f be c0             	movsbl %al,%eax
 572:	89 44 24 04          	mov    %eax,0x4(%esp)
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	89 04 24             	mov    %eax,(%esp)
 57c:	e8 05 fe ff ff       	call   386 <putc>
          s++;
 581:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 585:	8b 45 f4             	mov    -0xc(%ebp),%eax
 588:	0f b6 00             	movzbl (%eax),%eax
 58b:	84 c0                	test   %al,%al
 58d:	75 da                	jne    569 <printf+0x103>
 58f:	eb 68                	jmp    5f9 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 591:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 595:	75 1d                	jne    5b4 <printf+0x14e>
        putc(fd, *ap);
 597:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59a:	8b 00                	mov    (%eax),%eax
 59c:	0f be c0             	movsbl %al,%eax
 59f:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a3:	8b 45 08             	mov    0x8(%ebp),%eax
 5a6:	89 04 24             	mov    %eax,(%esp)
 5a9:	e8 d8 fd ff ff       	call   386 <putc>
        ap++;
 5ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b2:	eb 45                	jmp    5f9 <printf+0x193>
      } else if(c == '%'){
 5b4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b8:	75 17                	jne    5d1 <printf+0x16b>
        putc(fd, c);
 5ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	89 04 24             	mov    %eax,(%esp)
 5ca:	e8 b7 fd ff ff       	call   386 <putc>
 5cf:	eb 28                	jmp    5f9 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d8:	00 
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	89 04 24             	mov    %eax,(%esp)
 5df:	e8 a2 fd ff ff       	call   386 <putc>
        putc(fd, c);
 5e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e7:	0f be c0             	movsbl %al,%eax
 5ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	89 04 24             	mov    %eax,(%esp)
 5f4:	e8 8d fd ff ff       	call   386 <putc>
      }
      state = 0;
 5f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 600:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 604:	8b 55 0c             	mov    0xc(%ebp),%edx
 607:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60a:	01 d0                	add    %edx,%eax
 60c:	0f b6 00             	movzbl (%eax),%eax
 60f:	84 c0                	test   %al,%al
 611:	0f 85 71 fe ff ff    	jne    488 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 617:	c9                   	leave  
 618:	c3                   	ret    

00000619 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 619:	55                   	push   %ebp
 61a:	89 e5                	mov    %esp,%ebp
 61c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	83 e8 08             	sub    $0x8,%eax
 625:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 628:	a1 bc 0a 00 00       	mov    0xabc,%eax
 62d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 630:	eb 24                	jmp    656 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63a:	77 12                	ja     64e <free+0x35>
 63c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 642:	77 24                	ja     668 <free+0x4f>
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64c:	77 1a                	ja     668 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	89 45 fc             	mov    %eax,-0x4(%ebp)
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65c:	76 d4                	jbe    632 <free+0x19>
 65e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 661:	8b 00                	mov    (%eax),%eax
 663:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 666:	76 ca                	jbe    632 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	8b 40 04             	mov    0x4(%eax),%eax
 66e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	01 c2                	add    %eax,%edx
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	39 c2                	cmp    %eax,%edx
 681:	75 24                	jne    6a7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	8b 50 04             	mov    0x4(%eax),%edx
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	8b 40 04             	mov    0x4(%eax),%eax
 691:	01 c2                	add    %eax,%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	8b 10                	mov    (%eax),%edx
 6a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a3:	89 10                	mov    %edx,(%eax)
 6a5:	eb 0a                	jmp    6b1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 10                	mov    (%eax),%edx
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 40 04             	mov    0x4(%eax),%eax
 6b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	01 d0                	add    %edx,%eax
 6c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c6:	75 20                	jne    6e8 <free+0xcf>
    p->s.size += bp->s.size;
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 50 04             	mov    0x4(%eax),%edx
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	8b 40 04             	mov    0x4(%eax),%eax
 6d4:	01 c2                	add    %eax,%edx
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	8b 10                	mov    (%eax),%edx
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	89 10                	mov    %edx,(%eax)
 6e6:	eb 08                	jmp    6f0 <free+0xd7>
  } else
    p->s.ptr = bp;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ee:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	a3 bc 0a 00 00       	mov    %eax,0xabc
}
 6f8:	c9                   	leave  
 6f9:	c3                   	ret    

000006fa <morecore>:

static Header*
morecore(uint nu)
{
 6fa:	55                   	push   %ebp
 6fb:	89 e5                	mov    %esp,%ebp
 6fd:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 700:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 707:	77 07                	ja     710 <morecore+0x16>
    nu = 4096;
 709:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 710:	8b 45 08             	mov    0x8(%ebp),%eax
 713:	c1 e0 03             	shl    $0x3,%eax
 716:	89 04 24             	mov    %eax,(%esp)
 719:	e8 38 fc ff ff       	call   356 <sbrk>
 71e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 721:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 725:	75 07                	jne    72e <morecore+0x34>
    return 0;
 727:	b8 00 00 00 00       	mov    $0x0,%eax
 72c:	eb 22                	jmp    750 <morecore+0x56>
  hp = (Header*)p;
 72e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 731:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 734:	8b 45 f0             	mov    -0x10(%ebp),%eax
 737:	8b 55 08             	mov    0x8(%ebp),%edx
 73a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 740:	83 c0 08             	add    $0x8,%eax
 743:	89 04 24             	mov    %eax,(%esp)
 746:	e8 ce fe ff ff       	call   619 <free>
  return freep;
 74b:	a1 bc 0a 00 00       	mov    0xabc,%eax
}
 750:	c9                   	leave  
 751:	c3                   	ret    

00000752 <malloc>:

void*
malloc(uint nbytes)
{
 752:	55                   	push   %ebp
 753:	89 e5                	mov    %esp,%ebp
 755:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 758:	8b 45 08             	mov    0x8(%ebp),%eax
 75b:	83 c0 07             	add    $0x7,%eax
 75e:	c1 e8 03             	shr    $0x3,%eax
 761:	83 c0 01             	add    $0x1,%eax
 764:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 767:	a1 bc 0a 00 00       	mov    0xabc,%eax
 76c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 76f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 773:	75 23                	jne    798 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 775:	c7 45 f0 b4 0a 00 00 	movl   $0xab4,-0x10(%ebp)
 77c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77f:	a3 bc 0a 00 00       	mov    %eax,0xabc
 784:	a1 bc 0a 00 00       	mov    0xabc,%eax
 789:	a3 b4 0a 00 00       	mov    %eax,0xab4
    base.s.size = 0;
 78e:	c7 05 b8 0a 00 00 00 	movl   $0x0,0xab8
 795:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	8b 00                	mov    (%eax),%eax
 79d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a9:	72 4d                	jb     7f8 <malloc+0xa6>
      if(p->s.size == nunits)
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b4:	75 0c                	jne    7c2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7be:	89 10                	mov    %edx,(%eax)
 7c0:	eb 26                	jmp    7e8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7cb:	89 c2                	mov    %eax,%edx
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	8b 40 04             	mov    0x4(%eax),%eax
 7d9:	c1 e0 03             	shl    $0x3,%eax
 7dc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	a3 bc 0a 00 00       	mov    %eax,0xabc
      return (void*)(p + 1);
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	83 c0 08             	add    $0x8,%eax
 7f6:	eb 38                	jmp    830 <malloc+0xde>
    }
    if(p == freep)
 7f8:	a1 bc 0a 00 00       	mov    0xabc,%eax
 7fd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 800:	75 1b                	jne    81d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 802:	8b 45 ec             	mov    -0x14(%ebp),%eax
 805:	89 04 24             	mov    %eax,(%esp)
 808:	e8 ed fe ff ff       	call   6fa <morecore>
 80d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 814:	75 07                	jne    81d <malloc+0xcb>
        return 0;
 816:	b8 00 00 00 00       	mov    $0x0,%eax
 81b:	eb 13                	jmp    830 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	89 45 f0             	mov    %eax,-0x10(%ebp)
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 00                	mov    (%eax),%eax
 828:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 82b:	e9 70 ff ff ff       	jmp    7a0 <malloc+0x4e>
}
 830:	c9                   	leave  
 831:	c3                   	ret    
