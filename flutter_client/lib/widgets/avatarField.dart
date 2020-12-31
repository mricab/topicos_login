import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_client/camera_utils/photo.dart';

class AvatarFormField extends FormField<String> {
  AvatarFormField(
      {FormFieldSetter<String> onSaved,
      FormFieldValidator<String> validator,
      String initialValue,
      BuildContext context,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<String> state) {
              var photoMgr = Photo();
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton.icon(
                                      onPressed: () async {
                                        await photoMgr.getImageFromCamera();
                                        state.didChange(photoMgr.img.path);
                                      },
                                      icon: Icon(Icons.camera),
                                      label: Text('Camara')),
                                  FlatButton.icon(
                                      onPressed: () async {
                                        await photoMgr.getImageFromGallery();
                                        state.didChange(photoMgr.img.path);
                                      },
                                      icon: Icon(Icons.photo),
                                      label: Text('Galeria'))
                                ],
                              ),
                            )),
                      );
                    },
                    child: Column(
                      children: [
                        (state.value == null)
                            ? CircleAvatar(
                                backgroundColor: Colors.grey[400],
                                child: (state.value == null)
                                    ? Text(
                                        'Fotografía',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      )
                                    : null,
                                minRadius: 60,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  File(state.value),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container()
                ],
              );
            });
}
