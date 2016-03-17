
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	89 04 24             	mov    %eax,(%esp)
   c:	e8 98 01 00 00       	call   1a9 <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 b9 03 00 00       	call   3e0 <write>
}
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	55                   	push   %ebp
  2a:	89 e5                	mov    %esp,%ebp
  2c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
  2f:	c7 44 24 04 94 06 00 	movl   $0x694,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4a:	eb 1f                	jmp    6b <forktest+0x42>
    pid = fork();
  4c:	e8 67 03 00 00       	call   3b8 <fork>
  51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  58:	79 02                	jns    5c <forktest+0x33>
      break;
  5a:	eb 18                	jmp    74 <forktest+0x4b>
    if(pid == 0)
  5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  60:	75 05                	jne    67 <forktest+0x3e>
      exit();
  62:	e8 59 03 00 00       	call   3c0 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  6b:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  72:	7e d8                	jle    4c <forktest+0x23>
      break;
    if(pid == 0)
      exit();
  }
  
  if(n == N){
  74:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  7b:	75 21                	jne    9e <forktest+0x75>
    printf(1, "fork claimed to work N times!\n", N);
  7d:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  84:	00 
  85:	c7 44 24 04 a0 06 00 	movl   $0x6a0,0x4(%esp)
  8c:	00 
  8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  94:	e8 67 ff ff ff       	call   0 <printf>
    exit();
  99:	e8 22 03 00 00       	call   3c0 <exit>
  }
  
  for(; n > 0; n--){
  9e:	eb 26                	jmp    c6 <forktest+0x9d>
    if(wait() < 0){
  a0:	e8 23 03 00 00       	call   3c8 <wait>
  a5:	85 c0                	test   %eax,%eax
  a7:	79 19                	jns    c2 <forktest+0x99>
      printf(1, "wait stopped early\n");
  a9:	c7 44 24 04 bf 06 00 	movl   $0x6bf,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 43 ff ff ff       	call   0 <printf>
      exit();
  bd:	e8 fe 02 00 00       	call   3c0 <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--){
  c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  ca:	7f d4                	jg     a0 <forktest+0x77>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  cc:	e8 f7 02 00 00       	call   3c8 <wait>
  d1:	83 f8 ff             	cmp    $0xffffffff,%eax
  d4:	74 19                	je     ef <forktest+0xc6>
    printf(1, "wait got too many\n");
  d6:	c7 44 24 04 d3 06 00 	movl   $0x6d3,0x4(%esp)
  dd:	00 
  de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e5:	e8 16 ff ff ff       	call   0 <printf>
    exit();
  ea:	e8 d1 02 00 00       	call   3c0 <exit>
  }
  
  printf(1, "fork test OK\n");
  ef:	c7 44 24 04 e6 06 00 	movl   $0x6e6,0x4(%esp)
  f6:	00 
  f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fe:	e8 fd fe ff ff       	call   0 <printf>
}
 103:	c9                   	leave  
 104:	c3                   	ret    

00000105 <main>:

int
main(void)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
 10b:	e8 19 ff ff ff       	call   29 <forktest>
  exit();
 110:	e8 ab 02 00 00       	call   3c0 <exit>

00000115 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
 118:	57                   	push   %edi
 119:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11d:	8b 55 10             	mov    0x10(%ebp),%edx
 120:	8b 45 0c             	mov    0xc(%ebp),%eax
 123:	89 cb                	mov    %ecx,%ebx
 125:	89 df                	mov    %ebx,%edi
 127:	89 d1                	mov    %edx,%ecx
 129:	fc                   	cld    
 12a:	f3 aa                	rep stos %al,%es:(%edi)
 12c:	89 ca                	mov    %ecx,%edx
 12e:	89 fb                	mov    %edi,%ebx
 130:	89 5d 08             	mov    %ebx,0x8(%ebp)
 133:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 136:	5b                   	pop    %ebx
 137:	5f                   	pop    %edi
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 146:	90                   	nop
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	8d 50 01             	lea    0x1(%eax),%edx
 14d:	89 55 08             	mov    %edx,0x8(%ebp)
 150:	8b 55 0c             	mov    0xc(%ebp),%edx
 153:	8d 4a 01             	lea    0x1(%edx),%ecx
 156:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 159:	0f b6 12             	movzbl (%edx),%edx
 15c:	88 10                	mov    %dl,(%eax)
 15e:	0f b6 00             	movzbl (%eax),%eax
 161:	84 c0                	test   %al,%al
 163:	75 e2                	jne    147 <strcpy+0xd>
    ;
  return os;
 165:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 168:	c9                   	leave  
 169:	c3                   	ret    

