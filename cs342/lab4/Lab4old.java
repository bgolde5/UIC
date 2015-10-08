// Programmer:  Bradley Golden
// Program:     Lab 4, using a method to draw any face of a six sided die. 
// Date:        9/20/2015
// Description: This program implements a method to draw any face of a square six-sided die to a 
//              Graphics context with configurable color.

import java.awt.event.*;
import java.awt.*;
import java.applet.*;
import javax.swing.*;
import java.applet.*;

public class Lab4 extends JApplet implements ActionListener
{
    private int appletWidth;                    // Width of the applet
    private int appletHeight;                   // Height of the applet
    private int xCenter;                        // X center coordinate in die
    private int yCenter;                        // Y center coordinate in die
    private int dieHeight;                      // Height of the die
    private int dieWidth;                       // Width of the die
    private int dieLength;                      // Length of the die
    private int dieXCoord;                      // X coordinate to draw die in applet
    private int dieYCoord;                      // Y Coordinate to draw die in applet
    private int sideXCoord;                     // X coorinate of die side in applet
    private int sideYCoord;                     // Y coordinate of die side in applet
    private int circleHeight;                   // Height of a cirlce in the die
    private int circleWidth;                    // Width of a circle in the die
    private int padding;                        // Properly aligns circles in the die with spacing

    /* 
     * Gui variables
     */
    private JLabel descriptionLabel;            // Label to summarize the program function
    private JLabel promptXCoord;                // Prompt for left x coordinate of die
    private JLabel promptYCoord;                // Prompt for top y coordinate of die
    private JLabel promptLength;                // Prompt for length of die
    private JLabel promptColor;                 // Prompt for the color of the die background
    private JTextField inDieXCoord;             // Field to input left x coordinate of die
    private JTextField inDieYCoord;             // Field to input top y coordinate of die
    private JTextField inDieLength;             // Field to input length of die
    private Color color;                        // Color object for die color
    private JButton colorChooserButton;         // Button to select color of die
    private JButton drawButton;                 // Button to draw the die

    @Override
    public void init()
    {
        this.setLayout(new GridLayout(12,1));    // Divide windows into 12 rows with 1 column
        FlowLayout appletLayout = new FlowLayout(); // Create layout for gui

        appletWidth = getWidth();               // Get applet window width
        appletHeight = getHeight();             // Get applet window height

        xCenter = appletWidth/2;                 // Center xCoord to center of applet window
        yCenter = appletHeight/2;                // Center yCoord to center of applet window

        dieWidth = 100;                         // Set die width to 300
        dieHeight = 100;                        // Set die height to 300
        dieLength = 100;                        // Set die length to 300

        // Place die x and y coordinates to top left corner 
        dieXCoord = xCenter - dieWidth/2;
        dieYCoord = yCenter - dieHeight/2;

        // Place side of die x and y coordinate to center
        // This will be modified later on as the side of the face is selected
        sideXCoord = xCenter;
        sideYCoord = yCenter;

        circleWidth = 30;                       // Set circle width
        circleHeight = 30;                      // Set circle height

        padding = 40;                           // Set circle padding

        color = Color.WHITE;                    // Set color of die to white

        // Initialize gui
        descriptionLabel = new JLabel("This is a program that randomly draws one side of a six "
                + "sided die.");                // Create the program description label
        promptXCoord = new JLabel("X coordinate:"); // Set up prompt
        promptYCoord = new JLabel("Y coordinate:"); // Set up prompt
        promptLength = new JLabel("Die length:");   // Set up prompt
        inDieXCoord = new JTextField(5);            // Set up input
        inDieYCoord = new JTextField(5);            // Set up input
        inDieLength = new JTextField(5);            // Set up input
        colorChooserButton = new JButton("Pick a color"); // Create a new button to pick a color
        drawButton = new JButton("Draw it!");   // Create new Draw It! button

        colorChooserButton.addActionListener(this); // Register button with event handler
        drawButton.addActionListener(this);     // Register button with event handler

        // Create panels for rows
        JPanel row1 = new JPanel();             // Row 1 panel
        JPanel row2 = new JPanel();             // Row 2 panel
        JPanel row3 = new JPanel();             // Row 3 panel

        // Set panels to flowlayout
        row1.setLayout(appletLayout);           // Set row 1 layout to new flowlayout
        row2.setLayout(appletLayout);           // Set row 2 layout to new flowlayout
        row3.setLayout(appletLayout);           // Set row 3 layout to new flowlayout

        // Add elements to row 1
        row1.add(descriptionLabel);             // Add program description label to row 1 panel

        // Add elements to row 2 
        row2.add(promptXCoord);                 // Add prompt to gui
        row2.add(inDieXCoord);                  // Add input to gui
        row2.add(promptYCoord);                 // Add prompt to gui
        row2.add(inDieYCoord);                  // Add input to gui
        row2.add(promptLength);                 // Add prompt to gui
        row2.add(inDieLength);                  // Add input to gui

        // Add elements to row 3
        row3.add(colorChooserButton);           // Add button to gui
        row3.add(drawButton);                   // Add Draw It! button to gui

        add(row1);                              // Add row 1 to gui
        add(row2);                              // Add row 2 to gui
        add(row3);                              // Add row 3 to gui
    } // end init

