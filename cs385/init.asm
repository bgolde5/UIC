
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 21 09 00 00 	movl   $0x921,(%esp)
  18:	e8 dd 03 00 00       	call   3fa <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 21 09 00 00 	movl   $0x921,(%esp)
  38:	e8 c5 03 00 00       	call   402 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 21 09 00 00 	movl   $0x921,(%esp)
  4c:	e8 a9 03 00 00       	call   3fa <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 d5 03 00 00       	call   432 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 c9 03 00 00       	call   432 <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  69:	c7 44 24 04 29 09 00 	movl   $0x929,0x4(%esp)
  70:	00 
  71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  78:	e8 d5 04 00 00       	call   552 <printf>
    pid = fork();
  7d:	e8 30 03 00 00       	call   3b2 <fork>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  86:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8b:	79 19                	jns    a6 <main+0xa6>
      printf(1, "init: fork failed\n");
  8d:	c7 44 24 04 3c 09 00 	movl   $0x93c,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 b1 04 00 00       	call   552 <printf>
      exit();
  a1:	e8 14 03 00 00       	call   3ba <exit>
    }
    if(pid == 0){
  a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ab:	75 2d                	jne    da <main+0xda>
      exec("sh", argv);
  ad:	c7 44 24 04 dc 0b 00 	movl   $0xbdc,0x4(%esp)
  b4:	00 
  b5:	c7 04 24 1e 09 00 00 	movl   $0x91e,(%esp)
  bc:	e8 31 03 00 00       	call   3f2 <exec>
      printf(1, "init: exec sh failed\n");
  c1:	c7 44 24 04 4f 09 00 	movl   $0x94f,0x4(%esp)
  c8:	00 
  c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d0:	e8 7d 04 00 00       	call   552 <printf>
      exit();
  d5:	e8 e0 02 00 00       	call   3ba <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  da:	eb 14                	jmp    f0 <main+0xf0>
      printf(1, "zombie!\n");
  dc:	c7 44 24 04 65 09 00 	movl   $0x965,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  eb:	e8 62 04 00 00       	call   552 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f0:	e8 cd 02 00 00       	call   3c2 <wait>
  f5:	89 44 24 18          	mov    %eax,0x18(%esp)
  f9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  fe:	78 0a                	js     10a <main+0x10a>
 100:	8b 44 24 18          	mov    0x18(%esp),%eax
 104:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 108:	75 d2                	jne    dc <main+0xdc>
      printf(1, "zombie!\n");
  }
 10a:	e9 5a ff ff ff       	jmp    69 <main+0x69>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	5b                   	pop    %ebx
 131:	5f                   	pop    %edi
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    

00000134 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 140:	90                   	nop
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	8d 50 01             	lea    0x1(%eax),%edx
 147:	89 55 08             	mov    %edx,0x8(%ebp)
 14a:	8b 55 0c             	mov    0xc(%ebp),%edx
 14d:	8d 4a 01             	lea    0x1(%edx),%ecx
 150:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 153:	0f b6 12             	movzbl (%edx),%edx
 156:	88 10                	mov    %dl,(%eax)
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	84 c0                	test   %al,%al
 15d:	75 e2                	jne    141 <strcpy+0xd>
    ;
  return os;
 15f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 162:	c9                   	leave  
 163:	c3                   	ret    