0000016a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16d:	eb 08                	jmp    177 <strcmp+0xd>
    p++, q++;
 16f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 173:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 177:	8b 45 08             	mov    0x8(%ebp),%eax
 17a:	0f b6 00             	movzbl (%eax),%eax
 17d:	84 c0                	test   %al,%al
 17f:	74 10                	je     191 <strcmp+0x27>
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	0f b6 10             	movzbl (%eax),%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	38 c2                	cmp    %al,%dl
 18f:	74 de                	je     16f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	0f b6 00             	movzbl (%eax),%eax
 197:	0f b6 d0             	movzbl %al,%edx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	0f b6 00             	movzbl (%eax),%eax
 1a0:	0f b6 c0             	movzbl %al,%eax
 1a3:	29 c2                	sub    %eax,%edx
 1a5:	89 d0                	mov    %edx,%eax
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    

000001a9 <strlen>:

uint
strlen(char *s)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
 1ac:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b6:	eb 04                	jmp    1bc <strlen+0x13>
 1b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	01 d0                	add    %edx,%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	84 c0                	test   %al,%al
 1c9:	75 ed                	jne    1b8 <strlen+0xf>
    ;
  return n;
 1cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ce:	c9                   	leave  
 1cf:	c3                   	ret    

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d6:	8b 45 10             	mov    0x10(%ebp),%eax
 1d9:	89 44 24 08          	mov    %eax,0x8(%esp)
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	89 04 24             	mov    %eax,(%esp)
 1ea:	e8 26 ff ff ff       	call   115 <stosb>
  return dst;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f2:	c9                   	leave  
 1f3:	c3                   	ret    

000001f4 <strchr>:

char*
strchr(const char *s, char c)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 04             	sub    $0x4,%esp
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 200:	eb 14                	jmp    216 <strchr+0x22>
    if(*s == c)
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	0f b6 00             	movzbl (%eax),%eax
 208:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20b:	75 05                	jne    212 <strchr+0x1e>
      return (char*)s;
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	eb 13                	jmp    225 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 212:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	0f b6 00             	movzbl (%eax),%eax
 21c:	84 c0                	test   %al,%al
 21e:	75 e2                	jne    202 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 220:	b8 00 00 00 00       	mov    $0x0,%eax
}
 225:	c9                   	leave  
 226:	c3                   	ret    

00000227 <gets>:

