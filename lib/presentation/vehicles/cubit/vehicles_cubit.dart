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
  VehicleResponseModel? editingVehicle;
  String? plateNumber;
  int? year;
  String? color;

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
        getVehicles();
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

  // Initialize vehicle data for editing
  void initializeVehicleForEdit(VehicleResponseModel vehicle) {
    editingVehicle = vehicle;
    plateNumber = vehicle.plateNumber;
    year = vehicle.year;
    color = vehicle.color;
    
    // Find and select brand
    if (vehicle.brandModel?.brand != null && brands.isNotEmpty) {
      selectedBrand = brands.firstWhere(
        (b) => b.id == vehicle.brandModel!.brand!.id,
        orElse: () => vehicle.brandModel!.brand!,
      );
      // Load models for the selected brand
      if (selectedBrand != null) {
        selectBrand(selectedBrand);
        // After models are loaded, select the model
        Future.delayed(Duration(milliseconds: 300), () {
          if (models.isNotEmpty) {
            selectedModel = models.firstWhere(
              (m) => m.id == vehicle.brandModelId,
              orElse: () => models.first,
            );
            emit(EndSelectModelVehiclesState());
          }
        });
      }
    }
    
    // Find and select connector
    if (connectors.isNotEmpty) {
      selectedConnector = connectors.firstWhere(
        (c) => c.type == vehicle.connectorType,
        orElse: () => connectors.firstWhere(
          (c) => c.type == vehicle.connectorType,
          orElse: () => connectors.first,
        ),
      );
      emit(EndSelectModelVehiclesState());
    }
  }

  // Reset edit state
  void resetEditState() {
    editingVehicle = null;
    plateNumber = null;
    year = null;
    color = null;
    selectedBrand = null;
    selectedModel = null;
    selectedConnector = null;
    plateImage = null;
  }

  void editVehicle() async {
    if (editingVehicle == null) return;
    
    emit(LoadingUpdateVehiclesState());
    try {
      var response = await DioHelper.patchData(
        url: EndPoints.updateVehicle(editingVehicle!.id!),
        data: {
          "brand_model_id": selectedModel!.id,
          "plate_number": plateNumber ?? "",
          "connector_type": selectedConnector!.type,
          "year": year,
          "color": color ?? "",
        },
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        emit(SuccessUpdateVehiclesState());
        getVehicles();
        resetEditState();
      } else {
        emit(ErrorUpdateVehiclesState(
          response.data["message"] ?? "Failed to update vehicle",
        ));
      }
    } catch (e) {
      emit(ErrorUpdateVehiclesState("Please try again"));
    }
  }

  void deleteVehicle(int vehicleId) async {
    emit(LoadingDeleteVehiclesState());
    try {
      var response = await DioHelper.deleteData(
        url: EndPoints.deleteVehicle(vehicleId),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        // Remove vehicle from list
        vehicles.removeWhere((v) => v.id == vehicleId);
        emit(SuccessDeleteVehiclesState());
        // Refresh vehicles list
        getVehicles();
      } else {
        emit(ErrorDeleteVehiclesState(
          response.data["message"] ?? "Failed to delete vehicle",
        ));
      }
    } catch (e) {
      emit(ErrorDeleteVehiclesState("Please try again"));
    }
  }
}
