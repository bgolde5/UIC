
_thread4b:     file format elf32-i386


Disassembly of section .text:

00000000 <f>:
#include"types.h"
#include"user.h"

int shared = 1;

void f(void) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  while(shared<10000) shared++;
   6:	eb 0d                	jmp    15 <f+0x15>
   8:	a1 50 0b 00 00       	mov    0xb50,%eax
   d:	83 c0 01             	add    $0x1,%eax
  10:	a3 50 0b 00 00       	mov    %eax,0xb50
  15:	a1 50 0b 00 00       	mov    0xb50,%eax
  1a:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  1f:	7e e7                	jle    8 <f+0x8>
  printf(1,"Done looping\n");
  21:	c7 44 24 04 a8 08 00 	movl   $0x8a8,0x4(%esp)
  28:	00 
  29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  30:	e8 a7 04 00 00       	call   4dc <printf>
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
  47:	e8 ad 02 00 00       	call   2f9 <thread_create>
  4c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  while(shared<1000000) shared++;
  50:	eb 0d                	jmp    5f <main+0x28>
  52:	a1 50 0b 00 00       	mov    0xb50,%eax
  57:	83 c0 01             	add    $0x1,%eax
  5a:	a3 50 0b 00 00       	mov    %eax,0xb50
  5f:	a1 50 0b 00 00       	mov    0xb50,%eax
  64:	3d 3f 42 0f 00       	cmp    $0xf423f,%eax
  69:	7e e7                	jle    52 <main+0x1b>
  thread_join(t);
  6b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  6f:	89 04 24             	mov    %eax,(%esp)
  72:	e8 7d 03 00 00       	call   3f4 <thread_join>
  printf(1,"shared = %d\n",shared);
  77:	a1 50 0b 00 00       	mov    0xb50,%eax
  7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  80:	c7 44 24 04 b6 08 00 	movl   $0x8b6,0x4(%esp)
  87:	00 
  88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8f:	e8 48 04 00 00       	call   4dc <printf>
  exit();
  94:	e8 ab 02 00 00       	call   344 <exit>

00000099 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  99:	55                   	push   %ebp
  9a:	89 e5                	mov    %esp,%ebp
  9c:	57                   	push   %edi
  9d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a1:	8b 55 10             	mov    0x10(%ebp),%edx
  a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  a7:	89 cb                	mov    %ecx,%ebx
  a9:	89 df                	mov    %ebx,%edi
  ab:	89 d1                	mov    %edx,%ecx
  ad:	fc                   	cld    
  ae:	f3 aa                	rep stos %al,%es:(%edi)
  b0:	89 ca                	mov    %ecx,%edx
  b2:	89 fb                	mov    %edi,%ebx
  b4:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  ba:	5b                   	pop    %ebx
  bb:	5f                   	pop    %edi
  bc:	5d                   	pop    %ebp
  bd:	c3                   	ret    

000000be <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  c1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ca:	90                   	nop
  cb:	8b 45 08             	mov    0x8(%ebp),%eax
  ce:	8d 50 01             	lea    0x1(%eax),%edx
  d1:	89 55 08             	mov    %edx,0x8(%ebp)
  d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  da:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  dd:	0f b6 12             	movzbl (%edx),%edx
  e0:	88 10                	mov    %dl,(%eax)
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	84 c0                	test   %al,%al
  e7:	75 e2                	jne    cb <strcpy+0xd>
    ;
  return os;
  e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  f1:	eb 08                	jmp    fb <strcmp+0xd>
    p++, q++;
  f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	84 c0                	test   %al,%al
 103:	74 10                	je     115 <strcmp+0x27>
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	0f b6 10             	movzbl (%eax),%edx
 10b:	8b 45 0c             	mov    0xc(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	38 c2                	cmp    %al,%dl
 113:	74 de                	je     f3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	0f b6 d0             	movzbl %al,%edx
 11e:	8b 45 0c             	mov    0xc(%ebp),%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	0f b6 c0             	movzbl %al,%eax
 127:	29 c2                	sub    %eax,%edx
 129:	89 d0                	mov    %edx,%eax
}
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    

