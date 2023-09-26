
import 'package:flutter/material.dart';
import 'package:flutter_application_2/telacadastrada.dart';
import 'package:flutter_application_2/user.dart';

import 'Change.dart';


class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _Lista();
}

class _Lista extends State<Lista> {
  late List<User> search;
  String username = "";

  final userRepo = UserRepository.getUsers();
 @override
  void initState() {
    //cópia da lista original
    search = List.from(UserRepository.getUsers());
    super.initState();
  }
  void update(String nome) {
    setState(() {
      search = UserRepository.getUsers()
          .where((element) =>
              (element.nome.toLowerCase().contains(nome.toLowerCase())))
          .toList();
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed: () {},
    );
    Widget continueButton = TextButton(
      child: Text("Continuar"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Deseja mesmo excluir este usuário?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Consulta de usuários')),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
                labelText: "Buscar usuário", border: OutlineInputBorder()),
            onChanged: (String nome) {
              username = nome;
              update(username);
            },
          ),
          SizedBox(height: 24),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(thickness: 2),
            itemCount: search.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(search[index].nome),
                  subtitle: Text(search[index].username),
                  trailing: SizedBox(
                      width: 70,
                      child: Row(
                        children: [
                          Expanded(
                              child: IconButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UserEdit(search[index], index);
                              }));
                            },
                            icon: Icon(Icons.mode_edit_outline_outlined),
                          )),
                          Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Exclusão iminente"),
                                            content: Text(
                                                "Confirma a exclusão deste usuário?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    User user = userRepo[index];
                                                    UserRepository.removeUser(
                                                        user);
                                                    update(username);
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Sim")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancelar"))
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.delete_forever)))
                        ],
                      )));
            },
          ),
        ],
      ),
    );
  }
}