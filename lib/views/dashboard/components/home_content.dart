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
            childAspectRatio: 0.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (_, i) {
            final r = vm.recetas[i];
            return Card(
              child: Column(
                children: [
                  Image.network(r.imagenUrl, height: 120, fit: BoxFit.cover),
                  Text(r.titulo, maxLines: 2, overflow: TextOverflow.ellipsis),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      vm.like(r);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Agregado a favoritos')),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
