import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

/// Delivery team state
class DeliveryTeamState {
  final List<ChefDeliveryPerson> team;

  DeliveryTeamState({
    this.team = const [],
  });

  DeliveryTeamState copyWith({
    List<ChefDeliveryPerson>? team,
  }) {
    return DeliveryTeamState(
      team: team ?? this.team,
    );
  }

  /// Get available delivery persons
  List<ChefDeliveryPerson> get availablePersons {
    return team.where((person) => person.status == ChefDeliveryPersonStatus.available).toList();
  }

  /// Get busy delivery persons
  List<ChefDeliveryPerson> get busyPersons {
    return team.where((person) => person.status == ChefDeliveryPersonStatus.busy).toList();
  }

  /// Get offline delivery persons
  List<ChefDeliveryPerson> get offlinePersons {
    return team.where((person) => person.status == ChefDeliveryPersonStatus.offline).toList();
  }
}

/// Delivery team provider with state management
class DeliveryTeamNotifier extends StateNotifier<DeliveryTeamState> {
  DeliveryTeamNotifier() : super(DeliveryTeamState()) {
    _initializeMockData();
  }

  /// Initialize with mock data for development
  void _initializeMockData() {
    final mockTeam = [
      ChefDeliveryPerson(
        id: '1',
        name: 'كريم عبدالله',
        phone: '+213 555 111 222',
        email: 'karim@example.com',
        status: ChefDeliveryPersonStatus.available,
        vehicle: VehicleInfo(
          type: 'دراجة نارية',
          model: 'Honda',
          plateNumber: 'ALG-1234',
          color: 'أحمر',
        ),
        totalDeliveries: 245,
        rating: 4.8,
        joinedDate: DateTime.now().subtract(const Duration(days: 180)),
      ),
      ChefDeliveryPerson(
        id: '2',
        name: 'سارة محمد',
        phone: '+213 555 333 444',
        email: 'sara@example.com',
        status: ChefDeliveryPersonStatus.busy,
        vehicle: VehicleInfo(
          type: 'سيارة',
          model: 'Renault Clio',
          plateNumber: 'ALG-5678',
          color: 'أبيض',
        ),
        totalDeliveries: 189,
        rating: 4.9,
        joinedDate: DateTime.now().subtract(const Duration(days: 120)),
        currentOrderId: '#1236',
      ),
      ChefDeliveryPerson(
        id: '3',
        name: 'أحمد علي',
        phone: '+213 555 555 666',
        email: 'ahmed@example.com',
        status: ChefDeliveryPersonStatus.available,
        vehicle: VehicleInfo(
          type: 'دراجة نارية',
          model: 'Yamaha',
          plateNumber: 'ALG-9012',
          color: 'أسود',
        ),
        totalDeliveries: 312,
        rating: 4.7,
        joinedDate: DateTime.now().subtract(const Duration(days: 300)),
      ),
      ChefDeliveryPerson(
        id: '4',
        name: 'ليلى حسن',
        phone: '+213 555 777 888',
        email: 'leila@example.com',
        status: ChefDeliveryPersonStatus.offline,
        vehicle: VehicleInfo(
          type: 'دراجة',
          model: 'دراجة كهربائية',
          plateNumber: 'N/A',
        ),
        totalDeliveries: 98,
        rating: 4.6,
        joinedDate: DateTime.now().subtract(const Duration(days: 60)),
      ),
    ];

    state = state.copyWith(team: mockTeam);
  }

  /// Add new delivery person
  void addDeliveryPerson(ChefDeliveryPerson person) {
    state = state.copyWith(team: [...state.team, person]);
  }

  /// Update delivery person
  void updateDeliveryPerson(String personId, ChefDeliveryPerson updatedPerson) {
    final updatedTeam = state.team.map((person) {
      return person.id == personId ? updatedPerson : person;
    }).toList();

    state = state.copyWith(team: updatedTeam);
  }

  /// Remove delivery person
  void removeDeliveryPerson(String personId) {
    final updatedTeam = state.team.where((person) => person.id != personId).toList();
    state = state.copyWith(team: updatedTeam);
  }

  /// Update delivery person status
  void updateStatus(String personId, ChefDeliveryPersonStatus status) {
    final updatedTeam = state.team.map((person) {
      if (person.id == personId) {
        return person.copyWith(status: status);
      }
      return person;
    }).toList();

    state = state.copyWith(team: updatedTeam);
  }

  /// Assign order to delivery person
  void assignOrder(String personId, String orderId) {
    final updatedTeam = state.team.map((person) {
      if (person.id == personId) {
        return person.copyWith(
          currentOrderId: orderId,
          status: ChefDeliveryPersonStatus.busy,
        );
      }
      return person;
    }).toList();

    state = state.copyWith(team: updatedTeam);
  }

  /// Complete delivery for person
  void completeDelivery(String personId) {
    final updatedTeam = state.team.map((person) {
      if (person.id == personId) {
        return person.copyWith(
          currentOrderId: null,
          status: ChefDeliveryPersonStatus.available,
          totalDeliveries: person.totalDeliveries + 1,
        );
      }
      return person;
    }).toList();

    state = state.copyWith(team: updatedTeam);
  }
}

/// Provider instance
final deliveryTeamProvider = StateNotifierProvider<DeliveryTeamNotifier, DeliveryTeamState>((ref) {
  return DeliveryTeamNotifier();
});
