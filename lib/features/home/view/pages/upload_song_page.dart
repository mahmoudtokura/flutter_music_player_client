import 'dart:io';

import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _songTitleController = TextEditingController();

  Color selectedColor = Palette.cardColor;
  File? selectedAudioFile;
  File? selectedImageFile;

  final _formKey = GlobalKey<FormState>();

  void selectAudio() async {
    final file = await pickAudio();
    if (file != null) {
      setState(() {
        selectedAudioFile = file;
      });
    }
  }

  void selectImage() async {
    final file = await pickImage();
    if (file != null) {
      setState(() {
        selectedImageFile = file;
      });
    }
  }

  @override
  void dispose() {
    _artistController.dispose();
    _songTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      homeViewModelProvider.select((value) => value?.isLoading == true),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload song"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (_formKey.currentState!.validate() &&
                  selectedAudioFile != null &&
                  selectedImageFile != null) {
                ref.read(homeViewModelProvider.notifier).uploadSong(
                      audioFile: selectedAudioFile!,
                      imageFile: selectedImageFile!,
                      artist: _artistController.text,
                      songTitle: _songTitleController.text,
                      hexColor: selectedColor,
                    );
              } else {
                showSnackBar(context, "Please fill all the fields");
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: selectImage,
                        child: selectedImageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  selectedImageFile!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : DottedBorder(
                                color: Palette.borderColor,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                strokeWidth: 1,
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        "Select the thumbnail for your song",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 40),
                      selectedAudioFile != null
                          ? AudioWave(
                              audioPath: selectedAudioFile!.path,
                            )
                          : CustomField(
                              hintText: "Pick a song",
                              readOnly: true,
                              controller: null,
                              onTap: selectAudio,
                            ),
                      const SizedBox(height: 20),
                      CustomField(
                        hintText: "Artist name",
                        controller: _artistController,
                      ),
                      const SizedBox(height: 20),
                      CustomField(
                        hintText: "Song title",
                        controller: _songTitleController,
                      ),
                      const SizedBox(height: 20),
                      ColorPicker(
                        color: selectedColor,
                        onColorChanged: (Color color) =>
                            setState(() => selectedColor = color),
                        pickersEnabled: const <ColorPickerType, bool>{
                          ColorPickerType.wheel: true,
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
