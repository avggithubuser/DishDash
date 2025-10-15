import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dish_dash/data/models/restaurant_model.dart';
import 'package:dish_dash/data/repositories/restaurant_repository.dart';

// get repo
final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  return RestaurantRepository();
});

// Stream
final restaurantsStreamProvider = StreamProvider<List<Restaurant>>((ref) {
  final repo = ref.watch(restaurantRepositoryProvider);
  return repo.getRestaurants();
});

/// single resto provider
final restaurantByIdProvider = FutureProvider.family<Restaurant?, String>((
  ref,
  id,
) {
  final repo = ref.watch(restaurantRepositoryProvider);
  return repo.getRestaurantById(id);
});