    @Override
    public void paint(Graphics g)
    {
        super.paint(g);

        this.drawDie(dieXCoord, dieYCoord, dieLength, color, g); // Draw face of six sided 
                                                                 // die in the gui
    } // end paint

    public void drawDie(int x, int y, int length, Color c, Graphics die) // Draws any face of a 
                                                                         // square six-sided die
                                                                         // in color
    {
        //PRE: Arguments: 
        //     x, y:   Integers that map to the top left coordinates of the die side
        //     length: Integer value that is the length of the die sides in pixels
        //     c: Color object preset to a valid color value. i.e. Color.WHITE or Color.RED
        //     die: Graphics object used for drawing the die
        //POST: A die drawn at coordinates x, y with sides equal to length, color set to c,
        //      and random face value between 1 and 6 dots (filled circles).

        // Reset top left x and y coordinates of die
        dieXCoord = x;
        dieYCoord = y;

        // Reset die height and width to the given parameter, length
        dieWidth = length;
        dieHeight = length;

        color = c; // Set color of the die

        circleWidth = (int)((double)length*0.10); // Set circle width to 10% of length
        circleHeight = (int)((double)length*0.10); // Set circle height to 10% of length
        padding = (int)((double)length*0.10); // Set padding to be 10% of the length of the die

        // Reset center to new center of die given new top left coordinates x and y
        xCenter = x + dieHeight/2;
        yCenter = y + dieWidth/2;

        die.setColor(color); // Set the color of the die to color
        die.fillRect(dieXCoord, dieYCoord, dieWidth, dieHeight); // Draw a filled rectangle

        this.drawSide(die); // Draw the side of the die
    }

    public void drawSide(Graphics side) // Draw a side on a die
    {
        //POST: A random side drawn on the face of the die between 1 and 6
        int random; // Used for random values between 1 and 6

        side.setColor(Color.BLACK);  // Set color of die side to black

        random = (int)(Math.random() * 6 + 1); // Random pick a number between 1 and 6

        switch (random){ // Use the previous random number to randomly draw a side of the die
            case 1:
                this.drawOne(side); // Draw the one side on the die
                break;
            case 2:
                this.drawTwo(side); // Draw the two side on the die
                break;
            case 3:
                this.drawThree(side); // Draw the three side on the die
                break;
            case 4:
                this.drawFour(side); // Draw the four side on the die
                break;
            case 5:
                this.drawFive(side); // Draw the five side on the die
                break;
            case 6:
                this.drawSix(side); // Draw the six side on the die
                break;
        }
    } // end drawSide

    public void drawOne(Graphics one) // Draw the one on the side of the die
    {
        // POST: A one drawn on the side of the die
        drawCircleCenter(one); // Draw circle in center of the die
    } // end drawOne

    public void drawTwo(Graphics two) // Draw a two on the side of the die consisting of two circles
    {
        // POST: A two drawn on the side of the die
        drawCircleTopLeft(two); // Draw circle top left of die
        drawCircleBottomRight(two); // Draw circle bottom left of die
    } // drawTwo

    public void drawThree(Graphics three) // Draw a three on the side of the die
    {
        // POST: A three drawn on the side of the die
        drawCircleTopLeft(three);  // Draw circle top left of the die
        drawCircleBottomRight(three); // Draw circle bottom right of the die
        drawCircleCenter(three); // Draw circle in center of the die
    } // end drawThree

    public void drawFour(Graphics four) // Draw a four on the side of the die
    {
        // POST: A four drawn on the side of the die
        drawCircleTopLeft(four); // Draw cirlce top left of die
        drawCircleBottomLeft(four); // Draw circle bottom left of die
        drawCircleBottomRight(four); // Draw ciricle bottom right of die
        drawCircleTopRight(four); // Draw circle top right of die
    } // end drawFour

    public void drawFive(Graphics five) // Draw a five on the side of the die
    {
        // POST: A five drawn on the side of the die
        drawCircleCenter(five); // Draw circle in the center of the die
        drawCircleTopLeft(five); // Draw circle in the top left of die
        drawCircleBottomLeft(five); // Draw circle in the bottom left of die
        drawCircleTopRight(five); // Draw circle in the top right of die
        drawCircleBottomRight(five); // Draw circle in bottom right of die
    } // end drawFive

