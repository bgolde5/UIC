#include "waiting_system.h"


void doAdd(node *head)
{
 /* get group size from input */
 int size = getPosInt();
 if (size < 1)
   {
    printf ("Error: Add command requires an integer value of at least 1\n");
    printf ("Add command is of form: a <size> <name>\n");
    printf ("  where: <size> is the size of the group making the reservation\n");
    printf ("         <name> is the name of the group making the reservation\n");
    return;
   }

 /* get group name from input */
 char *name = getName();

 if (NULL == name)
 {
   printf ("Error: Add command requires a name to be given\n");
   printf ("Add command is of form: a <size> <name>\n");
   printf ("  where: <size> is the size of the group making the reservation\n");
   printf ("         <name> is the name of the group making the reservation\n");
   return;
 }

 printf ("Adding group \"%s\" of size %d\n", name, size);

 while(doesNameExist(head->next, name)){ //check if name exists on the list
   printf("Name is already in the system, please enter a different name: ");
   name = getName();
 }


 //add group to end of waitlist
 node *newGroup = addToList(head, name, size);
 //change status to in restaurant
 newGroup->status = arrive_at_restaurant;

}//end doAdd


void doCallAhead (node *head)
{
  /* get group size from input */
  int size = getPosInt();
  if (size < 1)
  {
    printf ("Error: Call-ahead command requires an integer value of at least 1\n");
    printf ("Call-ahead command is of form: c <size> <name>\n");
    printf ("  where: <size> is the size of the group making the reservation\n");
    printf ("         <name> is the name of the group making the reservation\n");
    return;
  }

  /* get group name from input */
  char *name = getName();
  if (NULL == name)
  {
    printf ("Error: Call-ahead command requires a name to be given\n");
    printf ("Call-ahead command is of form: c <size> <name>\n");
    printf ("  where: <size> is the size of the group making the reservation\n");
    printf ("         <name> is the name of the group making the reservation\n");
    return;
  }

  printf ("Call-ahead group \"%s\" of size %d\n", name, size);

  while(doesNameExist(head->next, name)){ //check if name exists on the list
    printf("Name is already in the system, please enter a different name: ");
    name = getName();
  }

  //add group to end of waitlist
  node *newGroup = addToList(head, name, size);
  //change status to call ahead
  newGroup->status = call_ahead;
}

void doWaiting (node *head)
{
  /* get group name from input */
  char *name = getName();

  if (NULL == name)
  {
    printf ("Error: Waiting command requires a name to be given\n");
    printf ("Waiting command is of form: w <name>\n");
    printf ("  where: <name> is the name of the group that is now waiting\n");
    return;
  }

  printf ("Waiting group \"%s\" is now in the restaurant\n", name);

  if(doesNameExist(head, name)){
    updateStatus(head, name);
  }
  else
    printf("%s could not be found in the system. Please check that you typed the name correctly.\n", name);
}

void doRetrieve (node *head)
{
  /* get table size from input */
  int size = getPosInt();
  if (size < 1)
  {
    printf ("Error: Retrieve command requires an integer value of at least 1\n");
    printf ("Retrieve command is of form: r <size>\n");
    printf ("  where: <size> is the size of the group making the reservation\n");
    return;
  }
  clearToEoln();
  printf ("Retrieve (and remove) the first group that can fit at a tabel of size %d\n", size);

  retrieveAndRemove(head, size);
}

void doList (node *head)
{
  /* get group name from input */
  char *name = getName();
  if (NULL == name)
  {
    printf ("Error: List command requires a name to be given\n");
    printf ("List command is of form: l <name>\n");
    printf ("  where: <name> is the name of the group to inquire about\n");
    return;
  }

  printf ("Group \"%s\" is behind the following groups\n", name);

  if(doesNameExist(head, name)){
    printf("There are %i groups ahead of %s\n", countGroupsAhead(head, name), name);
    displayGroupSizeAhead(head->next, name);
  }
  else
    printf("%s is not on the list\n", name);
}

void doDisplay (node *head)
{
  clearToEoln();
  printf ("Display information about all groups\n");

  displayListInformation(head);

}
