// Programmer:  Bradley Golden
// Assignment:  Lab 7
// Date:        September 29, 2015
// Description: A simple cube class that models a 3D cube. 

public class Cube extends ThreeDimensionalShape
{
    protected double length; // the length of the cubes sides

    public Cube(String name, double x, double y, double z, double length)
    // PRE: name, x, y, z, and radius are initalized. length >= 0
    // POST: An instance of a cube has been created with name name at (x, y, z) with
    //       length length
    {
        super(name, x, y, z); // initialize parameters in the super class
        this.length = length; // set the length of the cube
    }

    public String toString()
    // POST: FCTVAL == String representation of Cubde object
    {
        return (this.name + " is located at (" + this.xCenter + ", "
                + this.yCenter + ", " + this.zCenter + ") with a length of "
                + this.length); // string representation of Sphere
    }
}