0000012d <strlen>:

uint
strlen(char *s)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 13a:	eb 04                	jmp    140 <strlen+0x13>
 13c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 140:	8b 55 fc             	mov    -0x4(%ebp),%edx
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	84 c0                	test   %al,%al
 14d:	75 ed                	jne    13c <strlen+0xf>
    ;
  return n;
 14f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <memset>:

void*
memset(void *dst, int c, uint n)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 15a:	8b 45 10             	mov    0x10(%ebp),%eax
 15d:	89 44 24 08          	mov    %eax,0x8(%esp)
 161:	8b 45 0c             	mov    0xc(%ebp),%eax
 164:	89 44 24 04          	mov    %eax,0x4(%esp)
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	89 04 24             	mov    %eax,(%esp)
 16e:	e8 26 ff ff ff       	call   99 <stosb>
  return dst;
 173:	8b 45 08             	mov    0x8(%ebp),%eax
}
 176:	c9                   	leave  
 177:	c3                   	ret    

00000178 <strchr>:

char*
strchr(const char *s, char c)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 04             	sub    $0x4,%esp
 17e:	8b 45 0c             	mov    0xc(%ebp),%eax
 181:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 184:	eb 14                	jmp    19a <strchr+0x22>
    if(*s == c)
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	0f b6 00             	movzbl (%eax),%eax
 18c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 18f:	75 05                	jne    196 <strchr+0x1e>
      return (char*)s;
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	eb 13                	jmp    1a9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 196:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	0f b6 00             	movzbl (%eax),%eax
 1a0:	84 c0                	test   %al,%al
 1a2:	75 e2                	jne    186 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <gets>:

char*
gets(char *buf, int max)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1b8:	eb 4c                	jmp    206 <gets+0x5b>
    cc = read(0, &c, 1);
 1ba:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1c1:	00 
 1c2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1d0:	e8 87 01 00 00       	call   35c <read>
 1d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1dc:	7f 02                	jg     1e0 <gets+0x35>
      break;
 1de:	eb 31                	jmp    211 <gets+0x66>
    buf[i++] = c;
 1e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e3:	8d 50 01             	lea    0x1(%eax),%edx
 1e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e9:	89 c2                	mov    %eax,%edx
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	01 c2                	add    %eax,%edx
 1f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1f6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fa:	3c 0a                	cmp    $0xa,%al
 1fc:	74 13                	je     211 <gets+0x66>
 1fe:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 202:	3c 0d                	cmp    $0xd,%al
 204:	74 0b                	je     211 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 206:	8b 45 f4             	mov    -0xc(%ebp),%eax
 209:	83 c0 01             	add    $0x1,%eax
 20c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 20f:	7c a9                	jl     1ba <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 211:	8b 55 f4             	mov    -0xc(%ebp),%edx
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	01 d0                	add    %edx,%eax
 219:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <stat>:

int
stat(char *n, struct stat *st)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 227:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 22e:	00 
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	89 04 24             	mov    %eax,(%esp)
 235:	e8 4a 01 00 00       	call   384 <open>
 23a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 23d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 241:	79 07                	jns    24a <stat+0x29>
    return -1;
 243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 248:	eb 23                	jmp    26d <stat+0x4c>
  r = fstat(fd, st);
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 44 24 04          	mov    %eax,0x4(%esp)
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
 254:	89 04 24             	mov    %eax,(%esp)
 257:	e8 40 01 00 00       	call   39c <fstat>
 25c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	89 04 24             	mov    %eax,(%esp)
 265:	e8 02 01 00 00       	call   36c <close>
  return r;
 26a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 26d:	c9                   	leave  
 26e:	c3                   	ret    

0000026f <atoi>:

