// Programmer:  Bradley Golden
// Program:     Lab 4, using a method to draw any face of a six sided die.
// Date:        9/20/2015
// Description: This program implements a method to draw a face of a
//              square six-sided die

import java.awt.*;
import java.applet.*;
import javax.swing.*;
import java.applet.*;

public class Lab4 extends JApplet
{
    @Override
    public void init()
    {
      // Nothing to initialize
    } // end init

    @Override
    public void paint(Graphics g)
    {
        super.paint(g); // Draw in the gui

        this.drawDie(10, 10, 100, Color.WHITE, 1, g); // Draw side 1 on the die
        this.drawDie(10, 120, 100, Color.BLUE, 2, g); // Draw side 2 on the die
        this.drawDie(10, 230, 100, Color.RED, 3, g); // Draw side 3 on the die
        this.drawDie(120, 10, 100, Color.GREEN, 4, g); // Draw side 4 on the die
        this.drawDie(120, 120, 100, Color.PINK, 5, g); // Draw side 5 on the die
        this.drawDie(120, 230, 100, Color.YELLOW, 6, g); // Draw side 6 on the die

    } // end paint

    public void drawDie(int xCoord, int yCoord, int length, Color color, int side, Graphics g)
    {
        //PRE: xCoord - Integer value >= 0 and <= applet width
        //     yCoord - Integet value >= 0 and <= applet height
        //     length - Integer value >= 0 and <= both the applet height
        //              and applet width
        //     color - object preset to a valid color value.
        //             i.e. Color.WHITE or Color.RED
        //     side - Integer value >= 1 and <= 6
        //POST: A die of size length drawn with one to six dots at coordinates x, y
        //      of a predefined color

        int dotDiameter = (int)((double)length*0.15); // Set circle height to 15% of length
        int padding = (int)((double)length*0.15); // Set padding to be 15% of the length of the die

        // Center coordinates of die
        int xCenter = xCoord + length/2; // Center x coord for die
        int yCenter = yCoord + length/2; // Center y coord for die

        // Coordinates to center dots in middle of the die
        int dotXCenter = xCenter - dotDiameter/2;
        int dotYCenter = yCenter - dotDiameter/2;

        // Coordinates to place dot in the top left of the die
        // with padding
        int dotXTopLeft = xCoord + padding;
        int dotYTopLeft = yCoord + padding;

        // Coorinates to place dot in the bottom right of the die
        // with padding
        int dotXBottomRight = xCoord + length - dotDiameter - padding;
        int dotYBottomRight = yCoord + length - dotDiameter - padding;

        // Coordinates to place dot in the bottom left of the die with padding
        int dotXBottomLeft = xCoord + padding;
        int dotYBottomLeft = yCoord + length - dotDiameter - padding;

        // Coordinate to place dot in top right of the die with padding
        int dotXTopRight = xCoord + length - dotDiameter - padding;
        int dotYTopRight = yCoord + padding;

        // Coordinates to place the dot in the left middle of the die
        int dotXLeft = xCoord + padding;
        int dotYLeft = yCoord + length/2 - dotDiameter/2;

        //Coordinates to place the dot in the right middle of the die
        int dotXRight = xCoord + length - dotDiameter - padding;
        int dotYRight = yCoord + length/2 - dotDiameter/2;

        g.setColor(color); // Set the color of the die to color
        g.fillRect(xCoord, yCoord, length, length); // Draw a filled rectangle

        g.setColor(Color.BLACK); // Set the of all dots to be drawn to black

        switch (side){ // Select one of six sides to draw on the die
            case 1: // Draw one side on die
                // Draw center dot
                g.fillOval(dotXCenter, dotYCenter, dotDiameter, dotDiameter);
                break;
            case 2: // Draw a two on the die
                // Draw top left dot
                g.fillOval(dotXTopLeft, dotYTopLeft, dotDiameter, dotDiameter);
                // Draw bottom right dot
                g.fillOval(dotXBottomRight, dotYBottomRight, dotDiameter, dotDiameter);
                break;
            case 3: // Draw a three on the die
                // Draw center dot
                g.fillOval(dotXCenter, dotYCenter, dotDiameter, dotDiameter);
                // Draw top let dot
                g.fillOval(dotXTopLeft, dotYTopLeft, dotDiameter, dotDiameter);
                // Draw bottom right dot
                g.fillOval(dotXBottomRight, dotYBottomRight, dotDiameter, dotDiameter);
                break;
            case 4: // Draw a four on the die
                // Draw top left dot
                g.fillOval(dotXTopLeft, dotYTopLeft, dotDiameter, dotDiameter);
                // Draw bottom right dot
                g.fillOval(dotXBottomRight, dotYBottomRight, dotDiameter, dotDiameter);
                //Draw bottom left dot
                g.fillOval(dotXBottomLeft, dotYBottomLeft, dotDiameter, dotDiameter);
                // Draw top right dot
                g.fillOval(dotXTopRight, dotYTopRight, dotDiameter, dotDiameter);
                break;
            case 5: // Draw a five on the die
                // Draw center dot
                g.fillOval(dotXCenter, dotYCenter, dotDiameter, dotDiameter);
                // Draw top left dot
                g.fillOval(dotXTopLeft, dotYTopLeft, dotDiameter, dotDiameter);
                // Draw bottom right dot
                g.fillOval(dotXBottomRight, dotYBottomRight, dotDiameter, dotDiameter);
                // Draw bottom left dot
                g.fillOval(dotXBottomLeft, dotYBottomLeft, dotDiameter, dotDiameter);
                // Draw top right dot
                g.fillOval(dotXTopRight, dotYTopRight, dotDiameter, dotDiameter);
                break;
            case 6: // Draw a six on the die
                // Draw top left dot
                g.fillOval(dotXTopLeft, dotYTopLeft, dotDiameter, dotDiameter);
                // Draw bototm right dot
                g.fillOval(dotXBottomRight, dotYBottomRight, dotDiameter, dotDiameter);
                // Draw bottom left dot
                g.fillOval(dotXBottomLeft, dotYBottomLeft, dotDiameter, dotDiameter);
                // Draw top right dot
                g.fillOval(dotXTopRight, dotYTopRight, dotDiameter, dotDiameter);
                // Draw left dot
                g.fillOval(dotXLeft, dotYLeft, dotDiameter, dotDiameter);
                // Draw right dot
                g.fillOval(dotXRight, dotYRight, dotDiameter, dotDiameter);
                break;
        } // end switch to draw sides on the die
    } // end drawDie
}  // end Lab4 class
