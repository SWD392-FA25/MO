import 'package:flutter/foundation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/livestream.dart';
import '../../domain/usecases/get_livestream_detail.dart';
import '../../domain/usecases/get_livestreams.dart';

class LivestreamProvider extends ChangeNotifier {
  final GetLivestreams getLivestreamsUseCase;
  final GetLivestreamDetail getLivestreamDetailUseCase;

  LivestreamProvider({
    required this.getLivestreamsUseCase,
    required this.getLivestreamDetailUseCase,
  });

  // State
  List<Livestream> _livestreams = [];
  Livestream? _selectedLivestream;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Livestream> get livestreams => _livestreams;
  List<Livestream> get liveLivestreams =>
      _livestreams.where((ls) => ls.isLive).toList();
  List<Livestream> get upcomingLivestreams =>
      _livestreams.where((ls) => ls.isUpcoming).toList();
  Livestream? get selectedLivestream => _selectedLivestream;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load livestreams
  Future<void> loadLivestreams({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _livestreams = [];
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getLivestreamsUseCase.call(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (livestreams) {
        _livestreams = livestreams;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load livestream detail
  Future<void> loadLivestreamDetail(String livestreamId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getLivestreamDetailUseCase.call(livestreamId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (livestream) {
        _selectedLivestream = livestream;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Refresh
  Future<void> refresh() async {
    await loadLivestreams(refresh: true);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
