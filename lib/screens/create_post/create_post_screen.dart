import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:insta_bloc/helpers/helpers.dart';
import 'package:insta_bloc/screens/create_post/cubit/create_post_cubit.dart';
import 'package:insta_bloc/screens/widgets/widgets.dart';

class CreatePostScreen extends StatelessWidget {
  static const String routeName = '/create_post';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Create Post'),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _selectedPostImage(context),
                    child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: state.postImage != null
                            ? Image.file(
                                state.postImage!,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image, color: Colors.grey, size: 120)),
                  ),
                  if (state.status == CreatePostStatus.submitting)
                    LinearProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'Caption'),
                                onChanged: (value) => context
                                    .read<CreatePostCubit>()
                                    .captionChanged(value),
                                validator: (value) => value!.trim().isEmpty
                                    ? 'caption cannot be empty'
                                    : null),
                            SizedBox(
                              height: 28.0,
                            ),
                            RaisedButton(
                              onPressed: () => _submitForm(
                                  context,
                                  state.postImage!,
                                  state.status == CreatePostStatus.submitting),
                              elevation: 1,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text('Post'),
                            )
                          ]),
                    ),
                  )
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state.status == CreatePostStatus.success) {
              _formKey.currentState!.reset();
              context.read<CreatePostCubit>().reset();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                  content: Text('Post Created'),
                ),
              );
            } else if (state.status == CreatePostStatus.error) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(message: state.failure.message));
            }
          },
        ),
      ),
    );
  }

  void _selectedPostImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.rectangle,
      title: 'Create Post',
    );
    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(pickedFile);
    } else {
      print('Mantap djiwa');
    }
  }

  void _submitForm(BuildContext context, File postImage, bool isSubmitting) {
    if (_formKey.currentState!.validate() &&
        postImage != null &&
        !isSubmitting) {
      context.read<CreatePostCubit>().submit();
    }
  }
}
