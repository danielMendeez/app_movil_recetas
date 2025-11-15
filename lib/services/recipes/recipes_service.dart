import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../auth/secure_storage_service.dart';
import '../../models/recipe.dart';

class RecipesService {
  late final Dio _dio;

  RecipesService() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8000/api';

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );

    /// INTERCEPTOR → agrega token automáticamente
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );
  }

  // LISTAR RECETAS RANDOM
  // LISTAR RECETAS RANDOM
  Future<List<Recipe>> getRandomRecipes() async {
    try {
      final response = await _dio.get('/recetas/random');

      if (response.statusCode == 200) {
        // print("DATA TYPE: ${response.data.runtimeType}");
        // print("Cantidad de recetas: ${response.data.length}");

        // La respuesta es directamente una List<dynamic>
        final List<dynamic> recipesData = response.data;

        // Mapear cada elemento de la lista a un objeto Recipe
        return recipesData.map<Recipe>((recipeJson) {
          return Recipe.fromJson(recipeJson);
        }).toList();
      } else {
        throw Exception('No se pudieron obtener las recetas.');
      }
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // DAR LIKE A UNA RECETA
  Future<bool> likeRecipe({
    required int recetaId,
    required String tituloReceta,
    required String imagenUrl,
  }) async {
    try {
      final response = await _dio.post(
        '/recetas/like',
        data: {
          'receta_id': recetaId.toString(),
          'titulo_receta': tituloReceta,
          'imagen_url': imagenUrl,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      final msg = e.response?.data['mensaje'] ?? 'No se pudo marcar la receta.';
      throw Exception(msg);
    }
  }

  // LISTAR FAVORITOS
  Future<List<Recipe>> getFavorites() async {
    try {
      final response = await _dio.get('/recetas/likes');

      if (response.statusCode == 200) {
        final list = response.data['likes'] ?? response.data;
        return List<Recipe>.from(list.map((r) => Recipe.fromJson(r)));
      } else {
        throw Exception('No se pudieron obtener los favoritos.');
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data['mensaje'] ??
          'Ocurrió un error al obtener tus favoritos.';
      throw Exception(msg);
    }
  }

  // ELIMINAR FAVORITO
  Future<bool> removeFavorite(int id) async {
    try {
      final response = await _dio.delete('/recetas/eliminar_like/$id');

      return response.statusCode == 200;
    } on DioException catch (e) {
      final msg =
          e.response?.data['mensaje'] ?? 'No se pudo eliminar la receta.';
      throw Exception(msg);
    }
  }
}
