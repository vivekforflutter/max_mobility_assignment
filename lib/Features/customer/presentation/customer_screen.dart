import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Database/db_manager.dart';
import '../../../model/customer_model.dart';
import '../widget/item_card.dart';


class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final DbManager dbManager =  DbManager();

  Model? model;
  List<Model>? modelList;
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Customer Information'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogBox().dialog(
                  context: context,
                  onPressed: () async{
                    Model model =  Model(
                        personName: nameTextController.text,
                        email: emailTextController.text,
                        mobileNumber: phoneTextController.text,

                    );
                    int? id =   await dbManager.insertData(model) ;
                    print("data inserted  ${id}" );
                    WidgetsBinding.instance.addPostFrameCallback((_){
                      setState(() {
                        nameTextController.text = "";
                        emailTextController.text = "";
                        phoneTextController.text = "";
                      });
                      Navigator.of(context).pop();
                    });


                  },
                  textEditingController1: nameTextController,
                  textEditingController2: emailTextController,
                  textEditingController3: phoneTextController,
                  /* nameTextFocusNode: nameTextFocusNode,
                  ageTextFocusNode: ageTextFocusNode,*/
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: dbManager.getDataList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            modelList = snapshot.data as List<Model>?;
            return ListView.builder(
              itemCount: modelList?.length,
              itemBuilder: (context, index) {
                Model _model = modelList![index];
                return ItemCard(
                  model: _model,
                  nameTextController: nameTextController,
                  emailTextController: emailTextController,
                  phoneTextController: phoneTextController,
                  onDeletePress: () {
                    dbManager.deleteData(_model);
                    WidgetsBinding.instance.addPostFrameCallback((_){

                      setState(() {});

                    });


                  },
                  onEditPress: () {
                    nameTextController.text = _model.personName??"";
                    emailTextController.text = _model.email??"";
                    phoneTextController.text = _model.mobileNumber??"";
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogBox().dialog(
                              context: context,
                              onPressed: () {
                                Model __model = Model(
                                    id: _model.id,
                                    personName: nameTextController.text,
                                    email: emailTextController.text,
                                    mobileNumber: phoneTextController.text,
                                );
                                dbManager.updateData(__model);
                                WidgetsBinding.instance.addPostFrameCallback((_){

                                  setState(() {
                                    nameTextController.text = "";
                                    emailTextController.text = "";
                                    phoneTextController.text = "";
                                  });

                                });

                                Navigator.of(context).pop();
                              },
                              textEditingController2: emailTextController,
                              textEditingController1: nameTextController,
                              textEditingController3: phoneTextController,
                          );
                        });
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

}
class DialogBox {
  Widget dialog(
      {BuildContext? context,
        Function? onPressed,
        TextEditingController? textEditingController1,
        TextEditingController? textEditingController2,
        TextEditingController? textEditingController3,
        /*FocusNode? nameTextFocusNode,
        FocusNode? ageTextFocusNode*/}) {
    return AlertDialog(
      title: const Text("Enter person Data"),
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            TextFormField(
              controller: textEditingController1,
              keyboardType: TextInputType.text,
              // focusNode: nameTextFocusNode,
              decoration: const InputDecoration(hintText: "Enter full name "),
              /*autofocus: true,*/
              onFieldSubmitted: (value) {
                //nameTextFocusNode?.unfocus();
                //FocusScope.of(context!).requestFocus(ageTextFocusNode);
              },
            ),
            TextFormField(
              controller: textEditingController2,
              keyboardType: TextInputType.emailAddress,
              //focusNode: ageTextFocusNode,
              decoration: const InputDecoration(hintText: "Enter email address"),
              onFieldSubmitted: (value) {
                //  ageTextFocusNode?.unfocus();
              },
            ),
            TextFormField(
              controller: textEditingController3,
              keyboardType: TextInputType.phone,
              //focusNode: ageTextFocusNode,
              decoration: const InputDecoration(hintText: "Enter phone number"),
              onFieldSubmitted: (value) {
                //  ageTextFocusNode?.unfocus();
              },
            ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.of(context!).pop();
          },
          color: Colors.blue,
          child: const Text(
            "Cancel",
          ),
        ),
        MaterialButton(
          onPressed:(){
            onPressed!();
          } /*onPressed!()*/,
          child: Text("Save"),
          color: Colors.blue,
        )
      ],
    );
  }
}