char*
gets(char *buf, int max)
{
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
 22a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 234:	eb 4c                	jmp    282 <gets+0x5b>
    cc = read(0, &c, 1);
 236:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 23d:	00 
 23e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 241:	89 44 24 04          	mov    %eax,0x4(%esp)
 245:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 24c:	e8 87 01 00 00       	call   3d8 <read>
 251:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 258:	7f 02                	jg     25c <gets+0x35>
      break;
 25a:	eb 31                	jmp    28d <gets+0x66>
    buf[i++] = c;
 25c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25f:	8d 50 01             	lea    0x1(%eax),%edx
 262:	89 55 f4             	mov    %edx,-0xc(%ebp)
 265:	89 c2                	mov    %eax,%edx
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	01 c2                	add    %eax,%edx
 26c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 270:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 272:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 276:	3c 0a                	cmp    $0xa,%al
 278:	74 13                	je     28d <gets+0x66>
 27a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27e:	3c 0d                	cmp    $0xd,%al
 280:	74 0b                	je     28d <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 282:	8b 45 f4             	mov    -0xc(%ebp),%eax
 285:	83 c0 01             	add    $0x1,%eax
 288:	3b 45 0c             	cmp    0xc(%ebp),%eax
 28b:	7c a9                	jl     236 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	01 d0                	add    %edx,%eax
 295:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 298:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29b:	c9                   	leave  
 29c:	c3                   	ret    

0000029d <stat>:

int
stat(char *n, struct stat *st)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2aa:	00 
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	89 04 24             	mov    %eax,(%esp)
 2b1:	e8 4a 01 00 00       	call   400 <open>
 2b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2bd:	79 07                	jns    2c6 <stat+0x29>
    return -1;
 2bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c4:	eb 23                	jmp    2e9 <stat+0x4c>
  r = fstat(fd, st);
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d0:	89 04 24             	mov    %eax,(%esp)
 2d3:	e8 40 01 00 00       	call   418 <fstat>
 2d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2de:	89 04 24             	mov    %eax,(%esp)
 2e1:	e8 02 01 00 00       	call   3e8 <close>
  return r;
 2e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <atoi>:

int
atoi(const char *s)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f8:	eb 25                	jmp    31f <atoi+0x34>
    n = n*10 + *s++ - '0';
 2fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fd:	89 d0                	mov    %edx,%eax
 2ff:	c1 e0 02             	shl    $0x2,%eax
 302:	01 d0                	add    %edx,%eax
 304:	01 c0                	add    %eax,%eax
 306:	89 c1                	mov    %eax,%ecx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	8d 50 01             	lea    0x1(%eax),%edx
 30e:	89 55 08             	mov    %edx,0x8(%ebp)
 311:	0f b6 00             	movzbl (%eax),%eax
 314:	0f be c0             	movsbl %al,%eax
 317:	01 c8                	add    %ecx,%eax
 319:	83 e8 30             	sub    $0x30,%eax
 31c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	0f b6 00             	movzbl (%eax),%eax
 325:	3c 2f                	cmp    $0x2f,%al
 327:	7e 0a                	jle    333 <atoi+0x48>
 329:	8b 45 08             	mov    0x8(%ebp),%eax
 32c:	0f b6 00             	movzbl (%eax),%eax
 32f:	3c 39                	cmp    $0x39,%al
 331:	7e c7                	jle    2fa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 333:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 336:	c9                   	leave  
 337:	c3                   	ret    

00000338 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 344:	8b 45 0c             	mov    0xc(%ebp),%eax
 347:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 34a:	eb 17                	jmp    363 <memmove+0x2b>
    *dst++ = *src++;
 34c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34f:	8d 50 01             	lea    0x1(%eax),%edx
 352:	89 55 fc             	mov    %edx,-0x4(%ebp)
 355:	8b 55 f8             	mov    -0x8(%ebp),%edx
 358:	8d 4a 01             	lea    0x1(%edx),%ecx
 35b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 35e:	0f b6 12             	movzbl (%edx),%edx
 361:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 363:	8b 45 10             	mov    0x10(%ebp),%eax
 366:	8d 50 ff             	lea    -0x1(%eax),%edx
 369:	89 55 10             	mov    %edx,0x10(%ebp)
 36c:	85 c0                	test   %eax,%eax
 36e:	7f dc                	jg     34c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 370:	8b 45 08             	mov    0x8(%ebp),%eax
}
 373:	c9                   	leave  
 374:	c3                   	ret    

00000375 <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 375:	55                   	push   %ebp
 376:	89 e5                	mov    %esp,%ebp
 378:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 37b:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 382:	e8 2a 02 00 00       	call   5b1 <malloc>
 387:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 38a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38d:	05 fc ff 0f 00       	add    $0xffffc,%eax
 392:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 395:	ba 68 04 00 00       	mov    $0x468,%edx
 39a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 39d:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 39f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a2:	05 fc ff 0f 00       	add    $0xffffc,%eax
 3a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	89 04 24             	mov    %eax,(%esp)
 3b1:	e8 aa 00 00 00       	call   460 <clone>
}
 3b6:	c9                   	leave  
 3b7:	c3                   	ret    

000003b8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b8:	b8 01 00 00 00       	mov    $0x1,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <exit>:
SYSCALL(exit)
 3c0:	b8 02 00 00 00       	mov    $0x2,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <wait>:
SYSCALL(wait)
 3c8:	b8 03 00 00 00       	mov    $0x3,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <pipe>:
SYSCALL(pipe)
 3d0:	b8 04 00 00 00       	mov    $0x4,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <read>:
SYSCALL(read)
 3d8:	b8 05 00 00 00       	mov    $0x5,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <write>:
SYSCALL(write)
 3e0:	b8 10 00 00 00       	mov    $0x10,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <close>:
SYSCALL(close)
 3e8:	b8 15 00 00 00       	mov    $0x15,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <kill>:
SYSCALL(kill)
 3f0:	b8 06 00 00 00       	mov    $0x6,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <exec>:
SYSCALL(exec)
 3f8:	b8 07 00 00 00       	mov    $0x7,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <open>:
SYSCALL(open)
 400:	b8 0f 00 00 00       	mov    $0xf,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <mknod>:
SYSCALL(mknod)
 408:	b8 11 00 00 00       	mov    $0x11,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <unlink>:
SYSCALL(unlink)
 410:	b8 12 00 00 00       	mov    $0x12,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <fstat>:
SYSCALL(fstat)
 418:	b8 08 00 00 00       	mov    $0x8,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <link>:
