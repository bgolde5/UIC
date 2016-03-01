
_thread3d:     file format elf32-i386


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
  5f:	c7 44 24 04 4d 09 00 	movl   $0x94d,0x4(%esp)
  66:	00 
  67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6e:	e8 0e 05 00 00       	call   581 <printf>

}
  73:	c9                   	leave  
  74:	c3                   	ret    

00000075 <main>:

int main(int argc, char** argv) {
  75:	55                   	push   %ebp
  76:	89 e5                	mov    %esp,%ebp
  78:	83 e4 f0             	and    $0xfffffff0,%esp
  7b:	81 ec e0 00 00 00    	sub    $0xe0,%esp

  int threadids[50];
  int thread;
  for(thread=0;thread<50;thread++) {
  81:	c7 84 24 dc 00 00 00 	movl   $0x0,0xdc(%esp)
  88:	00 00 00 00 
  8c:	eb 1f                	jmp    ad <main+0x38>
    threadids[thread]=thread_create(f);
  8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  95:	e8 04 03 00 00       	call   39e <thread_create>
  9a:	8b 94 24 dc 00 00 00 	mov    0xdc(%esp),%edx
  a1:	89 44 94 14          	mov    %eax,0x14(%esp,%edx,4)

int main(int argc, char** argv) {

  int threadids[50];
  int thread;
  for(thread=0;thread<50;thread++) {
  a5:	83 84 24 dc 00 00 00 	addl   $0x1,0xdc(%esp)
  ac:	01 
  ad:	83 bc 24 dc 00 00 00 	cmpl   $0x31,0xdc(%esp)
  b4:	31 
  b5:	7e d7                	jle    8e <main+0x19>
    threadids[thread]=thread_create(f);
  }

  printf(1,"Done creating\n");
  b7:	c7 44 24 04 5e 09 00 	movl   $0x95e,0x4(%esp)
  be:	00 
  bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c6:	e8 b6 04 00 00       	call   581 <printf>

  for(thread=0;thread<50;thread++) {
  cb:	c7 84 24 dc 00 00 00 	movl   $0x0,0xdc(%esp)
  d2:	00 00 00 00 
  d6:	eb 43                	jmp    11b <main+0xa6>
    thread_join(threadids[thread]);
  d8:	8b 84 24 dc 00 00 00 	mov    0xdc(%esp),%eax
  df:	8b 44 84 14          	mov    0x14(%esp,%eax,4),%eax
  e3:	89 04 24             	mov    %eax,(%esp)
  e6:	e8 ae 03 00 00       	call   499 <thread_join>
    printf(1,"Joined %d, shared is now %d\n",thread,shared);
  eb:	a1 24 0c 00 00       	mov    0xc24,%eax
  f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  f4:	8b 84 24 dc 00 00 00 	mov    0xdc(%esp),%eax
  fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  ff:	c7 44 24 04 6d 09 00 	movl   $0x96d,0x4(%esp)
 106:	00 
 107:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 10e:	e8 6e 04 00 00       	call   581 <printf>
    threadids[thread]=thread_create(f);
  }

  printf(1,"Done creating\n");

  for(thread=0;thread<50;thread++) {
 113:	83 84 24 dc 00 00 00 	addl   $0x1,0xdc(%esp)
 11a:	01 
 11b:	83 bc 24 dc 00 00 00 	cmpl   $0x31,0xdc(%esp)
 122:	31 
 123:	7e b3                	jle    d8 <main+0x63>
    thread_join(threadids[thread]);
    printf(1,"Joined %d, shared is now %d\n",thread,shared);
  }  
  
  printf(1,"Main is done!\n"); 
 125:	c7 44 24 04 8a 09 00 	movl   $0x98a,0x4(%esp)
 12c:	00 
 12d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 134:	e8 48 04 00 00       	call   581 <printf>

  exit();
 139:	e8 ab 02 00 00       	call   3e9 <exit>

0000013e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	57                   	push   %edi
 142:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 143:	8b 4d 08             	mov    0x8(%ebp),%ecx
 146:	8b 55 10             	mov    0x10(%ebp),%edx
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	89 cb                	mov    %ecx,%ebx
 14e:	89 df                	mov    %ebx,%edi
 150:	89 d1                	mov    %edx,%ecx
 152:	fc                   	cld    
 153:	f3 aa                	rep stos %al,%es:(%edi)
 155:	89 ca                	mov    %ecx,%edx
 157:	89 fb                	mov    %edi,%ebx
 159:	89 5d 08             	mov    %ebx,0x8(%ebp)
 15c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15f:	5b                   	pop    %ebx
 160:	5f                   	pop    %edi
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    

00000163 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
 166:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 16f:	90                   	nop
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	8d 50 01             	lea    0x1(%eax),%edx
 176:	89 55 08             	mov    %edx,0x8(%ebp)
 179:	8b 55 0c             	mov    0xc(%ebp),%edx
 17c:	8d 4a 01             	lea    0x1(%edx),%ecx
 17f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 182:	0f b6 12             	movzbl (%edx),%edx
 185:	88 10                	mov    %dl,(%eax)
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	84 c0                	test   %al,%al
 18c:	75 e2                	jne    170 <strcpy+0xd>
    ;
  return os;
 18e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 191:	c9                   	leave  
 192:	c3                   	ret    

00000193 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 196:	eb 08                	jmp    1a0 <strcmp+0xd>
    p++, q++;
 198:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	84 c0                	test   %al,%al
 1a8:	74 10                	je     1ba <strcmp+0x27>
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	0f b6 10             	movzbl (%eax),%edx
 1b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b3:	0f b6 00             	movzbl (%eax),%eax
 1b6:	38 c2                	cmp    %al,%dl
 1b8:	74 de                	je     198 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	0f b6 d0             	movzbl %al,%edx
 1c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c6:	0f b6 00             	movzbl (%eax),%eax
 1c9:	0f b6 c0             	movzbl %al,%eax
 1cc:	29 c2                	sub    %eax,%edx
 1ce:	89 d0                	mov    %edx,%eax
}
 1d0:	5d                   	pop    %ebp
 1d1:	c3                   	ret    

000001d2 <strlen>:

uint
strlen(char *s)
{
 1d2:	55                   	push   %ebp
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1df:	eb 04                	jmp    1e5 <strlen+0x13>
 1e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	01 d0                	add    %edx,%eax
 1ed:	0f b6 00             	movzbl (%eax),%eax
 1f0:	84 c0                	test   %al,%al
 1f2:	75 ed                	jne    1e1 <strlen+0xf>
    ;
  return n;
 1f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1ff:	8b 45 10             	mov    0x10(%ebp),%eax
 202:	89 44 24 08          	mov    %eax,0x8(%esp)
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	89 44 24 04          	mov    %eax,0x4(%esp)
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	89 04 24             	mov    %eax,(%esp)
 213:	e8 26 ff ff ff       	call   13e <stosb>
  return dst;
 218:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21b:	c9                   	leave  
 21c:	c3                   	ret    

0000021d <strchr>:

char*
strchr(const char *s, char c)
{
 21d:	55                   	push   %ebp
 21e:	89 e5                	mov    %esp,%ebp
 220:	83 ec 04             	sub    $0x4,%esp
 223:	8b 45 0c             	mov    0xc(%ebp),%eax
 226:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 229:	eb 14                	jmp    23f <strchr+0x22>
    if(*s == c)
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	3a 45 fc             	cmp    -0x4(%ebp),%al
 234:	75 05                	jne    23b <strchr+0x1e>
      return (char*)s;
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	eb 13                	jmp    24e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 23b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	84 c0                	test   %al,%al
 247:	75 e2                	jne    22b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 249:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <gets>:

char*
gets(char *buf, int max)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 25d:	eb 4c                	jmp    2ab <gets+0x5b>
    cc = read(0, &c, 1);
 25f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 266:	00 
 267:	8d 45 ef             	lea    -0x11(%ebp),%eax
 26a:	89 44 24 04          	mov    %eax,0x4(%esp)
 26e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 275:	e8 87 01 00 00       	call   401 <read>
 27a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 27d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 281:	7f 02                	jg     285 <gets+0x35>
      break;
 283:	eb 31                	jmp    2b6 <gets+0x66>
    buf[i++] = c;
 285:	8b 45 f4             	mov    -0xc(%ebp),%eax
 288:	8d 50 01             	lea    0x1(%eax),%edx
 28b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28e:	89 c2                	mov    %eax,%edx
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	01 c2                	add    %eax,%edx
 295:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 299:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29f:	3c 0a                	cmp    $0xa,%al
 2a1:	74 13                	je     2b6 <gets+0x66>
 2a3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a7:	3c 0d                	cmp    $0xd,%al
 2a9:	74 0b                	je     2b6 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ae:	83 c0 01             	add    $0x1,%eax
 2b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b4:	7c a9                	jl     25f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	01 d0                	add    %edx,%eax
 2be:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <stat>:

int
stat(char *n, struct stat *st)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2d3:	00 
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	89 04 24             	mov    %eax,(%esp)
 2da:	e8 4a 01 00 00       	call   429 <open>
 2df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e6:	79 07                	jns    2ef <stat+0x29>
    return -1;
 2e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ed:	eb 23                	jmp    312 <stat+0x4c>
  r = fstat(fd, st);
 2ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f9:	89 04 24             	mov    %eax,(%esp)
 2fc:	e8 40 01 00 00       	call   441 <fstat>
 301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 304:	8b 45 f4             	mov    -0xc(%ebp),%eax
 307:	89 04 24             	mov    %eax,(%esp)
 30a:	e8 02 01 00 00       	call   411 <close>
  return r;
 30f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 312:	c9                   	leave  
 313:	c3                   	ret    

00000314 <atoi>:

int
atoi(const char *s)
{
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 321:	eb 25                	jmp    348 <atoi+0x34>
    n = n*10 + *s++ - '0';
 323:	8b 55 fc             	mov    -0x4(%ebp),%edx
 326:	89 d0                	mov    %edx,%eax
 328:	c1 e0 02             	shl    $0x2,%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	01 c0                	add    %eax,%eax
 32f:	89 c1                	mov    %eax,%ecx
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	8d 50 01             	lea    0x1(%eax),%edx
 337:	89 55 08             	mov    %edx,0x8(%ebp)
 33a:	0f b6 00             	movzbl (%eax),%eax
 33d:	0f be c0             	movsbl %al,%eax
 340:	01 c8                	add    %ecx,%eax
 342:	83 e8 30             	sub    $0x30,%eax
 345:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	0f b6 00             	movzbl (%eax),%eax
 34e:	3c 2f                	cmp    $0x2f,%al
 350:	7e 0a                	jle    35c <atoi+0x48>
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	0f b6 00             	movzbl (%eax),%eax
 358:	3c 39                	cmp    $0x39,%al
 35a:	7e c7                	jle    323 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 35c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    

00000361 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 36d:	8b 45 0c             	mov    0xc(%ebp),%eax
 370:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 373:	eb 17                	jmp    38c <memmove+0x2b>
    *dst++ = *src++;
 375:	8b 45 fc             	mov    -0x4(%ebp),%eax
 378:	8d 50 01             	lea    0x1(%eax),%edx
 37b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 37e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 381:	8d 4a 01             	lea    0x1(%edx),%ecx
 384:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 387:	0f b6 12             	movzbl (%edx),%edx
 38a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 38c:	8b 45 10             	mov    0x10(%ebp),%eax
 38f:	8d 50 ff             	lea    -0x1(%eax),%edx
 392:	89 55 10             	mov    %edx,0x10(%ebp)
 395:	85 c0                	test   %eax,%eax
 397:	7f dc                	jg     375 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 399:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39c:	c9                   	leave  
 39d:	c3                   	ret    

0000039e <thread_create>:

void* malloc(unsigned int);
int thread_create(void (*function)(void)) {
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	83 ec 28             	sub    $0x28,%esp
  char* new_stack = malloc(1024*1024);
 3a4:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
 3ab:	e8 bd 04 00 00       	call   86d <malloc>
 3b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char* sp = new_stack + 1024 * 1024 - 4;
 3b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b6:	05 fc ff 0f 00       	add    $0xffffc,%eax
 3bb:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // add thread exit to return value of new stack
  *(uint*)sp = (uint)&thread_exit;
 3be:	ba 91 04 00 00       	mov    $0x491,%edx
 3c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3c6:	89 10                	mov    %edx,(%eax)
  
  return clone(function,new_stack+1024*1024-4);
 3c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3cb:	05 fc ff 0f 00       	add    $0xffffc,%eax
 3d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	89 04 24             	mov    %eax,(%esp)
 3da:	e8 aa 00 00 00       	call   489 <clone>
}
 3df:	c9                   	leave  
 3e0:	c3                   	ret    

000003e1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3e1:	b8 01 00 00 00       	mov    $0x1,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <exit>:
SYSCALL(exit)
 3e9:	b8 02 00 00 00       	mov    $0x2,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <wait>:
SYSCALL(wait)
 3f1:	b8 03 00 00 00       	mov    $0x3,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <pipe>:
SYSCALL(pipe)
 3f9:	b8 04 00 00 00       	mov    $0x4,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <read>:
SYSCALL(read)
 401:	b8 05 00 00 00       	mov    $0x5,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <write>:
SYSCALL(write)
 409:	b8 10 00 00 00       	mov    $0x10,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <close>:
SYSCALL(close)
 411:	b8 15 00 00 00       	mov    $0x15,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <kill>:
SYSCALL(kill)
 419:	b8 06 00 00 00       	mov    $0x6,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <exec>:
SYSCALL(exec)
 421:	b8 07 00 00 00       	mov    $0x7,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <open>:
SYSCALL(open)
 429:	b8 0f 00 00 00       	mov    $0xf,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <mknod>:
SYSCALL(mknod)
 431:	b8 11 00 00 00       	mov    $0x11,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <unlink>:
SYSCALL(unlink)
 439:	b8 12 00 00 00       	mov    $0x12,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <fstat>:
SYSCALL(fstat)
 441:	b8 08 00 00 00       	mov    $0x8,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <link>:
SYSCALL(link)
 449:	b8 13 00 00 00       	mov    $0x13,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <mkdir>:
SYSCALL(mkdir)
 451:	b8 14 00 00 00       	mov    $0x14,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <chdir>:
SYSCALL(chdir)
 459:	b8 09 00 00 00       	mov    $0x9,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <dup>:
SYSCALL(dup)
 461:	b8 0a 00 00 00       	mov    $0xa,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <getpid>:
SYSCALL(getpid)
 469:	b8 0b 00 00 00       	mov    $0xb,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <sbrk>:
SYSCALL(sbrk)
 471:	b8 0c 00 00 00       	mov    $0xc,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <sleep>:
SYSCALL(sleep)
 479:	b8 0d 00 00 00       	mov    $0xd,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <uptime>:
SYSCALL(uptime)
 481:	b8 0e 00 00 00       	mov    $0xe,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <clone>:
SYSCALL(clone)
 489:	b8 16 00 00 00       	mov    $0x16,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <thread_exit>:
SYSCALL(thread_exit)
 491:	b8 17 00 00 00       	mov    $0x17,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <thread_join>:
SYSCALL(thread_join)
 499:	b8 18 00 00 00       	mov    $0x18,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a1:	55                   	push   %ebp
 4a2:	89 e5                	mov    %esp,%ebp
 4a4:	83 ec 18             	sub    $0x18,%esp
 4a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4aa:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ad:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b4:	00 
 4b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	89 04 24             	mov    %eax,(%esp)
 4c2:	e8 42 ff ff ff       	call   409 <write>
}
 4c7:	c9                   	leave  
 4c8:	c3                   	ret    

000004c9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c9:	55                   	push   %ebp
 4ca:	89 e5                	mov    %esp,%ebp
 4cc:	56                   	push   %esi
 4cd:	53                   	push   %ebx
 4ce:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4dc:	74 17                	je     4f5 <printint+0x2c>
 4de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e2:	79 11                	jns    4f5 <printint+0x2c>
    neg = 1;
 4e4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ee:	f7 d8                	neg    %eax
 4f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f3:	eb 06                	jmp    4fb <printint+0x32>
  } else {
    x = xx;
 4f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 502:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 505:	8d 41 01             	lea    0x1(%ecx),%eax
 508:	89 45 f4             	mov    %eax,-0xc(%ebp)
 50b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 50e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 511:	ba 00 00 00 00       	mov    $0x0,%edx
 516:	f7 f3                	div    %ebx
 518:	89 d0                	mov    %edx,%eax
 51a:	0f b6 80 2c 0c 00 00 	movzbl 0xc2c(%eax),%eax
 521:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 525:	8b 75 10             	mov    0x10(%ebp),%esi
 528:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52b:	ba 00 00 00 00       	mov    $0x0,%edx
 530:	f7 f6                	div    %esi
 532:	89 45 ec             	mov    %eax,-0x14(%ebp)
 535:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 539:	75 c7                	jne    502 <printint+0x39>
  if(neg)
 53b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 53f:	74 10                	je     551 <printint+0x88>
    buf[i++] = '-';
 541:	8b 45 f4             	mov    -0xc(%ebp),%eax
 544:	8d 50 01             	lea    0x1(%eax),%edx
 547:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 54f:	eb 1f                	jmp    570 <printint+0xa7>
 551:	eb 1d                	jmp    570 <printint+0xa7>
    putc(fd, buf[i]);
 553:	8d 55 dc             	lea    -0x24(%ebp),%edx
 556:	8b 45 f4             	mov    -0xc(%ebp),%eax
 559:	01 d0                	add    %edx,%eax
 55b:	0f b6 00             	movzbl (%eax),%eax
 55e:	0f be c0             	movsbl %al,%eax
 561:	89 44 24 04          	mov    %eax,0x4(%esp)
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	89 04 24             	mov    %eax,(%esp)
 56b:	e8 31 ff ff ff       	call   4a1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 570:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 578:	79 d9                	jns    553 <printint+0x8a>
    putc(fd, buf[i]);
}
 57a:	83 c4 30             	add    $0x30,%esp
 57d:	5b                   	pop    %ebx
 57e:	5e                   	pop    %esi
 57f:	5d                   	pop    %ebp
 580:	c3                   	ret    

00000581 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 581:	55                   	push   %ebp
 582:	89 e5                	mov    %esp,%ebp
 584:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 587:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58e:	8d 45 0c             	lea    0xc(%ebp),%eax
 591:	83 c0 04             	add    $0x4,%eax
 594:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 597:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59e:	e9 7c 01 00 00       	jmp    71f <printf+0x19e>
    c = fmt[i] & 0xff;
 5a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a9:	01 d0                	add    %edx,%eax
 5ab:	0f b6 00             	movzbl (%eax),%eax
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	25 ff 00 00 00       	and    $0xff,%eax
 5b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bd:	75 2c                	jne    5eb <printf+0x6a>
      if(c == '%'){
 5bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c3:	75 0c                	jne    5d1 <printf+0x50>
        state = '%';
 5c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cc:	e9 4a 01 00 00       	jmp    71b <printf+0x19a>
      } else {
        putc(fd, c);
 5d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d4:	0f be c0             	movsbl %al,%eax
 5d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5db:	8b 45 08             	mov    0x8(%ebp),%eax
 5de:	89 04 24             	mov    %eax,(%esp)
 5e1:	e8 bb fe ff ff       	call   4a1 <putc>
 5e6:	e9 30 01 00 00       	jmp    71b <printf+0x19a>
      }
    } else if(state == '%'){
 5eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ef:	0f 85 26 01 00 00    	jne    71b <printf+0x19a>
      if(c == 'd'){
 5f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f9:	75 2d                	jne    628 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 607:	00 
 608:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 60f:	00 
 610:	89 44 24 04          	mov    %eax,0x4(%esp)
 614:	8b 45 08             	mov    0x8(%ebp),%eax
 617:	89 04 24             	mov    %eax,(%esp)
 61a:	e8 aa fe ff ff       	call   4c9 <printint>
        ap++;
 61f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 623:	e9 ec 00 00 00       	jmp    714 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 628:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 62c:	74 06                	je     634 <printf+0xb3>
 62e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 632:	75 2d                	jne    661 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 634:	8b 45 e8             	mov    -0x18(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 640:	00 
 641:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 648:	00 
 649:	89 44 24 04          	mov    %eax,0x4(%esp)
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	89 04 24             	mov    %eax,(%esp)
 653:	e8 71 fe ff ff       	call   4c9 <printint>
        ap++;
 658:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65c:	e9 b3 00 00 00       	jmp    714 <printf+0x193>
      } else if(c == 's'){
 661:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 665:	75 45                	jne    6ac <printf+0x12b>
        s = (char*)*ap;
 667:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 66f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 673:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 677:	75 09                	jne    682 <printf+0x101>
          s = "(null)";
 679:	c7 45 f4 99 09 00 00 	movl   $0x999,-0xc(%ebp)
        while(*s != 0){
 680:	eb 1e                	jmp    6a0 <printf+0x11f>
 682:	eb 1c                	jmp    6a0 <printf+0x11f>
          putc(fd, *s);
 684:	8b 45 f4             	mov    -0xc(%ebp),%eax
 687:	0f b6 00             	movzbl (%eax),%eax
 68a:	0f be c0             	movsbl %al,%eax
 68d:	89 44 24 04          	mov    %eax,0x4(%esp)
 691:	8b 45 08             	mov    0x8(%ebp),%eax
 694:	89 04 24             	mov    %eax,(%esp)
 697:	e8 05 fe ff ff       	call   4a1 <putc>
          s++;
 69c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a3:	0f b6 00             	movzbl (%eax),%eax
 6a6:	84 c0                	test   %al,%al
 6a8:	75 da                	jne    684 <printf+0x103>
 6aa:	eb 68                	jmp    714 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ac:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b0:	75 1d                	jne    6cf <printf+0x14e>
        putc(fd, *ap);
 6b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	0f be c0             	movsbl %al,%eax
 6ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	89 04 24             	mov    %eax,(%esp)
 6c4:	e8 d8 fd ff ff       	call   4a1 <putc>
        ap++;
 6c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cd:	eb 45                	jmp    714 <printf+0x193>
      } else if(c == '%'){
 6cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d3:	75 17                	jne    6ec <printf+0x16b>
        putc(fd, c);
 6d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d8:	0f be c0             	movsbl %al,%eax
 6db:	89 44 24 04          	mov    %eax,0x4(%esp)
 6df:	8b 45 08             	mov    0x8(%ebp),%eax
 6e2:	89 04 24             	mov    %eax,(%esp)
 6e5:	e8 b7 fd ff ff       	call   4a1 <putc>
 6ea:	eb 28                	jmp    714 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ec:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6f3:	00 
 6f4:	8b 45 08             	mov    0x8(%ebp),%eax
 6f7:	89 04 24             	mov    %eax,(%esp)
 6fa:	e8 a2 fd ff ff       	call   4a1 <putc>
        putc(fd, c);
 6ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 702:	0f be c0             	movsbl %al,%eax
 705:	89 44 24 04          	mov    %eax,0x4(%esp)
 709:	8b 45 08             	mov    0x8(%ebp),%eax
 70c:	89 04 24             	mov    %eax,(%esp)
 70f:	e8 8d fd ff ff       	call   4a1 <putc>
      }
      state = 0;
 714:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 71f:	8b 55 0c             	mov    0xc(%ebp),%edx
 722:	8b 45 f0             	mov    -0x10(%ebp),%eax
 725:	01 d0                	add    %edx,%eax
 727:	0f b6 00             	movzbl (%eax),%eax
 72a:	84 c0                	test   %al,%al
 72c:	0f 85 71 fe ff ff    	jne    5a3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 732:	c9                   	leave  
 733:	c3                   	ret    

00000734 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 734:	55                   	push   %ebp
 735:	89 e5                	mov    %esp,%ebp
 737:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73a:	8b 45 08             	mov    0x8(%ebp),%eax
 73d:	83 e8 08             	sub    $0x8,%eax
 740:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 743:	a1 48 0c 00 00       	mov    0xc48,%eax
 748:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74b:	eb 24                	jmp    771 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 755:	77 12                	ja     769 <free+0x35>
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75d:	77 24                	ja     783 <free+0x4f>
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 767:	77 1a                	ja     783 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 777:	76 d4                	jbe    74d <free+0x19>
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 781:	76 ca                	jbe    74d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	01 c2                	add    %eax,%edx
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	39 c2                	cmp    %eax,%edx
 79c:	75 24                	jne    7c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 79e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a1:	8b 50 04             	mov    0x4(%eax),%edx
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	01 c2                	add    %eax,%edx
 7ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	89 10                	mov    %edx,(%eax)
 7c0:	eb 0a                	jmp    7cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 10                	mov    (%eax),%edx
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 40 04             	mov    0x4(%eax),%eax
 7d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	01 d0                	add    %edx,%eax
 7de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e1:	75 20                	jne    803 <free+0xcf>
    p->s.size += bp->s.size;
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 50 04             	mov    0x4(%eax),%edx
 7e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	01 c2                	add    %eax,%edx
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fa:	8b 10                	mov    (%eax),%edx
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	89 10                	mov    %edx,(%eax)
 801:	eb 08                	jmp    80b <free+0xd7>
  } else
    p->s.ptr = bp;
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	8b 55 f8             	mov    -0x8(%ebp),%edx
 809:	89 10                	mov    %edx,(%eax)
  freep = p;
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	a3 48 0c 00 00       	mov    %eax,0xc48
}
 813:	c9                   	leave  
 814:	c3                   	ret    

00000815 <morecore>:

static Header*
morecore(uint nu)
{
 815:	55                   	push   %ebp
 816:	89 e5                	mov    %esp,%ebp
 818:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 81b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 822:	77 07                	ja     82b <morecore+0x16>
    nu = 4096;
 824:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 82b:	8b 45 08             	mov    0x8(%ebp),%eax
 82e:	c1 e0 03             	shl    $0x3,%eax
 831:	89 04 24             	mov    %eax,(%esp)
 834:	e8 38 fc ff ff       	call   471 <sbrk>
 839:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 83c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 840:	75 07                	jne    849 <morecore+0x34>
    return 0;
 842:	b8 00 00 00 00       	mov    $0x0,%eax
 847:	eb 22                	jmp    86b <morecore+0x56>
  hp = (Header*)p;
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 84f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 852:	8b 55 08             	mov    0x8(%ebp),%edx
 855:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 858:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85b:	83 c0 08             	add    $0x8,%eax
 85e:	89 04 24             	mov    %eax,(%esp)
 861:	e8 ce fe ff ff       	call   734 <free>
  return freep;
 866:	a1 48 0c 00 00       	mov    0xc48,%eax
}
 86b:	c9                   	leave  
 86c:	c3                   	ret    

0000086d <malloc>:

void*
malloc(uint nbytes)
{
 86d:	55                   	push   %ebp
 86e:	89 e5                	mov    %esp,%ebp
 870:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 873:	8b 45 08             	mov    0x8(%ebp),%eax
 876:	83 c0 07             	add    $0x7,%eax
 879:	c1 e8 03             	shr    $0x3,%eax
 87c:	83 c0 01             	add    $0x1,%eax
 87f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 882:	a1 48 0c 00 00       	mov    0xc48,%eax
 887:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 88e:	75 23                	jne    8b3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 890:	c7 45 f0 40 0c 00 00 	movl   $0xc40,-0x10(%ebp)
 897:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89a:	a3 48 0c 00 00       	mov    %eax,0xc48
 89f:	a1 48 0c 00 00       	mov    0xc48,%eax
 8a4:	a3 40 0c 00 00       	mov    %eax,0xc40
    base.s.size = 0;
 8a9:	c7 05 44 0c 00 00 00 	movl   $0x0,0xc44
 8b0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b6:	8b 00                	mov    (%eax),%eax
 8b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c4:	72 4d                	jb     913 <malloc+0xa6>
      if(p->s.size == nunits)
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 40 04             	mov    0x4(%eax),%eax
 8cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cf:	75 0c                	jne    8dd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d4:	8b 10                	mov    (%eax),%edx
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	89 10                	mov    %edx,(%eax)
 8db:	eb 26                	jmp    903 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e0:	8b 40 04             	mov    0x4(%eax),%eax
 8e3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8e6:	89 c2                	mov    %eax,%edx
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f1:	8b 40 04             	mov    0x4(%eax),%eax
 8f4:	c1 e0 03             	shl    $0x3,%eax
 8f7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 900:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 903:	8b 45 f0             	mov    -0x10(%ebp),%eax
 906:	a3 48 0c 00 00       	mov    %eax,0xc48
      return (void*)(p + 1);
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	83 c0 08             	add    $0x8,%eax
 911:	eb 38                	jmp    94b <malloc+0xde>
    }
    if(p == freep)
 913:	a1 48 0c 00 00       	mov    0xc48,%eax
 918:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 91b:	75 1b                	jne    938 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 91d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 920:	89 04 24             	mov    %eax,(%esp)
 923:	e8 ed fe ff ff       	call   815 <morecore>
 928:	89 45 f4             	mov    %eax,-0xc(%ebp)
 92b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 92f:	75 07                	jne    938 <malloc+0xcb>
        return 0;
 931:	b8 00 00 00 00       	mov    $0x0,%eax
 936:	eb 13                	jmp    94b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 941:	8b 00                	mov    (%eax),%eax
 943:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 946:	e9 70 ff ff ff       	jmp    8bb <malloc+0x4e>
}
 94b:	c9                   	leave  
 94c:	c3                   	ret    
