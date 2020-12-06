public class CustomAccountController {
    
  public List<Account> accounts {get; private set;}
  public String selectedAccountId {get; set;}
  public Account selectedAccount {get; set;}
  public Account newAccount {get; set;}
  public List<Contact> newAccountContacts {get; set;}
  public Integer contactsCount {get; set;}
  public Contact newContact {get; set;}
  
  public CustomAccountController() {
      getAccounts();
      selectedAccountId = accounts.get(0).Id;
      updateSelectedAccount();
      newAccount = new Account();
      newAccountContacts = new List<Contact>();
      contactsCount = newAccountContacts.size();
      newContact = new Contact();
  }
  
  public void getAccounts() {
      accounts = [SELECT Name
              FROM Account];
  }
  
  public List<SelectOption> getAccountOptions() {
      List<SelectOption> options = new List<SelectOption>();
      for (Account account : accounts) {
          options.add(new SelectOption(account.Id, account.Name));
      }
      return options;
  }
  
  public void updateSelectedAccount() {
      selectedAccount = [SELECT Name, Phone, Type, OwnerId, Site,
              Industry, Rating, Fax, 
              Website, AnnualRevenue,
              (SELECT Name, Phone, Email
               FROM Contacts)
             FROM Account
             WHERE Id = :selectedAccountId
             LIMIT 1];
  }

  public void saveAccount() {
    insert newAccount;
    for (Contact contact : newAccountContacts) {
      contact.AccountId = newAccount.Id;
    }
    insert newAccountContacts;
    newAccount = new Account();
    newAccountContacts = new List<Contact>();
    getAccounts();
  }

  public void addContactForNewAccount() {
    newAccountContacts.add(newContact);
    contactsCount = newAccountContacts.size();
    newContact = new Contact();
  }
}