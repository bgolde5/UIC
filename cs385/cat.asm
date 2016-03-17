
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 20 0c 00 	movl   $0xc20,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 c5 03 00 00       	call   3e8 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 20 0c 00 	movl   $0xc20,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 a2 03 00 00       	call   3e0 <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 2c 09 00 	movl   $0x92c,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 ff 04 00 00       	call   560 <printf>
    exit();
  61:	e8 62 03 00 00       	call   3c8 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 40 03 00 00       	call   3c8 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 79                	jmp    10b <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 54 03 00 00       	call   408 <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 3d 09 00 	movl   $0x93d,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 77 04 00 00       	call   560 <printf>
      exit();
  e9:	e8 da 02 00 00       	call   3c8 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 ea 02 00 00       	call   3f0 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 106:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 10b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10f:	3b 45 08             	cmp    0x8(%ebp),%eax
 112:	0f 8c 7a ff ff ff    	jl     92 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 118:	e8 ab 02 00 00       	call   3c8 <exit>

0000011d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	57                   	push   %edi
 121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 122:	8b 4d 08             	mov    0x8(%ebp),%ecx
 125:	8b 55 10             	mov    0x10(%ebp),%edx
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	89 cb                	mov    %ecx,%ebx
 12d:	89 df                	mov    %ebx,%edi
 12f:	89 d1                	mov    %edx,%ecx
 131:	fc                   	cld    
 132:	f3 aa                	rep stos %al,%es:(%edi)
 134:	89 ca                	mov    %ecx,%edx
 136:	89 fb                	mov    %edi,%ebx
 138:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13e:	5b                   	pop    %ebx
 13f:	5f                   	pop    %edi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    

00000142 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14e:	90                   	nop
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	8d 50 01             	lea    0x1(%eax),%edx
 155:	89 55 08             	mov    %edx,0x8(%ebp)
 158:	8b 55 0c             	mov    0xc(%ebp),%edx
 15b:	8d 4a 01             	lea    0x1(%edx),%ecx
 15e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 161:	0f b6 12             	movzbl (%edx),%edx
 164:	88 10                	mov    %dl,(%eax)
 166:	0f b6 00             	movzbl (%eax),%eax
 169:	84 c0                	test   %al,%al
 16b:	75 e2                	jne    14f <strcpy+0xd>
    ;
  return os;
 16d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 170:	c9                   	leave  
 171:	c3                   	ret    

00000172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 175:	eb 08                	jmp    17f <strcmp+0xd>
    p++, q++;
 177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	84 c0                	test   %al,%al
 187:	74 10                	je     199 <strcmp+0x27>
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	0f b6 10             	movzbl (%eax),%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	38 c2                	cmp    %al,%dl
 197:	74 de                	je     177 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	0f b6 d0             	movzbl %al,%edx
 1a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	0f b6 c0             	movzbl %al,%eax
 1ab:	29 c2                	sub    %eax,%edx
 1ad:	89 d0                	mov    %edx,%eax
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:

uint
strlen(char *s)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1be:	eb 04                	jmp    1c4 <strlen+0x13>
 1c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 d0                	add    %edx,%eax
 1cc:	0f b6 00             	movzbl (%eax),%eax
 1cf:	84 c0                	test   %al,%al
 1d1:	75 ed                	jne    1c0 <strlen+0xf>
    ;
  return n;
 1d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d6:	c9                   	leave  
 1d7:	c3                   	ret    

000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1de:	8b 45 10             	mov    0x10(%ebp),%eax
 1e1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	89 04 24             	mov    %eax,(%esp)
 1f2:	e8 26 ff ff ff       	call   11d <stosb>
  return dst;
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fa:	c9                   	leave  
 1fb:	c3                   	ret    

000001fc <strchr>:

