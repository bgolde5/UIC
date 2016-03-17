
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 c2 09 00 	movl   $0x9c2,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 b6 05 00 00       	call   5f6 <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 12 02 00 00       	call   26e <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 13                	jmp    7c <main+0x7c>
    if(fork() > 0)
  69:	e8 e8 03 00 00       	call   456 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7e 02                	jle    74 <main+0x74>
      break;
  72:	eb 12                	jmp    86 <main+0x86>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  74:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  7b:	01 
  7c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  83:	03 
  84:	7e e3                	jle    69 <main+0x69>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  86:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 d5 09 00 	movl   $0x9d5,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 51 05 00 00       	call   5f6 <printf>

  path[8] += i;
  a5:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ac:	00 
  ad:	89 c2                	mov    %eax,%edx
  af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c6:	00 
  c7:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 c8 03 00 00       	call   49e <open>
  d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e4:	00 00 00 00 
  e8:	eb 27                	jmp    111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f1:	00 
  f2:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 101:	89 04 24             	mov    %eax,(%esp)
 104:	e8 75 03 00 00       	call   47e <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
 109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 110:	01 
 111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 118:	13 
 119:	7e cf                	jle    ea <main+0xea>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
 11b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 122:	89 04 24             	mov    %eax,(%esp)
 125:	e8 5c 03 00 00       	call   486 <close>

  printf(1, "read\n");
 12a:	c7 44 24 04 df 09 00 	movl   $0x9df,0x4(%esp)
 131:	00 
 132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 139:	e8 b8 04 00 00       	call   5f6 <printf>

  fd = open(path, O_RDONLY);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14d:	89 04 24             	mov    %eax,(%esp)
 150:	e8 49 03 00 00       	call   49e <open>
 155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 163:	00 00 00 00 
 167:	eb 27                	jmp    190 <main+0x190>
    read(fd, data, sizeof(data));
 169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 170:	00 
 171:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 175:	89 44 24 04          	mov    %eax,0x4(%esp)
 179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 180:	89 04 24             	mov    %eax,(%esp)
 183:	e8 ee 02 00 00       	call   476 <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 18f:	01 
 190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 197:	13 
 198:	7e cf                	jle    169 <main+0x169>
    read(fd, data, sizeof(data));
  close(fd);
 19a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 dd 02 00 00       	call   486 <close>

  wait();
 1a9:	e8 b8 02 00 00       	call   466 <wait>
  
  exit();
 1ae:	e8 ab 02 00 00       	call   45e <exit>

000001b3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	57                   	push   %edi
 1b7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bb:	8b 55 10             	mov    0x10(%ebp),%edx
 1be:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c1:	89 cb                	mov    %ecx,%ebx
 1c3:	89 df                	mov    %ebx,%edi
 1c5:	89 d1                	mov    %edx,%ecx
 1c7:	fc                   	cld    
 1c8:	f3 aa                	rep stos %al,%es:(%edi)
 1ca:	89 ca                	mov    %ecx,%edx
 1cc:	89 fb                	mov    %edi,%ebx
 1ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d4:	5b                   	pop    %ebx
 1d5:	5f                   	pop    %edi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    

000001d8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e4:	90                   	nop
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	8d 50 01             	lea    0x1(%eax),%edx
 1eb:	89 55 08             	mov    %edx,0x8(%ebp)
 1ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f1:	8d 4a 01             	lea    0x1(%edx),%ecx
 1f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1f7:	0f b6 12             	movzbl (%edx),%edx
 1fa:	88 10                	mov    %dl,(%eax)
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strcpy+0xd>
    ;
  return os;
 203:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 20b:	eb 08                	jmp    215 <strcmp+0xd>
    p++, q++;
 20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 211:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	84 c0                	test   %al,%al
 21d:	74 10                	je     22f <strcmp+0x27>
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 10             	movzbl (%eax),%edx
 225:	8b 45 0c             	mov    0xc(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	38 c2                	cmp    %al,%dl
 22d:	74 de                	je     20d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	0f b6 d0             	movzbl %al,%edx
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	0f b6 c0             	movzbl %al,%eax
 241:	29 c2                	sub    %eax,%edx
 243:	89 d0                	mov    %edx,%eax
}
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    

00000247 <strlen>:

