public class CustomAccountController {
    
  public String selectedAccountId {get; set;}
  public Account selectedAccount {
    get {
      return [SELECT Name, Phone, Type, OwnerId, Site,
      Industry, Rating, Fax, 
      Website, AnnualRevenue,
      (SELECT Name, Phone, Email
        FROM Contacts)
      FROM Account
      WHERE Id = :selectedAccountId
      LIMIT 1];
    }
    private set;
  }
  
  public Account newAccount {get; set;}
  public List<Contact> newContacts {get; set;}
  public Contact newContact {get; set;}

  public ApexPages.StandardSetController contactsController { get; set; }
  public List<Contact> contacts {
    get {
      return (List<Contact>) contactsController.getRecords();
    } 
    set;
  }
  
  private Integer PAGE_SIZE = 5;
  
  public CustomAccountController() {
    getAccountOptions();
    newAccount = new Account();
    newContacts = new List<Contact>();
    newContact = new Contact();
  }
  
  public List<SelectOption> getAccountOptions() {
    List<Account> accounts = [SELECT Name FROM Account];
    selectedAccountId = accounts[0].Id;
    updateContacts();
    List<SelectOption> options = new List<SelectOption>();
    for (Account account : accounts) {
        options.add(new SelectOption(account.Id, account.Name));
    }
    return options;
  }

  public void updateContacts() {
    contactsController = new ApexPages.StandardSetController(selectedAccount.Contacts);
    contactsController.setPageSize(PAGE_SIZE);
    contacts = contactsController.getRecords();
  }

  public void saveAccount() {
    insert newAccount;
    for (Contact contact : newContacts) {
      contact.AccountId = newAccount.Id;
    }
    insert newContacts;
    newAccount = new Account();
    newContacts = new List<Contact>();
    getAccountOptions();
  }

  public void addContactForNewAccount() {
    newContacts.add(newContact);
    newContact = new Contact();
  }
}