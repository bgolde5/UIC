#include <fnmatch.h>
#include <fcntl.h>
#include <errno.h>
#include <netinet/in.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>
#include <dirent.h>
#include <signal.h>

#define BACKLOG (10)

void serve_request(int);

enum status_message {STATUS_200=200, STATUS_404=404, STATUS_501=501};

char ROOT[128]; // root directory in server

char* html = "HTTP/1.1 200 OK\r\n"
"Content-type: text/html; charset=UTF-8\r\n\r\n";
char* jpg = "HTTP/1.1 200 OK\r\n"
"Content-type: image/jpg; charset=UTF-8\r\n\r\n";
char* png = "HTTP/1.1 200 OK\r\n"
"Content-type: image/png; charset=UTF-8\r\n\r\n";
char* gif = "HTTP/1.1 200 OK\r\n"
"Content-type: image/gif; charset=UTF-8\r\n\r\n";
char* pdf = "HTTP/1.1 200 OK\r\n"
"Content-type: application/pdf; charset=UTF-8\r\n\r\n";

char * index_hdr = "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\"><html>"
"<title>Directory listing for %s</title>"
"<body>"
"<h2>Directory listing for %s</h2><hr><ul>";

// snprintf(output_buffer,4096,index_hdr,filename,filename);

char * index_body = "<li><a href=\"%s\">%s</a>";

char * index_ftr = "</ul><hr></body></html>";

void sigchld_handler(){
  while(waitpid(-1, 0, WNOHANG) > 0);
  return;
}

/* char* parseRequest(char* request)
 * Args: HTTP request of the form "GET /path/to/resource HTTP/1.X" 
 *
 * Return: the resource requested "/path/to/resource"
 *         0 if the request is not a valid HTTP request 
 * 
 * Does not modify the given request string. 
 * The returned resource should be free'd by the caller function. 
 */
char* parseRequest(char* request) {
  //assume file paths are no more than 256 bytes + 1 for null. 
  char *buffer = malloc(sizeof(char)*257);
  memset(buffer, 0, 257);

  if(fnmatch("GET * HTTP/1.*",  request, 0)) return 0; 

  sscanf(request, "GET %s HTTP/1.", buffer);
  return buffer; 
}

void command_line_parsing(int code, char* method, char* uri){
  printf("%i %s %s\n", code, method, uri);
}

int method_supported(char* method) {
  if (strcasecmp(method, "GET") == 0) {
    return 1;
  }
  return 0;
}

int is_directory(char* path){
  struct stat stat_struct;
  if (stat(path, &stat_struct) == 0 && S_ISDIR(stat_struct.st_mode))
  {
    return 1;
  }
  return 0;
}

int is_file(char* path){
  struct stat stat_struct;
  if (stat(path, &stat_struct) == 0 && S_ISREG(stat_struct.st_mode))
  {
    return 1;
  }
  return 0;
}

//REFERENCE: 
//http://stackoverflow.com/questions/612097/how-can-i-get-the-list-of-files-in-a-directory-using-c-or-c
char * directory_listing(char* path){

  char *dir_listing = (char*)malloc(sizeof(char)*4096);
  char temp_body[4096];
  memset(dir_listing, 0, 4096);
  memset(temp_body, 0, 4096);

  sprintf(temp_body, index_hdr, path, path);
  sprintf(dir_listing, "%s", temp_body); //write the header of the directory listing

  memset(temp_body, 0, strlen(temp_body));

  DIR *dir;
  struct dirent *listing;
  if ((dir = opendir(path)) != NULL){

    while ((listing = readdir (dir)) != NULL) {
      if (strcmp(listing->d_name, ".") == 0 || strcmp(listing->d_name, "..") == 0){
        // do nothing
      }
      else {
        // temporarily hold the path and listing
        sprintf(temp_body, "%s%s", path, listing->d_name);

        // if listing is a director, append a "/" to the end
        if(is_directory(temp_body)) {
          sprintf(listing->d_name, "%s%c", listing->d_name, '/');
        }
        sprintf(temp_body, index_body, listing->d_name, listing->d_name);
        sprintf(dir_listing, "%s%s", dir_listing, temp_body);
      }
    }
  }

  sprintf(dir_listing, "%s%s", dir_listing, index_ftr); // write the footer of the directory listing

  return dir_listing;
}

//Referenced from Computer Systems, Second Edition by Bryant, O'Hallaron
void content_type(char* filename, char* filetype){
  if(strstr(filename, ".html")){
    strcpy(filetype, "text/html");
  }
  else if(strstr(filename, ".gif")){
    strcpy(filetype, "image/gif");
  }
  else if(strstr(filename, ".jpg")){
    strcpy(filetype, "image/jpg");
  }
  else if(strstr(filename, ".png")){
    strcpy(filetype, "image/png");
  }
  else if(strstr(filename, ".pdf")){
    strcpy(filetype, "application/pdf");
  }
  else {
    strcpy(filetype, "text/plain");
  }
}

