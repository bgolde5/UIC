
_rm:     file format elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: rm files...\n");
   f:	c7 44 24 04 9e 08 00 	movl   $0x89e,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 af 04 00 00       	call   4d2 <printf>
    exit();
  23:	e8 12 03 00 00       	call   33a <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4f                	jmp    81 <main+0x81>
    if(unlink(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 3e 03 00 00       	call   38a <unlink>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 b2 08 00 	movl   $0x8b2,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 58 04 00 00       	call   4d2 <printf>
      break;
  7a:	eb 0e                	jmp    8a <main+0x8a>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  85:	3b 45 08             	cmp    0x8(%ebp),%eax
  88:	7c a8                	jl     32 <main+0x32>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  8a:	e8 ab 02 00 00       	call   33a <exit>

0000008f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	57                   	push   %edi
  93:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 10             	mov    0x10(%ebp),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	89 cb                	mov    %ecx,%ebx
  9f:	89 df                	mov    %ebx,%edi
  a1:	89 d1                	mov    %edx,%ecx
  a3:	fc                   	cld    
  a4:	f3 aa                	rep stos %al,%es:(%edi)
  a6:	89 ca                	mov    %ecx,%edx
  a8:	89 fb                	mov    %edi,%ebx
  aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b0:	5b                   	pop    %ebx
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c0:	90                   	nop
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	8d 50 01             	lea    0x1(%eax),%edx
  c7:	89 55 08             	mov    %edx,0x8(%ebp)
  ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d3:	0f b6 12             	movzbl (%edx),%edx
  d6:	88 10                	mov    %dl,(%eax)
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	75 e2                	jne    c1 <strcpy+0xd>
    ;
  return os;
  df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e2:	c9                   	leave  
  e3:	c3                   	ret    

000000e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e7:	eb 08                	jmp    f1 <strcmp+0xd>
    p++, q++;
  e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	84 c0                	test   %al,%al
  f9:	74 10                	je     10b <strcmp+0x27>
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 10             	movzbl (%eax),%edx
 101:	8b 45 0c             	mov    0xc(%ebp),%eax
 104:	0f b6 00             	movzbl (%eax),%eax
 107:	38 c2                	cmp    %al,%dl
 109:	74 de                	je     e9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	0f b6 d0             	movzbl %al,%edx
 114:	8b 45 0c             	mov    0xc(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	0f b6 c0             	movzbl %al,%eax
 11d:	29 c2                	sub    %eax,%edx
 11f:	89 d0                	mov    %edx,%eax
}
 121:	5d                   	pop    %ebp
 122:	c3                   	ret    

00000123 <strlen>:

uint
strlen(char *s)
{
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 130:	eb 04                	jmp    136 <strlen+0x13>
 132:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 136:	8b 55 fc             	mov    -0x4(%ebp),%edx
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	01 d0                	add    %edx,%eax
 13e:	0f b6 00             	movzbl (%eax),%eax
 141:	84 c0                	test   %al,%al
 143:	75 ed                	jne    132 <strlen+0xf>
    ;
  return n;
 145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <memset>:

void*
memset(void *dst, int c, uint n)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 150:	8b 45 10             	mov    0x10(%ebp),%eax
 153:	89 44 24 08          	mov    %eax,0x8(%esp)
 157:	8b 45 0c             	mov    0xc(%ebp),%eax
 15a:	89 44 24 04          	mov    %eax,0x4(%esp)
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	89 04 24             	mov    %eax,(%esp)
 164:	e8 26 ff ff ff       	call   8f <stosb>
  return dst;
 169:	8b 45 08             	mov    0x8(%ebp),%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <strchr>:

char*
strchr(const char *s, char c)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 04             	sub    $0x4,%esp
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 17a:	eb 14                	jmp    190 <strchr+0x22>
    if(*s == c)
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 00             	movzbl (%eax),%eax
 182:	3a 45 fc             	cmp    -0x4(%ebp),%al
 185:	75 05                	jne    18c <strchr+0x1e>
      return (char*)s;
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	eb 13                	jmp    19f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 18c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	0f b6 00             	movzbl (%eax),%eax
 196:	84 c0                	test   %al,%al
 198:	75 e2                	jne    17c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 19a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 19f:	c9                   	leave  
 1a0:	c3                   	ret    

000001a1 <gets>:

char*
gets(char *buf, int max)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
 1a4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ae:	eb 4c                	jmp    1fc <gets+0x5b>
    cc = read(0, &c, 1);
 1b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1b7:	00 
 1b8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c6:	e8 87 01 00 00       	call   352 <read>
 1cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d2:	7f 02                	jg     1d6 <gets+0x35>
      break;
 1d4:	eb 31                	jmp    207 <gets+0x66>
    buf[i++] = c;
 1d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d9:	8d 50 01             	lea    0x1(%eax),%edx
 1dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1df:	89 c2                	mov    %eax,%edx
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	01 c2                	add    %eax,%edx
 1e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ea:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f0:	3c 0a                	cmp    $0xa,%al
 1f2:	74 13                	je     207 <gets+0x66>
 1f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f8:	3c 0d                	cmp    $0xd,%al
 1fa:	74 0b                	je     207 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ff:	83 c0 01             	add    $0x1,%eax
 202:	3b 45 0c             	cmp    0xc(%ebp),%eax
 205:	7c a9                	jl     1b0 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 207:	8b 55 f4             	mov    -0xc(%ebp),%edx
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	01 d0                	add    %edx,%eax
 20f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 212:	8b 45 08             	mov    0x8(%ebp),%eax
}
 215:	c9                   	leave  
 216:	c3                   	ret    

00000217 <stat>:

int
stat(char *n, struct stat *st)
{
 217:	55                   	push   %ebp
 218:	89 e5                	mov    %esp,%ebp
 21a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 224:	00 
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	89 04 24             	mov    %eax,(%esp)
 22b:	e8 4a 01 00 00       	call   37a <open>
 230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 237:	79 07                	jns    240 <stat+0x29>
    return -1;
 239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 23e:	eb 23                	jmp    263 <stat+0x4c>
  r = fstat(fd, st);
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	89 44 24 04          	mov    %eax,0x4(%esp)
 247:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24a:	89 04 24             	mov    %eax,(%esp)
 24d:	e8 40 01 00 00       	call   392 <fstat>
 252:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 255:	8b 45 f4             	mov    -0xc(%ebp),%eax
 258:	89 04 24             	mov    %eax,(%esp)
 25b:	e8 02 01 00 00       	call   362 <close>
  return r;
 260:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <atoi>:

int
atoi(const char *s)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 26b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 272:	eb 25                	jmp    299 <atoi+0x34>
    n = n*10 + *s++ - '0';
 274:	8b 55 fc             	mov    -0x4(%ebp),%edx
 277:	89 d0                	mov    %edx,%eax
 279:	c1 e0 02             	shl    $0x2,%eax
 27c:	01 d0                	add    %edx,%eax
 27e:	01 c0                	add    %eax,%eax
 280:	89 c1                	mov    %eax,%ecx
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	8d 50 01             	lea    0x1(%eax),%edx
 288:	89 55 08             	mov    %edx,0x8(%ebp)
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	0f be c0             	movsbl %al,%eax
 291:	01 c8                	add    %ecx,%eax
 293:	83 e8 30             	sub    $0x30,%eax
 296:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	3c 2f                	cmp    $0x2f,%al
 2a1:	7e 0a                	jle    2ad <atoi+0x48>
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	3c 39                	cmp    $0x39,%al
 2ab:	7e c7                	jle    274 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b0:	c9                   	leave  
 2b1:	c3                   	ret    

000002b2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2be:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c4:	eb 17                	jmp    2dd <memmove+0x2b>
    *dst++ = *src++;
 2c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c9:	8d 50 01             	lea    0x1(%eax),%edx
 2cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2d2:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d8:	0f b6 12             	movzbl (%edx),%edx
 2db:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2dd:	8b 45 10             	mov    0x10(%ebp),%eax
 2e0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2e3:	89 55 10             	mov    %edx,0x10(%ebp)
 2e6:	85 c0                	test   %eax,%eax
 2e8:	7f dc                	jg     2c6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ed:	c9                   	leave  
 2ee:	c3                   	ret    

000002ef <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 2ef:	55                   	push   %ebp
 2f0:	89 e5                	mov    %esp,%ebp
 2f2:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 2f5:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 2fc:	e8 bd 04 00 00       	call   7be <malloc>
 301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 304:	8b 45 f4             	mov    -0xc(%ebp),%eax
 307:	05 fc ff 0f 00       	add    $0xffffc,%eax
 30c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 30f:	ba e2 03 00 00       	mov    $0x3e2,%edx
 314:	8b 45 f0             	mov    -0x10(%ebp),%eax
 317:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 319:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31c:	05 fc ff 0f 00       	add    $0xffffc,%eax
 321:	89 44 24 04          	mov    %eax,0x4(%esp)
 325:	8b 45 08             	mov    0x8(%ebp),%eax
 328:	89 04 24             	mov    %eax,(%esp)
 32b:	e8 aa 00 00 00       	call   3da <clone>
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 332:	b8 01 00 00 00       	mov    $0x1,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <exit>:
SYSCALL(exit)
 33a:	b8 02 00 00 00       	mov    $0x2,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <wait>:
SYSCALL(wait)
 342:	b8 03 00 00 00       	mov    $0x3,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <pipe>:
SYSCALL(pipe)
 34a:	b8 04 00 00 00       	mov    $0x4,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <read>:
SYSCALL(read)
 352:	b8 05 00 00 00       	mov    $0x5,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <write>:
SYSCALL(write)
 35a:	b8 10 00 00 00       	mov    $0x10,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <close>:
SYSCALL(close)
 362:	b8 15 00 00 00       	mov    $0x15,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <kill>:
SYSCALL(kill)
 36a:	b8 06 00 00 00       	mov    $0x6,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <exec>:
SYSCALL(exec)
 372:	b8 07 00 00 00       	mov    $0x7,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <open>:
SYSCALL(open)
 37a:	b8 0f 00 00 00       	mov    $0xf,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <mknod>:
SYSCALL(mknod)
 382:	b8 11 00 00 00       	mov    $0x11,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <unlink>:
SYSCALL(unlink)
 38a:	b8 12 00 00 00       	mov    $0x12,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <fstat>:
SYSCALL(fstat)
 392:	b8 08 00 00 00       	mov    $0x8,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <link>:
SYSCALL(link)
 39a:	b8 13 00 00 00       	mov    $0x13,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <mkdir>:
SYSCALL(mkdir)
 3a2:	b8 14 00 00 00       	mov    $0x14,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <chdir>:
SYSCALL(chdir)
 3aa:	b8 09 00 00 00       	mov    $0x9,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <dup>:
SYSCALL(dup)
 3b2:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <getpid>:
SYSCALL(getpid)
 3ba:	b8 0b 00 00 00       	mov    $0xb,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <sbrk>:
SYSCALL(sbrk)
 3c2:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <sleep>:
SYSCALL(sleep)
 3ca:	b8 0d 00 00 00       	mov    $0xd,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <uptime>:
SYSCALL(uptime)
 3d2:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <clone>:
SYSCALL(clone)
 3da:	b8 16 00 00 00       	mov    $0x16,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <thread_exit>:
SYSCALL(thread_exit)
 3e2:	b8 17 00 00 00       	mov    $0x17,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <thread_join>:
SYSCALL(thread_join)
 3ea:	b8 18 00 00 00       	mov    $0x18,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	83 ec 18             	sub    $0x18,%esp
 3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 405:	00 
 406:	8d 45 f4             	lea    -0xc(%ebp),%eax
 409:	89 44 24 04          	mov    %eax,0x4(%esp)
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	89 04 24             	mov    %eax,(%esp)
 413:	e8 42 ff ff ff       	call   35a <write>
}
 418:	c9                   	leave  
 419:	c3                   	ret    

0000041a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41a:	55                   	push   %ebp
 41b:	89 e5                	mov    %esp,%ebp
 41d:	56                   	push   %esi
 41e:	53                   	push   %ebx
 41f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 422:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 429:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 42d:	74 17                	je     446 <printint+0x2c>
 42f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 433:	79 11                	jns    446 <printint+0x2c>
    neg = 1;
 435:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 43c:	8b 45 0c             	mov    0xc(%ebp),%eax
 43f:	f7 d8                	neg    %eax
 441:	89 45 ec             	mov    %eax,-0x14(%ebp)
 444:	eb 06                	jmp    44c <printint+0x32>
  } else {
    x = xx;
 446:	8b 45 0c             	mov    0xc(%ebp),%eax
 449:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 44c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 453:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 456:	8d 41 01             	lea    0x1(%ecx),%eax
 459:	89 45 f4             	mov    %eax,-0xc(%ebp)
 45c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 45f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 462:	ba 00 00 00 00       	mov    $0x0,%edx
 467:	f7 f3                	div    %ebx
 469:	89 d0                	mov    %edx,%eax
 46b:	0f b6 80 38 0b 00 00 	movzbl 0xb38(%eax),%eax
 472:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 476:	8b 75 10             	mov    0x10(%ebp),%esi
 479:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47c:	ba 00 00 00 00       	mov    $0x0,%edx
 481:	f7 f6                	div    %esi
 483:	89 45 ec             	mov    %eax,-0x14(%ebp)
 486:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 48a:	75 c7                	jne    453 <printint+0x39>
  if(neg)
 48c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 490:	74 10                	je     4a2 <printint+0x88>
    buf[i++] = '-';
 492:	8b 45 f4             	mov    -0xc(%ebp),%eax
 495:	8d 50 01             	lea    0x1(%eax),%edx
 498:	89 55 f4             	mov    %edx,-0xc(%ebp)
 49b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a0:	eb 1f                	jmp    4c1 <printint+0xa7>
 4a2:	eb 1d                	jmp    4c1 <printint+0xa7>
    putc(fd, buf[i]);
 4a4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4aa:	01 d0                	add    %edx,%eax
 4ac:	0f b6 00             	movzbl (%eax),%eax
 4af:	0f be c0             	movsbl %al,%eax
 4b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	89 04 24             	mov    %eax,(%esp)
 4bc:	e8 31 ff ff ff       	call   3f2 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c9:	79 d9                	jns    4a4 <printint+0x8a>
    putc(fd, buf[i]);
}
 4cb:	83 c4 30             	add    $0x30,%esp
 4ce:	5b                   	pop    %ebx
 4cf:	5e                   	pop    %esi
 4d0:	5d                   	pop    %ebp
 4d1:	c3                   	ret    

000004d2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d2:	55                   	push   %ebp
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4df:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e2:	83 c0 04             	add    $0x4,%eax
 4e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ef:	e9 7c 01 00 00       	jmp    670 <printf+0x19e>
    c = fmt[i] & 0xff;
 4f4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4fa:	01 d0                	add    %edx,%eax
 4fc:	0f b6 00             	movzbl (%eax),%eax
 4ff:	0f be c0             	movsbl %al,%eax
 502:	25 ff 00 00 00       	and    $0xff,%eax
 507:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 50a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50e:	75 2c                	jne    53c <printf+0x6a>
      if(c == '%'){
 510:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 514:	75 0c                	jne    522 <printf+0x50>
        state = '%';
 516:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 51d:	e9 4a 01 00 00       	jmp    66c <printf+0x19a>
      } else {
        putc(fd, c);
 522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 525:	0f be c0             	movsbl %al,%eax
 528:	89 44 24 04          	mov    %eax,0x4(%esp)
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
 52f:	89 04 24             	mov    %eax,(%esp)
 532:	e8 bb fe ff ff       	call   3f2 <putc>
 537:	e9 30 01 00 00       	jmp    66c <printf+0x19a>
      }
    } else if(state == '%'){
 53c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 540:	0f 85 26 01 00 00    	jne    66c <printf+0x19a>
      if(c == 'd'){
 546:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 54a:	75 2d                	jne    579 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 54c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54f:	8b 00                	mov    (%eax),%eax
 551:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 558:	00 
 559:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 560:	00 
 561:	89 44 24 04          	mov    %eax,0x4(%esp)
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	89 04 24             	mov    %eax,(%esp)
 56b:	e8 aa fe ff ff       	call   41a <printint>
        ap++;
 570:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 574:	e9 ec 00 00 00       	jmp    665 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 579:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 57d:	74 06                	je     585 <printf+0xb3>
 57f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 583:	75 2d                	jne    5b2 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 585:	8b 45 e8             	mov    -0x18(%ebp),%eax
 588:	8b 00                	mov    (%eax),%eax
 58a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 591:	00 
 592:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 599:	00 
 59a:	89 44 24 04          	mov    %eax,0x4(%esp)
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	89 04 24             	mov    %eax,(%esp)
 5a4:	e8 71 fe ff ff       	call   41a <printint>
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ad:	e9 b3 00 00 00       	jmp    665 <printf+0x193>
      } else if(c == 's'){
 5b2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5b6:	75 45                	jne    5fd <printf+0x12b>
        s = (char*)*ap;
 5b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bb:	8b 00                	mov    (%eax),%eax
 5bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c8:	75 09                	jne    5d3 <printf+0x101>
          s = "(null)";
 5ca:	c7 45 f4 cb 08 00 00 	movl   $0x8cb,-0xc(%ebp)
        while(*s != 0){
 5d1:	eb 1e                	jmp    5f1 <printf+0x11f>
 5d3:	eb 1c                	jmp    5f1 <printf+0x11f>
          putc(fd, *s);
 5d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d8:	0f b6 00             	movzbl (%eax),%eax
 5db:	0f be c0             	movsbl %al,%eax
 5de:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	89 04 24             	mov    %eax,(%esp)
 5e8:	e8 05 fe ff ff       	call   3f2 <putc>
          s++;
 5ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f4:	0f b6 00             	movzbl (%eax),%eax
 5f7:	84 c0                	test   %al,%al
 5f9:	75 da                	jne    5d5 <printf+0x103>
 5fb:	eb 68                	jmp    665 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 601:	75 1d                	jne    620 <printf+0x14e>
        putc(fd, *ap);
 603:	8b 45 e8             	mov    -0x18(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	89 44 24 04          	mov    %eax,0x4(%esp)
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	89 04 24             	mov    %eax,(%esp)
 615:	e8 d8 fd ff ff       	call   3f2 <putc>
        ap++;
 61a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61e:	eb 45                	jmp    665 <printf+0x193>
      } else if(c == '%'){
 620:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 624:	75 17                	jne    63d <printf+0x16b>
        putc(fd, c);
 626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 629:	0f be c0             	movsbl %al,%eax
 62c:	89 44 24 04          	mov    %eax,0x4(%esp)
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	89 04 24             	mov    %eax,(%esp)
 636:	e8 b7 fd ff ff       	call   3f2 <putc>
 63b:	eb 28                	jmp    665 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 644:	00 
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	89 04 24             	mov    %eax,(%esp)
 64b:	e8 a2 fd ff ff       	call   3f2 <putc>
        putc(fd, c);
 650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	89 44 24 04          	mov    %eax,0x4(%esp)
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	89 04 24             	mov    %eax,(%esp)
 660:	e8 8d fd ff ff       	call   3f2 <putc>
      }
      state = 0;
 665:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 66c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 670:	8b 55 0c             	mov    0xc(%ebp),%edx
 673:	8b 45 f0             	mov    -0x10(%ebp),%eax
 676:	01 d0                	add    %edx,%eax
 678:	0f b6 00             	movzbl (%eax),%eax
 67b:	84 c0                	test   %al,%al
 67d:	0f 85 71 fe ff ff    	jne    4f4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 683:	c9                   	leave  
 684:	c3                   	ret    

00000685 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 685:	55                   	push   %ebp
 686:	89 e5                	mov    %esp,%ebp
 688:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68b:	8b 45 08             	mov    0x8(%ebp),%eax
 68e:	83 e8 08             	sub    $0x8,%eax
 691:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 694:	a1 54 0b 00 00       	mov    0xb54,%eax
 699:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69c:	eb 24                	jmp    6c2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a6:	77 12                	ja     6ba <free+0x35>
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ae:	77 24                	ja     6d4 <free+0x4f>
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b8:	77 1a                	ja     6d4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c8:	76 d4                	jbe    69e <free+0x19>
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	8b 00                	mov    (%eax),%eax
 6cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d2:	76 ca                	jbe    69e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	8b 40 04             	mov    0x4(%eax),%eax
 6da:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	01 c2                	add    %eax,%edx
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	39 c2                	cmp    %eax,%edx
 6ed:	75 24                	jne    713 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	8b 50 04             	mov    0x4(%eax),%edx
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	8b 40 04             	mov    0x4(%eax),%eax
 6fd:	01 c2                	add    %eax,%edx
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	8b 10                	mov    (%eax),%edx
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	89 10                	mov    %edx,(%eax)
 711:	eb 0a                	jmp    71d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 10                	mov    (%eax),%edx
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 40 04             	mov    0x4(%eax),%eax
 723:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	01 d0                	add    %edx,%eax
 72f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 732:	75 20                	jne    754 <free+0xcf>
    p->s.size += bp->s.size;
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 50 04             	mov    0x4(%eax),%edx
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	8b 40 04             	mov    0x4(%eax),%eax
 740:	01 c2                	add    %eax,%edx
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 748:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74b:	8b 10                	mov    (%eax),%edx
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	89 10                	mov    %edx,(%eax)
 752:	eb 08                	jmp    75c <free+0xd7>
  } else
    p->s.ptr = bp;
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75a:	89 10                	mov    %edx,(%eax)
  freep = p;
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	a3 54 0b 00 00       	mov    %eax,0xb54
}
 764:	c9                   	leave  
 765:	c3                   	ret    

00000766 <morecore>:

static Header*
morecore(uint nu)
{
 766:	55                   	push   %ebp
 767:	89 e5                	mov    %esp,%ebp
 769:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 773:	77 07                	ja     77c <morecore+0x16>
    nu = 4096;
 775:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77c:	8b 45 08             	mov    0x8(%ebp),%eax
 77f:	c1 e0 03             	shl    $0x3,%eax
 782:	89 04 24             	mov    %eax,(%esp)
 785:	e8 38 fc ff ff       	call   3c2 <sbrk>
 78a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 78d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 791:	75 07                	jne    79a <morecore+0x34>
    return 0;
 793:	b8 00 00 00 00       	mov    $0x0,%eax
 798:	eb 22                	jmp    7bc <morecore+0x56>
  hp = (Header*)p;
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	8b 55 08             	mov    0x8(%ebp),%edx
 7a6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	83 c0 08             	add    $0x8,%eax
 7af:	89 04 24             	mov    %eax,(%esp)
 7b2:	e8 ce fe ff ff       	call   685 <free>
  return freep;
 7b7:	a1 54 0b 00 00       	mov    0xb54,%eax
}
 7bc:	c9                   	leave  
 7bd:	c3                   	ret    

000007be <malloc>:

void*
malloc(uint nbytes)
{
 7be:	55                   	push   %ebp
 7bf:	89 e5                	mov    %esp,%ebp
 7c1:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c4:	8b 45 08             	mov    0x8(%ebp),%eax
 7c7:	83 c0 07             	add    $0x7,%eax
 7ca:	c1 e8 03             	shr    $0x3,%eax
 7cd:	83 c0 01             	add    $0x1,%eax
 7d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d3:	a1 54 0b 00 00       	mov    0xb54,%eax
 7d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7df:	75 23                	jne    804 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e1:	c7 45 f0 4c 0b 00 00 	movl   $0xb4c,-0x10(%ebp)
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	a3 54 0b 00 00       	mov    %eax,0xb54
 7f0:	a1 54 0b 00 00       	mov    0xb54,%eax
 7f5:	a3 4c 0b 00 00       	mov    %eax,0xb4c
    base.s.size = 0;
 7fa:	c7 05 50 0b 00 00 00 	movl   $0x0,0xb50
 801:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 804:	8b 45 f0             	mov    -0x10(%ebp),%eax
 807:	8b 00                	mov    (%eax),%eax
 809:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 815:	72 4d                	jb     864 <malloc+0xa6>
      if(p->s.size == nunits)
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 820:	75 0c                	jne    82e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 10                	mov    (%eax),%edx
 827:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82a:	89 10                	mov    %edx,(%eax)
 82c:	eb 26                	jmp    854 <malloc+0x96>
      else {
        p->s.size -= nunits;
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	2b 45 ec             	sub    -0x14(%ebp),%eax
 837:	89 c2                	mov    %eax,%edx
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	8b 40 04             	mov    0x4(%eax),%eax
 845:	c1 e0 03             	shl    $0x3,%eax
 848:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 851:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	a3 54 0b 00 00       	mov    %eax,0xb54
      return (void*)(p + 1);
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	83 c0 08             	add    $0x8,%eax
 862:	eb 38                	jmp    89c <malloc+0xde>
    }
    if(p == freep)
 864:	a1 54 0b 00 00       	mov    0xb54,%eax
 869:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 86c:	75 1b                	jne    889 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 86e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 871:	89 04 24             	mov    %eax,(%esp)
 874:	e8 ed fe ff ff       	call   766 <morecore>
 879:	89 45 f4             	mov    %eax,-0xc(%ebp)
 87c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 880:	75 07                	jne    889 <malloc+0xcb>
        return 0;
 882:	b8 00 00 00 00       	mov    $0x0,%eax
 887:	eb 13                	jmp    89c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 00                	mov    (%eax),%eax
 894:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 897:	e9 70 ff ff ff       	jmp    80c <malloc+0x4e>
}
 89c:	c9                   	leave  
 89d:	c3                   	ret    
