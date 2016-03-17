
_thread5_helper:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include"types.h"
#include"user.h"

int shared = 1;

int main(int argc, char** argv) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i=1000;
   9:	c7 44 24 1c e8 03 00 	movl   $0x3e8,0x1c(%esp)
  10:	00 
  while(i--)
  11:	eb 1c                	jmp    2f <main+0x2f>
    printf(1,"thread5_helper now running instead, finishing in %d.\n",i);
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	89 44 24 08          	mov    %eax,0x8(%esp)
  1b:	c7 44 24 04 54 08 00 	movl   $0x854,0x4(%esp)
  22:	00 
  23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  2a:	e8 57 04 00 00       	call   486 <printf>

int shared = 1;

int main(int argc, char** argv) {
  int i=1000;
  while(i--)
  2f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  33:	8d 50 ff             	lea    -0x1(%eax),%edx
  36:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  3a:	85 c0                	test   %eax,%eax
  3c:	75 d5                	jne    13 <main+0x13>
    printf(1,"thread5_helper now running instead, finishing in %d.\n",i);
  exit();
  3e:	e8 ab 02 00 00       	call   2ee <exit>

00000043 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  43:	55                   	push   %ebp
  44:	89 e5                	mov    %esp,%ebp
  46:	57                   	push   %edi
  47:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  4b:	8b 55 10             	mov    0x10(%ebp),%edx
  4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  51:	89 cb                	mov    %ecx,%ebx
  53:	89 df                	mov    %ebx,%edi
  55:	89 d1                	mov    %edx,%ecx
  57:	fc                   	cld    
  58:	f3 aa                	rep stos %al,%es:(%edi)
  5a:	89 ca                	mov    %ecx,%edx
  5c:	89 fb                	mov    %edi,%ebx
  5e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  61:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  64:	5b                   	pop    %ebx
  65:	5f                   	pop    %edi
  66:	5d                   	pop    %ebp
  67:	c3                   	ret    

00000068 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  6e:	8b 45 08             	mov    0x8(%ebp),%eax
  71:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  74:	90                   	nop
  75:	8b 45 08             	mov    0x8(%ebp),%eax
  78:	8d 50 01             	lea    0x1(%eax),%edx
  7b:	89 55 08             	mov    %edx,0x8(%ebp)
  7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  81:	8d 4a 01             	lea    0x1(%edx),%ecx
  84:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  87:	0f b6 12             	movzbl (%edx),%edx
  8a:	88 10                	mov    %dl,(%eax)
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	84 c0                	test   %al,%al
  91:	75 e2                	jne    75 <strcpy+0xd>
    ;
  return os;
  93:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  96:	c9                   	leave  
  97:	c3                   	ret    

00000098 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  9b:	eb 08                	jmp    a5 <strcmp+0xd>
    p++, q++;
  9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	84 c0                	test   %al,%al
  ad:	74 10                	je     bf <strcmp+0x27>
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	0f b6 10             	movzbl (%eax),%edx
  b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  b8:	0f b6 00             	movzbl (%eax),%eax
  bb:	38 c2                	cmp    %al,%dl
  bd:	74 de                	je     9d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  bf:	8b 45 08             	mov    0x8(%ebp),%eax
  c2:	0f b6 00             	movzbl (%eax),%eax
  c5:	0f b6 d0             	movzbl %al,%edx
  c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	0f b6 c0             	movzbl %al,%eax
  d1:	29 c2                	sub    %eax,%edx
  d3:	89 d0                	mov    %edx,%eax
}
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    

000000d7 <strlen>:

uint
strlen(char *s)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  da:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e4:	eb 04                	jmp    ea <strlen+0x13>
  e6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	01 d0                	add    %edx,%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	84 c0                	test   %al,%al
  f7:	75 ed                	jne    e6 <strlen+0xf>
    ;
  return n;
  f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <memset>:

void*
memset(void *dst, int c, uint n)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 104:	8b 45 10             	mov    0x10(%ebp),%eax
 107:	89 44 24 08          	mov    %eax,0x8(%esp)
 10b:	8b 45 0c             	mov    0xc(%ebp),%eax
 10e:	89 44 24 04          	mov    %eax,0x4(%esp)
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	89 04 24             	mov    %eax,(%esp)
 118:	e8 26 ff ff ff       	call   43 <stosb>
  return dst;
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <strchr>:

char*
strchr(const char *s, char c)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 04             	sub    $0x4,%esp
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 12e:	eb 14                	jmp    144 <strchr+0x22>
    if(*s == c)
 130:	8b 45 08             	mov    0x8(%ebp),%eax
 133:	0f b6 00             	movzbl (%eax),%eax
 136:	3a 45 fc             	cmp    -0x4(%ebp),%al
 139:	75 05                	jne    140 <strchr+0x1e>
      return (char*)s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	eb 13                	jmp    153 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 140:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	0f b6 00             	movzbl (%eax),%eax
 14a:	84 c0                	test   %al,%al
 14c:	75 e2                	jne    130 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 14e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 153:	c9                   	leave  
 154:	c3                   	ret    

00000155 <gets>:

char*
gets(char *buf, int max)
{
 155:	55                   	push   %ebp
 156:	89 e5                	mov    %esp,%ebp
 158:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 162:	eb 4c                	jmp    1b0 <gets+0x5b>
    cc = read(0, &c, 1);
 164:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 16b:	00 
 16c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 16f:	89 44 24 04          	mov    %eax,0x4(%esp)
 173:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 17a:	e8 87 01 00 00       	call   306 <read>
 17f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 182:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 186:	7f 02                	jg     18a <gets+0x35>
      break;
 188:	eb 31                	jmp    1bb <gets+0x66>
    buf[i++] = c;
 18a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18d:	8d 50 01             	lea    0x1(%eax),%edx
 190:	89 55 f4             	mov    %edx,-0xc(%ebp)
 193:	89 c2                	mov    %eax,%edx
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	01 c2                	add    %eax,%edx
 19a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a4:	3c 0a                	cmp    $0xa,%al
 1a6:	74 13                	je     1bb <gets+0x66>
 1a8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ac:	3c 0d                	cmp    $0xd,%al
 1ae:	74 0b                	je     1bb <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b3:	83 c0 01             	add    $0x1,%eax
 1b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1b9:	7c a9                	jl     164 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	01 d0                	add    %edx,%eax
 1c3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <stat>:

int
stat(char *n, struct stat *st)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1d8:	00 
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	89 04 24             	mov    %eax,(%esp)
 1df:	e8 4a 01 00 00       	call   32e <open>
 1e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1eb:	79 07                	jns    1f4 <stat+0x29>
    return -1;
 1ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f2:	eb 23                	jmp    217 <stat+0x4c>
  r = fstat(fd, st);
 1f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fe:	89 04 24             	mov    %eax,(%esp)
 201:	e8 40 01 00 00       	call   346 <fstat>
 206:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 209:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20c:	89 04 24             	mov    %eax,(%esp)
 20f:	e8 02 01 00 00       	call   316 <close>
  return r;
 214:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <atoi>:

int
atoi(const char *s)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
 21c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 21f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 226:	eb 25                	jmp    24d <atoi+0x34>
    n = n*10 + *s++ - '0';
 228:	8b 55 fc             	mov    -0x4(%ebp),%edx
 22b:	89 d0                	mov    %edx,%eax
 22d:	c1 e0 02             	shl    $0x2,%eax
 230:	01 d0                	add    %edx,%eax
 232:	01 c0                	add    %eax,%eax
 234:	89 c1                	mov    %eax,%ecx
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	8d 50 01             	lea    0x1(%eax),%edx
 23c:	89 55 08             	mov    %edx,0x8(%ebp)
 23f:	0f b6 00             	movzbl (%eax),%eax
 242:	0f be c0             	movsbl %al,%eax
 245:	01 c8                	add    %ecx,%eax
 247:	83 e8 30             	sub    $0x30,%eax
 24a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	3c 2f                	cmp    $0x2f,%al
 255:	7e 0a                	jle    261 <atoi+0x48>
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	0f b6 00             	movzbl (%eax),%eax
 25d:	3c 39                	cmp    $0x39,%al
 25f:	7e c7                	jle    228 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 261:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 272:	8b 45 0c             	mov    0xc(%ebp),%eax
 275:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 278:	eb 17                	jmp    291 <memmove+0x2b>
    *dst++ = *src++;
 27a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 27d:	8d 50 01             	lea    0x1(%eax),%edx
 280:	89 55 fc             	mov    %edx,-0x4(%ebp)
 283:	8b 55 f8             	mov    -0x8(%ebp),%edx
 286:	8d 4a 01             	lea    0x1(%edx),%ecx
 289:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 28c:	0f b6 12             	movzbl (%edx),%edx
 28f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 291:	8b 45 10             	mov    0x10(%ebp),%eax
 294:	8d 50 ff             	lea    -0x1(%eax),%edx
 297:	89 55 10             	mov    %edx,0x10(%ebp)
 29a:	85 c0                	test   %eax,%eax
 29c:	7f dc                	jg     27a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 2a9:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 2b0:	e8 bd 04 00 00       	call   772 <malloc>
 2b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 2b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bb:	05 fc ff 0f 00       	add    $0xffffc,%eax
 2c0:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 2c3:	ba 96 03 00 00       	mov    $0x396,%edx
 2c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2cb:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 2cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d0:	05 fc ff 0f 00       	add    $0xffffc,%eax
 2d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	89 04 24             	mov    %eax,(%esp)
 2df:	e8 aa 00 00 00       	call   38e <clone>
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e6:	b8 01 00 00 00       	mov    $0x1,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <exit>:
SYSCALL(exit)
 2ee:	b8 02 00 00 00       	mov    $0x2,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <wait>:
SYSCALL(wait)
 2f6:	b8 03 00 00 00       	mov    $0x3,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <pipe>:
SYSCALL(pipe)
 2fe:	b8 04 00 00 00       	mov    $0x4,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <read>:
SYSCALL(read)
 306:	b8 05 00 00 00       	mov    $0x5,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <write>:
SYSCALL(write)
 30e:	b8 10 00 00 00       	mov    $0x10,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <close>:
SYSCALL(close)
 316:	b8 15 00 00 00       	mov    $0x15,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <kill>:
SYSCALL(kill)
 31e:	b8 06 00 00 00       	mov    $0x6,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <exec>:
SYSCALL(exec)
 326:	b8 07 00 00 00       	mov    $0x7,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <open>:
SYSCALL(open)
 32e:	b8 0f 00 00 00       	mov    $0xf,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <mknod>:
SYSCALL(mknod)
 336:	b8 11 00 00 00       	mov    $0x11,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <unlink>:
SYSCALL(unlink)
 33e:	b8 12 00 00 00       	mov    $0x12,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <fstat>:
SYSCALL(fstat)
 346:	b8 08 00 00 00       	mov    $0x8,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <link>:
SYSCALL(link)
 34e:	b8 13 00 00 00       	mov    $0x13,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <mkdir>:
SYSCALL(mkdir)
 356:	b8 14 00 00 00       	mov    $0x14,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <chdir>:
SYSCALL(chdir)
 35e:	b8 09 00 00 00       	mov    $0x9,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <dup>:
SYSCALL(dup)
 366:	b8 0a 00 00 00       	mov    $0xa,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <getpid>:
SYSCALL(getpid)
 36e:	b8 0b 00 00 00       	mov    $0xb,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <sbrk>:
SYSCALL(sbrk)
 376:	b8 0c 00 00 00       	mov    $0xc,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <sleep>:
SYSCALL(sleep)
 37e:	b8 0d 00 00 00       	mov    $0xd,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <uptime>:
SYSCALL(uptime)
 386:	b8 0e 00 00 00       	mov    $0xe,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <clone>:
SYSCALL(clone)
 38e:	b8 16 00 00 00       	mov    $0x16,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <thread_exit>:
SYSCALL(thread_exit)
 396:	b8 17 00 00 00       	mov    $0x17,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <thread_join>:
SYSCALL(thread_join)
 39e:	b8 18 00 00 00       	mov    $0x18,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a6:	55                   	push   %ebp
 3a7:	89 e5                	mov    %esp,%ebp
 3a9:	83 ec 18             	sub    $0x18,%esp
 3ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 3af:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3b9:	00 
 3ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	89 04 24             	mov    %eax,(%esp)
 3c7:	e8 42 ff ff ff       	call   30e <write>
}
 3cc:	c9                   	leave  
 3cd:	c3                   	ret    

