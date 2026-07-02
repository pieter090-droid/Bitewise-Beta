import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bitewise/core/router/app_router.dart';
import 'package:bitewise/core/theme/app_colors.dart';
import 'package:bitewise/features/favorites/data/favorites_repository.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorieten')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (favorites) {
          if (favorites.isEmpty) {
            return const _EmptyState();
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final fav = favorites[i];
              return Card(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.mist,
                    child: Icon(Icons.favorite, color: AppColors.danger, size: 20),
                  ),
                  title: Text(fav.name),
                  subtitle: Text('Barcode ${fav.barcode}',
                      style: const TextStyle(fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.slate),
                    onPressed: () => ref
                        .read(favoritesRepositoryProvider)
                        .remove(fav.barcode),
                  ),
                  onTap: () => context.push(Routes.product(fav.barcode)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 48, color: AppColors.slate),
            SizedBox(height: 12),
            Text(
              'Nog geen favorieten.\nTik op het hartje bij een product om het te bewaren.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.slate),
            ),
          ],
        ),
      ),
    );
  }
}
