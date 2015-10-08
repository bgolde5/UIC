// Programmer:  Bradley Golden
// Assignment:  Lab 7
// Date:        September 29, 2015
// Description: A simple sphere class that models a 3D sphere. 

public class Sphere extends ThreeDimensionalShape
{
    protected double radius; // the radius of the sphere

    public Sphere(String name, double x, double y, double z, double radius)
    // PRE: name, x, y, z, and radius are initalized. radius >= 0
    // POST: An instance of a sphere has been created with name name at (x, y, z) with
    //       radius radius
    {
        super(name, x, y, z); // initialize parameters in the super class
        this.radius = radius; // set the radius of the sphere
    }

    public String toString()
    // POST: FCTVAL == String representation of Sphere object
    {
        return (this.name + " is located at (" + this.xCenter + ", "
                + this.yCenter + ", " + this.zCenter + ") with a radius of "
                + this.radius); // string representation of Sphere
    }
}