00000164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 167:	eb 08                	jmp    171 <strcmp+0xd>
    p++, q++;
 169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	84 c0                	test   %al,%al
 179:	74 10                	je     18b <strcmp+0x27>
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	0f b6 10             	movzbl (%eax),%edx
 181:	8b 45 0c             	mov    0xc(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	38 c2                	cmp    %al,%dl
 189:	74 de                	je     169 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	0f b6 d0             	movzbl %al,%edx
 194:	8b 45 0c             	mov    0xc(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	0f b6 c0             	movzbl %al,%eax
 19d:	29 c2                	sub    %eax,%edx
 19f:	89 d0                	mov    %edx,%eax
}
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    

000001a3 <strlen>:

uint
strlen(char *s)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b0:	eb 04                	jmp    1b6 <strlen+0x13>
 1b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	01 d0                	add    %edx,%eax
 1be:	0f b6 00             	movzbl (%eax),%eax
 1c1:	84 c0                	test   %al,%al
 1c3:	75 ed                	jne    1b2 <strlen+0xf>
    ;
  return n;
 1c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c8:	c9                   	leave  
 1c9:	c3                   	ret    

000001ca <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d0:	8b 45 10             	mov    0x10(%ebp),%eax
 1d3:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1da:	89 44 24 04          	mov    %eax,0x4(%esp)
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 26 ff ff ff       	call   10f <stosb>
  return dst;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ec:	c9                   	leave  
 1ed:	c3                   	ret    

000001ee <strchr>:

char*
strchr(const char *s, char c)
{
 1ee:	55                   	push   %ebp
 1ef:	89 e5                	mov    %esp,%ebp
 1f1:	83 ec 04             	sub    $0x4,%esp
 1f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fa:	eb 14                	jmp    210 <strchr+0x22>
    if(*s == c)
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 00             	movzbl (%eax),%eax
 202:	3a 45 fc             	cmp    -0x4(%ebp),%al
 205:	75 05                	jne    20c <strchr+0x1e>
      return (char*)s;
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	eb 13                	jmp    21f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	84 c0                	test   %al,%al
 218:	75 e2                	jne    1fc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <gets>:

char*
gets(char *buf, int max)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22e:	eb 4c                	jmp    27c <gets+0x5b>
    cc = read(0, &c, 1);
 230:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 237:	00 
 238:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23b:	89 44 24 04          	mov    %eax,0x4(%esp)
 23f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 246:	e8 87 01 00 00       	call   3d2 <read>
 24b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 252:	7f 02                	jg     256 <gets+0x35>
      break;
 254:	eb 31                	jmp    287 <gets+0x66>
    buf[i++] = c;
 256:	8b 45 f4             	mov    -0xc(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25f:	89 c2                	mov    %eax,%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	01 c2                	add    %eax,%edx
 266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 26c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 270:	3c 0a                	cmp    $0xa,%al
 272:	74 13                	je     287 <gets+0x66>
 274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 278:	3c 0d                	cmp    $0xd,%al
 27a:	74 0b                	je     287 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27f:	83 c0 01             	add    $0x1,%eax
 282:	3b 45 0c             	cmp    0xc(%ebp),%eax
 285:	7c a9                	jl     230 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 287:	8b 55 f4             	mov    -0xc(%ebp),%edx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	01 d0                	add    %edx,%eax
 28f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 292:	8b 45 08             	mov    0x8(%ebp),%eax
}
 295:	c9                   	leave  
 296:	c3                   	ret    

00000297 <stat>:

int
stat(char *n, struct stat *st)
{
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a4:	00 
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	89 04 24             	mov    %eax,(%esp)
 2ab:	e8 4a 01 00 00       	call   3fa <open>
 2b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b7:	79 07                	jns    2c0 <stat+0x29>
    return -1;
 2b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2be:	eb 23                	jmp    2e3 <stat+0x4c>
  r = fstat(fd, st);
 2c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ca:	89 04 24             	mov    %eax,(%esp)
 2cd:	e8 40 01 00 00       	call   412 <fstat>
 2d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d8:	89 04 24             	mov    %eax,(%esp)
 2db:	e8 02 01 00 00       	call   3e2 <close>
  return r;
 2e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e3:	c9                   	leave  
 2e4:	c3                   	ret    

000002e5 <atoi>:

int
atoi(const char *s)
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
 2e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f2:	eb 25                	jmp    319 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f7:	89 d0                	mov    %edx,%eax
 2f9:	c1 e0 02             	shl    $0x2,%eax
 2fc:	01 d0                	add    %edx,%eax
 2fe:	01 c0                	add    %eax,%eax
 300:	89 c1                	mov    %eax,%ecx
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	8d 50 01             	lea    0x1(%eax),%edx
 308:	89 55 08             	mov    %edx,0x8(%ebp)
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	0f be c0             	movsbl %al,%eax
 311:	01 c8                	add    %ecx,%eax
 313:	83 e8 30             	sub    $0x30,%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	3c 2f                	cmp    $0x2f,%al
 321:	7e 0a                	jle    32d <atoi+0x48>
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	0f b6 00             	movzbl (%eax),%eax
 329:	3c 39                	cmp    $0x39,%al
 32b:	7e c7                	jle    2f4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 32d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33e:	8b 45 0c             	mov    0xc(%ebp),%eax
 341:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 344:	eb 17                	jmp    35d <memmove+0x2b>
    *dst++ = *src++;
 346:	8b 45 fc             	mov    -0x4(%ebp),%eax
 349:	8d 50 01             	lea    0x1(%eax),%edx
 34c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 34f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 352:	8d 4a 01             	lea    0x1(%edx),%ecx
 355:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 358:	0f b6 12             	movzbl (%edx),%edx
 35b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35d:	8b 45 10             	mov    0x10(%ebp),%eax
 360:	8d 50 ff             	lea    -0x1(%eax),%edx
 363:	89 55 10             	mov    %edx,0x10(%ebp)
 366:	85 c0                	test   %eax,%eax
 368:	7f dc                	jg     346 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 375:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 37c:	e8 bd 04 00 00       	call   83e <malloc>
 381:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 384:	8b 45 f4             	mov    -0xc(%ebp),%eax
 387:	05 fc ff 0f 00       	add    $0xffffc,%eax
 38c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 38f:	ba 62 04 00 00       	mov    $0x462,%edx
 394:	8b 45 f0             	mov    -0x10(%ebp),%eax
 397:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 399:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39c:	05 fc ff 0f 00       	add    $0xffffc,%eax
 3a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a5:	8b 45 08             	mov    0x8(%ebp),%eax
 3a8:	89 04 24             	mov    %eax,(%esp)
 3ab:	e8 aa 00 00 00       	call   45a <clone>
}
 3b0:	c9                   	leave  
 3b1:	c3                   	ret    

000003b2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b2:	b8 01 00 00 00       	mov    $0x1,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <exit>:
SYSCALL(exit)
 3ba:	b8 02 00 00 00       	mov    $0x2,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <wait>:
SYSCALL(wait)
 3c2:	b8 03 00 00 00       	mov    $0x3,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <pipe>:
SYSCALL(pipe)
 3ca:	b8 04 00 00 00       	mov    $0x4,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <read>:
SYSCALL(read)
 3d2:	b8 05 00 00 00       	mov    $0x5,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <write>:
SYSCALL(write)
 3da:	b8 10 00 00 00       	mov    $0x10,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <close>:
SYSCALL(close)
 3e2:	b8 15 00 00 00       	mov    $0x15,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <kill>:
SYSCALL(kill)
 3ea:	b8 06 00 00 00       	mov    $0x6,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <exec>:
SYSCALL(exec)
 3f2:	b8 07 00 00 00       	mov    $0x7,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <open>:
SYSCALL(open)
 3fa:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <mknod>:
SYSCALL(mknod)
 402:	b8 11 00 00 00       	mov    $0x11,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <unlink>:
SYSCALL(unlink)
 40a:	b8 12 00 00 00       	mov    $0x12,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <fstat>:
SYSCALL(fstat)
 412:	b8 08 00 00 00       	mov    $0x8,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <link>:
SYSCALL(link)
 41a:	b8 13 00 00 00       	mov    $0x13,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <mkdir>:
SYSCALL(mkdir)
 422:	b8 14 00 00 00       	mov    $0x14,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <chdir>:
SYSCALL(chdir)
 42a:	b8 09 00 00 00       	mov    $0x9,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <dup>:
SYSCALL(dup)
 432:	b8 0a 00 00 00       	mov    $0xa,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <getpid>:
SYSCALL(getpid)
 43a:	b8 0b 00 00 00       	mov    $0xb,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <sbrk>:
SYSCALL(sbrk)
 442:	b8 0c 00 00 00       	mov    $0xc,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <sleep>:
SYSCALL(sleep)
 44a:	b8 0d 00 00 00       	mov    $0xd,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <uptime>:
SYSCALL(uptime)
 452:	b8 0e 00 00 00       	mov    $0xe,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <clone>:
SYSCALL(clone)
 45a:	b8 16 00 00 00       	mov    $0x16,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <thread_exit>:
SYSCALL(thread_exit)
 462:	b8 17 00 00 00       	mov    $0x17,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <thread_join>:
SYSCALL(thread_join)
 46a:	b8 18 00 00 00       	mov    $0x18,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 472:	55                   	push   %ebp
 473:	89 e5                	mov    %esp,%ebp
 475:	83 ec 18             	sub    $0x18,%esp
 478:	8b 45 0c             	mov    0xc(%ebp),%eax
 47b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 47e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 485:	00 
 486:	8d 45 f4             	lea    -0xc(%ebp),%eax
 489:	89 44 24 04          	mov    %eax,0x4(%esp)
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	89 04 24             	mov    %eax,(%esp)
 493:	e8 42 ff ff ff       	call   3da <write>
}
 498:	c9                   	leave  
 499:	c3                   	ret    

0000049a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49a:	55                   	push   %ebp
 49b:	89 e5                	mov    %esp,%ebp
 49d:	56                   	push   %esi
 49e:	53                   	push   %ebx
 49f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4a9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4ad:	74 17                	je     4c6 <printint+0x2c>
 4af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b3:	79 11                	jns    4c6 <printint+0x2c>
    neg = 1;
 4b5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bf:	f7 d8                	neg    %eax
 4c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c4:	eb 06                	jmp    4cc <printint+0x32>
  } else {
    x = xx;
 4c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4d6:	8d 41 01             	lea    0x1(%ecx),%eax
 4d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e2:	ba 00 00 00 00       	mov    $0x0,%edx
 4e7:	f7 f3                	div    %ebx
 4e9:	89 d0                	mov    %edx,%eax
 4eb:	0f b6 80 e4 0b 00 00 	movzbl 0xbe4(%eax),%eax
 4f2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4f6:	8b 75 10             	mov    0x10(%ebp),%esi
 4f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fc:	ba 00 00 00 00       	mov    $0x0,%edx
 501:	f7 f6                	div    %esi
 503:	89 45 ec             	mov    %eax,-0x14(%ebp)
 506:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50a:	75 c7                	jne    4d3 <printint+0x39>
  if(neg)
 50c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 510:	74 10                	je     522 <printint+0x88>
    buf[i++] = '-';
 512:	8b 45 f4             	mov    -0xc(%ebp),%eax
 515:	8d 50 01             	lea    0x1(%eax),%edx
 518:	89 55 f4             	mov    %edx,-0xc(%ebp)
 51b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 520:	eb 1f                	jmp    541 <printint+0xa7>
 522:	eb 1d                	jmp    541 <printint+0xa7>
    putc(fd, buf[i]);
 524:	8d 55 dc             	lea    -0x24(%ebp),%edx
 527:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52a:	01 d0                	add    %edx,%eax
 52c:	0f b6 00             	movzbl (%eax),%eax
 52f:	0f be c0             	movsbl %al,%eax
 532:	89 44 24 04          	mov    %eax,0x4(%esp)
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	89 04 24             	mov    %eax,(%esp)
 53c:	e8 31 ff ff ff       	call   472 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 541:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 545:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 549:	79 d9                	jns    524 <printint+0x8a>
    putc(fd, buf[i]);
}
 54b:	83 c4 30             	add    $0x30,%esp
 54e:	5b                   	pop    %ebx
 54f:	5e                   	pop    %esi
 550:	5d                   	pop    %ebp
 551:	c3                   	ret    

