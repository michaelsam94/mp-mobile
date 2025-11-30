import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';
import 'package:mega_plus/presentation/vehicles/models/brand_response_model.dart';
import 'package:mega_plus/presentation/vehicles/models/connector_response_model.dart';
import 'package:mega_plus/presentation/vehicles/models/model_response_model.dart';
import 'package:mega_plus/presentation/vehicles/models/vehicle_response_model.dart';
import 'package:meta/meta.dart';

part 'vehicles_state.dart';

class VehiclesCubit extends Cubit<VehiclesState> {
  VehiclesCubit() : super(VehiclesInitial());

  static VehiclesCubit get(context) => BlocProvider.of(context);

  BrandResponseModel? selectedBrand;
  ModelResponseModel? selectedModel;
  ConnectorResponseModel? selectedConnector;
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
        getConnectors();
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

  List<ConnectorResponseModel> connectors = [];
  void getConnectors() async {
    emit(LoadingGetBrandsVehiclesState());
    try {
      var response = await DioHelper.getData(url: EndPoints.connectors);

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        connectors = data
            .map((e) => ConnectorResponseModel.fromJson(e))
            .toList();

        selectedConnector = null;

        emit(SuccessGetBrandsVehiclesState());
      } else {
        emit(ErrorGetBrandsVehiclesState());
      }
    } catch (e) {
      emit(ErrorGetBrandsVehiclesState());
    }
  }

  void selectConnector(ConnectorResponseModel? newConnector) {
    emit(StartSelectModelVehiclesState());
    selectedConnector = newConnector;
    emit(EndSelectModelVehiclesState());
  }

  void addVehicle() async {
    emit(LoadingAddVehiclesState());
    try {
      var response = await DioHelper.postData(
        url: EndPoints.addVehicle,
        data: FormData.fromMap({
          "brand_model_id": selectedModel!.id,
          "connector_type": selectedConnector!.type,
          "path": "customerVehicle",
          "media": plateImage == null
              ? null
              : await MultipartFile.fromFile(plateImage!.path),
        }),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        emit(SuccessAddVehiclesState());
      } else {
        emit(
          ErrorAddVehiclesState(response.data["errors"]["connector_type"][0]),
        );
      }
    } catch (e) {
      emit(ErrorAddVehiclesState("Please try again"));
    }
  }

  List<VehicleResponseModel> vehicles = [];
  void getVehicles() async {
    emit(LoadingGetVehiclesState());
    try {
      var response = await DioHelper.getData(url: EndPoints.getVehicles);

      if (response.statusCode == 200 && response.data["success"] == true) {
        var data = response.data["data"] as List;
        vehicles = data.map((e) => VehicleResponseModel.fromJson(e)).toList();

        emit(SuccessGetVehiclesState());
      } else {
        emit(ErrorGetVehiclesState());
      }
    } catch (e) {
      emit(ErrorGetVehiclesState());
    }
  }
}
