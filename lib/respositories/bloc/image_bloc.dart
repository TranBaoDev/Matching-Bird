import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiki/respositories/databerepository.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final DatabaseRepository _databaseRepository;
  StreamSubscription? databaseSubscription;

  ImageBloc({
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        super(ImagesLoading());

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is LoadImage) {
      yield* _mapLoadImagesToState();
    }
    if (event is UpdateImages) {
      yield* _mapUpdateImagesToState(event);
    }
    if (event is ImagesError) {
      yield* _mapImagesErrorToState(event);
    }
  }

  Stream<ImageState> _mapLoadImagesToState() async* {
  // Cancel the existing subscription if it exists
  await databaseSubscription?.cancel();

  // Subscribe to user data stream and handle errors
  databaseSubscription = _databaseRepository
      .getUser()
      .listen(
        (user) {
          // Cast the List<dynamic> to List<String> if necessary
          add(UpdateImages(imageUrls: List<String>.from(user.imageUrls ?? [])));
        },
        onError: (error) {
          // Emit ImagesError state if there's an error
          add(ImagesError(error.toString()));
        },
      );
}


  Stream<ImageState> _mapUpdateImagesToState(UpdateImages event) async* {
    yield ImagesLoaded(imageUrls: event.imageUrls);
  }

  Stream<ImageState> _mapImagesErrorToState(ImagesError event) async* {
    yield ImagesErrorState(errorMessage: event.errorMessage);
  }

  @override
  Future<void> close() async {
    await databaseSubscription?.cancel();
    super.close();
  }
}
