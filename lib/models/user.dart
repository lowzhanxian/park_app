//here to enter model of the user

class User{
  int? id;
  String full_name;
  String username;
  String contact_number;
  String email_address;
  String password;

  User({
    this.id,
    required this.full_name,
    required this.username,
    required this.contact_number,
    required this.email_address,
    required this.password,
});

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'full_name':full_name,
      'username':username,
      'contact_number':contact_number,
      'email_address':email_address,
      'password':password,
    };
  }
  factory User.fromMap(Map<String,dynamic > map) {
    return User(
      id: map['id'],
      full_name: map['full_name'],
      username: map['username'],
      contact_number: map['contact_number'],
      email_address: map['email_address'],
      password: map['password'],
    );
  }
}