SYSCALL(link)
 420:	b8 13 00 00 00       	mov    $0x13,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <mkdir>:
SYSCALL(mkdir)
 428:	b8 14 00 00 00       	mov    $0x14,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <chdir>:
SYSCALL(chdir)
 430:	b8 09 00 00 00       	mov    $0x9,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <dup>:
SYSCALL(dup)
 438:	b8 0a 00 00 00       	mov    $0xa,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <getpid>:
SYSCALL(getpid)
 440:	b8 0b 00 00 00       	mov    $0xb,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <sbrk>:
SYSCALL(sbrk)
 448:	b8 0c 00 00 00       	mov    $0xc,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <sleep>:
SYSCALL(sleep)
 450:	b8 0d 00 00 00       	mov    $0xd,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <uptime>:
SYSCALL(uptime)
 458:	b8 0e 00 00 00       	mov    $0xe,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <clone>:
SYSCALL(clone)
 460:	b8 16 00 00 00       	mov    $0x16,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <thread_exit>:
SYSCALL(thread_exit)
 468:	b8 17 00 00 00       	mov    $0x17,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <thread_join>:
SYSCALL(thread_join)
 470:	b8 18 00 00 00       	mov    $0x18,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 478:	55                   	push   %ebp
 479:	89 e5                	mov    %esp,%ebp
 47b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	83 e8 08             	sub    $0x8,%eax
 484:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 487:	a1 38 09 00 00       	mov    0x938,%eax
 48c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 48f:	eb 24                	jmp    4b5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 491:	8b 45 fc             	mov    -0x4(%ebp),%eax
 494:	8b 00                	mov    (%eax),%eax
 496:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 499:	77 12                	ja     4ad <free+0x35>
 49b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 49e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 4a1:	77 24                	ja     4c7 <free+0x4f>
 4a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4a6:	8b 00                	mov    (%eax),%eax
 4a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 4ab:	77 1a                	ja     4c7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4b0:	8b 00                	mov    (%eax),%eax
 4b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 4b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 4bb:	76 d4                	jbe    491 <free+0x19>
 4bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4c0:	8b 00                	mov    (%eax),%eax
 4c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 4c5:	76 ca                	jbe    491 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 4c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4ca:	8b 40 04             	mov    0x4(%eax),%eax
 4cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 4d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4d7:	01 c2                	add    %eax,%edx
 4d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4dc:	8b 00                	mov    (%eax),%eax
 4de:	39 c2                	cmp    %eax,%edx
 4e0:	75 24                	jne    506 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 4e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4e5:	8b 50 04             	mov    0x4(%eax),%edx
 4e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4eb:	8b 00                	mov    (%eax),%eax
 4ed:	8b 40 04             	mov    0x4(%eax),%eax
 4f0:	01 c2                	add    %eax,%edx
 4f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4f5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 4f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4fb:	8b 00                	mov    (%eax),%eax
 4fd:	8b 10                	mov    (%eax),%edx
 4ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 502:	89 10                	mov    %edx,(%eax)
 504:	eb 0a                	jmp    510 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 506:	8b 45 fc             	mov    -0x4(%ebp),%eax
 509:	8b 10                	mov    (%eax),%edx
 50b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 50e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 510:	8b 45 fc             	mov    -0x4(%ebp),%eax
 513:	8b 40 04             	mov    0x4(%eax),%eax
 516:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 51d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 520:	01 d0                	add    %edx,%eax
 522:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 525:	75 20                	jne    547 <free+0xcf>
    p->s.size += bp->s.size;
 527:	8b 45 fc             	mov    -0x4(%ebp),%eax
 52a:	8b 50 04             	mov    0x4(%eax),%edx
 52d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 530:	8b 40 04             	mov    0x4(%eax),%eax
 533:	01 c2                	add    %eax,%edx
 535:	8b 45 fc             	mov    -0x4(%ebp),%eax
 538:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 53b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 53e:	8b 10                	mov    (%eax),%edx
 540:	8b 45 fc             	mov    -0x4(%ebp),%eax
 543:	89 10                	mov    %edx,(%eax)
 545:	eb 08                	jmp    54f <free+0xd7>
  } else
    p->s.ptr = bp;
 547:	8b 45 fc             	mov    -0x4(%ebp),%eax
 54a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 54d:	89 10                	mov    %edx,(%eax)
  freep = p;
 54f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 552:	a3 38 09 00 00       	mov    %eax,0x938
}
 557:	c9                   	leave  
 558:	c3                   	ret    

