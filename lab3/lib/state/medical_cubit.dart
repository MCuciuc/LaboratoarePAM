import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2/data/models/appointment.dart';
import 'package:lab2/data/repositories/medical_repository.dart';
import 'package:lab2/state/medical_state.dart';

class MedicalCubit extends Cubit<MedicalState> {
  MedicalCubit(this._repository, {this.bookingDelay = const Duration(milliseconds: 700)})
    : super(const MedicalState());

  final MedicalRepository _repository;
  final Duration bookingDelay;

  Future<void> load({bool fail = false}) async {
    final favoriteIds = <String>{
      for (final doctor in state.doctors)
        if (doctor.isFavorite) doctor.id,
    };
    emit(state.copyWith(status: PageStatus.loading, clearError: true));
    try {
      final data = await _repository.load(fail: fail);
      emit(
        state.copyWith(
          status: PageStatus.success,
          clearError: true,
          user: data.user,
          hasUnreadNotifications: data.hasUnreadNotifications,
          searchHint: data.searchHint,
          appointment: data.appointment,
          details: data.details,
          services: data.services,
          doctors: [
            for (final doctor in data.doctors)
              doctor.copyWith(isFavorite: doctor.isFavorite || favoriteIds.contains(doctor.id)),
          ],
          selectedTimeSlotId: state.selectedTimeSlotId ?? AppointmentDetails.initialId(data.details.hours),
          selectedDateSlotId: state.selectedDateSlotId ?? AppointmentDetails.initialId(data.details.dates),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PageStatus.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void setQuery(String query) => emit(state.copyWith(query: query));

  void setSpecialty(String? specialty) {
    emit(state.copyWith(specialtyFilter: specialty, clearSpecialty: specialty == null));
  }

  void setService(String? serviceId) {
    emit(state.copyWith(serviceFilter: serviceId, clearService: serviceId == null));
  }

  void clearService() => emit(state.copyWith(clearService: true));

  void setSort(DoctorSort sort) => emit(state.copyWith(sort: sort));

  void setFavoritesOnly(bool value) => emit(state.copyWith(favoritesOnly: value));

  void clearFilters() {
    emit(
      state.copyWith(
        query: '',
        clearSpecialty: true,
        clearService: true,
        favoritesOnly: false,
        sort: DoctorSort.nameAsc,
      ),
    );
  }

  void toggleFavorite(String id) {
    emit(
      state.copyWith(
        doctors: [
          for (final doctor in state.doctors)
            if (doctor.id == id) doctor.copyWith(isFavorite: !doctor.isFavorite) else doctor,
        ],
      ),
    );
  }

  void selectTime(String id) => emit(state.copyWith(selectedTimeSlotId: id));

  void selectDate(String id) => emit(state.copyWith(selectedDateSlotId: id));

  Future<void> bookAppointment() async {
    if (state.bookingStatus == BookingStatus.submitting) return;
    final details = state.details;
    final time = details?.hourLabel(state.selectedTimeSlotId);
    final date = details?.dateLabel(state.selectedDateSlotId);
    if (details == null || !details.bookEnabled || time == null || date == null) {
      emit(
        state.copyWith(
          bookingStatus: BookingStatus.failure,
          bookingMessage: 'Choose a working hour and a date first.',
        ),
      );
      return;
    }

    emit(state.copyWith(bookingStatus: BookingStatus.submitting, clearBookingMessage: true));
    if (bookingDelay > Duration.zero) {
      await Future<void>.delayed(bookingDelay);
    } else {
      await Future<void>.value();
    }
    if (isClosed) return;
    emit(
      state.copyWith(
        bookingStatus: BookingStatus.success,
        bookingMessage: 'Appointment booked for $date at $time.',
      ),
    );
  }

  void acknowledgeBooking() {
    if (state.bookingStatus == BookingStatus.idle) return;
    emit(state.copyWith(bookingStatus: BookingStatus.idle, clearBookingMessage: true));
  }
}