uint
strlen(char *s)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
 24a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 24d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 254:	eb 04                	jmp    25a <strlen+0x13>
 256:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 25a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	01 d0                	add    %edx,%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	84 c0                	test   %al,%al
 267:	75 ed                	jne    256 <strlen+0xf>
    ;
  return n;
 269:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 26c:	c9                   	leave  
 26d:	c3                   	ret    

0000026e <memset>:

void*
memset(void *dst, int c, uint n)
{
 26e:	55                   	push   %ebp
 26f:	89 e5                	mov    %esp,%ebp
 271:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 274:	8b 45 10             	mov    0x10(%ebp),%eax
 277:	89 44 24 08          	mov    %eax,0x8(%esp)
 27b:	8b 45 0c             	mov    0xc(%ebp),%eax
 27e:	89 44 24 04          	mov    %eax,0x4(%esp)
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	89 04 24             	mov    %eax,(%esp)
 288:	e8 26 ff ff ff       	call   1b3 <stosb>
  return dst;
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 290:	c9                   	leave  
 291:	c3                   	ret    

00000292 <strchr>:

char*
strchr(const char *s, char c)
{
 292:	55                   	push   %ebp
 293:	89 e5                	mov    %esp,%ebp
 295:	83 ec 04             	sub    $0x4,%esp
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29e:	eb 14                	jmp    2b4 <strchr+0x22>
    if(*s == c)
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2a9:	75 05                	jne    2b0 <strchr+0x1e>
      return (char*)s;
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	eb 13                	jmp    2c3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	84 c0                	test   %al,%al
 2bc:	75 e2                	jne    2a0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2be:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c3:	c9                   	leave  
 2c4:	c3                   	ret    

000002c5 <gets>:

char*
gets(char *buf, int max)
{
 2c5:	55                   	push   %ebp
 2c6:	89 e5                	mov    %esp,%ebp
 2c8:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d2:	eb 4c                	jmp    320 <gets+0x5b>
    cc = read(0, &c, 1);
 2d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2db:	00 
 2dc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2df:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2ea:	e8 87 01 00 00       	call   476 <read>
 2ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2f6:	7f 02                	jg     2fa <gets+0x35>
      break;
 2f8:	eb 31                	jmp    32b <gets+0x66>
    buf[i++] = c;
 2fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fd:	8d 50 01             	lea    0x1(%eax),%edx
 300:	89 55 f4             	mov    %edx,-0xc(%ebp)
 303:	89 c2                	mov    %eax,%edx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	01 c2                	add    %eax,%edx
 30a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 314:	3c 0a                	cmp    $0xa,%al
 316:	74 13                	je     32b <gets+0x66>
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	3c 0d                	cmp    $0xd,%al
 31e:	74 0b                	je     32b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 320:	8b 45 f4             	mov    -0xc(%ebp),%eax
 323:	83 c0 01             	add    $0x1,%eax
 326:	3b 45 0c             	cmp    0xc(%ebp),%eax
 329:	7c a9                	jl     2d4 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 32b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	01 d0                	add    %edx,%eax
 333:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 336:	8b 45 08             	mov    0x8(%ebp),%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <stat>:

int
stat(char *n, struct stat *st)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 348:	00 
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	89 04 24             	mov    %eax,(%esp)
 34f:	e8 4a 01 00 00       	call   49e <open>
 354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 35b:	79 07                	jns    364 <stat+0x29>
    return -1;
 35d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 362:	eb 23                	jmp    387 <stat+0x4c>
  r = fstat(fd, st);
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	89 44 24 04          	mov    %eax,0x4(%esp)
 36b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 36e:	89 04 24             	mov    %eax,(%esp)
 371:	e8 40 01 00 00       	call   4b6 <fstat>
 376:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 379:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 02 01 00 00       	call   486 <close>
  return r;
 384:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 387:	c9                   	leave  
 388:	c3                   	ret    

00000389 <atoi>:

int
atoi(const char *s)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 38f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 396:	eb 25                	jmp    3bd <atoi+0x34>
    n = n*10 + *s++ - '0';
 398:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39b:	89 d0                	mov    %edx,%eax
 39d:	c1 e0 02             	shl    $0x2,%eax
 3a0:	01 d0                	add    %edx,%eax
 3a2:	01 c0                	add    %eax,%eax
 3a4:	89 c1                	mov    %eax,%ecx
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	8d 50 01             	lea    0x1(%eax),%edx
 3ac:	89 55 08             	mov    %edx,0x8(%ebp)
 3af:	0f b6 00             	movzbl (%eax),%eax
 3b2:	0f be c0             	movsbl %al,%eax
 3b5:	01 c8                	add    %ecx,%eax
 3b7:	83 e8 30             	sub    $0x30,%eax
 3ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 2f                	cmp    $0x2f,%al
 3c5:	7e 0a                	jle    3d1 <atoi+0x48>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 39                	cmp    $0x39,%al
 3cf:	7e c7                	jle    398 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d4:	c9                   	leave  
 3d5:	c3                   	ret    

000003d6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e8:	eb 17                	jmp    401 <memmove+0x2b>
    *dst++ = *src++;
 3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ed:	8d 50 01             	lea    0x1(%eax),%edx
 3f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3f6:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3fc:	0f b6 12             	movzbl (%edx),%edx
 3ff:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 401:	8b 45 10             	mov    0x10(%ebp),%eax
 404:	8d 50 ff             	lea    -0x1(%eax),%edx
 407:	89 55 10             	mov    %edx,0x10(%ebp)
 40a:	85 c0                	test   %eax,%eax
 40c:	7f dc                	jg     3ea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 411:	c9                   	leave  
 412:	c3                   	ret    

00000413 <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 413:	55                   	push   %ebp
 414:	89 e5                	mov    %esp,%ebp
 416:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 419:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 420:	e8 bd 04 00 00       	call   8e2 <malloc>
 425:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 428:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42b:	05 fc ff 0f 00       	add    $0xffffc,%eax
 430:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 433:	ba 06 05 00 00       	mov    $0x506,%edx
 438:	8b 45 f0             	mov    -0x10(%ebp),%eax
 43b:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 43d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 440:	05 fc ff 0f 00       	add    $0xffffc,%eax
 445:	89 44 24 04          	mov    %eax,0x4(%esp)
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	89 04 24             	mov    %eax,(%esp)
 44f:	e8 aa 00 00 00       	call   4fe <clone>
}
 454:	c9                   	leave  
 455:	c3                   	ret    

00000456 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 456:	b8 01 00 00 00       	mov    $0x1,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <exit>:
SYSCALL(exit)
 45e:	b8 02 00 00 00       	mov    $0x2,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <wait>:
SYSCALL(wait)
 466:	b8 03 00 00 00       	mov    $0x3,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <pipe>:
SYSCALL(pipe)
 46e:	b8 04 00 00 00       	mov    $0x4,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <read>:
SYSCALL(read)
 476:	b8 05 00 00 00       	mov    $0x5,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <write>:
SYSCALL(write)
 47e:	b8 10 00 00 00       	mov    $0x10,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <close>:
SYSCALL(close)
 486:	b8 15 00 00 00       	mov    $0x15,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <kill>:
SYSCALL(kill)
 48e:	b8 06 00 00 00       	mov    $0x6,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <exec>:
SYSCALL(exec)
 496:	b8 07 00 00 00       	mov    $0x7,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <open>:
SYSCALL(open)
 49e:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <mknod>:
SYSCALL(mknod)
 4a6:	b8 11 00 00 00       	mov    $0x11,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <unlink>:
SYSCALL(unlink)
 4ae:	b8 12 00 00 00       	mov    $0x12,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <fstat>:
SYSCALL(fstat)
 4b6:	b8 08 00 00 00       	mov    $0x8,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <link>:
SYSCALL(link)
 4be:	b8 13 00 00 00       	mov    $0x13,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <mkdir>:
SYSCALL(mkdir)
 4c6:	b8 14 00 00 00       	mov    $0x14,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <chdir>:
SYSCALL(chdir)
 4ce:	b8 09 00 00 00       	mov    $0x9,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <dup>:
SYSCALL(dup)
 4d6:	b8 0a 00 00 00       	mov    $0xa,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <getpid>:
SYSCALL(getpid)
 4de:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <sbrk>:
SYSCALL(sbrk)
 4e6:	b8 0c 00 00 00       	mov    $0xc,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <sleep>:
SYSCALL(sleep)
 4ee:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <uptime>:
SYSCALL(uptime)
 4f6:	b8 0e 00 00 00       	mov    $0xe,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <clone>:
SYSCALL(clone)
 4fe:	b8 16 00 00 00       	mov    $0x16,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <thread_exit>:
SYSCALL(thread_exit)
 506:	b8 17 00 00 00       	mov    $0x17,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <thread_join>:
SYSCALL(thread_join)
 50e:	b8 18 00 00 00       	mov    $0x18,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 516:	55                   	push   %ebp
 517:	89 e5                	mov    %esp,%ebp
 519:	83 ec 18             	sub    $0x18,%esp
 51c:	8b 45 0c             	mov    0xc(%ebp),%eax
 51f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 522:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 529:	00 
 52a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 52d:	89 44 24 04          	mov    %eax,0x4(%esp)
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	89 04 24             	mov    %eax,(%esp)
 537:	e8 42 ff ff ff       	call   47e <write>
}
 53c:	c9                   	leave  
 53d:	c3                   	ret    

0000053e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53e:	55                   	push   %ebp
 53f:	89 e5                	mov    %esp,%ebp
 541:	56                   	push   %esi
 542:	53                   	push   %ebx
 543:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 546:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 54d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 551:	74 17                	je     56a <printint+0x2c>
 553:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 557:	79 11                	jns    56a <printint+0x2c>
    neg = 1;
 559:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 560:	8b 45 0c             	mov    0xc(%ebp),%eax
 563:	f7 d8                	neg    %eax
 565:	89 45 ec             	mov    %eax,-0x14(%ebp)
 568:	eb 06                	jmp    570 <printint+0x32>
  } else {
    x = xx;
 56a:	8b 45 0c             	mov    0xc(%ebp),%eax
 56d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 570:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 577:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 57a:	8d 41 01             	lea    0x1(%ecx),%eax
 57d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 580:	8b 5d 10             	mov    0x10(%ebp),%ebx
 583:	8b 45 ec             	mov    -0x14(%ebp),%eax
 586:	ba 00 00 00 00       	mov    $0x0,%edx
 58b:	f7 f3                	div    %ebx
 58d:	89 d0                	mov    %edx,%eax
 58f:	0f b6 80 50 0c 00 00 	movzbl 0xc50(%eax),%eax
 596:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 59a:	8b 75 10             	mov    0x10(%ebp),%esi
 59d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a0:	ba 00 00 00 00       	mov    $0x0,%edx
 5a5:	f7 f6                	div    %esi
 5a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ae:	75 c7                	jne    577 <printint+0x39>
  if(neg)
 5b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5b4:	74 10                	je     5c6 <printint+0x88>
    buf[i++] = '-';
 5b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b9:	8d 50 01             	lea    0x1(%eax),%edx
 5bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5bf:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5c4:	eb 1f                	jmp    5e5 <printint+0xa7>
 5c6:	eb 1d                	jmp    5e5 <printint+0xa7>
    putc(fd, buf[i]);
 5c8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ce:	01 d0                	add    %edx,%eax
 5d0:	0f b6 00             	movzbl (%eax),%eax
 5d3:	0f be c0             	movsbl %al,%eax
 5d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	89 04 24             	mov    %eax,(%esp)
 5e0:	e8 31 ff ff ff       	call   516 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5e5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ed:	79 d9                	jns    5c8 <printint+0x8a>
    putc(fd, buf[i]);
}
 5ef:	83 c4 30             	add    $0x30,%esp
 5f2:	5b                   	pop    %ebx
 5f3:	5e                   	pop    %esi
 5f4:	5d                   	pop    %ebp
 5f5:	c3                   	ret    