int Send(int fd, char* buf, int size){

  if (size == 0)
    return 0;

  int bytes_read = 0;
  while(1){
    bytes_read += send(fd, &buf[0]+bytes_read, size-bytes_read, 0);

    if (bytes_read >= size)
      break;
  }
  return size;
}

void send_501(int client_fd){
  char* header = "HTTP/1.1 501 Not implemented\r\n";
  int header_len = strlen(header);
  header = malloc(header_len);
  strcpy(header, "HTTP/1.1 501 Not implemented\r\n");

  Send(client_fd, header, header_len);

  close(client_fd);

  return;
}

void send_404(int client_fd, char* filename){

  char buffer[4096];
  memset(buffer, 0, 4096);

  sprintf(buffer, 
      "HTTP/1.1 404 Not found\r\n"
      "Content-type: text/html\r\n\r\n"
      "<html>"
      "<p><h1>Error</h1></p>"
      "<h3>404 - Path not found</h3>"
      "<p><i>%s</i></p>"
      "<p>We could not find the path requested :(</p>"
      "</html>", filename);

  Send(client_fd, buffer, strlen(buffer));

  close(client_fd);

  return;
}

void send_file(int client_fd, int read_fd, char* filename){

  int bytes_needed, bytes_read, content_length = 0;
  char buffer[4096];
  char* http_header;
  char* type = (char*)malloc(sizeof(char)*100);

  content_type(filename, type);

  if(strcmp("image/jpg", type) == 0)
    http_header = jpg;
  else if (strcmp("image/png", type) == 0)
    http_header = png;
  else if (strcmp("image/gif", type) == 0)
    http_header = gif;
  else if (strcmp("application/pdf", type) == 0)
    http_header = pdf;
  else
    http_header = html;

  // get content length
  struct stat st;
  if (stat(filename, &st) == 0)
    content_length = st.st_size;

  bytes_needed = strlen(http_header);

  Send(client_fd, http_header, bytes_needed); 
  while(1){
    bytes_read = read(read_fd, buffer, 4096); 

    if (bytes_read <= 0)
      break;

    Send(client_fd, buffer, bytes_read); 
  }

  close(client_fd);

  free(type);

  return;
}

void send_dir_list(int client_fd, char* path){

  char dir_list[4096];
  char buffer[4096];

  strcpy(dir_list, directory_listing(path));

  sprintf(buffer, 
      "HTTP/1.1 200 OK\r\n"
      "Content-type: text/html\r\n\r\n"
      "%s", dir_list);

  Send(client_fd, buffer, strlen(buffer));
  close(client_fd);

  return;
}

void serve_request(int client_fd){
  int read_fd;
  int file_offset = 0;
  char client_buf[4096];
  char path[4096];
  char filename[4096];
  char *requested_file;
  char *root_requested_file;
  char *method = (char*)malloc(sizeof(char)*100);
  char uri[100], version[100];

  memset(client_buf,0,4096);
  memset(path,0,4096);
  memset(filename,0,4096);
  memset(method,0,100);
  memset(uri,0,100);
  memset(version,0,100);

  while(1){
    file_offset += recv(client_fd,&client_buf[file_offset],4096,0);
    if(strstr(client_buf,"\r\n\r\n"))
      break;
  }

  // get method, uri, and http version
  sscanf(client_buf, "%s %s %s", method, uri, version);

  // Check that the correct method has been used. I.E. GET
  if (!method_supported(method)){
    send_501(client_fd);
    command_line_parsing(STATUS_501, method, uri);
    return;
  }

  // Continue to read file
  requested_file = parseRequest(client_buf);

  // ingnore slash
  requested_file = &requested_file[1];

  // add ROOT directory to requested file
  root_requested_file = (char*)malloc(sizeof(char)*(strlen(requested_file)+strlen(ROOT)));
  sprintf(root_requested_file, "%s%s", ROOT, requested_file);
  requested_file = &root_requested_file[0];

  // take requested_file, add a . to beginning, open that file
  path[0] = '.';
  path[1] = '/';
  strncpy(&path[2],requested_file,4094);


  // Check that the requested path exists I.E. localhost:port/WHOOPS.html
  if((read_fd = open(path,0,0)) <= 0){ 
    // path is invalid, 404 status code
    send_404(client_fd, requested_file);
    command_line_parsing(STATUS_404, method, uri);
    return;
  }

  // Path is valid
  else {
    if(is_directory(path)){
      // check for index.html in directory
      // assuming '/' at end of request

      sprintf(filename, "%sindex.html", path); // add index to test for it in the directory
      // check if directory contains index.html
      if((read_fd = open(filename, 0,0)) <= 0){
        // directory does not contain index.html
        // we must build the directory from the current path
        send_dir_list(client_fd, path);
        command_line_parsing(STATUS_200, method, uri);
        return;
      }
      else { // directory does contain index.html
        send_file(client_fd, read_fd, filename);
        command_line_parsing(STATUS_200, method, uri);
      }
    }
    else if(is_file(path)) {
      send_file(client_fd, read_fd, path);
      command_line_parsing(STATUS_200, method, uri);
    }
    else {
      printf("Unknown path type\n");
    }
  }

  close(read_fd);
  close(client_fd);
  return;
}

