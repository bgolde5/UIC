
_thread3c:     file format elf32-i386


Disassembly of section .text:

00000000 <f>:
#include"user.h"

int shared = 1;
uint limit = 345873;

void f(void) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  limit = limit*9987998 % 1238979;
   6:	a1 28 0c 00 00       	mov    0xc28,%eax
   b:	69 c8 9e 67 98 00    	imul   $0x98679e,%eax,%ecx
  11:	ba 09 9a a8 d8       	mov    $0xd8a89a09,%edx
  16:	89 c8                	mov    %ecx,%eax
  18:	f7 e2                	mul    %edx
  1a:	89 d0                	mov    %edx,%eax
  1c:	c1 e8 14             	shr    $0x14,%eax
  1f:	69 c0 c3 e7 12 00    	imul   $0x12e7c3,%eax,%eax
  25:	29 c1                	sub    %eax,%ecx
  27:	89 c8                	mov    %ecx,%eax
  29:	a3 28 0c 00 00       	mov    %eax,0xc28
  uint mylimit = limit;
  2e:	a1 28 0c 00 00       	mov    0xc28,%eax
  33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i=0;
  36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while(i<mylimit) { 
  3d:	eb 11                	jmp    50 <f+0x50>
    i++;
  3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    shared++;
  43:	a1 24 0c 00 00       	mov    0xc24,%eax
  48:	83 c0 01             	add    $0x1,%eax
  4b:	a3 24 0c 00 00       	mov    %eax,0xc24

void f(void) {
  limit = limit*9987998 % 1238979;
  uint mylimit = limit;
  int i=0;
  while(i<mylimit) { 
  50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  53:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  56:	72 e7                	jb     3f <f+0x3f>
    i++;
    shared++;
  }
  printf(1,"Done looping %d\n",mylimit);
  58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  5f:	c7 44 24 04 50 09 00 	movl   $0x950,0x4(%esp)
  66:	00 
  67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6e:	e8 11 05 00 00       	call   584 <printf>

  exit();
  73:	e8 74 03 00 00       	call   3ec <exit>

00000078 <main>:
}

int main(int argc, char** argv) {
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	83 e4 f0             	and    $0xfffffff0,%esp
  7e:	81 ec e0 00 00 00    	sub    $0xe0,%esp

  int threadids[50];
  int thread;
  for(thread=0;thread<50;thread++) {
  84:	c7 84 24 dc 00 00 00 	movl   $0x0,0xdc(%esp)
  8b:	00 00 00 00 
  8f:	eb 1f                	jmp    b0 <main+0x38>
    threadids[thread]=thread_create(f);
  91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  98:	e8 04 03 00 00       	call   3a1 <thread_create>
  9d:	8b 94 24 dc 00 00 00 	mov    0xdc(%esp),%edx
  a4:	89 44 94 14          	mov    %eax,0x14(%esp,%edx,4)

int main(int argc, char** argv) {

  int threadids[50];
  int thread;
  for(thread=0;thread<50;thread++) {
  a8:	83 84 24 dc 00 00 00 	addl   $0x1,0xdc(%esp)
  af:	01 
  b0:	83 bc 24 dc 00 00 00 	cmpl   $0x31,0xdc(%esp)
  b7:	31 
  b8:	7e d7                	jle    91 <main+0x19>
    threadids[thread]=thread_create(f);
  }

  printf(1,"Done creating\n");
  ba:	c7 44 24 04 61 09 00 	movl   $0x961,0x4(%esp)
  c1:	00 
  c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c9:	e8 b6 04 00 00       	call   584 <printf>

  for(thread=0;thread<50;thread++) {
  ce:	c7 84 24 dc 00 00 00 	movl   $0x0,0xdc(%esp)
  d5:	00 00 00 00 
  d9:	eb 43                	jmp    11e <main+0xa6>
    thread_join(threadids[thread]);
  db:	8b 84 24 dc 00 00 00 	mov    0xdc(%esp),%eax
  e2:	8b 44 84 14          	mov    0x14(%esp,%eax,4),%eax
  e6:	89 04 24             	mov    %eax,(%esp)
  e9:	e8 ae 03 00 00       	call   49c <thread_join>
    printf(1,"Joined %d, shared is now %d\n",thread,shared);
  ee:	a1 24 0c 00 00       	mov    0xc24,%eax
  f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  f7:	8b 84 24 dc 00 00 00 	mov    0xdc(%esp),%eax
  fe:	89 44 24 08          	mov    %eax,0x8(%esp)
 102:	c7 44 24 04 70 09 00 	movl   $0x970,0x4(%esp)
 109:	00 
 10a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 111:	e8 6e 04 00 00       	call   584 <printf>
    threadids[thread]=thread_create(f);
  }

  printf(1,"Done creating\n");

  for(thread=0;thread<50;thread++) {
 116:	83 84 24 dc 00 00 00 	addl   $0x1,0xdc(%esp)
 11d:	01 
 11e:	83 bc 24 dc 00 00 00 	cmpl   $0x31,0xdc(%esp)
 125:	31 
 126:	7e b3                	jle    db <main+0x63>
    thread_join(threadids[thread]);
    printf(1,"Joined %d, shared is now %d\n",thread,shared);
  }  
  
  printf(1,"Main is done!\n"); 
 128:	c7 44 24 04 8d 09 00 	movl   $0x98d,0x4(%esp)
 12f:	00 
 130:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 137:	e8 48 04 00 00       	call   584 <printf>

  exit();
 13c:	e8 ab 02 00 00       	call   3ec <exit>

00000141 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	57                   	push   %edi
 145:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 146:	8b 4d 08             	mov    0x8(%ebp),%ecx
 149:	8b 55 10             	mov    0x10(%ebp),%edx
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	89 cb                	mov    %ecx,%ebx
 151:	89 df                	mov    %ebx,%edi
 153:	89 d1                	mov    %edx,%ecx
 155:	fc                   	cld    
 156:	f3 aa                	rep stos %al,%es:(%edi)
 158:	89 ca                	mov    %ecx,%edx
 15a:	89 fb                	mov    %edi,%ebx
 15c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 15f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 162:	5b                   	pop    %ebx
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    

00000166 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 172:	90                   	nop
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	8d 50 01             	lea    0x1(%eax),%edx
 179:	89 55 08             	mov    %edx,0x8(%ebp)
 17c:	8b 55 0c             	mov    0xc(%ebp),%edx
 17f:	8d 4a 01             	lea    0x1(%edx),%ecx
 182:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 185:	0f b6 12             	movzbl (%edx),%edx
 188:	88 10                	mov    %dl,(%eax)
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	84 c0                	test   %al,%al
 18f:	75 e2                	jne    173 <strcpy+0xd>
    ;
  return os;
 191:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 194:	c9                   	leave  
 195:	c3                   	ret    

00000196 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 199:	eb 08                	jmp    1a3 <strcmp+0xd>
    p++, q++;
 19b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	0f b6 00             	movzbl (%eax),%eax
 1a9:	84 c0                	test   %al,%al
 1ab:	74 10                	je     1bd <strcmp+0x27>
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	0f b6 10             	movzbl (%eax),%edx
 1b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b6:	0f b6 00             	movzbl (%eax),%eax
 1b9:	38 c2                	cmp    %al,%dl
 1bb:	74 de                	je     19b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	0f b6 00             	movzbl (%eax),%eax
 1c3:	0f b6 d0             	movzbl %al,%edx
 1c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c9:	0f b6 00             	movzbl (%eax),%eax
 1cc:	0f b6 c0             	movzbl %al,%eax
 1cf:	29 c2                	sub    %eax,%edx
 1d1:	89 d0                	mov    %edx,%eax
}
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    

000001d5 <strlen>:

uint
strlen(char *s)
{
 1d5:	55                   	push   %ebp
 1d6:	89 e5                	mov    %esp,%ebp
 1d8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e2:	eb 04                	jmp    1e8 <strlen+0x13>
 1e4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	01 d0                	add    %edx,%eax
 1f0:	0f b6 00             	movzbl (%eax),%eax
 1f3:	84 c0                	test   %al,%al
 1f5:	75 ed                	jne    1e4 <strlen+0xf>
    ;
  return n;
 1f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1fa:	c9                   	leave  
 1fb:	c3                   	ret    

000001fc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
 1ff:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 202:	8b 45 10             	mov    0x10(%ebp),%eax
 205:	89 44 24 08          	mov    %eax,0x8(%esp)
 209:	8b 45 0c             	mov    0xc(%ebp),%eax
 20c:	89 44 24 04          	mov    %eax,0x4(%esp)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	89 04 24             	mov    %eax,(%esp)
 216:	e8 26 ff ff ff       	call   141 <stosb>
  return dst;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 04             	sub    $0x4,%esp
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 22c:	eb 14                	jmp    242 <strchr+0x22>
    if(*s == c)
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	3a 45 fc             	cmp    -0x4(%ebp),%al
 237:	75 05                	jne    23e <strchr+0x1e>
      return (char*)s;
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	eb 13                	jmp    251 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 23e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	0f b6 00             	movzbl (%eax),%eax
 248:	84 c0                	test   %al,%al
 24a:	75 e2                	jne    22e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 24c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <gets>:

char*
gets(char *buf, int max)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 260:	eb 4c                	jmp    2ae <gets+0x5b>
    cc = read(0, &c, 1);
 262:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 269:	00 
 26a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 26d:	89 44 24 04          	mov    %eax,0x4(%esp)
 271:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 278:	e8 87 01 00 00       	call   404 <read>
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	7f 02                	jg     288 <gets+0x35>
      break;
 286:	eb 31                	jmp    2b9 <gets+0x66>
    buf[i++] = c;
 288:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28b:	8d 50 01             	lea    0x1(%eax),%edx
 28e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 291:	89 c2                	mov    %eax,%edx
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	01 c2                	add    %eax,%edx
 298:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a2:	3c 0a                	cmp    $0xa,%al
 2a4:	74 13                	je     2b9 <gets+0x66>
 2a6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2aa:	3c 0d                	cmp    $0xd,%al
 2ac:	74 0b                	je     2b9 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b1:	83 c0 01             	add    $0x1,%eax
 2b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b7:	7c a9                	jl     262 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	01 d0                	add    %edx,%eax
 2c1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <stat>:

int
stat(char *n, struct stat *st)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2d6:	00 
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	89 04 24             	mov    %eax,(%esp)
 2dd:	e8 4a 01 00 00       	call   42c <open>
 2e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e9:	79 07                	jns    2f2 <stat+0x29>
    return -1;
 2eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f0:	eb 23                	jmp    315 <stat+0x4c>
  r = fstat(fd, st);
 2f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fc:	89 04 24             	mov    %eax,(%esp)
 2ff:	e8 40 01 00 00       	call   444 <fstat>
 304:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 307:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30a:	89 04 24             	mov    %eax,(%esp)
 30d:	e8 02 01 00 00       	call   414 <close>
  return r;
 312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <atoi>:

int
atoi(const char *s)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	eb 25                	jmp    34b <atoi+0x34>
    n = n*10 + *s++ - '0';
 326:	8b 55 fc             	mov    -0x4(%ebp),%edx
 329:	89 d0                	mov    %edx,%eax
 32b:	c1 e0 02             	shl    $0x2,%eax
 32e:	01 d0                	add    %edx,%eax
 330:	01 c0                	add    %eax,%eax
 332:	89 c1                	mov    %eax,%ecx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 08             	mov    %edx,0x8(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	01 c8                	add    %ecx,%eax
 345:	83 e8 30             	sub    $0x30,%eax
 348:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 2f                	cmp    $0x2f,%al
 353:	7e 0a                	jle    35f <atoi+0x48>
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 39                	cmp    $0x39,%al
 35d:	7e c7                	jle    326 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 35f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 376:	eb 17                	jmp    38f <memmove+0x2b>
    *dst++ = *src++;
 378:	8b 45 fc             	mov    -0x4(%ebp),%eax
 37b:	8d 50 01             	lea    0x1(%eax),%edx
 37e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 381:	8b 55 f8             	mov    -0x8(%ebp),%edx
 384:	8d 4a 01             	lea    0x1(%edx),%ecx
 387:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 38a:	0f b6 12             	movzbl (%edx),%edx
 38d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38f:	8b 45 10             	mov    0x10(%ebp),%eax
 392:	8d 50 ff             	lea    -0x1(%eax),%edx
 395:	89 55 10             	mov    %edx,0x10(%ebp)
 398:	85 c0                	test   %eax,%eax
 39a:	7f dc                	jg     378 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    

000003a1 <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 3a1:	55                   	push   %ebp
 3a2:	89 e5                	mov    %esp,%ebp
 3a4:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 3a7:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 3ae:	e8 bd 04 00 00       	call   870 <malloc>
 3b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 3b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b9:	05 fc ff 0f 00       	add    $0xffffc,%eax
 3be:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 3c1:	ba 94 04 00 00       	mov    $0x494,%edx
 3c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3c9:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 3cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ce:	05 fc ff 0f 00       	add    $0xffffc,%eax
 3d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	89 04 24             	mov    %eax,(%esp)
 3dd:	e8 aa 00 00 00       	call   48c <clone>
}
 3e2:	c9                   	leave  
 3e3:	c3                   	ret    

000003e4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3e4:	b8 01 00 00 00       	mov    $0x1,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <exit>:
SYSCALL(exit)
 3ec:	b8 02 00 00 00       	mov    $0x2,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <wait>:
SYSCALL(wait)
 3f4:	b8 03 00 00 00       	mov    $0x3,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <pipe>:
SYSCALL(pipe)
 3fc:	b8 04 00 00 00       	mov    $0x4,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <read>:
SYSCALL(read)
 404:	b8 05 00 00 00       	mov    $0x5,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <write>:
SYSCALL(write)
 40c:	b8 10 00 00 00       	mov    $0x10,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <close>:
SYSCALL(close)
 414:	b8 15 00 00 00       	mov    $0x15,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <kill>:
SYSCALL(kill)
 41c:	b8 06 00 00 00       	mov    $0x6,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <exec>:
SYSCALL(exec)
 424:	b8 07 00 00 00       	mov    $0x7,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <open>:
SYSCALL(open)
 42c:	b8 0f 00 00 00       	mov    $0xf,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <mknod>:
SYSCALL(mknod)
 434:	b8 11 00 00 00       	mov    $0x11,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <unlink>:
SYSCALL(unlink)
 43c:	b8 12 00 00 00       	mov    $0x12,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <fstat>:
SYSCALL(fstat)
 444:	b8 08 00 00 00       	mov    $0x8,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <link>:
SYSCALL(link)
 44c:	b8 13 00 00 00       	mov    $0x13,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <mkdir>:
SYSCALL(mkdir)
 454:	b8 14 00 00 00       	mov    $0x14,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <chdir>:
SYSCALL(chdir)
 45c:	b8 09 00 00 00       	mov    $0x9,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <dup>:
SYSCALL(dup)
 464:	b8 0a 00 00 00       	mov    $0xa,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <getpid>:
SYSCALL(getpid)
 46c:	b8 0b 00 00 00       	mov    $0xb,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <sbrk>:
SYSCALL(sbrk)
 474:	b8 0c 00 00 00       	mov    $0xc,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <sleep>:
SYSCALL(sleep)
 47c:	b8 0d 00 00 00       	mov    $0xd,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <uptime>:
SYSCALL(uptime)
 484:	b8 0e 00 00 00       	mov    $0xe,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <clone>:
SYSCALL(clone)
 48c:	b8 16 00 00 00       	mov    $0x16,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <thread_exit>:
SYSCALL(thread_exit)
 494:	b8 17 00 00 00       	mov    $0x17,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <thread_join>:
SYSCALL(thread_join)
 49c:	b8 18 00 00 00       	mov    $0x18,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	83 ec 18             	sub    $0x18,%esp
 4aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ad:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b7:	00 
 4b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
 4c2:	89 04 24             	mov    %eax,(%esp)
 4c5:	e8 42 ff ff ff       	call   40c <write>
}
 4ca:	c9                   	leave  
 4cb:	c3                   	ret    

000004cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	56                   	push   %esi
 4d0:	53                   	push   %ebx
 4d1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4db:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4df:	74 17                	je     4f8 <printint+0x2c>
 4e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e5:	79 11                	jns    4f8 <printint+0x2c>
    neg = 1;
 4e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f1:	f7 d8                	neg    %eax
 4f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f6:	eb 06                	jmp    4fe <printint+0x32>
  } else {
    x = xx;
 4f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 505:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 508:	8d 41 01             	lea    0x1(%ecx),%eax
 50b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 50e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 511:	8b 45 ec             	mov    -0x14(%ebp),%eax
 514:	ba 00 00 00 00       	mov    $0x0,%edx
 519:	f7 f3                	div    %ebx
 51b:	89 d0                	mov    %edx,%eax
 51d:	0f b6 80 2c 0c 00 00 	movzbl 0xc2c(%eax),%eax
 524:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 528:	8b 75 10             	mov    0x10(%ebp),%esi
 52b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52e:	ba 00 00 00 00       	mov    $0x0,%edx
 533:	f7 f6                	div    %esi
 535:	89 45 ec             	mov    %eax,-0x14(%ebp)
 538:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53c:	75 c7                	jne    505 <printint+0x39>
  if(neg)
 53e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 542:	74 10                	je     554 <printint+0x88>
    buf[i++] = '-';
 544:	8b 45 f4             	mov    -0xc(%ebp),%eax
 547:	8d 50 01             	lea    0x1(%eax),%edx
 54a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 552:	eb 1f                	jmp    573 <printint+0xa7>
 554:	eb 1d                	jmp    573 <printint+0xa7>
    putc(fd, buf[i]);
 556:	8d 55 dc             	lea    -0x24(%ebp),%edx
 559:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55c:	01 d0                	add    %edx,%eax
 55e:	0f b6 00             	movzbl (%eax),%eax
 561:	0f be c0             	movsbl %al,%eax
 564:	89 44 24 04          	mov    %eax,0x4(%esp)
 568:	8b 45 08             	mov    0x8(%ebp),%eax
 56b:	89 04 24             	mov    %eax,(%esp)
 56e:	e8 31 ff ff ff       	call   4a4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 573:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57b:	79 d9                	jns    556 <printint+0x8a>
    putc(fd, buf[i]);
}
 57d:	83 c4 30             	add    $0x30,%esp
 580:	5b                   	pop    %ebx
 581:	5e                   	pop    %esi
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    

00000584 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 58a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 591:	8d 45 0c             	lea    0xc(%ebp),%eax
 594:	83 c0 04             	add    $0x4,%eax
 597:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 59a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5a1:	e9 7c 01 00 00       	jmp    722 <printf+0x19e>
    c = fmt[i] & 0xff;
 5a6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ac:	01 d0                	add    %edx,%eax
 5ae:	0f b6 00             	movzbl (%eax),%eax
 5b1:	0f be c0             	movsbl %al,%eax
 5b4:	25 ff 00 00 00       	and    $0xff,%eax
 5b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c0:	75 2c                	jne    5ee <printf+0x6a>
      if(c == '%'){
 5c2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c6:	75 0c                	jne    5d4 <printf+0x50>
        state = '%';
 5c8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cf:	e9 4a 01 00 00       	jmp    71e <printf+0x19a>
      } else {
        putc(fd, c);
 5d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d7:	0f be c0             	movsbl %al,%eax
 5da:	89 44 24 04          	mov    %eax,0x4(%esp)
 5de:	8b 45 08             	mov    0x8(%ebp),%eax
 5e1:	89 04 24             	mov    %eax,(%esp)
 5e4:	e8 bb fe ff ff       	call   4a4 <putc>
 5e9:	e9 30 01 00 00       	jmp    71e <printf+0x19a>
      }
    } else if(state == '%'){
 5ee:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5f2:	0f 85 26 01 00 00    	jne    71e <printf+0x19a>
      if(c == 'd'){
 5f8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5fc:	75 2d                	jne    62b <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 601:	8b 00                	mov    (%eax),%eax
 603:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 60a:	00 
 60b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 612:	00 
 613:	89 44 24 04          	mov    %eax,0x4(%esp)
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	89 04 24             	mov    %eax,(%esp)
 61d:	e8 aa fe ff ff       	call   4cc <printint>
        ap++;
 622:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 626:	e9 ec 00 00 00       	jmp    717 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 62b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 62f:	74 06                	je     637 <printf+0xb3>
 631:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 635:	75 2d                	jne    664 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 637:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 643:	00 
 644:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 64b:	00 
 64c:	89 44 24 04          	mov    %eax,0x4(%esp)
 650:	8b 45 08             	mov    0x8(%ebp),%eax
 653:	89 04 24             	mov    %eax,(%esp)
 656:	e8 71 fe ff ff       	call   4cc <printint>
        ap++;
 65b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65f:	e9 b3 00 00 00       	jmp    717 <printf+0x193>
      } else if(c == 's'){
 664:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 668:	75 45                	jne    6af <printf+0x12b>
        s = (char*)*ap;
 66a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 672:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 67a:	75 09                	jne    685 <printf+0x101>
          s = "(null)";
 67c:	c7 45 f4 9c 09 00 00 	movl   $0x99c,-0xc(%ebp)
        while(*s != 0){
 683:	eb 1e                	jmp    6a3 <printf+0x11f>
 685:	eb 1c                	jmp    6a3 <printf+0x11f>
          putc(fd, *s);
 687:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68a:	0f b6 00             	movzbl (%eax),%eax
 68d:	0f be c0             	movsbl %al,%eax
 690:	89 44 24 04          	mov    %eax,0x4(%esp)
 694:	8b 45 08             	mov    0x8(%ebp),%eax
 697:	89 04 24             	mov    %eax,(%esp)
 69a:	e8 05 fe ff ff       	call   4a4 <putc>
          s++;
 69f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a6:	0f b6 00             	movzbl (%eax),%eax
 6a9:	84 c0                	test   %al,%al
 6ab:	75 da                	jne    687 <printf+0x103>
 6ad:	eb 68                	jmp    717 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6af:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b3:	75 1d                	jne    6d2 <printf+0x14e>
        putc(fd, *ap);
 6b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	0f be c0             	movsbl %al,%eax
 6bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c1:	8b 45 08             	mov    0x8(%ebp),%eax
 6c4:	89 04 24             	mov    %eax,(%esp)
 6c7:	e8 d8 fd ff ff       	call   4a4 <putc>
        ap++;
 6cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d0:	eb 45                	jmp    717 <printf+0x193>
      } else if(c == '%'){
 6d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d6:	75 17                	jne    6ef <printf+0x16b>
        putc(fd, c);
 6d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6db:	0f be c0             	movsbl %al,%eax
 6de:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e2:	8b 45 08             	mov    0x8(%ebp),%eax
 6e5:	89 04 24             	mov    %eax,(%esp)
 6e8:	e8 b7 fd ff ff       	call   4a4 <putc>
 6ed:	eb 28                	jmp    717 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ef:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6f6:	00 
 6f7:	8b 45 08             	mov    0x8(%ebp),%eax
 6fa:	89 04 24             	mov    %eax,(%esp)
 6fd:	e8 a2 fd ff ff       	call   4a4 <putc>
        putc(fd, c);
 702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 705:	0f be c0             	movsbl %al,%eax
 708:	89 44 24 04          	mov    %eax,0x4(%esp)
 70c:	8b 45 08             	mov    0x8(%ebp),%eax
 70f:	89 04 24             	mov    %eax,(%esp)
 712:	e8 8d fd ff ff       	call   4a4 <putc>
      }
      state = 0;
 717:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 722:	8b 55 0c             	mov    0xc(%ebp),%edx
 725:	8b 45 f0             	mov    -0x10(%ebp),%eax
 728:	01 d0                	add    %edx,%eax
 72a:	0f b6 00             	movzbl (%eax),%eax
 72d:	84 c0                	test   %al,%al
 72f:	0f 85 71 fe ff ff    	jne    5a6 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 735:	c9                   	leave  
 736:	c3                   	ret    

00000737 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 737:	55                   	push   %ebp
 738:	89 e5                	mov    %esp,%ebp
 73a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73d:	8b 45 08             	mov    0x8(%ebp),%eax
 740:	83 e8 08             	sub    $0x8,%eax
 743:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 746:	a1 48 0c 00 00       	mov    0xc48,%eax
 74b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74e:	eb 24                	jmp    774 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 00                	mov    (%eax),%eax
 755:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 758:	77 12                	ja     76c <free+0x35>
 75a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 760:	77 24                	ja     786 <free+0x4f>
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 00                	mov    (%eax),%eax
 767:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76a:	77 1a                	ja     786 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76f:	8b 00                	mov    (%eax),%eax
 771:	89 45 fc             	mov    %eax,-0x4(%ebp)
 774:	8b 45 f8             	mov    -0x8(%ebp),%eax
 777:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77a:	76 d4                	jbe    750 <free+0x19>
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	8b 00                	mov    (%eax),%eax
 781:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 784:	76 ca                	jbe    750 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 786:	8b 45 f8             	mov    -0x8(%ebp),%eax
 789:	8b 40 04             	mov    0x4(%eax),%eax
 78c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	01 c2                	add    %eax,%edx
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	8b 00                	mov    (%eax),%eax
 79d:	39 c2                	cmp    %eax,%edx
 79f:	75 24                	jne    7c5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a4:	8b 50 04             	mov    0x4(%eax),%edx
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	8b 40 04             	mov    0x4(%eax),%eax
 7af:	01 c2                	add    %eax,%edx
 7b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	8b 10                	mov    (%eax),%edx
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	89 10                	mov    %edx,(%eax)
 7c3:	eb 0a                	jmp    7cf <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c8:	8b 10                	mov    (%eax),%edx
 7ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	01 d0                	add    %edx,%eax
 7e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e4:	75 20                	jne    806 <free+0xcf>
    p->s.size += bp->s.size;
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	8b 50 04             	mov    0x4(%eax),%edx
 7ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	01 c2                	add    %eax,%edx
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fd:	8b 10                	mov    (%eax),%edx
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	89 10                	mov    %edx,(%eax)
 804:	eb 08                	jmp    80e <free+0xd7>
  } else
    p->s.ptr = bp;
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	8b 55 f8             	mov    -0x8(%ebp),%edx
 80c:	89 10                	mov    %edx,(%eax)
  freep = p;
 80e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 811:	a3 48 0c 00 00       	mov    %eax,0xc48
}
 816:	c9                   	leave  
 817:	c3                   	ret    

00000818 <morecore>:

static Header*
morecore(uint nu)
{
 818:	55                   	push   %ebp
 819:	89 e5                	mov    %esp,%ebp
 81b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 81e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 825:	77 07                	ja     82e <morecore+0x16>
    nu = 4096;
 827:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 82e:	8b 45 08             	mov    0x8(%ebp),%eax
 831:	c1 e0 03             	shl    $0x3,%eax
 834:	89 04 24             	mov    %eax,(%esp)
 837:	e8 38 fc ff ff       	call   474 <sbrk>
 83c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 83f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 843:	75 07                	jne    84c <morecore+0x34>
    return 0;
 845:	b8 00 00 00 00       	mov    $0x0,%eax
 84a:	eb 22                	jmp    86e <morecore+0x56>
  hp = (Header*)p;
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 852:	8b 45 f0             	mov    -0x10(%ebp),%eax
 855:	8b 55 08             	mov    0x8(%ebp),%edx
 858:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 85b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85e:	83 c0 08             	add    $0x8,%eax
 861:	89 04 24             	mov    %eax,(%esp)
 864:	e8 ce fe ff ff       	call   737 <free>
  return freep;
 869:	a1 48 0c 00 00       	mov    0xc48,%eax
}
 86e:	c9                   	leave  
 86f:	c3                   	ret    

00000870 <malloc>:

void*
malloc(uint nbytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 876:	8b 45 08             	mov    0x8(%ebp),%eax
 879:	83 c0 07             	add    $0x7,%eax
 87c:	c1 e8 03             	shr    $0x3,%eax
 87f:	83 c0 01             	add    $0x1,%eax
 882:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 885:	a1 48 0c 00 00       	mov    0xc48,%eax
 88a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 891:	75 23                	jne    8b6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 893:	c7 45 f0 40 0c 00 00 	movl   $0xc40,-0x10(%ebp)
 89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89d:	a3 48 0c 00 00       	mov    %eax,0xc48
 8a2:	a1 48 0c 00 00       	mov    0xc48,%eax
 8a7:	a3 40 0c 00 00       	mov    %eax,0xc40
    base.s.size = 0;
 8ac:	c7 05 44 0c 00 00 00 	movl   $0x0,0xc44
 8b3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b9:	8b 00                	mov    (%eax),%eax
 8bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	8b 40 04             	mov    0x4(%eax),%eax
 8c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c7:	72 4d                	jb     916 <malloc+0xa6>
      if(p->s.size == nunits)
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	8b 40 04             	mov    0x4(%eax),%eax
 8cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8d2:	75 0c                	jne    8e0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 10                	mov    (%eax),%edx
 8d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8dc:	89 10                	mov    %edx,(%eax)
 8de:	eb 26                	jmp    906 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 40 04             	mov    0x4(%eax),%eax
 8e6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8e9:	89 c2                	mov    %eax,%edx
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	8b 40 04             	mov    0x4(%eax),%eax
 8f7:	c1 e0 03             	shl    $0x3,%eax
 8fa:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	8b 55 ec             	mov    -0x14(%ebp),%edx
 903:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 906:	8b 45 f0             	mov    -0x10(%ebp),%eax
 909:	a3 48 0c 00 00       	mov    %eax,0xc48
      return (void*)(p + 1);
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	83 c0 08             	add    $0x8,%eax
 914:	eb 38                	jmp    94e <malloc+0xde>
    }
    if(p == freep)
 916:	a1 48 0c 00 00       	mov    0xc48,%eax
 91b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 91e:	75 1b                	jne    93b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 920:	8b 45 ec             	mov    -0x14(%ebp),%eax
 923:	89 04 24             	mov    %eax,(%esp)
 926:	e8 ed fe ff ff       	call   818 <morecore>
 92b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 92e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 932:	75 07                	jne    93b <malloc+0xcb>
        return 0;
 934:	b8 00 00 00 00       	mov    $0x0,%eax
 939:	eb 13                	jmp    94e <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	8b 00                	mov    (%eax),%eax
 946:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 949:	e9 70 ff ff ff       	jmp    8be <malloc+0x4e>
}
 94e:	c9                   	leave  
 94f:	c3                   	ret    
