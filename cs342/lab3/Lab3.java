// Programmer:  Bradley Golden
// Assignment:  Lab 3
// Date:        September 9, 2015
// Description: A basic applet with the ability to display a rectangle or message

import java.awt.FlowLayout;
import java.awt.Graphics;
import java.awt.event.*;
import javax.swing.*;
import java.applet.*;
import javax.swing.JOptionPane;
import javax.swing.JFrame;

public class Lab3 extends JApplet implements ActionListener
{

    private static final String[] CHOICES = {" ", "Center", "Random"}; // User choices in combobox

    private JFrame parent;                      // Used for pop up windows
    private int appletWidth;                    // Width of the applet
    private int appletHeight;                   // Height of the applet
    private int xCoord;                         // X coordinate location to draw in applet
    private int yCoord;                         // Y coordinate location to draw in applet
    private int borderHeight;                   // Border of the square to be drawn
    private int borderWidth;                    // Border width of the square to be drawn
    private int panelPadding;                   // Gives padding so drawings don't overlap the panel

    /*
     * GUI Front End Variables
     */
    // Row 1 contents
    private JRadioButton drawSquareButton;      // Radio choice for drawing square
    private JRadioButton writeMessageButton;    // Radio choice for writing a message
    private JTextField messageField;            // Message field for inputting a message

    // Row 2 contents
    private JLabel selectLabel;                 // Label to descript combobox
    private JComboBox selectBox;                // Provides the user with a set of options from
                                                // CHOICES
    private JCheckBox drawColor;                // Option to draw a rectangle/message in color
    private JButton drawIt;                     // Initiates the drawing

    /*
     * Back End Variables
     */
    private String message;                     // Used to store message


    @Override
    public void init()
    {
        parent = new JFrame();
        message = "";                                          // Initially draw nothing
        borderHeight = 0;                                      // Initially draw nothing
        borderWidth = 0;                                       // Initially draw nothing
        appletWidth = getWidth();                              // Get the width of the applet
        appletHeight = getHeight();                            // Get the height of the applet
        xCoord = appletWidth/2;                                // Center width of the applet window
        yCoord = appletHeight/2;                               // Center height of the applet window
        panelPadding = 200;                                    // Gives adequate padding for the panel

        /*
         * Row 1 Contents
         */
        // Initialize row 1 contents
        drawSquareButton = new JRadioButton("Draw square", true);   // Initialize draw square radio
        writeMessageButton = new JRadioButton("Write message:", false); // Initialize write message
                                                                        // radio
        messageField = new JTextField(20);                      // Initialize message field
        messageField.addActionListener(this);                   // Get text from this field later

        // Add contents to panel
        JPanel contentPanel = new JPanel();                     // Create new panel
        contentPanel.add(drawSquareButton);                     // Add draw square button to panel
        contentPanel.add(writeMessageButton);                   // Add write message button to panel
        contentPanel.add(messageField);                         // Add message field to panel

        // Logically link radio buttons
        ButtonGroup squareOrMessageGroup = new ButtonGroup();   // Add new group of buttons
                                                                // for linking
        squareOrMessageGroup.add(drawSquareButton);             // Add draw square button to group
        squareOrMessageGroup.add(writeMessageButton);           // Add write message button to group

        /*
         * Row 2 Contents
         */
        //Initialize row 2 contents
        selectLabel = new JLabel("Select where to draw:");      // Initialize elements
        selectBox = new JComboBox(CHOICES);                     // Add new combo box populated from
                                                                // CHOICES
        selectBox.setMaximumRowCount(3);                        // Set maximum combo box selections
                                                                // to 3
        drawColor = new JCheckBox("Draw in color");             // Initialize draw in color checkbox
        drawIt = new JButton("Draw It!");                       // Initialize draw it button
        drawIt.addActionListener(this);                         // Listen for click event

        // add row 2 contents to panel
        contentPanel.add(selectLabel);                          // Add select label button to
                                                                // content panel
        contentPanel.add(selectBox);                            // Add select box to
                                                                // content panel
        contentPanel.add(drawColor);                            // Add draw color checkbox to
                                                                // content panel
        contentPanel.add(drawIt);                               // Add draw it button to content
                                                                // panel

        add(contentPanel);                                      // Add content panel to GUI

    } // end init

    @Override
    public void paint(Graphics g)
    {
        super.paint(g);

        g.drawString(message, xCoord, yCoord); // Draw the current message
        g.drawRect(xCoord, yCoord, borderWidth, borderHeight); // Draw the rectangle
    } // end paint




    public void actionPerformed(ActionEvent e)
    {
        if (selectBox.getSelectedIndex() > 0) // Check if the user selected a combo box option
        {
            if (selectBox.getSelectedItem() == "Center") // Center the drawing in the applet window
            {
                xCoord = appletWidth/2; // Get the x center of the applet
                yCoord = appletHeight/2; // Get the y center of the applet
            }

            if (selectBox.getSelectedItem() == "Random") // Randomize the drawing location
            {
                xCoord = (int)(Math.random() * appletWidth); // Randomize x coord

                // Randomize y coord, gives padding so the square doesn't overlap the GUI panel
                yCoord = (int)(Math.random() * (appletHeight-panelPadding + 1)) + panelPadding;
            }
        }
        else { // User didn't select something, prompt them to select from the combo box
            JOptionPane.showMessageDialog(parent, "Please select where to draw"); // Prompt
            return; // Do not process any further commands
        }

        if (drawColor.isSelected()) // Check if the user wants to draw in color
        {
            JOptionPane.showMessageDialog(parent, "color turned on"); // Prompt
        }
        else // User doesn't want to draw in color :(
        {
            JOptionPane.showMessageDialog(parent, "color turned off"); // Prompt
        }

        if (e.getSource() == drawIt && writeMessageButton.isSelected()) // Write message upon clicking
        {                                                               // "Draw It!"
            borderHeight = 0; // Clear the square
            borderWidth = 0; // Clear the square

            message = messageField.getText();                   // Get text from message field

            if (message.length() <= 0)                          // Prompt user if message not entered
            {
                JOptionPane.showMessageDialog(parent, "Please enter a message to display."); // Prompt
                return; // Exit to stop futher processing
            }
        }
        else if (e.getSource() == drawIt && drawSquareButton.isSelected()){ // Check if user wants to
            message = ""; // Clear the message string

            borderHeight = 100; // Set height of square
            borderWidth = 100; // Set width of square

            // Center the sqaure in the GUI
            xCoord = xCoord-borderWidth/2; // Set x coord to left of square
            yCoord = yCoord-borderHeight/2; // Set y coord to top of square
        }

        repaint();                                              // Redraw items on screen
    } // end actionPerformed
} // end Lab3 class