/* Your program should take two arguments:
 * 1) The port number on which to bind and listen for connections, and
 * 2) The directory out of which to serve files.
 */
int main(int argc, char** argv) {
  /* For checking return values. */
  int retval;

  /* Read the port number from the first command line argument. */
  int port = atoi(argv[1]);
  strncpy(&ROOT[0], argv[2], strlen(argv[2]));

  /* Create a socket to which clients will connect. */
  int server_sock = socket(AF_INET6, SOCK_STREAM, 0);
  if(server_sock < 0) {
    perror("Creating socket failed");
    exit(1);
  }

  /* A server socket is bound to a port, which it will listen on for incoming
   * connections.  By default, when a bound socket is closed, the OS waits a
   * couple of minutes before allowing the port to be re-used.  This is
   * inconvenient when you're developing an application, since it means that
   * you have to wait a minute or two after you run to try things again, so
   * we can disable the wait time by setting a socket option called
   * SO_REUSEADDR, which tells the OS that we want to be able to immediately
   * re-bind to that same port. See the socket(7) man page ("man 7 socket")
   * and setsockopt(2) pages for more details about socket options. */
  int reuse_true = 1;
  retval = setsockopt(server_sock, SOL_SOCKET, SO_REUSEADDR, &reuse_true,
      sizeof(reuse_true));
  if (retval < 0) {
    perror("Setting socket option failed");
    exit(1);
  }

  /* Create an address structure.  This is very similar to what we saw on the
   * client side, only this time, we're not telling the OS where to connect,
   * we're telling it to bind to a particular address and port to receive
   * incoming connections.  Like the client side, we must use htons() to put
   * the port number in network byte order.  When specifying the IP address,
   * we use a special constant, INADDR_ANY, which tells the OS to bind to all
   * of the system's addresses.  If your machine has multiple network
   * interfaces, and you only wanted to accept connections from one of them,
   * you could supply the address of the interface you wanted to use here. */


  struct sockaddr_in6 addr;   // internet socket address data structure
  addr.sin6_family = AF_INET6;
  addr.sin6_port = htons(port); // byte order is significant
  addr.sin6_addr = in6addr_any; // listen to all interfaces


  /* As its name implies, this system call asks the OS to bind the socket to
   * address and port specified above. */
  retval = bind(server_sock, (struct sockaddr*)&addr, sizeof(addr));
  if(retval < 0) {
    perror("Error binding to port");
    exit(1);
  }

  /* Now that we've bound to an address and port, we tell the OS that we're
   * ready to start listening for client connections.  This effectively
   * activates the server socket.  BACKLOG (#defined above) tells the OS how
   * much space to reserve for incoming connections that have not yet been
   * accepted. */
  retval = listen(server_sock, BACKLOG);
  if(retval < 0) {
    perror("Error listening for connections");
    exit(1);
  }

  // register signal handler
  signal(SIGCHLD, sigchld_handler);


  while(1) {
    /* Declare a socket for the client connection. */
    int sock;
    //char buffer[256];

    /* Another address structure.  This time, the system will automatically
     * fill it in, when we accept a connection, to tell us where the
     * connection came from. */
    struct sockaddr_in remote_addr;
    unsigned int socklen = sizeof(remote_addr); 

    /* Accept the first waiting connection from the server socket and
     * populate the address information.  The result (sock) is a socket
     * descriptor for the conversation with the newly connected client.  If
     * there are no pending connections in the back log, this function will
     * block indefinitely while waiting for a client connection to be made.
     * */
    sock = accept(server_sock, (struct sockaddr*) &remote_addr, &socklen);
    if(sock < 0) {
      perror("Error accepting connection");
      exit(1);
    }

    if (fork() == 0){
      close(server_sock);
      serve_request(sock);
      close(sock);
      exit(0);
    }

    /* At this point, you have a connected socket (named sock) that you can
     * use to send() and recv(). */

    /* ALWAYS check the return value of send().  Also, don't hardcode
     * values.  This is just an example.  Do as I say, not as I do, etc. */
    //serve_request(sock);

    /* Tell the OS to clean up the resources associated with that client
     * connection, now that we're done with it. */
    close(sock);
  }

  close(server_sock);
}
