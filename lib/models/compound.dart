class Compound {
  int? id;
  int userId;
  String description;
  double amount;
  String date;

  Compound({
    this.id,
    required this.userId,
    required this.description,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'description': description,
      'amount': amount,
      'date': date,
    };
  }

  factory Compound.fromMap(Map<String, dynamic> map) {
    return Compound(
      id: map['id'],
      userId: map['user_id'],
      description: map['description'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}
