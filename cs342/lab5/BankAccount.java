// Programmer:  Bradley Golden
// Program:     BankAccount, models simple bank account
// Date:        9/24/2015
// Description: This class models a simple bank account that allows you to create an account 
//              with a balance and type (checking or savings)

public class BankAccount
{
    private String name;      // name of account holder
    private double balance;   // how much money is in account, $
    private String accountType; // the type of account, i.e. savings or checking

    public BankAccount()
    // POST: A default BankAccount object is created with name and acccount type set to a blank and
    //       and balance set to $0.00
    {
       this(0.0); 
    }

    public BankAccount(double balance)
    // PRE:  balance >= 0.00 and balance is in dollars
    // POST: A BankAccount object is created with name and account type set to a blank
    //       and the class member balance set to balance
    {
       name = " ";
       accountType = " ";
      
       if(balance >= 0)              // validate proposed initial balance
          this.balance = balance; 
       else
          this.balance = 0; 
    }

    public BankAccount(double balance, String accountType)
    // PRE:  balance >= 0.00 and balance is in dollars
    //       accountType = "savings" or accountType = "checking"
    // POST: A BankAccount object is created with name set to blank, account type set to 
    //       "checking", "savings", or blank (if invalid accoutType string), and the class member
    //       balance set to balance
    {
        this(balance); // set the account balance

        if(accountType.equals("checking")) // check if account type is valid
        {
            this.accountType = accountType; // set accountType to "checking"
        }
        else if(accountType.equals("savings")) // check if account type is valid
        {
            this.accountType = accountType; // set accountType to "savings"
        }
        else // account type is not "checking" or "savings", therefore set it's value to blank
        {
            this.accountType = " ";
        }
    }

    public void ResetAccount(String newName, double newBalance)
    // PRE:  newName has been assigned a value
    //       && newBalance >= 0.00 and newBalance is in dollars
    // POST: This account object is reset with name set to newName
    //       and balance set to newBalance
    {
        name = newName;            // Match up private variables with parameters
        balance = newBalance;      // Could do error checking here with an if(balance >= 0)
    }

    public boolean Withdraw(double amount)
    // PRE:  amount >= 0.00 and amount is in dollars
    // POST: FCTVAL == True if withdrawl is possible from the account
    //                 False if withdrawl is not possible.
    {
        double remainingBalance; // remaining balance in the account
        remainingBalance = this.balance; // set remaining balance to the current accoutn balance
        remainingBalance = balance - amount; // 

        if(remainingBalance >= 0.00) // remaining balance is greater than or equal to 0, 
                                     // withdrawl is possible
        {
            return true;
        }
        else // remaining balance is less than 0, withdrawl is not possible
        {
            return false;
        }
    }

    public double GetBalance() 
    // POST: FCTVAL == current balance of this account in dollars
    {
        return balance;
    }

    public String GetAccountType()
    // POST: FCTVAL == current account type in this account
    {
        return accountType;
    }

    public void DisplayBalance() 
    // POST: The current balance of this account has been displayed to the screen
    {
        System.out.printf("Your balance is currently $%.2f\n", balance); 
    }

    public void DisplayAccountType()
    // POST: The current account type of this account has been displayed to the screen
    {
        if(accountType.length() > 1)  // bank account type has been set
        {
            System.out.printf("Your account type is %s\n", accountType);
        }
        else  // bank account type has not been set
        {
            System.out.printf("No account type has been assigned.\n");
        }
    }
}
