class Recipe {
  final int id;
  final String titulo;
  final String titulo_receta;
  final String imagenUrl;
  final int tiempoPreparacion;
  final int porciones;
  final bool vegetariana;
  final bool vegana;
  final bool sinGluten;
  final bool sinLacteos;
  final double precioPorPorcion;
  final String resumen;
  final List<String> tiposPlato;
  final List<String> dietas;
  final List<Ingrediente> ingredientes;
  final List<PasoInstruccion> instrucciones;
  final bool esFavorito;

  Recipe({
    required this.id,
    required this.titulo,
    required this.titulo_receta,
    required this.imagenUrl,
    required this.tiempoPreparacion,
    required this.porciones,
    required this.vegetariana,
    required this.vegana,
    required this.sinGluten,
    required this.sinLacteos,
    required this.precioPorPorcion,
    required this.resumen,
    required this.tiposPlato,
    required this.dietas,
    required this.ingredientes,
    required this.instrucciones,
    this.esFavorito = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      titulo: json['title'] ?? '',
      titulo_receta: json['titulo_receta'] ?? '',
      imagenUrl: json['image'] ?? '',
      tiempoPreparacion: json['readyInMinutes'] ?? 0,
      porciones: json['servings'] ?? 1,
      vegetariana: json['vegetarian'] ?? false,
      vegana: json['vegan'] ?? false,
      sinGluten: json['glutenFree'] ?? false,
      sinLacteos: json['dairyFree'] ?? false,
      precioPorPorcion: (json['pricePerServing'] ?? 0.0).toDouble(),
      resumen: json['summary'] ?? '',
      tiposPlato: List<String>.from(json['dishTypes'] ?? []),
      dietas: List<String>.from(json['diets'] ?? []),
      ingredientes:
          (json['extendedIngredients'] as List<dynamic>?)
              ?.map((ing) => Ingrediente.fromJson(ing))
              .toList() ??
          [],
      instrucciones: _parseInstrucciones(json),
      esFavorito: json['es_favorito'] ?? false,
    );
  }

  static List<PasoInstruccion> _parseInstrucciones(Map<String, dynamic> json) {
    final List<PasoInstruccion> instrucciones = [];

    if (json['analyzedInstructions'] != null) {
      for (var instruction in json['analyzedInstructions']) {
        if (instruction['steps'] != null) {
          for (var step in instruction['steps']) {
            instrucciones.add(PasoInstruccion.fromJson(step));
          }
        }
      }
    }

    // Si no hay instrucciones analizadas, usar las instrucciones simples
    if (instrucciones.isEmpty && json['instructions'] != null) {
      final String instructionsText = json['instructions'];
      final List<String> steps = instructionsText
          .split('\n')
          .where((step) => step.trim().isNotEmpty)
          .toList();

      for (int i = 0; i < steps.length; i++) {
        instrucciones.add(
          PasoInstruccion(
            numero: i + 1,
            paso: steps[i].trim(),
            ingredientes: [],
          ),
        );
      }
    }

    return instrucciones;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'titulo_receta': titulo_receta,
      'imagenUrl': imagenUrl,
      'tiempoPreparacion': tiempoPreparacion,
      'porciones': porciones,
      'vegetariana': vegetariana,
      'vegana': vegana,
      'sinGluten': sinGluten,
      'sinLacteos': sinLacteos,
      'precioPorPorcion': precioPorPorcion,
      'resumen': resumen,
      'tiposPlato': tiposPlato,
      'dietas': dietas,
      'ingredientes': ingredientes.map((ing) => ing.toJson()).toList(),
      'instrucciones': instrucciones.map((inst) => inst.toJson()).toList(),
      'esFavorito': esFavorito,
    };
  }

  Recipe copyWith({
    int? id,
    String? titulo,
    String? imagenUrl,
    int? tiempoPreparacion,
    int? porciones,
    bool? vegetariana,
    bool? vegana,
    bool? sinGluten,
    bool? sinLacteos,
    double? precioPorPorcion,
    String? resumen,
    List<String>? tiposPlato,
    List<String>? dietas,
    List<Ingrediente>? ingredientes,
    List<PasoInstruccion>? instrucciones,
    bool? esFavorito,
  }) {
    return Recipe(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      titulo_receta: titulo_receta ?? this.titulo_receta,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      tiempoPreparacion: tiempoPreparacion ?? this.tiempoPreparacion,
      porciones: porciones ?? this.porciones,
      vegetariana: vegetariana ?? this.vegetariana,
      vegana: vegana ?? this.vegana,
      sinGluten: sinGluten ?? this.sinGluten,
      sinLacteos: sinLacteos ?? this.sinLacteos,
      precioPorPorcion: precioPorPorcion ?? this.precioPorPorcion,
      resumen: resumen ?? this.resumen,
      tiposPlato: tiposPlato ?? this.tiposPlato,
      dietas: dietas ?? this.dietas,
      ingredientes: ingredientes ?? this.ingredientes,
      instrucciones: instrucciones ?? this.instrucciones,
      esFavorito: esFavorito ?? this.esFavorito,
    );
  }
}

class Ingrediente {
  final int id;
  final String nombre;
  final String nombreLimpio;
  final double cantidad;
  final String unidad;
  final String? imagen;

  Ingrediente({
    required this.id,
    required this.nombre,
    required this.nombreLimpio,
    required this.cantidad,
    required this.unidad,
    this.imagen,
  });

  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    return Ingrediente(
      id: json['id'] ?? 0,
      nombre: json['name'] ?? '',
      nombreLimpio: json['nameClean'] ?? json['name'] ?? '',
      cantidad: (json['amount'] ?? 0.0).toDouble(),
      unidad: json['unit'] ?? '',
      imagen: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'nombreLimpio': nombreLimpio,
      'cantidad': cantidad,
      'unidad': unidad,
      'imagen': imagen,
    };
  }
}

class PasoInstruccion {
  final int numero;
  final String paso;
  final List<IngredientePaso> ingredientes;

  PasoInstruccion({
    required this.numero,
    required this.paso,
    required this.ingredientes,
  });

  factory PasoInstruccion.fromJson(Map<String, dynamic> json) {
    return PasoInstruccion(
      numero: json['number'] ?? 0,
      paso: json['step'] ?? '',
      ingredientes:
          (json['ingredients'] as List<dynamic>?)
              ?.map((ing) => IngredientePaso.fromJson(ing))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'paso': paso,
      'ingredientes': ingredientes.map((ing) => ing.toJson()).toList(),
    };
  }
}

class IngredientePaso {
  final int id;
  final String nombre;
  final String? imagen;

  IngredientePaso({required this.id, required this.nombre, this.imagen});

  factory IngredientePaso.fromJson(Map<String, dynamic> json) {
    return IngredientePaso(
      id: json['id'] ?? 0,
      nombre: json['name'] ?? '',
      imagen: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'imagen': imagen};
  }
}
