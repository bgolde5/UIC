import random
import sys

def generate_pins(n):
    l = []
    for i in range(0,n):
         l.append(random.randrange(1,100) + 0.0)
    return l

def pins_list(l):
    line = str(len(l)) + "\n"
    for i in range(0, len(l)):
        line = line + str(l[i])
        if i != len(l)-1:
           line = line + "\n" 
            
    return line

def main():
    args =  sys.argv

    filename = args[1]
    n = int(args[2])
    l1 =  generate_pins(n)

    f = open(filename, 'w')
    f.write(pins_list(l1))

if __name__ == "__main__":
    main()