000003ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ce:	55                   	push   %ebp
 3cf:	89 e5                	mov    %esp,%ebp
 3d1:	56                   	push   %esi
 3d2:	53                   	push   %ebx
 3d3:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3dd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e1:	74 17                	je     3fa <printint+0x2c>
 3e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e7:	79 11                	jns    3fa <printint+0x2c>
    neg = 1;
 3e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	f7 d8                	neg    %eax
 3f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f8:	eb 06                	jmp    400 <printint+0x32>
  } else {
    x = xx;
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 400:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 407:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 40a:	8d 41 01             	lea    0x1(%ecx),%eax
 40d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 410:	8b 5d 10             	mov    0x10(%ebp),%ebx
 413:	8b 45 ec             	mov    -0x14(%ebp),%eax
 416:	ba 00 00 00 00       	mov    $0x0,%edx
 41b:	f7 f3                	div    %ebx
 41d:	89 d0                	mov    %edx,%eax
 41f:	0f b6 80 fc 0a 00 00 	movzbl 0xafc(%eax),%eax
 426:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 42a:	8b 75 10             	mov    0x10(%ebp),%esi
 42d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 430:	ba 00 00 00 00       	mov    $0x0,%edx
 435:	f7 f6                	div    %esi
 437:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43e:	75 c7                	jne    407 <printint+0x39>
  if(neg)
 440:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 444:	74 10                	je     456 <printint+0x88>
    buf[i++] = '-';
 446:	8b 45 f4             	mov    -0xc(%ebp),%eax
 449:	8d 50 01             	lea    0x1(%eax),%edx
 44c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 44f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 454:	eb 1f                	jmp    475 <printint+0xa7>
 456:	eb 1d                	jmp    475 <printint+0xa7>
    putc(fd, buf[i]);
 458:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45e:	01 d0                	add    %edx,%eax
 460:	0f b6 00             	movzbl (%eax),%eax
 463:	0f be c0             	movsbl %al,%eax
 466:	89 44 24 04          	mov    %eax,0x4(%esp)
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	89 04 24             	mov    %eax,(%esp)
 470:	e8 31 ff ff ff       	call   3a6 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 475:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47d:	79 d9                	jns    458 <printint+0x8a>
    putc(fd, buf[i]);
}
 47f:	83 c4 30             	add    $0x30,%esp
 482:	5b                   	pop    %ebx
 483:	5e                   	pop    %esi
 484:	5d                   	pop    %ebp
 485:	c3                   	ret    