int
atoi(const char *s)
{
 26f:	55                   	push   %ebp
 270:	89 e5                	mov    %esp,%ebp
 272:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 275:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 27c:	eb 25                	jmp    2a3 <atoi+0x34>
    n = n*10 + *s++ - '0';
 27e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 281:	89 d0                	mov    %edx,%eax
 283:	c1 e0 02             	shl    $0x2,%eax
 286:	01 d0                	add    %edx,%eax
 288:	01 c0                	add    %eax,%eax
 28a:	89 c1                	mov    %eax,%ecx
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	8d 50 01             	lea    0x1(%eax),%edx
 292:	89 55 08             	mov    %edx,0x8(%ebp)
 295:	0f b6 00             	movzbl (%eax),%eax
 298:	0f be c0             	movsbl %al,%eax
 29b:	01 c8                	add    %ecx,%eax
 29d:	83 e8 30             	sub    $0x30,%eax
 2a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	3c 2f                	cmp    $0x2f,%al
 2ab:	7e 0a                	jle    2b7 <atoi+0x48>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 39                	cmp    $0x39,%al
 2b5:	7e c7                	jle    27e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ce:	eb 17                	jmp    2e7 <memmove+0x2b>
    *dst++ = *src++;
 2d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d3:	8d 50 01             	lea    0x1(%eax),%edx
 2d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2dc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2df:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2e2:	0f b6 12             	movzbl (%edx),%edx
 2e5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e7:	8b 45 10             	mov    0x10(%ebp),%eax
 2ea:	8d 50 ff             	lea    -0x1(%eax),%edx
 2ed:	89 55 10             	mov    %edx,0x10(%ebp)
 2f0:	85 c0                	test   %eax,%eax
 2f2:	7f dc                	jg     2d0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 2ff:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 306:	e8 bd 04 00 00       	call   7c8 <malloc>
 30b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 30e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 311:	05 fc ff 0f 00       	add    $0xffffc,%eax
 316:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 319:	ba ec 03 00 00       	mov    $0x3ec,%edx
 31e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 321:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 323:	8b 45 f4             	mov    -0xc(%ebp),%eax
 326:	05 fc ff 0f 00       	add    $0xffffc,%eax
 32b:	89 44 24 04          	mov    %eax,0x4(%esp)
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	89 04 24             	mov    %eax,(%esp)
 335:	e8 aa 00 00 00       	call   3e4 <clone>
}
 33a:	c9                   	leave  
 33b:	c3                   	ret    

0000033c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33c:	b8 01 00 00 00       	mov    $0x1,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <exit>:
SYSCALL(exit)
 344:	b8 02 00 00 00       	mov    $0x2,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <wait>:
SYSCALL(wait)
 34c:	b8 03 00 00 00       	mov    $0x3,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <pipe>:
SYSCALL(pipe)
 354:	b8 04 00 00 00       	mov    $0x4,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <read>:
SYSCALL(read)
 35c:	b8 05 00 00 00       	mov    $0x5,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <write>:
SYSCALL(write)
 364:	b8 10 00 00 00       	mov    $0x10,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <close>:
SYSCALL(close)
 36c:	b8 15 00 00 00       	mov    $0x15,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <kill>:
SYSCALL(kill)
 374:	b8 06 00 00 00       	mov    $0x6,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exec>:
SYSCALL(exec)
 37c:	b8 07 00 00 00       	mov    $0x7,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <open>:
SYSCALL(open)
 384:	b8 0f 00 00 00       	mov    $0xf,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <mknod>:
SYSCALL(mknod)
 38c:	b8 11 00 00 00       	mov    $0x11,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <unlink>:
SYSCALL(unlink)
 394:	b8 12 00 00 00       	mov    $0x12,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <fstat>:
SYSCALL(fstat)
 39c:	b8 08 00 00 00       	mov    $0x8,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <link>:
SYSCALL(link)
 3a4:	b8 13 00 00 00       	mov    $0x13,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <mkdir>:
SYSCALL(mkdir)
 3ac:	b8 14 00 00 00       	mov    $0x14,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <chdir>:
SYSCALL(chdir)
 3b4:	b8 09 00 00 00       	mov    $0x9,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <dup>:
SYSCALL(dup)
 3bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <getpid>:
SYSCALL(getpid)
 3c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <sbrk>:
SYSCALL(sbrk)
 3cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <sleep>:
SYSCALL(sleep)
 3d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <uptime>:
SYSCALL(uptime)
 3dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <clone>:
SYSCALL(clone)
 3e4:	b8 16 00 00 00       	mov    $0x16,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <thread_exit>:
SYSCALL(thread_exit)
 3ec:	b8 17 00 00 00       	mov    $0x17,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <thread_join>:
SYSCALL(thread_join)
 3f4:	b8 18 00 00 00       	mov    $0x18,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	83 ec 18             	sub    $0x18,%esp
 402:	8b 45 0c             	mov    0xc(%ebp),%eax
 405:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 408:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 40f:	00 
 410:	8d 45 f4             	lea    -0xc(%ebp),%eax
 413:	89 44 24 04          	mov    %eax,0x4(%esp)
 417:	8b 45 08             	mov    0x8(%ebp),%eax
 41a:	89 04 24             	mov    %eax,(%esp)
 41d:	e8 42 ff ff ff       	call   364 <write>
}
 422:	c9                   	leave  
 423:	c3                   	ret    

00000424 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	56                   	push   %esi
 428:	53                   	push   %ebx
 429:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 42c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 433:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 437:	74 17                	je     450 <printint+0x2c>
 439:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 43d:	79 11                	jns    450 <printint+0x2c>
    neg = 1;
 43f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 446:	8b 45 0c             	mov    0xc(%ebp),%eax
 449:	f7 d8                	neg    %eax
 44b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44e:	eb 06                	jmp    456 <printint+0x32>
  } else {
    x = xx;
 450:	8b 45 0c             	mov    0xc(%ebp),%eax
 453:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 456:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 45d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 460:	8d 41 01             	lea    0x1(%ecx),%eax
 463:	89 45 f4             	mov    %eax,-0xc(%ebp)
 466:	8b 5d 10             	mov    0x10(%ebp),%ebx
 469:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46c:	ba 00 00 00 00       	mov    $0x0,%edx
 471:	f7 f3                	div    %ebx
 473:	89 d0                	mov    %edx,%eax
 475:	0f b6 80 54 0b 00 00 	movzbl 0xb54(%eax),%eax
 47c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 480:	8b 75 10             	mov    0x10(%ebp),%esi
 483:	8b 45 ec             	mov    -0x14(%ebp),%eax
 486:	ba 00 00 00 00       	mov    $0x0,%edx
 48b:	f7 f6                	div    %esi
 48d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 490:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 494:	75 c7                	jne    45d <printint+0x39>
  if(neg)
 496:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49a:	74 10                	je     4ac <printint+0x88>
    buf[i++] = '-';
 49c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49f:	8d 50 01             	lea    0x1(%eax),%edx
 4a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4aa:	eb 1f                	jmp    4cb <printint+0xa7>
 4ac:	eb 1d                	jmp    4cb <printint+0xa7>
    putc(fd, buf[i]);
 4ae:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b4:	01 d0                	add    %edx,%eax
 4b6:	0f b6 00             	movzbl (%eax),%eax
 4b9:	0f be c0             	movsbl %al,%eax
 4bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	89 04 24             	mov    %eax,(%esp)
 4c6:	e8 31 ff ff ff       	call   3fc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4cb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d3:	79 d9                	jns    4ae <printint+0x8a>
    putc(fd, buf[i]);
}
 4d5:	83 c4 30             	add    $0x30,%esp
 4d8:	5b                   	pop    %ebx
 4d9:	5e                   	pop    %esi
 4da:	5d                   	pop    %ebp
 4db:	c3                   	ret    

