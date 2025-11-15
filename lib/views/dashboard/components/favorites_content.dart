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
          return const Center(child: Text('No has agregado favoritos'));
        }

        return ListView.builder(
          itemCount: vm.favoritos.length,
          itemBuilder: (_, i) {
            final r = vm.favoritos[i];
            return ListTile(
              leading: Image.network(r.imagenUrl, width: 60),
              title: Text(r.titulo),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => vm.removeFavorite(r.id),
              ),
            );
          },
        );
      },
    );
  }
}
