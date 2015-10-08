public class EnemyTest {
    public static void main(String[] args){
        Enemy enemyOne = new Enemy(15, 2); 
        Enemy enemyTwo = new Enemy(10, 4); 
        Enemy enemyThree = new Enemy(20, 5); 

        // Test constructor initialization
        System.out.println("--------Constructor initialization--------");
        System.out.println("Enemy 1: \n"
                + enemyOne.toString() + "\n");
        System.out.println("Enemy 2: \n"
                + enemyTwo.toString() + "\n");
        System.out.println("Enemy 3: \n"
                + enemyThree.toString() + "\n");
        
        // Get strength of each enemy
        System.out.println("--------Get Strength--------");
        System.out.println("Enemy 1: \n"
                + enemyOne.getStrength() + "\n");
        System.out.println("Enemy 2: \n"
                + enemyTwo.getStrength() + "\n");
        System.out.println("Enemy 3: \n"
                + enemyThree.getStrength() + "\n");

        // Render every enemy inactive
        System.out.println("--------Render inactive--------");
        Enemy.renderInactive();
        System.out.println("Enemy 1: \n"
                + enemyOne.toString() + "\n");
        System.out.println("Enemy 2: \n"
                + enemyTwo.toString() + "\n");
        System.out.println("Enemy 3: \n"
                + enemyThree.toString() + "\n");
        
        // Render every enemy active
        System.out.println("--------Render active--------");
        Enemy.renderActive();
        System.out.println("Enemy 1: \n"
                + enemyOne.toString() + "\n");
        System.out.println("Enemy 2: \n"
                + enemyTwo.toString() + "\n");
        System.out.println("Enemy 3: \n"
                + enemyThree.toString() + "\n");
        
        // Simulate the player hitting each enemy
        System.out.println("--------Hit enemy one--------");
        enemyOne.playerHit();
        System.out.println("Enemy 1: \n"
                + enemyOne.toString() + "\n");

        System.out.println("--------Hit enemy two--------");
        enemyTwo.playerHit();
        System.out.println("Enemy 2: \n"
                + enemyTwo.toString() + "\n");

        System.out.println("--------Hit enemy three--------");
        enemyThree.playerHit();
        System.out.println("Enemy 3: \n"
                + enemyThree.toString() + "\n");

        // Test the threshhold limit of the enemy
        System.out.println("--------Hit--------");
        enemyOne.playerHit();
        System.out.println("Enemy 1: \n"
                + enemyOne.toString() + "\n");
        System.out.println("--------Hit--------");
        enemyOne.playerHit();
        System.out.println("Enemy 1: \n"
                + enemyOne.toString() + "\n");
        System.out.println("--------Hit--------");
        enemyOne.playerHit();
        System.out.println("Enemy 1: \n"
                + enemyOne.toString() + "\n");
        System.out.println("--------Hit--------");
        enemyOne.playerHit();
        System.out.println("Enemy 1: \n"
                + enemyOne.toString() + "\n");
        System.out.println("--------Hit--------");
        enemyOne.playerHit();
        System.out.println("Enemy 1: \n"
                + enemyOne.toString() + "\n");
        System.out.println("--------Hit--------");
        enemyOne.playerHit();
        System.out.println("Enemy 1: \n"
                + enemyOne.toString() + "\n");

        //Test getEnemyDanger
        System.out.println("-------getEnemyDanger of Enemy 1 at 3-------");
        System.out.println(enemyOne.toString());
        System.out.println(enemyOne.getEnemyDanger(3));
        System.out.println("-------getEnemyDanger of Enemy 2 at 3-------");
        System.out.println(enemyTwo.toString());
        System.out.println(enemyTwo.getEnemyDanger(3));
        System.out.println("-------getEnemyDanger of Enemy 3 at 3-------");
        System.out.println(enemyThree.toString());
        System.out.println(enemyThree.getEnemyDanger(3));

        // Test compareDanger
        System.out.println("-------compareStrength of 1 and 2-------");
        System.out.println(enemyOne.compareStrength(enemyTwo));
        System.out.println("-------compareStrength of 2 and 3-------");
        System.out.println(enemyTwo.compareStrength(enemyThree));
        System.out.println("-------compareStrength of 3 and 1-------");
        System.out.println(enemyThree.compareStrength(enemyOne));
    }
}