char*
strchr(const char *s, char c)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	83 ec 04             	sub    $0x4,%esp
 202:	8b 45 0c             	mov    0xc(%ebp),%eax
 205:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 208:	eb 14                	jmp    21e <strchr+0x22>
    if(*s == c)
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	3a 45 fc             	cmp    -0x4(%ebp),%al
 213:	75 05                	jne    21a <strchr+0x1e>
      return (char*)s;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	eb 13                	jmp    22d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 21a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	84 c0                	test   %al,%al
 226:	75 e2                	jne    20a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 228:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <gets>:

char*
gets(char *buf, int max)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 23c:	eb 4c                	jmp    28a <gets+0x5b>
    cc = read(0, &c, 1);
 23e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 245:	00 
 246:	8d 45 ef             	lea    -0x11(%ebp),%eax
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 254:	e8 87 01 00 00       	call   3e0 <read>
 259:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 260:	7f 02                	jg     264 <gets+0x35>
      break;
 262:	eb 31                	jmp    295 <gets+0x66>
    buf[i++] = c;
 264:	8b 45 f4             	mov    -0xc(%ebp),%eax
 267:	8d 50 01             	lea    0x1(%eax),%edx
 26a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 26d:	89 c2                	mov    %eax,%edx
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	01 c2                	add    %eax,%edx
 274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 278:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 27a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27e:	3c 0a                	cmp    $0xa,%al
 280:	74 13                	je     295 <gets+0x66>
 282:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 286:	3c 0d                	cmp    $0xd,%al
 288:	74 0b                	je     295 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28d:	83 c0 01             	add    $0x1,%eax
 290:	3b 45 0c             	cmp    0xc(%ebp),%eax
 293:	7c a9                	jl     23e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 295:	8b 55 f4             	mov    -0xc(%ebp),%edx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	01 d0                	add    %edx,%eax
 29d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a3:	c9                   	leave  
 2a4:	c3                   	ret    

000002a5 <stat>:

