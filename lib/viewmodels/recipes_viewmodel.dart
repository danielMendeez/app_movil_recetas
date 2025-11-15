import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipes/recipes_service.dart';

class RecipesViewModel extends ChangeNotifier {
  final RecipesService _service = RecipesService();

  List<Recipe> recetas = [];
  List<Recipe> favoritos = [];

  bool loading = false;
  String? errorMessage;

  /// Carga recetas random
  Future<void> cargarRecetas() async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      recetas = await _service.getRandomRecipes();
    } catch (e) {
      errorMessage = 'No se pudieron cargar las recetas';
    }

    loading = false;
    notifyListeners();
  }

  /// Carga favoritos
  Future<void> cargarFavoritos() async {
    try {
      favoritos = await _service.getFavorites();
      notifyListeners();
    } catch (e) {
      errorMessage = 'No se pudieron cargar los favoritos';
      notifyListeners();
    }
  }

  /// Like
  Future<void> like(Recipe recipe) async {
    await _service.likeRecipe(
      recetaId: recipe.id,
      tituloReceta: recipe.titulo,
      imagenUrl: recipe.imagenUrl,
    );

    cargarFavoritos();
  }

  /// Eliminar favorito
  Future<void> removeFavorite(int id) async {
    await _service.removeFavorite(id);
    cargarFavoritos();
  }
}
