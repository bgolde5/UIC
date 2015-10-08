// Programmer:  Bradley Golden
// Assignment:  Lab 7
// Date:        September 29, 2015
// Description: A simple test driver for testing the Shape, ThreeDimensionlShape, Sphere, and
//              Cube classes

public class ShapeTest
{
    public static void main(String[] args)
    {
        int n = 4; // the number of shapes to create
        Shape[] shapeArr = new Shape[n]; // create an array of 4 shapes
        shapeArr[0] = new Shape();
        shapeArr[1] = new ThreeDimensionalShape("3D shape", 1, 2, 3);
        shapeArr[2] = new Cube("cube", 4, 5, 6, 10);
        shapeArr[3] = new Sphere("sphere", 100, 200, 300, 5);

        for (int i=0; i<n; i++){
            System.out.println("A " + shapeArr[i].toString()); 
        }
    }
}
