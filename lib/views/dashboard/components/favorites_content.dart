import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/recipes_viewmodel.dart';

class FavoritesContent extends StatefulWidget {
  const FavoritesContent({super.key});

  @override
  State<FavoritesContent> createState() => _FavoritesContentState();
}

class _FavoritesContentState extends State<FavoritesContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<RecipesViewModel>(
        context,
        listen: false,
      ).cargarFavoritos(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipesViewModel>(
      builder: (context, vm, child) {
        if (vm.favoritos.isEmpty) {
          return Center(
            child: Text(
              'No has agregado favoritos',
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: vm.favoritos.length,
          itemBuilder: (_, i) {
            final r = vm.favoritos[i];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Placeholder icon (image removed due to CORS)
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.orange.shade100,
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 30,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Title, diet info, and details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.titulo_receta,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Wrap(
                            spacing: 6,
                            children: [
                              if (r.vegana)
                                Chip(
                                  label: const Text('Vegano'),
                                  backgroundColor: Colors.orange.shade50,
                                  side: BorderSide(
                                    color: Colors.orange.shade200,
                                  ),
                                ),
                              if (r.vegetariana)
                                Chip(
                                  label: const Text('Vegetariano'),
                                  backgroundColor: Colors.orange.shade50,
                                  side: BorderSide(
                                    color: Colors.orange.shade200,
                                  ),
                                ),
                              if (r.sinGluten)
                                Chip(
                                  label: const Text('Sin Gluten'),
                                  backgroundColor: Colors.orange.shade50,
                                  side: BorderSide(
                                    color: Colors.orange.shade200,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 4),
                          Text(
                            '⏱️ ${r.tiempoPreparacion} min · 🍽️ ${r.porciones} porciones',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => vm.removeFavorite(r.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