00000552 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 552:	55                   	push   %ebp
 553:	89 e5                	mov    %esp,%ebp
 555:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 558:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 55f:	8d 45 0c             	lea    0xc(%ebp),%eax
 562:	83 c0 04             	add    $0x4,%eax
 565:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 568:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 56f:	e9 7c 01 00 00       	jmp    6f0 <printf+0x19e>
    c = fmt[i] & 0xff;
 574:	8b 55 0c             	mov    0xc(%ebp),%edx
 577:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57a:	01 d0                	add    %edx,%eax
 57c:	0f b6 00             	movzbl (%eax),%eax
 57f:	0f be c0             	movsbl %al,%eax
 582:	25 ff 00 00 00       	and    $0xff,%eax
 587:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 58a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58e:	75 2c                	jne    5bc <printf+0x6a>
      if(c == '%'){
 590:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 594:	75 0c                	jne    5a2 <printf+0x50>
        state = '%';
 596:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 59d:	e9 4a 01 00 00       	jmp    6ec <printf+0x19a>
      } else {
        putc(fd, c);
 5a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a5:	0f be c0             	movsbl %al,%eax
 5a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ac:	8b 45 08             	mov    0x8(%ebp),%eax
 5af:	89 04 24             	mov    %eax,(%esp)
 5b2:	e8 bb fe ff ff       	call   472 <putc>
 5b7:	e9 30 01 00 00       	jmp    6ec <printf+0x19a>
      }
    } else if(state == '%'){
 5bc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5c0:	0f 85 26 01 00 00    	jne    6ec <printf+0x19a>
      if(c == 'd'){
 5c6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ca:	75 2d                	jne    5f9 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cf:	8b 00                	mov    (%eax),%eax
 5d1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5d8:	00 
 5d9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5e0:	00 
 5e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	89 04 24             	mov    %eax,(%esp)
 5eb:	e8 aa fe ff ff       	call   49a <printint>
        ap++;
 5f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f4:	e9 ec 00 00 00       	jmp    6e5 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5f9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5fd:	74 06                	je     605 <printf+0xb3>
 5ff:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 603:	75 2d                	jne    632 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 605:	8b 45 e8             	mov    -0x18(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 611:	00 
 612:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 619:	00 
 61a:	89 44 24 04          	mov    %eax,0x4(%esp)
 61e:	8b 45 08             	mov    0x8(%ebp),%eax
 621:	89 04 24             	mov    %eax,(%esp)
 624:	e8 71 fe ff ff       	call   49a <printint>
        ap++;
 629:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62d:	e9 b3 00 00 00       	jmp    6e5 <printf+0x193>
      } else if(c == 's'){
 632:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 636:	75 45                	jne    67d <printf+0x12b>
        s = (char*)*ap;
 638:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 640:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 644:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 648:	75 09                	jne    653 <printf+0x101>
          s = "(null)";
 64a:	c7 45 f4 6e 09 00 00 	movl   $0x96e,-0xc(%ebp)
        while(*s != 0){
 651:	eb 1e                	jmp    671 <printf+0x11f>
 653:	eb 1c                	jmp    671 <printf+0x11f>
          putc(fd, *s);
 655:	8b 45 f4             	mov    -0xc(%ebp),%eax
 658:	0f b6 00             	movzbl (%eax),%eax
 65b:	0f be c0             	movsbl %al,%eax
 65e:	89 44 24 04          	mov    %eax,0x4(%esp)
 662:	8b 45 08             	mov    0x8(%ebp),%eax
 665:	89 04 24             	mov    %eax,(%esp)
 668:	e8 05 fe ff ff       	call   472 <putc>
          s++;
 66d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 671:	8b 45 f4             	mov    -0xc(%ebp),%eax
 674:	0f b6 00             	movzbl (%eax),%eax
 677:	84 c0                	test   %al,%al
 679:	75 da                	jne    655 <printf+0x103>
 67b:	eb 68                	jmp    6e5 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 67d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 681:	75 1d                	jne    6a0 <printf+0x14e>
        putc(fd, *ap);
 683:	8b 45 e8             	mov    -0x18(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	0f be c0             	movsbl %al,%eax
 68b:	89 44 24 04          	mov    %eax,0x4(%esp)
 68f:	8b 45 08             	mov    0x8(%ebp),%eax
 692:	89 04 24             	mov    %eax,(%esp)
 695:	e8 d8 fd ff ff       	call   472 <putc>
        ap++;
 69a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69e:	eb 45                	jmp    6e5 <printf+0x193>
      } else if(c == '%'){
 6a0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a4:	75 17                	jne    6bd <printf+0x16b>
        putc(fd, c);
 6a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a9:	0f be c0             	movsbl %al,%eax
 6ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b0:	8b 45 08             	mov    0x8(%ebp),%eax
 6b3:	89 04 24             	mov    %eax,(%esp)
 6b6:	e8 b7 fd ff ff       	call   472 <putc>
 6bb:	eb 28                	jmp    6e5 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6bd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6c4:	00 
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	89 04 24             	mov    %eax,(%esp)
 6cb:	e8 a2 fd ff ff       	call   472 <putc>
        putc(fd, c);
 6d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d3:	0f be c0             	movsbl %al,%eax
 6d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6da:	8b 45 08             	mov    0x8(%ebp),%eax
 6dd:	89 04 24             	mov    %eax,(%esp)
 6e0:	e8 8d fd ff ff       	call   472 <putc>
      }
      state = 0;
 6e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f6:	01 d0                	add    %edx,%eax
 6f8:	0f b6 00             	movzbl (%eax),%eax
 6fb:	84 c0                	test   %al,%al
 6fd:	0f 85 71 fe ff ff    	jne    574 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 703:	c9                   	leave  
 704:	c3                   	ret    

00000705 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 705:	55                   	push   %ebp
 706:	89 e5                	mov    %esp,%ebp
 708:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70b:	8b 45 08             	mov    0x8(%ebp),%eax
 70e:	83 e8 08             	sub    $0x8,%eax
 711:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 714:	a1 00 0c 00 00       	mov    0xc00,%eax
 719:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71c:	eb 24                	jmp    742 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 726:	77 12                	ja     73a <free+0x35>
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72e:	77 24                	ja     754 <free+0x4f>
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 738:	77 1a                	ja     754 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 00                	mov    (%eax),%eax
 73f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 742:	8b 45 f8             	mov    -0x8(%ebp),%eax
 745:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 748:	76 d4                	jbe    71e <free+0x19>
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 752:	76 ca                	jbe    71e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 754:	8b 45 f8             	mov    -0x8(%ebp),%eax
 757:	8b 40 04             	mov    0x4(%eax),%eax
 75a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	01 c2                	add    %eax,%edx
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	8b 00                	mov    (%eax),%eax
 76b:	39 c2                	cmp    %eax,%edx
 76d:	75 24                	jne    793 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	8b 50 04             	mov    0x4(%eax),%edx
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	01 c2                	add    %eax,%edx
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	8b 10                	mov    (%eax),%edx
 78c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78f:	89 10                	mov    %edx,(%eax)
 791:	eb 0a                	jmp    79d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	01 d0                	add    %edx,%eax
 7af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b2:	75 20                	jne    7d4 <free+0xcf>
    p->s.size += bp->s.size;
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 50 04             	mov    0x4(%eax),%edx
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	8b 40 04             	mov    0x4(%eax),%eax
 7c0:	01 c2                	add    %eax,%edx
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	8b 10                	mov    (%eax),%edx
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	89 10                	mov    %edx,(%eax)
 7d2:	eb 08                	jmp    7dc <free+0xd7>
  } else
    p->s.ptr = bp;
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7da:	89 10                	mov    %edx,(%eax)
  freep = p;
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	a3 00 0c 00 00       	mov    %eax,0xc00
}
 7e4:	c9                   	leave  
 7e5:	c3                   	ret    

000007e6 <morecore>:

static Header*
morecore(uint nu)
{
 7e6:	55                   	push   %ebp
 7e7:	89 e5                	mov    %esp,%ebp
 7e9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ec:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f3:	77 07                	ja     7fc <morecore+0x16>
    nu = 4096;
 7f5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7fc:	8b 45 08             	mov    0x8(%ebp),%eax
 7ff:	c1 e0 03             	shl    $0x3,%eax
 802:	89 04 24             	mov    %eax,(%esp)
 805:	e8 38 fc ff ff       	call   442 <sbrk>
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 80d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 811:	75 07                	jne    81a <morecore+0x34>
    return 0;
 813:	b8 00 00 00 00       	mov    $0x0,%eax
 818:	eb 22                	jmp    83c <morecore+0x56>
  hp = (Header*)p;
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 820:	8b 45 f0             	mov    -0x10(%ebp),%eax
 823:	8b 55 08             	mov    0x8(%ebp),%edx
 826:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	83 c0 08             	add    $0x8,%eax
 82f:	89 04 24             	mov    %eax,(%esp)
 832:	e8 ce fe ff ff       	call   705 <free>
  return freep;
 837:	a1 00 0c 00 00       	mov    0xc00,%eax
}
 83c:	c9                   	leave  
 83d:	c3                   	ret    

0000083e <malloc>:

void*
malloc(uint nbytes)
{
 83e:	55                   	push   %ebp
 83f:	89 e5                	mov    %esp,%ebp
 841:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 844:	8b 45 08             	mov    0x8(%ebp),%eax
 847:	83 c0 07             	add    $0x7,%eax
 84a:	c1 e8 03             	shr    $0x3,%eax
 84d:	83 c0 01             	add    $0x1,%eax
 850:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 853:	a1 00 0c 00 00       	mov    0xc00,%eax
 858:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 85f:	75 23                	jne    884 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 861:	c7 45 f0 f8 0b 00 00 	movl   $0xbf8,-0x10(%ebp)
 868:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86b:	a3 00 0c 00 00       	mov    %eax,0xc00
 870:	a1 00 0c 00 00       	mov    0xc00,%eax
 875:	a3 f8 0b 00 00       	mov    %eax,0xbf8
    base.s.size = 0;
 87a:	c7 05 fc 0b 00 00 00 	movl   $0x0,0xbfc
 881:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	8b 45 f0             	mov    -0x10(%ebp),%eax
 887:	8b 00                	mov    (%eax),%eax
 889:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 895:	72 4d                	jb     8e4 <malloc+0xa6>
      if(p->s.size == nunits)
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	8b 40 04             	mov    0x4(%eax),%eax
 89d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a0:	75 0c                	jne    8ae <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	8b 10                	mov    (%eax),%edx
 8a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8aa:	89 10                	mov    %edx,(%eax)
 8ac:	eb 26                	jmp    8d4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	8b 40 04             	mov    0x4(%eax),%eax
 8b4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8b7:	89 c2                	mov    %eax,%edx
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c2:	8b 40 04             	mov    0x4(%eax),%eax
 8c5:	c1 e0 03             	shl    $0x3,%eax
 8c8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8d1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d7:	a3 00 0c 00 00       	mov    %eax,0xc00
      return (void*)(p + 1);
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	83 c0 08             	add    $0x8,%eax
 8e2:	eb 38                	jmp    91c <malloc+0xde>
    }
    if(p == freep)
 8e4:	a1 00 0c 00 00       	mov    0xc00,%eax
 8e9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ec:	75 1b                	jne    909 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f1:	89 04 24             	mov    %eax,(%esp)
 8f4:	e8 ed fe ff ff       	call   7e6 <morecore>
 8f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 900:	75 07                	jne    909 <malloc+0xcb>
        return 0;
 902:	b8 00 00 00 00       	mov    $0x0,%eax
 907:	eb 13                	jmp    91c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 912:	8b 00                	mov    (%eax),%eax
 914:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 917:	e9 70 ff ff ff       	jmp    88c <malloc+0x4e>
}
 91c:	c9                   	leave  
 91d:	c3                   	ret    