    public void drawSix(Graphics six) // Draw a six on the side of the die
    {
        //POST: A six drawn on the side of the die
        drawCircleTopLeft(six); // Draw circle top left of die
        drawCircleBottomLeft(six); // Draw circle bottom left of die
        drawCircleTopRight(six); // Draw circle top right of die
        drawCircleBottomRight(six); // Draw circle bottom right of die

        // Draw circle between top left and bottom left circle
        sideXCoord = xCenter; // Center the circle in die x axis
        sideYCoord = yCenter - circleHeight/2; // Center the circle in die y axis
        sideXCoord = sideXCoord - dieWidth/2; // Move circle to the left side
        sideXCoord = sideXCoord + padding; // Give the circle some padding

        six.fillOval(sideXCoord, sideYCoord, circleHeight, circleWidth); // Draw the circle

        // Draw circle between top right and bottom right circle
        sideXCoord = xCenter; // Center the circle in die x axis
        sideYCoord = yCenter - circleHeight/2; // Center the circle in die y axis
        sideXCoord = sideXCoord + dieWidth/2 - circleWidth; // Move circle to the right side
        sideXCoord = sideXCoord - padding; // Give the circle some padding

        six.fillOval(sideXCoord, sideYCoord, circleHeight, circleWidth); // Draw the circle
    }

    public void drawCircleTopLeft(Graphics g) // Draw a cirlce in the top left of the die
    {
        // POST: A cirlce drawn in the top left of the die
        // Set x and y coordinate for first circle to top left
        sideXCoord = dieXCoord + padding;
        sideYCoord = dieYCoord + padding;

        g.fillOval(sideXCoord, sideYCoord, circleHeight, circleWidth); // draw circle one
    } // end drawCircleTopLeft

    public void drawCircleBottomRight(Graphics g) // Draw a circle in the bottom right of the die
    {
        // POST: A circle drawn in the botton right of the die
        // Set x and y coordinate for second circle to bottom right of die
        sideXCoord = dieXCoord + dieWidth;
        sideYCoord = dieYCoord + dieHeight;

        // Place circle inside the bottom right of the die
        sideXCoord = sideXCoord - circleWidth;
        sideYCoord = sideYCoord - circleHeight;

        // Give the circle padding from the botton right
        sideXCoord = sideXCoord - padding;
        sideYCoord = sideYCoord - padding;

        g.fillOval(sideXCoord, sideYCoord, circleHeight, circleWidth); // Draw the second circle
    } // end drawCircleBottomRight

    public void drawCircleCenter(Graphics g) // Draw a circle in the center of the die
    {
        // POST: A circle drawn in the center of the die
        // Center one side to center of the die
        sideXCoord = xCenter - circleWidth/2;
        sideYCoord = yCenter - circleHeight/2;

        g.fillOval(sideXCoord, sideYCoord, circleHeight, circleWidth); // Draw one side on die
    } // end drawCircleCenter

    public void drawCircleBottomLeft(Graphics g) // Draw a cirlce in the bottom left of the die
    {
        // POST: A circle drawn in the botton left of the die
        // Place x and y coord to bottom left of the die
        sideXCoord = dieXCoord;
        sideYCoord = dieYCoord + dieHeight;

        // Place circle inside the die 
        sideYCoord = sideYCoord - circleHeight;

        // Give the circle some padding
        sideXCoord = sideXCoord + padding;
        sideYCoord = sideYCoord - padding;

        g.fillOval(sideXCoord, sideYCoord, circleHeight, circleWidth); // Draw the circle
    } // end drawCircleBottomLeft

    public void drawCircleTopRight(Graphics g) // Draw a circle in the top right of the die
    {
        // POST: A circle drawn in the top right of the die
        // Place x and y coord to top left of the die
        sideXCoord = dieXCoord + dieHeight;
        sideYCoord = dieYCoord;

        // Place circle inside the die
        sideXCoord = sideXCoord - circleWidth;

        // Give the circle some padding
        sideXCoord = sideXCoord - padding;
        sideYCoord = sideYCoord + padding;

        g.fillOval(sideXCoord, sideYCoord, circleHeight, circleWidth);
    } // end drawCircleTopRight

    public void actionPerformed(ActionEvent e)
    {
        if(e.getSource() == drawButton)   // Listen for drawButton to be clicked
        {
            dieXCoord = Integer.parseInt(inDieXCoord.getText()); // Set die x coordinate to 
                                                                 // value in input field
            dieYCoord = Integer.parseInt(inDieXCoord.getText()); //Set die y coordinate to
                                                                 // value in input field
            dieLength = Integer.parseInt(inDieLength.getText()); // Set die length to value in
                                                                 // input field
        }
        if(e.getSource() == colorChooserButton) // Listen for colorChooserButton to be clicked
        {
            color = JColorChooser.showDialog(this, "Choose a color", color); // Display color chooser
        }

        repaint(); // Redraw items on the screen
    } // end actionPerformed
} // end Lab4 class
