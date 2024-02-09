import 'package:flutter/material.dart';

import '../../../Database/db_manager.dart';
import '../../../model/customer_model.dart';

class ItemCard extends StatefulWidget {
  Model? model;
  TextEditingController? nameTextController;
  TextEditingController? emailTextController;
  TextEditingController? phoneTextController;
  Function? onDeletePress;
  Function? onEditPress;

  ItemCard(
      {this.model,
        this.nameTextController,
        this.emailTextController,
        this.phoneTextController,
        this.onDeletePress,
        this.onEditPress});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final DbManager dbManager = new DbManager();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //CircleAvatar(radius: 20, backgroundColor: Colors.grey.withAlpha(100),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Name: ${widget.model?.personName}',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'email: ${widget.model?.email}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'mobileNumber: ${widget.model?.mobileNumber}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: (){
                        widget.onEditPress!();
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: (){widget.onDeletePress!();},
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}