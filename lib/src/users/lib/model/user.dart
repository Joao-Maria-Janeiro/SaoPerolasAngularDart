class User {
  String email, name, last_name, country, address, zip_code, city, localidade, cell_number;

  User(this.email, this.name, this.last_name, this.country, this.address, this.zip_code, this.city, this.localidade, this.cell_number);

    factory User.fromJson(Map<String, dynamic> user) =>
      User(
        user['email'],
        user['first_name'],
        user['last_name'],
        user['country'],
        user['adress'],
        user['zip'],
        user['city'],
        user['localidade'],
        user['phone_number']
      );
}