000005f6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5f6:	55                   	push   %ebp
 5f7:	89 e5                	mov    %esp,%ebp
 5f9:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 603:	8d 45 0c             	lea    0xc(%ebp),%eax
 606:	83 c0 04             	add    $0x4,%eax
 609:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 60c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 613:	e9 7c 01 00 00       	jmp    794 <printf+0x19e>
    c = fmt[i] & 0xff;
 618:	8b 55 0c             	mov    0xc(%ebp),%edx
 61b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61e:	01 d0                	add    %edx,%eax
 620:	0f b6 00             	movzbl (%eax),%eax
 623:	0f be c0             	movsbl %al,%eax
 626:	25 ff 00 00 00       	and    $0xff,%eax
 62b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 62e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 632:	75 2c                	jne    660 <printf+0x6a>
      if(c == '%'){
 634:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 638:	75 0c                	jne    646 <printf+0x50>
        state = '%';
 63a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 641:	e9 4a 01 00 00       	jmp    790 <printf+0x19a>
      } else {
        putc(fd, c);
 646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 649:	0f be c0             	movsbl %al,%eax
 64c:	89 44 24 04          	mov    %eax,0x4(%esp)
 650:	8b 45 08             	mov    0x8(%ebp),%eax
 653:	89 04 24             	mov    %eax,(%esp)
 656:	e8 bb fe ff ff       	call   516 <putc>
 65b:	e9 30 01 00 00       	jmp    790 <printf+0x19a>
      }
    } else if(state == '%'){
 660:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 664:	0f 85 26 01 00 00    	jne    790 <printf+0x19a>
      if(c == 'd'){
 66a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 66e:	75 2d                	jne    69d <printf+0xa7>
        printint(fd, *ap, 10, 1);
 670:	8b 45 e8             	mov    -0x18(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 67c:	00 
 67d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 684:	00 
 685:	89 44 24 04          	mov    %eax,0x4(%esp)
 689:	8b 45 08             	mov    0x8(%ebp),%eax
 68c:	89 04 24             	mov    %eax,(%esp)
 68f:	e8 aa fe ff ff       	call   53e <printint>
        ap++;
 694:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 698:	e9 ec 00 00 00       	jmp    789 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 69d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6a1:	74 06                	je     6a9 <printf+0xb3>
 6a3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6a7:	75 2d                	jne    6d6 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6b5:	00 
 6b6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6bd:	00 
 6be:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c2:	8b 45 08             	mov    0x8(%ebp),%eax
 6c5:	89 04 24             	mov    %eax,(%esp)
 6c8:	e8 71 fe ff ff       	call   53e <printint>
        ap++;
 6cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d1:	e9 b3 00 00 00       	jmp    789 <printf+0x193>
      } else if(c == 's'){
 6d6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6da:	75 45                	jne    721 <printf+0x12b>
        s = (char*)*ap;
 6dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6df:	8b 00                	mov    (%eax),%eax
 6e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ec:	75 09                	jne    6f7 <printf+0x101>
          s = "(null)";
 6ee:	c7 45 f4 e5 09 00 00 	movl   $0x9e5,-0xc(%ebp)
        while(*s != 0){
 6f5:	eb 1e                	jmp    715 <printf+0x11f>
 6f7:	eb 1c                	jmp    715 <printf+0x11f>
          putc(fd, *s);
 6f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fc:	0f b6 00             	movzbl (%eax),%eax
 6ff:	0f be c0             	movsbl %al,%eax
 702:	89 44 24 04          	mov    %eax,0x4(%esp)
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	89 04 24             	mov    %eax,(%esp)
 70c:	e8 05 fe ff ff       	call   516 <putc>
          s++;
 711:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 715:	8b 45 f4             	mov    -0xc(%ebp),%eax
 718:	0f b6 00             	movzbl (%eax),%eax
 71b:	84 c0                	test   %al,%al
 71d:	75 da                	jne    6f9 <printf+0x103>
 71f:	eb 68                	jmp    789 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 721:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 725:	75 1d                	jne    744 <printf+0x14e>
        putc(fd, *ap);
 727:	8b 45 e8             	mov    -0x18(%ebp),%eax
 72a:	8b 00                	mov    (%eax),%eax
 72c:	0f be c0             	movsbl %al,%eax
 72f:	89 44 24 04          	mov    %eax,0x4(%esp)
 733:	8b 45 08             	mov    0x8(%ebp),%eax
 736:	89 04 24             	mov    %eax,(%esp)
 739:	e8 d8 fd ff ff       	call   516 <putc>
        ap++;
 73e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 742:	eb 45                	jmp    789 <printf+0x193>
      } else if(c == '%'){
 744:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 748:	75 17                	jne    761 <printf+0x16b>
        putc(fd, c);
 74a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74d:	0f be c0             	movsbl %al,%eax
 750:	89 44 24 04          	mov    %eax,0x4(%esp)
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	89 04 24             	mov    %eax,(%esp)
 75a:	e8 b7 fd ff ff       	call   516 <putc>
 75f:	eb 28                	jmp    789 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 761:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 768:	00 
 769:	8b 45 08             	mov    0x8(%ebp),%eax
 76c:	89 04 24             	mov    %eax,(%esp)
 76f:	e8 a2 fd ff ff       	call   516 <putc>
        putc(fd, c);
 774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 777:	0f be c0             	movsbl %al,%eax
 77a:	89 44 24 04          	mov    %eax,0x4(%esp)
 77e:	8b 45 08             	mov    0x8(%ebp),%eax
 781:	89 04 24             	mov    %eax,(%esp)
 784:	e8 8d fd ff ff       	call   516 <putc>
      }
      state = 0;
 789:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 790:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 794:	8b 55 0c             	mov    0xc(%ebp),%edx
 797:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79a:	01 d0                	add    %edx,%eax
 79c:	0f b6 00             	movzbl (%eax),%eax
 79f:	84 c0                	test   %al,%al
 7a1:	0f 85 71 fe ff ff    	jne    618 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7a7:	c9                   	leave  
 7a8:	c3                   	ret    

000007a9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a9:	55                   	push   %ebp
 7aa:	89 e5                	mov    %esp,%ebp
 7ac:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7af:	8b 45 08             	mov    0x8(%ebp),%eax
 7b2:	83 e8 08             	sub    $0x8,%eax
 7b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	a1 6c 0c 00 00       	mov    0xc6c,%eax
 7bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c0:	eb 24                	jmp    7e6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 00                	mov    (%eax),%eax
 7c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ca:	77 12                	ja     7de <free+0x35>
 7cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d2:	77 24                	ja     7f8 <free+0x4f>
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7dc:	77 1a                	ja     7f8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 00                	mov    (%eax),%eax
 7e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ec:	76 d4                	jbe    7c2 <free+0x19>
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f6:	76 ca                	jbe    7c2 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fb:	8b 40 04             	mov    0x4(%eax),%eax
 7fe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 805:	8b 45 f8             	mov    -0x8(%ebp),%eax
 808:	01 c2                	add    %eax,%edx
 80a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80d:	8b 00                	mov    (%eax),%eax
 80f:	39 c2                	cmp    %eax,%edx
 811:	75 24                	jne    837 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 813:	8b 45 f8             	mov    -0x8(%ebp),%eax
 816:	8b 50 04             	mov    0x4(%eax),%edx
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	8b 40 04             	mov    0x4(%eax),%eax
 821:	01 c2                	add    %eax,%edx
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 829:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	8b 10                	mov    (%eax),%edx
 830:	8b 45 f8             	mov    -0x8(%ebp),%eax
 833:	89 10                	mov    %edx,(%eax)
 835:	eb 0a                	jmp    841 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 10                	mov    (%eax),%edx
 83c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	8b 40 04             	mov    0x4(%eax),%eax
 847:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 84e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 851:	01 d0                	add    %edx,%eax
 853:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 856:	75 20                	jne    878 <free+0xcf>
    p->s.size += bp->s.size;
 858:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85b:	8b 50 04             	mov    0x4(%eax),%edx
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	8b 40 04             	mov    0x4(%eax),%eax
 864:	01 c2                	add    %eax,%edx
 866:	8b 45 fc             	mov    -0x4(%ebp),%eax
 869:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 86c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86f:	8b 10                	mov    (%eax),%edx
 871:	8b 45 fc             	mov    -0x4(%ebp),%eax
 874:	89 10                	mov    %edx,(%eax)
 876:	eb 08                	jmp    880 <free+0xd7>
  } else
    p->s.ptr = bp;
 878:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 87e:	89 10                	mov    %edx,(%eax)
  freep = p;
 880:	8b 45 fc             	mov    -0x4(%ebp),%eax
 883:	a3 6c 0c 00 00       	mov    %eax,0xc6c
}
 888:	c9                   	leave  
 889:	c3                   	ret    

0000088a <morecore>:

static Header*
morecore(uint nu)
{
 88a:	55                   	push   %ebp
 88b:	89 e5                	mov    %esp,%ebp
 88d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 890:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 897:	77 07                	ja     8a0 <morecore+0x16>
    nu = 4096;
 899:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8a0:	8b 45 08             	mov    0x8(%ebp),%eax
 8a3:	c1 e0 03             	shl    $0x3,%eax
 8a6:	89 04 24             	mov    %eax,(%esp)
 8a9:	e8 38 fc ff ff       	call   4e6 <sbrk>
 8ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b5:	75 07                	jne    8be <morecore+0x34>
    return 0;
 8b7:	b8 00 00 00 00       	mov    $0x0,%eax
 8bc:	eb 22                	jmp    8e0 <morecore+0x56>
  hp = (Header*)p;
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c7:	8b 55 08             	mov    0x8(%ebp),%edx
 8ca:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	83 c0 08             	add    $0x8,%eax
 8d3:	89 04 24             	mov    %eax,(%esp)
 8d6:	e8 ce fe ff ff       	call   7a9 <free>
  return freep;
 8db:	a1 6c 0c 00 00       	mov    0xc6c,%eax
}
 8e0:	c9                   	leave  
 8e1:	c3                   	ret    

000008e2 <malloc>:

void*
malloc(uint nbytes)
{
 8e2:	55                   	push   %ebp
 8e3:	89 e5                	mov    %esp,%ebp
 8e5:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e8:	8b 45 08             	mov    0x8(%ebp),%eax
 8eb:	83 c0 07             	add    $0x7,%eax
 8ee:	c1 e8 03             	shr    $0x3,%eax
 8f1:	83 c0 01             	add    $0x1,%eax
 8f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8f7:	a1 6c 0c 00 00       	mov    0xc6c,%eax
 8fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 903:	75 23                	jne    928 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 905:	c7 45 f0 64 0c 00 00 	movl   $0xc64,-0x10(%ebp)
 90c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90f:	a3 6c 0c 00 00       	mov    %eax,0xc6c
 914:	a1 6c 0c 00 00       	mov    0xc6c,%eax
 919:	a3 64 0c 00 00       	mov    %eax,0xc64
    base.s.size = 0;
 91e:	c7 05 68 0c 00 00 00 	movl   $0x0,0xc68
 925:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 928:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 930:	8b 45 f4             	mov    -0xc(%ebp),%eax
 933:	8b 40 04             	mov    0x4(%eax),%eax
 936:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 939:	72 4d                	jb     988 <malloc+0xa6>
      if(p->s.size == nunits)
 93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93e:	8b 40 04             	mov    0x4(%eax),%eax
 941:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 944:	75 0c                	jne    952 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 946:	8b 45 f4             	mov    -0xc(%ebp),%eax
 949:	8b 10                	mov    (%eax),%edx
 94b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94e:	89 10                	mov    %edx,(%eax)
 950:	eb 26                	jmp    978 <malloc+0x96>
      else {
        p->s.size -= nunits;
 952:	8b 45 f4             	mov    -0xc(%ebp),%eax
 955:	8b 40 04             	mov    0x4(%eax),%eax
 958:	2b 45 ec             	sub    -0x14(%ebp),%eax
 95b:	89 c2                	mov    %eax,%edx
 95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 960:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	8b 40 04             	mov    0x4(%eax),%eax
 969:	c1 e0 03             	shl    $0x3,%eax
 96c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 96f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 972:	8b 55 ec             	mov    -0x14(%ebp),%edx
 975:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 978:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97b:	a3 6c 0c 00 00       	mov    %eax,0xc6c
      return (void*)(p + 1);
 980:	8b 45 f4             	mov    -0xc(%ebp),%eax
 983:	83 c0 08             	add    $0x8,%eax
 986:	eb 38                	jmp    9c0 <malloc+0xde>
    }
    if(p == freep)
 988:	a1 6c 0c 00 00       	mov    0xc6c,%eax
 98d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 990:	75 1b                	jne    9ad <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 992:	8b 45 ec             	mov    -0x14(%ebp),%eax
 995:	89 04 24             	mov    %eax,(%esp)
 998:	e8 ed fe ff ff       	call   88a <morecore>
 99d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a4:	75 07                	jne    9ad <malloc+0xcb>
        return 0;
 9a6:	b8 00 00 00 00       	mov    $0x0,%eax
 9ab:	eb 13                	jmp    9c0 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b6:	8b 00                	mov    (%eax),%eax
 9b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9bb:	e9 70 ff ff ff       	jmp    930 <malloc+0x4e>
}
 9c0:	c9                   	leave  
 9c1:	c3                   	ret    
