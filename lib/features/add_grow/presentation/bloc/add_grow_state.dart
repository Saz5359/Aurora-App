part of 'add_grow_bloc.dart';

sealed class AddGrowState extends Equatable {
  const AddGrowState();
  @override
  List<Object?> get props => [];
}

final class AddGrowInitial extends AddGrowState {}

final class AddGrowStepSuccess extends AddGrowState {
  final GrowForm form;
  const AddGrowStepSuccess(this.form);
  @override
  List<Object?> get props => [form];
}

final class AddGrowSubmissionInProgress extends AddGrowState {}

final class AddGrowSubmissionSuccess extends AddGrowState {}

class AddGrowSubmissionFailure extends AddGrowState {
  final AppErrorType errorType;
  final String message;
  const AddGrowSubmissionFailure({
    required this.errorType,
    required this.message,
  });
  @override
  List<Object?> get props => [errorType, message];
}
