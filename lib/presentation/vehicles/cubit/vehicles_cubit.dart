import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/vehicles/models/brand_response_model.dart';
import 'package:mega_plus/presentation/vehicles/models/model_response_model.dart';
import 'package:meta/meta.dart';

part 'vehicles_state.dart';

class VehiclesCubit extends Cubit<VehiclesState> {
  VehiclesCubit() : super(VehiclesInitial());

  static VehiclesCubit get(context) => BlocProvider.of(context);

  BrandResponseModel? selectedBrand;
  ModelResponseModel? selectedModel;
  // String? selectedConnector;
  File? plateImage;

  List<BrandResponseModel> brands = [];
  void getBrands() async {
    emit(LoadingGetBrandsVehiclesState());
    try {
      var response = await DioHelper.getData(url: EndPoints.brands);

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        brands = data.map((e) => BrandResponseModel.fromJson(e)).toList();
        selectedBrand = null;
        selectedModel = null;
        emit(SuccessGetBrandsVehiclesState());
      } else {
        emit(ErrorGetBrandsVehiclesState());
      }
    } catch (e) {
      emit(ErrorGetBrandsVehiclesState());
    }
  }

  List<ModelResponseModel> models = [];
  void selectBrand(BrandResponseModel? newBrand) async {
    selectedBrand = newBrand;
    models = [];
    selectedModel = null;
    emit(LoadingGetModelsVehiclesState());
    if (selectedBrand == null) {
      return;
    }
    try {
      var response = await DioHelper.getData(
        url: EndPoints.models(selectedBrand?.id ?? 0),
      );
      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        models = data.map((e) => ModelResponseModel.fromJson(e)).toList();

        selectedModel = null;
        emit(SuccessGetModelsVehiclesState());
      } else {
        emit(ErrorGetModelsVehiclesState());
      }
    } catch (e) {
      emit(ErrorGetModelsVehiclesState());
    }
  }

  void selectModel(ModelResponseModel? newModel) {
    emit(StartSelectModelVehiclesState());
    selectedModel = newModel;
    emit(EndSelectModelVehiclesState());
  }

  void chooseImage() async {
    emit(StartChoosePlateImageVehiclesState());
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      plateImage = File(pickedFile.path);
    }
    emit(EndChoosePlateImageVehiclesState());
  }
}
