// Programmer:  Bradley Golden
// Program:     BankTest
// Date:        9/24/2015
// Description: Tests the BankAccount class by testing all constructors and instance variable
//              boundaries

public class BankTest
{
    public static void main(String[] args)
    {
        BankAccount testAccount; // create new test bank account

        System.out.printf("\n");
            
        System.out.printf("-------------------------------------\n");
        System.out.printf("      Default constructor test       \n");
        System.out.printf("-------------------------------------\n");
        /* Test the default constructor of the BankAccount class */
        testAccount = new BankAccount(); // default constructor
        testAccount.DisplayBalance(); // check that the bank account was set to 0
        testAccount.DisplayAccountType(); // check that the bank account type hasn't been assigned yet
        // check boundary conditions for withdraw method
        System.out.printf("Withdrawl possible for 0.01: %s\n", testAccount.Withdraw(0.01));
        System.out.printf("Withdrawl possible for 0.00: %s\n", testAccount.Withdraw(0.00));

        System.out.printf("\n");

        System.out.printf("-------------------------------------\n");
        System.out.printf("    Set balance constructor test     \n");
        System.out.printf("-------------------------------------\n");
        /* Test for constructor that allows to set the bank account balance */
        testAccount = new BankAccount(10.00); // create bank account with 0 dollar balance
        testAccount.DisplayBalance(); // check that bank account balance is correct
        testAccount.DisplayAccountType(); // check that bank account type hasn't been assigned
        //check boundary conditions for withdraw method
        System.out.printf("Withdrawl possible for 10.01: %s\n", testAccount.Withdraw(10.01));
        System.out.printf("Withdrawl possible for 10.00: %s\n", testAccount.Withdraw(10.00));
        System.out.printf("Withdrawl possible for 9.99: %s\n", testAccount.Withdraw(9.99));

        System.out.printf("\n");

        System.out.printf("-------------------------------------\n");
        System.out.printf("Set balance and type constructor test\n");
        System.out.printf("-------------------------------------\n");
        /* Test for constructor that allows to set the bank account balance and account type */
        testAccount = new BankAccount(100.00, "checking"); // create checking account with balance 
                                                           // of 100 dollars

        testAccount.DisplayBalance(); // check that bank account balance is correct
        testAccount.DisplayAccountType(); // check for proper bank type assignment

        //check boundary conditions for withdraw method
        System.out.printf("Withdrawl possible for 100.01: %s\n", testAccount.Withdraw(100.01));
        System.out.printf("Withdrawl possible for 100.00: %s\n", testAccount.Withdraw(10.000));
        System.out.printf("Withdrawl possible for 99.99: %s\n", testAccount.Withdraw(99.99));

        testAccount = new BankAccount(100.00, "savings"); // create savings account with balance 
                                                          // of 100 dollars
        testAccount.DisplayAccountType(); // check for proper bank type assignment

        testAccount = new BankAccount(100.00, "blah blah"); // create erroneous account with balance 
                                                            // of 100 dollars
        testAccount.DisplayAccountType(); // check for proper bank type assignment
    } // end main
} // end BankTest class
