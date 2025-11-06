// ---------------------- ABSTRACT CLASS -----------------------
abstract class BankAccount {
  // Private fields (Encapsulation)
  final int _accountNumber;
  String _accountHolderName;
  double _balance;
  List<String> _transactionHistory = [];

  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // Getters & Setters (Encapsulation)
  int get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;
  List<String> get transactionHistory => _transactionHistory;

  set accountHolderName(String name) {
    if (name.isNotEmpty) {
      _accountHolderName = name;
    }
  }

  // Abstract methods (Abstraction)
  void deposit(double amount);
  void withdraw(double amount);

  // Record transaction
  void addTransaction(String details) {
    _transactionHistory.add(details);
  }

  // Display method
  void displayInfo() {
    print("Account No: $_accountNumber");
    print("Holder: $_accountHolderName");
    print("Balance: \$${_balance.toStringAsFixed(2)}");
    print("Transactions:");
    for (var t in _transactionHistory) {
      print(" - $t");
    }
    print("-----------------------------");
  }

  // Protected method to safely update balance
  void updateBalance(double amount) {
    _balance += amount;
  }
}

// ---------------------- INTERFACE -----------------------------
abstract class InterestBearing {
  double calculateInterest();
  void applyInterest();
}

// ----------------------SAVINGS ACCOUNT----------------------
class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawals = 0;
  static const double _interestRate = 0.02;
  static const double _minBalance = 500;
  static const int _withdrawalLimit = 3;

  SavingsAccount(int accNo, String holder, double bal)
    : super(accNo, holder, bal);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print("Invalid deposit amount!");
      return;
    }
    updateBalance(amount);
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (_withdrawals >= _withdrawalLimit) {
      print("Withdrawal limit reached!");
      return;
    }
    if (balance - amount < _minBalance) {
      print("Cannot withdraw below minimum balance of \$$_minBalance");
      return;
    }
    updateBalance(-amount);
    _withdrawals++;
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
  }

  @override
  double calculateInterest() => balance * _interestRate;

  @override
  void applyInterest() {
    double interest = calculateInterest();
    updateBalance(interest);
    addTransaction("Interest applied: \$${interest.toStringAsFixed(2)}");
  }
}

// ---------------------- CHECKING ACCOUNT ---------------------
class CheckingAccount extends BankAccount {
  static const double _overdraftFee = 35.0;

  CheckingAccount(int accNo, String holder, double bal)
    : super(accNo, holder, bal);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print("Invalid deposit amount!");
      return;
    }
    updateBalance(amount);
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    updateBalance(-amount);
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");

    if (balance < 0) {
      updateBalance(-_overdraftFee);
      addTransaction("Overdraft fee of \$$_overdraftFee applied");
      print("Warning: Overdraft fee charged!");
    }
  }
}

// ---------------------- PREMIUM ACCOUNT ----------------------
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double _minBalance = 10000;
  static const double _interestRate = 0.05;

  PremiumAccount(int accNo, String holder, double bal)
    : super(accNo, holder, bal);

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print("Invalid deposit amount!");
      return;
    }
    updateBalance(amount);
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < _minBalance) {
      print("Cannot withdraw below minimum balance of \$$_minBalance");
      return;
    }
    updateBalance(-amount);
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
  }

  @override
  double calculateInterest() => balance * _interestRate;

  @override
  void applyInterest() {
    double interest = calculateInterest();
    updateBalance(interest);
    addTransaction("Interest applied: \$${interest.toStringAsFixed(2)}");
  }
}

// ---------------------- STUDENT ACCOUNT ----------------------
class StudentAccount extends BankAccount {
  static const double _maxBalance = 5000;

  StudentAccount(int accNo, String holder, double bal)
    : super(accNo, holder, bal);

  @override
  void deposit(double amount) {
    if (balance + amount > _maxBalance) {
      print("Cannot exceed maximum balance of \$$_maxBalance");
      return;
    }
    updateBalance(amount);
    addTransaction("Deposited \$${amount.toStringAsFixed(2)}");
  }

  @override
  void withdraw(double amount) {
    if (amount > balance) {
      print("Insufficient balance!");
      return;
    }
    updateBalance(-amount);
    addTransaction("Withdrew \$${amount.toStringAsFixed(2)}");
  }
}

class Bank {
  final List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
    print("Account created for ${account.accountHolderName}");
  }

  BankAccount? findAccount(int accNo) {
    try {
      return _accounts.firstWhere((acc) => acc.accountNumber == accNo);
    } catch (e) {
      return null; // safely return null if not found
    }
  }

  void transfer(int fromAcc, int toAcc, double amount) {
    final sender = findAccount(fromAcc);
    final receiver = findAccount(toAcc);

    if (sender == null || receiver == null) {
      print(" One or both accounts not found!");
      return;
    }

    sender.withdraw(amount);
    receiver.deposit(amount);

    sender.addTransaction(
      "Transferred \$${amount.toStringAsFixed(2)} to ${receiver.accountHolderName}",
    );
    receiver.addTransaction(
      "Received \$${amount.toStringAsFixed(2)} from ${sender.accountHolderName}",
    );
  }

  void applyMonthlyInterest() {
    for (final acc in _accounts) {
      if (acc is InterestBearing) {
        (acc as InterestBearing).applyInterest(); // explicit cast
      }
    }
  }

  void generateReport() {
    print("===== 🏦 BANK REPORT =====");
    for (final acc in _accounts) {
      acc.displayInfo();
    }
  }
}

// ---------------------- MAIN FUNCTION -------------------------
void main() {
  Bank bank = Bank();

  var acc1 = SavingsAccount(1001, "Alice", 1500);
  var acc2 = CheckingAccount(1002, "Bob", 200);
  var acc3 = PremiumAccount(1003, "Charlie", 20000);
  var acc4 = StudentAccount(1004, "Daisy", 1000);

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);
  bank.createAccount(acc4);

  acc1.withdraw(300);
  acc2.withdraw(250);
  acc3.deposit(1000);
  acc4.deposit(4200);

  bank.transfer(1001, 1002, 100);
  bank.applyMonthlyInterest();
  bank.generateReport();
}
