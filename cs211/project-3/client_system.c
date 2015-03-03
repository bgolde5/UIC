#include "waiting_system.h"

node *addToList(node *head, char *name, int size){

  node *tmp = head;

  node *newGroup = (node*)malloc(sizeof(node));
  strcpy(newGroup->name, name);
  newGroup->size = size;
  newGroup->next= NULL;

  while(tmp->next != NULL){
    if(debugMode == 1){
      printf("group name: %s, pary size: %i, status: ", tmp->name, tmp->size); 
      (tmp->status == 0) ? printf("called in\n") : printf("waiting in restaurant\n");
    }

    tmp = tmp->next;
  }
  newGroup->next = tmp->next;
  tmp->next = newGroup;

  return newGroup;
} //end addToList

int doesNameExist(node *head, char *name){
  node *tmp = head;

  while(tmp != NULL){
    if(strcmp(tmp->name, name) == 0){
      return 1; //name does exist
    } 
    tmp = tmp->next;
  }
  return 0; //name doesn't exist
}//end doesNameExist

int updateStatus(node *head, char *name){
  node *tmp = head;
  while(tmp->next != NULL && strcmp(tmp->name, name) != 0){
    if(debugMode == 1){
      printf("group name: %s, pary size: %i, status: ", tmp->name, tmp->size); 
      (tmp->status == 0) ? printf("called in\n") : printf("waiting in restaurant\n");
    }
    tmp = tmp->next;
  }
  if(tmp->status == arrive_at_restaurant)
    return 0; //already arrived at the restaurant, return FALSE
  else{
    tmp->status = arrive_at_restaurant;
    return 1;
  }
}//end updateStatus

void retrieveAndRemove(node *head, int size){
  node *curr = head;
  node *prev = NULL;
  while(curr->next != NULL && curr->size != size){
    prev = curr;
    curr = curr ->next;
    if(debugMode == 1){
      printf("group name: %s, pary size: %i, status: ", curr->name, curr->size); 
      (curr->status == 0) ? printf("called in\n") : printf("waiting in restaurant\n");
    }
  }
  if(curr->status != call_ahead){
    prev->next = curr->next;
    free(curr);
  }
}

int countGroupsAhead(node *head, char *name){
  node *tmp = head;
  int count = 0;

  while(tmp->next != NULL && strcmp(tmp->name, name) != 0){
    count++;
    if(debugMode == 1){
      printf("group name: %s, pary size: %i, status: ", tmp->name, tmp->size); 
      (tmp->status == 0) ? printf("called in\n") : printf("waiting in restaurant\n");
    }

    tmp = tmp->next;
  }
  count--; //subract the dummy node

  return count;
}//end countGroupsAhead

void displayGroupSizeAhead(node *head, char *name){
  node *tmp = head;
  int count = 0;

  while(tmp->next != NULL && strcmp(tmp->name, name) != 0){
    if(debugMode == 1){
      printf("group name: %s, pary size: %i, status: ", tmp->name, tmp->size); 
      (tmp->status == 0) ? printf("called in\n") : printf("waiting in restaurant\n");
    }

    printf("%s, party of %i\n", tmp->name, tmp->size);
    tmp = tmp->next;
  }
}//end displayGroupSizeAhead

void displayListInformation(node *head){
  node *tmp = head;
  int i = 0;
  while(tmp != NULL){
    printf("Group %i: %s, party of %i ", i, tmp->name, tmp->size);
    if(tmp->status == 0){
      printf("called ahead and has not arrived yet.\n");
    }
    else
      printf("has arrived and is waiting in the restaurant.\n");
    i++;
    tmp = tmp->next;
    if(debugMode == 1){
      printf("group name: %s, pary size: %i, status: ", tmp->name, tmp->size); 
      (tmp->status == 0) ? printf("called in\n") : printf("waiting in restaurant\n");
    }
  }
}//end displayListInformation