int
stat(char *n, struct stat *st)
{
 2a5:	55                   	push   %ebp
 2a6:	89 e5                	mov    %esp,%ebp
 2a8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2b2:	00 
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	89 04 24             	mov    %eax,(%esp)
 2b9:	e8 4a 01 00 00       	call   408 <open>
 2be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c5:	79 07                	jns    2ce <stat+0x29>
    return -1;
 2c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cc:	eb 23                	jmp    2f1 <stat+0x4c>
  r = fstat(fd, st);
 2ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d8:	89 04 24             	mov    %eax,(%esp)
 2db:	e8 40 01 00 00       	call   420 <fstat>
 2e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e6:	89 04 24             	mov    %eax,(%esp)
 2e9:	e8 02 01 00 00       	call   3f0 <close>
  return r;
 2ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f1:	c9                   	leave  
 2f2:	c3                   	ret    

000002f3 <atoi>:

int
atoi(const char *s)
{
 2f3:	55                   	push   %ebp
 2f4:	89 e5                	mov    %esp,%ebp
 2f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 300:	eb 25                	jmp    327 <atoi+0x34>
    n = n*10 + *s++ - '0';
 302:	8b 55 fc             	mov    -0x4(%ebp),%edx
 305:	89 d0                	mov    %edx,%eax
 307:	c1 e0 02             	shl    $0x2,%eax
 30a:	01 d0                	add    %edx,%eax
 30c:	01 c0                	add    %eax,%eax
 30e:	89 c1                	mov    %eax,%ecx
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	8d 50 01             	lea    0x1(%eax),%edx
 316:	89 55 08             	mov    %edx,0x8(%ebp)
 319:	0f b6 00             	movzbl (%eax),%eax
 31c:	0f be c0             	movsbl %al,%eax
 31f:	01 c8                	add    %ecx,%eax
 321:	83 e8 30             	sub    $0x30,%eax
 324:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	3c 2f                	cmp    $0x2f,%al
 32f:	7e 0a                	jle    33b <atoi+0x48>
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	0f b6 00             	movzbl (%eax),%eax
 337:	3c 39                	cmp    $0x39,%al
 339:	7e c7                	jle    302 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 33b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 33e:	c9                   	leave  
 33f:	c3                   	ret    

00000340 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 34c:	8b 45 0c             	mov    0xc(%ebp),%eax
 34f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 352:	eb 17                	jmp    36b <memmove+0x2b>
    *dst++ = *src++;
 354:	8b 45 fc             	mov    -0x4(%ebp),%eax
 357:	8d 50 01             	lea    0x1(%eax),%edx
 35a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 35d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 360:	8d 4a 01             	lea    0x1(%edx),%ecx
 363:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 366:	0f b6 12             	movzbl (%edx),%edx
 369:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 36b:	8b 45 10             	mov    0x10(%ebp),%eax
 36e:	8d 50 ff             	lea    -0x1(%eax),%edx
 371:	89 55 10             	mov    %edx,0x10(%ebp)
 374:	85 c0                	test   %eax,%eax
 376:	7f dc                	jg     354 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 378:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37b:	c9                   	leave  
 37c:	c3                   	ret    

0000037d <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 37d:	55                   	push   %ebp
 37e:	89 e5                	mov    %esp,%ebp
 380:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 383:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 38a:	e8 bd 04 00 00       	call   84c <malloc>
 38f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 392:	8b 45 f4             	mov    -0xc(%ebp),%eax
 395:	05 fc ff 0f 00       	add    $0xffffc,%eax
 39a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 39d:	ba 70 04 00 00       	mov    $0x470,%edx
 3a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3a5:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 3a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3aa:	05 fc ff 0f 00       	add    $0xffffc,%eax
 3af:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	89 04 24             	mov    %eax,(%esp)
 3b9:	e8 aa 00 00 00       	call   468 <clone>
}
 3be:	c9                   	leave  
 3bf:	c3                   	ret    

000003c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3c0:	b8 01 00 00 00       	mov    $0x1,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <exit>:
SYSCALL(exit)
 3c8:	b8 02 00 00 00       	mov    $0x2,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <wait>:
SYSCALL(wait)
 3d0:	b8 03 00 00 00       	mov    $0x3,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <pipe>:
SYSCALL(pipe)
 3d8:	b8 04 00 00 00       	mov    $0x4,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <read>:
SYSCALL(read)
 3e0:	b8 05 00 00 00       	mov    $0x5,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <write>:
SYSCALL(write)
 3e8:	b8 10 00 00 00       	mov    $0x10,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <close>:
SYSCALL(close)
 3f0:	b8 15 00 00 00       	mov    $0x15,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <kill>:
SYSCALL(kill)
 3f8:	b8 06 00 00 00       	mov    $0x6,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <exec>:
SYSCALL(exec)
 400:	b8 07 00 00 00       	mov    $0x7,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <open>:
SYSCALL(open)
 408:	b8 0f 00 00 00       	mov    $0xf,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <mknod>:
SYSCALL(mknod)
 410:	b8 11 00 00 00       	mov    $0x11,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <unlink>:
SYSCALL(unlink)
 418:	b8 12 00 00 00       	mov    $0x12,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <fstat>:
SYSCALL(fstat)
 420:	b8 08 00 00 00       	mov    $0x8,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <link>:
SYSCALL(link)
 428:	b8 13 00 00 00       	mov    $0x13,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <mkdir>:
SYSCALL(mkdir)
 430:	b8 14 00 00 00       	mov    $0x14,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <chdir>:
SYSCALL(chdir)
 438:	b8 09 00 00 00       	mov    $0x9,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <dup>:
SYSCALL(dup)
 440:	b8 0a 00 00 00       	mov    $0xa,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <getpid>:
SYSCALL(getpid)
 448:	b8 0b 00 00 00       	mov    $0xb,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <sbrk>:
SYSCALL(sbrk)
 450:	b8 0c 00 00 00       	mov    $0xc,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <sleep>:
SYSCALL(sleep)
 458:	b8 0d 00 00 00       	mov    $0xd,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <uptime>:
SYSCALL(uptime)
 460:	b8 0e 00 00 00       	mov    $0xe,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <clone>:
SYSCALL(clone)
 468:	b8 16 00 00 00       	mov    $0x16,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <thread_exit>:
SYSCALL(thread_exit)
 470:	b8 17 00 00 00       	mov    $0x17,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <thread_join>:
SYSCALL(thread_join)
 478:	b8 18 00 00 00       	mov    $0x18,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	83 ec 18             	sub    $0x18,%esp
 486:	8b 45 0c             	mov    0xc(%ebp),%eax
 489:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 48c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 493:	00 
 494:	8d 45 f4             	lea    -0xc(%ebp),%eax
 497:	89 44 24 04          	mov    %eax,0x4(%esp)
 49b:	8b 45 08             	mov    0x8(%ebp),%eax
 49e:	89 04 24             	mov    %eax,(%esp)
 4a1:	e8 42 ff ff ff       	call   3e8 <write>
}
 4a6:	c9                   	leave  
 4a7:	c3                   	ret    

