public class Enemy {
    private static int dangerThreshold = 15; // The threshold until the enemy is dangerous to the player

    /* NOTE: The following comment has been placed above the statement because the comment does 
     * not fit to the right of the statement. Continuing the comment to the next line and keeping
     * alignment with the previous comment ruins my auto formatting. I will continue this method 
     * for the rest of this program. */
    // Defines whether all of the enemies are actively dangerous to the player
    private static boolean active = true; 

    private int verticalLevel;  // Where the enemy is on the screen
    private int strength; // The strength of the enemy
    private int singleHit; // The amount of strength lost when hit by the player

    public Enemy() 
    {
        // POST: A default Enemy object is created with strength set to 100
        strength = 100; // Enemy starts at strength of 100
    }

    public Enemy(int singleHit, int verticalLevel)
    {
        // PRE: singleHit is an int > 0 and verticalLevel is an int > 0 and <= total number 
        // of vertical levels.
        // POST: An enemy object with strength lost by each player hit set and the vertical level
        // of the enemy set.
        this(); // Initialize default values
        this.singleHit = singleHit; // Enemy loses 15 strength per hit by the player
        this.verticalLevel = verticalLevel; // Set vertical level of the enemy
    } 

    public void playerHit()
    {
        // POST: The enemy strength is deducted by the amount of a single hit
        this.strength = this.strength - this.singleHit; // Set the new strength of the enemy

        if (this.strength < 0) // Check that the strength of the enemy is a valid value after a hit
        {
            this.strength = 0; // Set negative strength value of the enemy to 0
        }

    } // end singleHit

    public static void renderInactive()
    {
        // POST: The enemy is set to inactive
        active = false; // Set the enemy to inactive
    } // end renderInactive

    public static void renderActive()
    {
        // POST: The enemy is set to active
        active = true; // Set the enemy to active
    }

    public int getStrength()
    {
        // POST: FCTVAL = current strength of the enemy
        return this.strength; // Return the current strength of the enemy
    }

    public int getEnemyDanger(int playerLocation)
    {
        // PRE: playerLocation is an int > 0 and less than the total number of vertical levels
        // POST: FCTVAL = vertical location of the enemy danger if the enemy is active and the 
        // strength is less than 15, otherwise return 0

        int danger;
        if(this.active && this.strength >= 15) // Check whether the enemy is active and strength < 15
        {
            danger = this.verticalLevel - playerLocation; // Return distance enemy is from the player
            if (danger < 0) // If the danger is less than 0
                return 0; // return 0
            else // Otherwise danger is greater than 0
                return danger;  // Return the danger level
        }
        else
        {
            return 0; // Return vertical height of 0
        }
    }

    public boolean compareStrength(Enemy anotherEnemy)
    {
        // PRE: A valid enemy object
        // POST: FCTVAL = true when this enemy's strength is greather than anotherEnemy,
        // otherwise FCTVAL = false

        // Compare strength between this enemy and anotherEnemy
        if(this.strength > anotherEnemy.getStrength())         
        {
            return true; // This enemy's strength is greather than anotherEnemy
        }
        else
        {
            return false; // This enemy's strength is not greater than anotherEnemy
        }
    }

    public String toString()
    {
        // POST:  FCTVAL = A string containing the following enemy attributes:
        //       * strength of the enemy
        //       * active status
        //       * vertical level
        //       * the amount a player hit deals to the enemy
        return ("The enemy has the following attributes\n"
                + "Strength: " + this.strength + "\n" // Display strength
                + "Vertical Level: " + this.verticalLevel + "\n" // Display vertical level
                + "Active: " + active + "\n" // Display whether the enemy is active
                + "Player Hit Amount: " + this.singleHit + "\n"); // Display player hit amt
    }
} // end Enemy class