000004dc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4dc:	55                   	push   %ebp
 4dd:	89 e5                	mov    %esp,%ebp
 4df:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e9:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ec:	83 c0 04             	add    $0x4,%eax
 4ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f9:	e9 7c 01 00 00       	jmp    67a <printf+0x19e>
    c = fmt[i] & 0xff;
 4fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 501:	8b 45 f0             	mov    -0x10(%ebp),%eax
 504:	01 d0                	add    %edx,%eax
 506:	0f b6 00             	movzbl (%eax),%eax
 509:	0f be c0             	movsbl %al,%eax
 50c:	25 ff 00 00 00       	and    $0xff,%eax
 511:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 518:	75 2c                	jne    546 <printf+0x6a>
      if(c == '%'){
 51a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 51e:	75 0c                	jne    52c <printf+0x50>
        state = '%';
 520:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 527:	e9 4a 01 00 00       	jmp    676 <printf+0x19a>
      } else {
        putc(fd, c);
 52c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52f:	0f be c0             	movsbl %al,%eax
 532:	89 44 24 04          	mov    %eax,0x4(%esp)
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	89 04 24             	mov    %eax,(%esp)
 53c:	e8 bb fe ff ff       	call   3fc <putc>
 541:	e9 30 01 00 00       	jmp    676 <printf+0x19a>
      }
    } else if(state == '%'){
 546:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 54a:	0f 85 26 01 00 00    	jne    676 <printf+0x19a>
      if(c == 'd'){
 550:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 554:	75 2d                	jne    583 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 556:	8b 45 e8             	mov    -0x18(%ebp),%eax
 559:	8b 00                	mov    (%eax),%eax
 55b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 562:	00 
 563:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 56a:	00 
 56b:	89 44 24 04          	mov    %eax,0x4(%esp)
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	89 04 24             	mov    %eax,(%esp)
 575:	e8 aa fe ff ff       	call   424 <printint>
        ap++;
 57a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57e:	e9 ec 00 00 00       	jmp    66f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 583:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 587:	74 06                	je     58f <printf+0xb3>
 589:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 58d:	75 2d                	jne    5bc <printf+0xe0>
        printint(fd, *ap, 16, 0);
 58f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 592:	8b 00                	mov    (%eax),%eax
 594:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 59b:	00 
 59c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5a3:	00 
 5a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	89 04 24             	mov    %eax,(%esp)
 5ae:	e8 71 fe ff ff       	call   424 <printint>
        ap++;
 5b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b7:	e9 b3 00 00 00       	jmp    66f <printf+0x193>
      } else if(c == 's'){
 5bc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5c0:	75 45                	jne    607 <printf+0x12b>
        s = (char*)*ap;
 5c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c5:	8b 00                	mov    (%eax),%eax
 5c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d2:	75 09                	jne    5dd <printf+0x101>
          s = "(null)";
 5d4:	c7 45 f4 c3 08 00 00 	movl   $0x8c3,-0xc(%ebp)
        while(*s != 0){
 5db:	eb 1e                	jmp    5fb <printf+0x11f>
 5dd:	eb 1c                	jmp    5fb <printf+0x11f>
          putc(fd, *s);
 5df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ec:	8b 45 08             	mov    0x8(%ebp),%eax
 5ef:	89 04 24             	mov    %eax,(%esp)
 5f2:	e8 05 fe ff ff       	call   3fc <putc>
          s++;
 5f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fe:	0f b6 00             	movzbl (%eax),%eax
 601:	84 c0                	test   %al,%al
 603:	75 da                	jne    5df <printf+0x103>
 605:	eb 68                	jmp    66f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 607:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 60b:	75 1d                	jne    62a <printf+0x14e>
        putc(fd, *ap);
 60d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 610:	8b 00                	mov    (%eax),%eax
 612:	0f be c0             	movsbl %al,%eax
 615:	89 44 24 04          	mov    %eax,0x4(%esp)
 619:	8b 45 08             	mov    0x8(%ebp),%eax
 61c:	89 04 24             	mov    %eax,(%esp)
 61f:	e8 d8 fd ff ff       	call   3fc <putc>
        ap++;
 624:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 628:	eb 45                	jmp    66f <printf+0x193>
      } else if(c == '%'){
 62a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62e:	75 17                	jne    647 <printf+0x16b>
        putc(fd, c);
 630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 633:	0f be c0             	movsbl %al,%eax
 636:	89 44 24 04          	mov    %eax,0x4(%esp)
 63a:	8b 45 08             	mov    0x8(%ebp),%eax
 63d:	89 04 24             	mov    %eax,(%esp)
 640:	e8 b7 fd ff ff       	call   3fc <putc>
 645:	eb 28                	jmp    66f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 647:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 64e:	00 
 64f:	8b 45 08             	mov    0x8(%ebp),%eax
 652:	89 04 24             	mov    %eax,(%esp)
 655:	e8 a2 fd ff ff       	call   3fc <putc>
        putc(fd, c);
 65a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65d:	0f be c0             	movsbl %al,%eax
 660:	89 44 24 04          	mov    %eax,0x4(%esp)
 664:	8b 45 08             	mov    0x8(%ebp),%eax
 667:	89 04 24             	mov    %eax,(%esp)
 66a:	e8 8d fd ff ff       	call   3fc <putc>
      }
      state = 0;
 66f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 676:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 67a:	8b 55 0c             	mov    0xc(%ebp),%edx
 67d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 680:	01 d0                	add    %edx,%eax
 682:	0f b6 00             	movzbl (%eax),%eax
 685:	84 c0                	test   %al,%al
 687:	0f 85 71 fe ff ff    	jne    4fe <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 68d:	c9                   	leave  
 68e:	c3                   	ret    

0000068f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68f:	55                   	push   %ebp
 690:	89 e5                	mov    %esp,%ebp
 692:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	83 e8 08             	sub    $0x8,%eax
 69b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69e:	a1 70 0b 00 00       	mov    0xb70,%eax
 6a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a6:	eb 24                	jmp    6cc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b0:	77 12                	ja     6c4 <free+0x35>
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b8:	77 24                	ja     6de <free+0x4f>
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c2:	77 1a                	ja     6de <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 00                	mov    (%eax),%eax
 6c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d2:	76 d4                	jbe    6a8 <free+0x19>
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6dc:	76 ca                	jbe    6a8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	8b 40 04             	mov    0x4(%eax),%eax
 6e4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	01 c2                	add    %eax,%edx
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	39 c2                	cmp    %eax,%edx
 6f7:	75 24                	jne    71d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	8b 50 04             	mov    0x4(%eax),%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	8b 40 04             	mov    0x4(%eax),%eax
 707:	01 c2                	add    %eax,%edx
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	8b 10                	mov    (%eax),%edx
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	89 10                	mov    %edx,(%eax)
 71b:	eb 0a                	jmp    727 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 10                	mov    (%eax),%edx
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	8b 40 04             	mov    0x4(%eax),%eax
 72d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	01 d0                	add    %edx,%eax
 739:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73c:	75 20                	jne    75e <free+0xcf>
    p->s.size += bp->s.size;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 50 04             	mov    0x4(%eax),%edx
 744:	8b 45 f8             	mov    -0x8(%ebp),%eax
 747:	8b 40 04             	mov    0x4(%eax),%eax
 74a:	01 c2                	add    %eax,%edx
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 752:	8b 45 f8             	mov    -0x8(%ebp),%eax
 755:	8b 10                	mov    (%eax),%edx
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	89 10                	mov    %edx,(%eax)
 75c:	eb 08                	jmp    766 <free+0xd7>
  } else
    p->s.ptr = bp;
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 55 f8             	mov    -0x8(%ebp),%edx
 764:	89 10                	mov    %edx,(%eax)
  freep = p;
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	a3 70 0b 00 00       	mov    %eax,0xb70
}
 76e:	c9                   	leave  
 76f:	c3                   	ret    