000004a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a8:	55                   	push   %ebp
 4a9:	89 e5                	mov    %esp,%ebp
 4ab:	56                   	push   %esi
 4ac:	53                   	push   %ebx
 4ad:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4b7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4bb:	74 17                	je     4d4 <printint+0x2c>
 4bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4c1:	79 11                	jns    4d4 <printint+0x2c>
    neg = 1;
 4c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	f7 d8                	neg    %eax
 4cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d2:	eb 06                	jmp    4da <printint+0x32>
  } else {
    x = xx;
 4d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4e1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4e4:	8d 41 01             	lea    0x1(%ecx),%eax
 4e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f0:	ba 00 00 00 00       	mov    $0x0,%edx
 4f5:	f7 f3                	div    %ebx
 4f7:	89 d0                	mov    %edx,%eax
 4f9:	0f b6 80 e0 0b 00 00 	movzbl 0xbe0(%eax),%eax
 500:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 504:	8b 75 10             	mov    0x10(%ebp),%esi
 507:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50a:	ba 00 00 00 00       	mov    $0x0,%edx
 50f:	f7 f6                	div    %esi
 511:	89 45 ec             	mov    %eax,-0x14(%ebp)
 514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 518:	75 c7                	jne    4e1 <printint+0x39>
  if(neg)
 51a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 51e:	74 10                	je     530 <printint+0x88>
    buf[i++] = '-';
 520:	8b 45 f4             	mov    -0xc(%ebp),%eax
 523:	8d 50 01             	lea    0x1(%eax),%edx
 526:	89 55 f4             	mov    %edx,-0xc(%ebp)
 529:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 52e:	eb 1f                	jmp    54f <printint+0xa7>
 530:	eb 1d                	jmp    54f <printint+0xa7>
    putc(fd, buf[i]);
 532:	8d 55 dc             	lea    -0x24(%ebp),%edx
 535:	8b 45 f4             	mov    -0xc(%ebp),%eax
 538:	01 d0                	add    %edx,%eax
 53a:	0f b6 00             	movzbl (%eax),%eax
 53d:	0f be c0             	movsbl %al,%eax
 540:	89 44 24 04          	mov    %eax,0x4(%esp)
 544:	8b 45 08             	mov    0x8(%ebp),%eax
 547:	89 04 24             	mov    %eax,(%esp)
 54a:	e8 31 ff ff ff       	call   480 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 54f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 553:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 557:	79 d9                	jns    532 <printint+0x8a>
    putc(fd, buf[i]);
}
 559:	83 c4 30             	add    $0x30,%esp
 55c:	5b                   	pop    %ebx
 55d:	5e                   	pop    %esi
 55e:	5d                   	pop    %ebp
 55f:	c3                   	ret    

