// Programmer:  Bradley Golden
// Assignment:  Lab 7
// Date:        September 29, 2015
// Description: A simple class that models a three dimensional shape and 
//              inherits attributes from the Shape class
public class ThreeDimensionalShape extends Shape
{
    // coordinates for the center of a 3d shape
    protected double xCenter; // x coordinate center
    protected double yCenter; // y coordinate center
    protected double zCenter; // z coordinate center

    public ThreeDimensionalShape(String name, double x, double y, double z)
    // PRE: name, x, y, and z are initialized
    // POST: An instance of the ThreeDimensionalShape has been created. It is
    //       located at (x, y, z) and named name
    {
        super(); // call Shape class default constructor 
        super.SetName(name); // set the name of the shape
        this.xCenter = x; // set x center of shape
        this.yCenter = y; // set y center of shape
        this.zCenter = z; // set z center of shape
    }

    public String toString()
    // POST: A printed string containing information about the current shape including:
    //       * name
    //       * x, y, and z center coordinates
    {
        return (this.name + " is located at (" + this.xCenter + ", " 
                + this.yCenter + ", " + this.zCenter + ")"); // print out shape attributes
    }
}