00000486 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 486:	55                   	push   %ebp
 487:	89 e5                	mov    %esp,%ebp
 489:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 493:	8d 45 0c             	lea    0xc(%ebp),%eax
 496:	83 c0 04             	add    $0x4,%eax
 499:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a3:	e9 7c 01 00 00       	jmp    624 <printf+0x19e>
    c = fmt[i] & 0xff;
 4a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ae:	01 d0                	add    %edx,%eax
 4b0:	0f b6 00             	movzbl (%eax),%eax
 4b3:	0f be c0             	movsbl %al,%eax
 4b6:	25 ff 00 00 00       	and    $0xff,%eax
 4bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c2:	75 2c                	jne    4f0 <printf+0x6a>
      if(c == '%'){
 4c4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c8:	75 0c                	jne    4d6 <printf+0x50>
        state = '%';
 4ca:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d1:	e9 4a 01 00 00       	jmp    620 <printf+0x19a>
      } else {
        putc(fd, c);
 4d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d9:	0f be c0             	movsbl %al,%eax
 4dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
 4e3:	89 04 24             	mov    %eax,(%esp)
 4e6:	e8 bb fe ff ff       	call   3a6 <putc>
 4eb:	e9 30 01 00 00       	jmp    620 <printf+0x19a>
      }
    } else if(state == '%'){
 4f0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f4:	0f 85 26 01 00 00    	jne    620 <printf+0x19a>
      if(c == 'd'){
 4fa:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4fe:	75 2d                	jne    52d <printf+0xa7>
        printint(fd, *ap, 10, 1);
 500:	8b 45 e8             	mov    -0x18(%ebp),%eax
 503:	8b 00                	mov    (%eax),%eax
 505:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 50c:	00 
 50d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 514:	00 
 515:	89 44 24 04          	mov    %eax,0x4(%esp)
 519:	8b 45 08             	mov    0x8(%ebp),%eax
 51c:	89 04 24             	mov    %eax,(%esp)
 51f:	e8 aa fe ff ff       	call   3ce <printint>
        ap++;
 524:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 528:	e9 ec 00 00 00       	jmp    619 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 52d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 531:	74 06                	je     539 <printf+0xb3>
 533:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 537:	75 2d                	jne    566 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 539:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53c:	8b 00                	mov    (%eax),%eax
 53e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 545:	00 
 546:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 54d:	00 
 54e:	89 44 24 04          	mov    %eax,0x4(%esp)
 552:	8b 45 08             	mov    0x8(%ebp),%eax
 555:	89 04 24             	mov    %eax,(%esp)
 558:	e8 71 fe ff ff       	call   3ce <printint>
        ap++;
 55d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 561:	e9 b3 00 00 00       	jmp    619 <printf+0x193>
      } else if(c == 's'){
 566:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56a:	75 45                	jne    5b1 <printf+0x12b>
        s = (char*)*ap;
 56c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56f:	8b 00                	mov    (%eax),%eax
 571:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 574:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57c:	75 09                	jne    587 <printf+0x101>
          s = "(null)";
 57e:	c7 45 f4 8a 08 00 00 	movl   $0x88a,-0xc(%ebp)
        while(*s != 0){
 585:	eb 1e                	jmp    5a5 <printf+0x11f>
 587:	eb 1c                	jmp    5a5 <printf+0x11f>
          putc(fd, *s);
 589:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58c:	0f b6 00             	movzbl (%eax),%eax
 58f:	0f be c0             	movsbl %al,%eax
 592:	89 44 24 04          	mov    %eax,0x4(%esp)
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	89 04 24             	mov    %eax,(%esp)
 59c:	e8 05 fe ff ff       	call   3a6 <putc>
          s++;
 5a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a8:	0f b6 00             	movzbl (%eax),%eax
 5ab:	84 c0                	test   %al,%al
 5ad:	75 da                	jne    589 <printf+0x103>
 5af:	eb 68                	jmp    619 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b5:	75 1d                	jne    5d4 <printf+0x14e>
        putc(fd, *ap);
 5b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ba:	8b 00                	mov    (%eax),%eax
 5bc:	0f be c0             	movsbl %al,%eax
 5bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	89 04 24             	mov    %eax,(%esp)
 5c9:	e8 d8 fd ff ff       	call   3a6 <putc>
        ap++;
 5ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d2:	eb 45                	jmp    619 <printf+0x193>
      } else if(c == '%'){
 5d4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d8:	75 17                	jne    5f1 <printf+0x16b>
        putc(fd, c);
 5da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5dd:	0f be c0             	movsbl %al,%eax
 5e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	89 04 24             	mov    %eax,(%esp)
 5ea:	e8 b7 fd ff ff       	call   3a6 <putc>
 5ef:	eb 28                	jmp    619 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5f8:	00 
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	89 04 24             	mov    %eax,(%esp)
 5ff:	e8 a2 fd ff ff       	call   3a6 <putc>
        putc(fd, c);
 604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 607:	0f be c0             	movsbl %al,%eax
 60a:	89 44 24 04          	mov    %eax,0x4(%esp)
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
 611:	89 04 24             	mov    %eax,(%esp)
 614:	e8 8d fd ff ff       	call   3a6 <putc>
      }
      state = 0;
 619:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 620:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 624:	8b 55 0c             	mov    0xc(%ebp),%edx
 627:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62a:	01 d0                	add    %edx,%eax
 62c:	0f b6 00             	movzbl (%eax),%eax
 62f:	84 c0                	test   %al,%al
 631:	0f 85 71 fe ff ff    	jne    4a8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 637:	c9                   	leave  
 638:	c3                   	ret    

00000639 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 639:	55                   	push   %ebp
 63a:	89 e5                	mov    %esp,%ebp
 63c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	83 e8 08             	sub    $0x8,%eax
 645:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 648:	a1 18 0b 00 00       	mov    0xb18,%eax
 64d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 650:	eb 24                	jmp    676 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65a:	77 12                	ja     66e <free+0x35>
 65c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 662:	77 24                	ja     688 <free+0x4f>
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66c:	77 1a                	ja     688 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 00                	mov    (%eax),%eax
 673:	89 45 fc             	mov    %eax,-0x4(%ebp)
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67c:	76 d4                	jbe    652 <free+0x19>
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 686:	76 ca                	jbe    652 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	8b 40 04             	mov    0x4(%eax),%eax
 68e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	01 c2                	add    %eax,%edx
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	39 c2                	cmp    %eax,%edx
 6a1:	75 24                	jne    6c7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	8b 50 04             	mov    0x4(%eax),%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	8b 40 04             	mov    0x4(%eax),%eax
 6b1:	01 c2                	add    %eax,%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	8b 10                	mov    (%eax),%edx
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	89 10                	mov    %edx,(%eax)
 6c5:	eb 0a                	jmp    6d1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 40 04             	mov    0x4(%eax),%eax
 6d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	01 d0                	add    %edx,%eax
 6e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e6:	75 20                	jne    708 <free+0xcf>
    p->s.size += bp->s.size;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 50 04             	mov    0x4(%eax),%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	8b 40 04             	mov    0x4(%eax),%eax
 6f4:	01 c2                	add    %eax,%edx
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ff:	8b 10                	mov    (%eax),%edx
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	89 10                	mov    %edx,(%eax)
 706:	eb 08                	jmp    710 <free+0xd7>
  } else
    p->s.ptr = bp;
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 70e:	89 10                	mov    %edx,(%eax)
  freep = p;
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	a3 18 0b 00 00       	mov    %eax,0xb18
}
 718:	c9                   	leave  
 719:	c3                   	ret    

