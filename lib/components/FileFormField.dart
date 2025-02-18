import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileFormField extends FormField<File?> {
  FileFormField({
    Key? key,
    required FormFieldSetter<File?> onSaved,
    FormFieldValidator<File?>? validator,
    File? initialValue,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<File?> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      state.didChange(File(result.files.single.path!));
                    }
                  },
                  child: Text(state.value == null ? 'Selecionar Arquivo' : 'Arquivo Selecionado'),
                ),
                if (state.value != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Arquivo: ${state.value!.path}'),
                  ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        );
}