00000770 <morecore>:

static Header*
morecore(uint nu)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 776:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 77d:	77 07                	ja     786 <morecore+0x16>
    nu = 4096;
 77f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 786:	8b 45 08             	mov    0x8(%ebp),%eax
 789:	c1 e0 03             	shl    $0x3,%eax
 78c:	89 04 24             	mov    %eax,(%esp)
 78f:	e8 38 fc ff ff       	call   3cc <sbrk>
 794:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 797:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 79b:	75 07                	jne    7a4 <morecore+0x34>
    return 0;
 79d:	b8 00 00 00 00       	mov    $0x0,%eax
 7a2:	eb 22                	jmp    7c6 <morecore+0x56>
  hp = (Header*)p;
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ad:	8b 55 08             	mov    0x8(%ebp),%edx
 7b0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b6:	83 c0 08             	add    $0x8,%eax
 7b9:	89 04 24             	mov    %eax,(%esp)
 7bc:	e8 ce fe ff ff       	call   68f <free>
  return freep;
 7c1:	a1 70 0b 00 00       	mov    0xb70,%eax
}
 7c6:	c9                   	leave  
 7c7:	c3                   	ret    

000007c8 <malloc>:

void*
malloc(uint nbytes)
{
 7c8:	55                   	push   %ebp
 7c9:	89 e5                	mov    %esp,%ebp
 7cb:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ce:	8b 45 08             	mov    0x8(%ebp),%eax
 7d1:	83 c0 07             	add    $0x7,%eax
 7d4:	c1 e8 03             	shr    $0x3,%eax
 7d7:	83 c0 01             	add    $0x1,%eax
 7da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7dd:	a1 70 0b 00 00       	mov    0xb70,%eax
 7e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e9:	75 23                	jne    80e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7eb:	c7 45 f0 68 0b 00 00 	movl   $0xb68,-0x10(%ebp)
 7f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f5:	a3 70 0b 00 00       	mov    %eax,0xb70
 7fa:	a1 70 0b 00 00       	mov    0xb70,%eax
 7ff:	a3 68 0b 00 00       	mov    %eax,0xb68
    base.s.size = 0;
 804:	c7 05 6c 0b 00 00 00 	movl   $0x0,0xb6c
 80b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 811:	8b 00                	mov    (%eax),%eax
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81f:	72 4d                	jb     86e <malloc+0xa6>
      if(p->s.size == nunits)
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 82a:	75 0c                	jne    838 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	8b 10                	mov    (%eax),%edx
 831:	8b 45 f0             	mov    -0x10(%ebp),%eax
 834:	89 10                	mov    %edx,(%eax)
 836:	eb 26                	jmp    85e <malloc+0x96>
      else {
        p->s.size -= nunits;
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	8b 40 04             	mov    0x4(%eax),%eax
 83e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 841:	89 c2                	mov    %eax,%edx
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	8b 40 04             	mov    0x4(%eax),%eax
 84f:	c1 e0 03             	shl    $0x3,%eax
 852:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	8b 55 ec             	mov    -0x14(%ebp),%edx
 85b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 861:	a3 70 0b 00 00       	mov    %eax,0xb70
      return (void*)(p + 1);
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	83 c0 08             	add    $0x8,%eax
 86c:	eb 38                	jmp    8a6 <malloc+0xde>
    }
    if(p == freep)
 86e:	a1 70 0b 00 00       	mov    0xb70,%eax
 873:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 876:	75 1b                	jne    893 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 878:	8b 45 ec             	mov    -0x14(%ebp),%eax
 87b:	89 04 24             	mov    %eax,(%esp)
 87e:	e8 ed fe ff ff       	call   770 <morecore>
 883:	89 45 f4             	mov    %eax,-0xc(%ebp)
 886:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 88a:	75 07                	jne    893 <malloc+0xcb>
        return 0;
 88c:	b8 00 00 00 00       	mov    $0x0,%eax
 891:	eb 13                	jmp    8a6 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	89 45 f0             	mov    %eax,-0x10(%ebp)
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 00                	mov    (%eax),%eax
 89e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8a1:	e9 70 ff ff ff       	jmp    816 <malloc+0x4e>
}
 8a6:	c9                   	leave  
 8a7:	c3                   	ret    