00000560 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 566:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 56d:	8d 45 0c             	lea    0xc(%ebp),%eax
 570:	83 c0 04             	add    $0x4,%eax
 573:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 576:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 57d:	e9 7c 01 00 00       	jmp    6fe <printf+0x19e>
    c = fmt[i] & 0xff;
 582:	8b 55 0c             	mov    0xc(%ebp),%edx
 585:	8b 45 f0             	mov    -0x10(%ebp),%eax
 588:	01 d0                	add    %edx,%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	25 ff 00 00 00       	and    $0xff,%eax
 595:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 598:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 59c:	75 2c                	jne    5ca <printf+0x6a>
      if(c == '%'){
 59e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a2:	75 0c                	jne    5b0 <printf+0x50>
        state = '%';
 5a4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ab:	e9 4a 01 00 00       	jmp    6fa <printf+0x19a>
      } else {
        putc(fd, c);
 5b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b3:	0f be c0             	movsbl %al,%eax
 5b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	89 04 24             	mov    %eax,(%esp)
 5c0:	e8 bb fe ff ff       	call   480 <putc>
 5c5:	e9 30 01 00 00       	jmp    6fa <printf+0x19a>
      }
    } else if(state == '%'){
 5ca:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ce:	0f 85 26 01 00 00    	jne    6fa <printf+0x19a>
      if(c == 'd'){
 5d4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5d8:	75 2d                	jne    607 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5dd:	8b 00                	mov    (%eax),%eax
 5df:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5e6:	00 
 5e7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ee:	00 
 5ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	89 04 24             	mov    %eax,(%esp)
 5f9:	e8 aa fe ff ff       	call   4a8 <printint>
        ap++;
 5fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 602:	e9 ec 00 00 00       	jmp    6f3 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 607:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 60b:	74 06                	je     613 <printf+0xb3>
 60d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 611:	75 2d                	jne    640 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 613:	8b 45 e8             	mov    -0x18(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 61f:	00 
 620:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 627:	00 
 628:	89 44 24 04          	mov    %eax,0x4(%esp)
 62c:	8b 45 08             	mov    0x8(%ebp),%eax
 62f:	89 04 24             	mov    %eax,(%esp)
 632:	e8 71 fe ff ff       	call   4a8 <printint>
        ap++;
 637:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63b:	e9 b3 00 00 00       	jmp    6f3 <printf+0x193>
      } else if(c == 's'){
 640:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 644:	75 45                	jne    68b <printf+0x12b>
        s = (char*)*ap;
 646:	8b 45 e8             	mov    -0x18(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 64e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 656:	75 09                	jne    661 <printf+0x101>
          s = "(null)";
 658:	c7 45 f4 52 09 00 00 	movl   $0x952,-0xc(%ebp)
        while(*s != 0){
 65f:	eb 1e                	jmp    67f <printf+0x11f>
 661:	eb 1c                	jmp    67f <printf+0x11f>
          putc(fd, *s);
 663:	8b 45 f4             	mov    -0xc(%ebp),%eax
 666:	0f b6 00             	movzbl (%eax),%eax
 669:	0f be c0             	movsbl %al,%eax
 66c:	89 44 24 04          	mov    %eax,0x4(%esp)
 670:	8b 45 08             	mov    0x8(%ebp),%eax
 673:	89 04 24             	mov    %eax,(%esp)
 676:	e8 05 fe ff ff       	call   480 <putc>
          s++;
 67b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 67f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 682:	0f b6 00             	movzbl (%eax),%eax
 685:	84 c0                	test   %al,%al
 687:	75 da                	jne    663 <printf+0x103>
 689:	eb 68                	jmp    6f3 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 68f:	75 1d                	jne    6ae <printf+0x14e>
        putc(fd, *ap);
 691:	8b 45 e8             	mov    -0x18(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	0f be c0             	movsbl %al,%eax
 699:	89 44 24 04          	mov    %eax,0x4(%esp)
 69d:	8b 45 08             	mov    0x8(%ebp),%eax
 6a0:	89 04 24             	mov    %eax,(%esp)
 6a3:	e8 d8 fd ff ff       	call   480 <putc>
        ap++;
 6a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ac:	eb 45                	jmp    6f3 <printf+0x193>
      } else if(c == '%'){
 6ae:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b2:	75 17                	jne    6cb <printf+0x16b>
        putc(fd, c);
 6b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b7:	0f be c0             	movsbl %al,%eax
 6ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	89 04 24             	mov    %eax,(%esp)
 6c4:	e8 b7 fd ff ff       	call   480 <putc>
 6c9:	eb 28                	jmp    6f3 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6cb:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6d2:	00 
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	89 04 24             	mov    %eax,(%esp)
 6d9:	e8 a2 fd ff ff       	call   480 <putc>
        putc(fd, c);
 6de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e1:	0f be c0             	movsbl %al,%eax
 6e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	89 04 24             	mov    %eax,(%esp)
 6ee:	e8 8d fd ff ff       	call   480 <putc>
      }
      state = 0;
 6f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6fa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 701:	8b 45 f0             	mov    -0x10(%ebp),%eax
 704:	01 d0                	add    %edx,%eax
 706:	0f b6 00             	movzbl (%eax),%eax
 709:	84 c0                	test   %al,%al
 70b:	0f 85 71 fe ff ff    	jne    582 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 711:	c9                   	leave  
 712:	c3                   	ret    

00000713 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 713:	55                   	push   %ebp
 714:	89 e5                	mov    %esp,%ebp
 716:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	83 e8 08             	sub    $0x8,%eax
 71f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 722:	a1 08 0c 00 00       	mov    0xc08,%eax
 727:	89 45 fc             	mov    %eax,-0x4(%ebp)
 72a:	eb 24                	jmp    750 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 00                	mov    (%eax),%eax
 731:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 734:	77 12                	ja     748 <free+0x35>
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73c:	77 24                	ja     762 <free+0x4f>
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 00                	mov    (%eax),%eax
 743:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 746:	77 1a                	ja     762 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 00                	mov    (%eax),%eax
 74d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 756:	76 d4                	jbe    72c <free+0x19>
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 760:	76 ca                	jbe    72c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 762:	8b 45 f8             	mov    -0x8(%ebp),%eax
 765:	8b 40 04             	mov    0x4(%eax),%eax
 768:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	01 c2                	add    %eax,%edx
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	39 c2                	cmp    %eax,%edx
 77b:	75 24                	jne    7a1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 77d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 780:	8b 50 04             	mov    0x4(%eax),%edx
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	01 c2                	add    %eax,%edx
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	8b 10                	mov    (%eax),%edx
 79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79d:	89 10                	mov    %edx,(%eax)
 79f:	eb 0a                	jmp    7ab <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 10                	mov    (%eax),%edx
 7a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	8b 40 04             	mov    0x4(%eax),%eax
 7b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	01 d0                	add    %edx,%eax
 7bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c0:	75 20                	jne    7e2 <free+0xcf>
    p->s.size += bp->s.size;
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 50 04             	mov    0x4(%eax),%edx
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	01 c2                	add    %eax,%edx
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	8b 10                	mov    (%eax),%edx
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	89 10                	mov    %edx,(%eax)
 7e0:	eb 08                	jmp    7ea <free+0xd7>
  } else
    p->s.ptr = bp;
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e8:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ed:	a3 08 0c 00 00       	mov    %eax,0xc08
}
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    

000007f4 <morecore>:

static Header*
morecore(uint nu)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7fa:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 801:	77 07                	ja     80a <morecore+0x16>
    nu = 4096;
 803:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 80a:	8b 45 08             	mov    0x8(%ebp),%eax
 80d:	c1 e0 03             	shl    $0x3,%eax
 810:	89 04 24             	mov    %eax,(%esp)
 813:	e8 38 fc ff ff       	call   450 <sbrk>
 818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 81b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 81f:	75 07                	jne    828 <morecore+0x34>
    return 0;
 821:	b8 00 00 00 00       	mov    $0x0,%eax
 826:	eb 22                	jmp    84a <morecore+0x56>
  hp = (Header*)p;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 82e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 831:	8b 55 08             	mov    0x8(%ebp),%edx
 834:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 837:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83a:	83 c0 08             	add    $0x8,%eax
 83d:	89 04 24             	mov    %eax,(%esp)
 840:	e8 ce fe ff ff       	call   713 <free>
  return freep;
 845:	a1 08 0c 00 00       	mov    0xc08,%eax
}
 84a:	c9                   	leave  
 84b:	c3                   	ret    

0000084c <malloc>:

void*
malloc(uint nbytes)
{
 84c:	55                   	push   %ebp
 84d:	89 e5                	mov    %esp,%ebp
 84f:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 852:	8b 45 08             	mov    0x8(%ebp),%eax
 855:	83 c0 07             	add    $0x7,%eax
 858:	c1 e8 03             	shr    $0x3,%eax
 85b:	83 c0 01             	add    $0x1,%eax
 85e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 861:	a1 08 0c 00 00       	mov    0xc08,%eax
 866:	89 45 f0             	mov    %eax,-0x10(%ebp)
 869:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86d:	75 23                	jne    892 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86f:	c7 45 f0 00 0c 00 00 	movl   $0xc00,-0x10(%ebp)
 876:	8b 45 f0             	mov    -0x10(%ebp),%eax
 879:	a3 08 0c 00 00       	mov    %eax,0xc08
 87e:	a1 08 0c 00 00       	mov    0xc08,%eax
 883:	a3 00 0c 00 00       	mov    %eax,0xc00
    base.s.size = 0;
 888:	c7 05 04 0c 00 00 00 	movl   $0x0,0xc04
 88f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	8b 45 f0             	mov    -0x10(%ebp),%eax
 895:	8b 00                	mov    (%eax),%eax
 897:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	8b 40 04             	mov    0x4(%eax),%eax
 8a0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a3:	72 4d                	jb     8f2 <malloc+0xa6>
      if(p->s.size == nunits)
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	8b 40 04             	mov    0x4(%eax),%eax
 8ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ae:	75 0c                	jne    8bc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	8b 10                	mov    (%eax),%edx
 8b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b8:	89 10                	mov    %edx,(%eax)
 8ba:	eb 26                	jmp    8e2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bf:	8b 40 04             	mov    0x4(%eax),%eax
 8c2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c5:	89 c2                	mov    %eax,%edx
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d0:	8b 40 04             	mov    0x4(%eax),%eax
 8d3:	c1 e0 03             	shl    $0x3,%eax
 8d6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8df:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e5:	a3 08 0c 00 00       	mov    %eax,0xc08
      return (void*)(p + 1);
 8ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ed:	83 c0 08             	add    $0x8,%eax
 8f0:	eb 38                	jmp    92a <malloc+0xde>
    }
    if(p == freep)
 8f2:	a1 08 0c 00 00       	mov    0xc08,%eax
 8f7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8fa:	75 1b                	jne    917 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ff:	89 04 24             	mov    %eax,(%esp)
 902:	e8 ed fe ff ff       	call   7f4 <morecore>
 907:	89 45 f4             	mov    %eax,-0xc(%ebp)
 90a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90e:	75 07                	jne    917 <malloc+0xcb>
        return 0;
 910:	b8 00 00 00 00       	mov    $0x0,%eax
 915:	eb 13                	jmp    92a <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 917:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	8b 00                	mov    (%eax),%eax
 922:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 925:	e9 70 ff ff ff       	jmp    89a <malloc+0x4e>
}
 92a:	c9                   	leave  
 92b:	c3                   	ret    