0000071a <morecore>:

static Header*
morecore(uint nu)
{
 71a:	55                   	push   %ebp
 71b:	89 e5                	mov    %esp,%ebp
 71d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 720:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 727:	77 07                	ja     730 <morecore+0x16>
    nu = 4096;
 729:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	c1 e0 03             	shl    $0x3,%eax
 736:	89 04 24             	mov    %eax,(%esp)
 739:	e8 38 fc ff ff       	call   376 <sbrk>
 73e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 741:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 745:	75 07                	jne    74e <morecore+0x34>
    return 0;
 747:	b8 00 00 00 00       	mov    $0x0,%eax
 74c:	eb 22                	jmp    770 <morecore+0x56>
  hp = (Header*)p;
 74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 751:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 754:	8b 45 f0             	mov    -0x10(%ebp),%eax
 757:	8b 55 08             	mov    0x8(%ebp),%edx
 75a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 75d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 760:	83 c0 08             	add    $0x8,%eax
 763:	89 04 24             	mov    %eax,(%esp)
 766:	e8 ce fe ff ff       	call   639 <free>
  return freep;
 76b:	a1 18 0b 00 00       	mov    0xb18,%eax
}
 770:	c9                   	leave  
 771:	c3                   	ret    

00000772 <malloc>:

void*
malloc(uint nbytes)
{
 772:	55                   	push   %ebp
 773:	89 e5                	mov    %esp,%ebp
 775:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 778:	8b 45 08             	mov    0x8(%ebp),%eax
 77b:	83 c0 07             	add    $0x7,%eax
 77e:	c1 e8 03             	shr    $0x3,%eax
 781:	83 c0 01             	add    $0x1,%eax
 784:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 787:	a1 18 0b 00 00       	mov    0xb18,%eax
 78c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 78f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 793:	75 23                	jne    7b8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 795:	c7 45 f0 10 0b 00 00 	movl   $0xb10,-0x10(%ebp)
 79c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79f:	a3 18 0b 00 00       	mov    %eax,0xb18
 7a4:	a1 18 0b 00 00       	mov    0xb18,%eax
 7a9:	a3 10 0b 00 00       	mov    %eax,0xb10
    base.s.size = 0;
 7ae:	c7 05 14 0b 00 00 00 	movl   $0x0,0xb14
 7b5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	8b 40 04             	mov    0x4(%eax),%eax
 7c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c9:	72 4d                	jb     818 <malloc+0xa6>
      if(p->s.size == nunits)
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	8b 40 04             	mov    0x4(%eax),%eax
 7d1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d4:	75 0c                	jne    7e2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d9:	8b 10                	mov    (%eax),%edx
 7db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7de:	89 10                	mov    %edx,(%eax)
 7e0:	eb 26                	jmp    808 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	8b 40 04             	mov    0x4(%eax),%eax
 7e8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7eb:	89 c2                	mov    %eax,%edx
 7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	c1 e0 03             	shl    $0x3,%eax
 7fc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	8b 55 ec             	mov    -0x14(%ebp),%edx
 805:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 808:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80b:	a3 18 0b 00 00       	mov    %eax,0xb18
      return (void*)(p + 1);
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	83 c0 08             	add    $0x8,%eax
 816:	eb 38                	jmp    850 <malloc+0xde>
    }
    if(p == freep)
 818:	a1 18 0b 00 00       	mov    0xb18,%eax
 81d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 820:	75 1b                	jne    83d <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 822:	8b 45 ec             	mov    -0x14(%ebp),%eax
 825:	89 04 24             	mov    %eax,(%esp)
 828:	e8 ed fe ff ff       	call   71a <morecore>
 82d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 830:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 834:	75 07                	jne    83d <malloc+0xcb>
        return 0;
 836:	b8 00 00 00 00       	mov    $0x0,%eax
 83b:	eb 13                	jmp    850 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	89 45 f0             	mov    %eax,-0x10(%ebp)
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	8b 00                	mov    (%eax),%eax
 848:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 84b:	e9 70 ff ff ff       	jmp    7c0 <malloc+0x4e>
}
 850:	c9                   	leave  
 851:	c3                   	ret    