00000559 <morecore>:

static Header*
morecore(uint nu)
{
 559:	55                   	push   %ebp
 55a:	89 e5                	mov    %esp,%ebp
 55c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 55f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 566:	77 07                	ja     56f <morecore+0x16>
    nu = 4096;
 568:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	c1 e0 03             	shl    $0x3,%eax
 575:	89 04 24             	mov    %eax,(%esp)
 578:	e8 cb fe ff ff       	call   448 <sbrk>
 57d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 580:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 584:	75 07                	jne    58d <morecore+0x34>
    return 0;
 586:	b8 00 00 00 00       	mov    $0x0,%eax
 58b:	eb 22                	jmp    5af <morecore+0x56>
  hp = (Header*)p;
 58d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 590:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 593:	8b 45 f0             	mov    -0x10(%ebp),%eax
 596:	8b 55 08             	mov    0x8(%ebp),%edx
 599:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 59c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 59f:	83 c0 08             	add    $0x8,%eax
 5a2:	89 04 24             	mov    %eax,(%esp)
 5a5:	e8 ce fe ff ff       	call   478 <free>
  return freep;
 5aa:	a1 38 09 00 00       	mov    0x938,%eax
}
 5af:	c9                   	leave  
 5b0:	c3                   	ret    

000005b1 <malloc>:

void*
malloc(uint nbytes)
{
 5b1:	55                   	push   %ebp
 5b2:	89 e5                	mov    %esp,%ebp
 5b4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	83 c0 07             	add    $0x7,%eax
 5bd:	c1 e8 03             	shr    $0x3,%eax
 5c0:	83 c0 01             	add    $0x1,%eax
 5c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 5c6:	a1 38 09 00 00       	mov    0x938,%eax
 5cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 5ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d2:	75 23                	jne    5f7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 5d4:	c7 45 f0 30 09 00 00 	movl   $0x930,-0x10(%ebp)
 5db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5de:	a3 38 09 00 00       	mov    %eax,0x938
 5e3:	a1 38 09 00 00       	mov    0x938,%eax
 5e8:	a3 30 09 00 00       	mov    %eax,0x930
    base.s.size = 0;
 5ed:	c7 05 34 09 00 00 00 	movl   $0x0,0x934
 5f4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 5ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 602:	8b 40 04             	mov    0x4(%eax),%eax
 605:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 608:	72 4d                	jb     657 <malloc+0xa6>
      if(p->s.size == nunits)
 60a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60d:	8b 40 04             	mov    0x4(%eax),%eax
 610:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 613:	75 0c                	jne    621 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 615:	8b 45 f4             	mov    -0xc(%ebp),%eax
 618:	8b 10                	mov    (%eax),%edx
 61a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61d:	89 10                	mov    %edx,(%eax)
 61f:	eb 26                	jmp    647 <malloc+0x96>
      else {
        p->s.size -= nunits;
 621:	8b 45 f4             	mov    -0xc(%ebp),%eax
 624:	8b 40 04             	mov    0x4(%eax),%eax
 627:	2b 45 ec             	sub    -0x14(%ebp),%eax
 62a:	89 c2                	mov    %eax,%edx
 62c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 632:	8b 45 f4             	mov    -0xc(%ebp),%eax
 635:	8b 40 04             	mov    0x4(%eax),%eax
 638:	c1 e0 03             	shl    $0x3,%eax
 63b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 63e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 641:	8b 55 ec             	mov    -0x14(%ebp),%edx
 644:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 647:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64a:	a3 38 09 00 00       	mov    %eax,0x938
      return (void*)(p + 1);
 64f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 652:	83 c0 08             	add    $0x8,%eax
 655:	eb 38                	jmp    68f <malloc+0xde>
    }
    if(p == freep)
 657:	a1 38 09 00 00       	mov    0x938,%eax
 65c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 65f:	75 1b                	jne    67c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 661:	8b 45 ec             	mov    -0x14(%ebp),%eax
 664:	89 04 24             	mov    %eax,(%esp)
 667:	e8 ed fe ff ff       	call   559 <morecore>
 66c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 66f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 673:	75 07                	jne    67c <malloc+0xcb>
        return 0;
 675:	b8 00 00 00 00       	mov    $0x0,%eax
 67a:	eb 13                	jmp    68f <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 67c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 682:	8b 45 f4             	mov    -0xc(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 68a:	e9 70 ff ff ff       	jmp    5ff <malloc+0x4e>
}
 68f:	c9                   	leave  
 690:	c3                   	ret    
