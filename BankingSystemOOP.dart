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
