import 'package:equatable/equatable.dart';

sealed class StrainEvent extends Equatable {
  const StrainEvent();

  @override
  List<Object?> get props => [];
}

final class DeleteStrainRequested extends StrainEvent {
  final String plantId;

  const DeleteStrainRequested(this.plantId);

  @override
  List<Object?> get props => [plantId];
}
