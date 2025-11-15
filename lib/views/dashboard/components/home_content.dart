import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/recipes_viewmodel.dart';
import '../../../models/user.dart';

class HomeContent extends StatefulWidget {
  final User user;

  const HomeContent({super.key, required this.user});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<RecipesViewModel>(context, listen: false).cargarRecetas(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipesViewModel>(
      builder: (context, vm, child) {
        if (vm.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.errorMessage != null) {
          return Center(child: Text(vm.errorMessage!));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.recetas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (_, i) {
            final r = vm.recetas[i];

            return Card(
              color: Colors.orange.shade50,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Icon(
                      Icons.fastfood,
                      size: 48,
                      color: Colors.orange.shade400,
                    ),
                    const SizedBox(height: 12),

                    /// El título de la receta
                    Expanded(
                      child: Text(
                        r.titulo,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Barra inferior con precio + favorito
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '\$${r.precioPorPorcion.toStringAsFixed(2)} / porción',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            vm.like(r);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Agregado a favoritos'),
                              ),
                            );
                          },
                        ),
                      ],
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
