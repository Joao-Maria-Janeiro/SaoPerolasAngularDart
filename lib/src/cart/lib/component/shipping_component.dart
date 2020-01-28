import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:encrypt/encrypt.dart';


import '../../../constants.dart';


@Component (
  selector: 'shipping',
  directives: [coreDirectives,formDirectives, routerDirectives],
  templateUrl: 'shipping_component.html',
)
class ShippingComponent {
  bool loggedIn = window.localStorage.containsKey('sao_perolas_key');
  String full_name, address, city, localidade, zip, country, cell, email;

  void submitShippingDetails() {
    final key = Key.fromUtf8('my 32 length key................');

    final encrypter = Encrypter(AES(key));

    // final encrypted = encrypter.encrypt(plainText, iv: iv);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);


    window.localStorage['sao_perolas_shipping'] = jsonEncode(  
      {
        'full_name': encrypter.encrypt(full_name).base64,
        'address': encrypter.encrypt(address).base64,
        'city': city,
        'localidade': localidade,
        'zip': zip,
        'country': country,
        'cell': encrypter.encrypt(cell).base64,
        'email': email
      }
    );
    String test = jsonDecode(window.localStorage['sao_perolas_shipping'])['address'];
    print(encrypter.decrypt64(test));
    // print(encrypter.decrypt(encrypted, iv: iv));
    
  }
}

