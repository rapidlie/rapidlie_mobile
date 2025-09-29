import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rapidlie/features/categories/bloc/category_bloc.dart';
import 'package:rapidlie/features/categories/repository/category_repository.dart';
import 'package:rapidlie/features/contacts/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:rapidlie/features/contacts/blocs/flockr_contacts_bloc/telephone_numbers_bloc.dart';
import 'package:rapidlie/features/contacts/repository/telephone_numbers_repository.dart';
import 'package:rapidlie/features/events/blocs/create_bloc/create_event_bloc.dart';
import 'package:rapidlie/features/events/blocs/event_detail_bloc/event_detail_bloc.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';
import 'package:rapidlie/features/events/blocs/give_consent_bloc/consent_bloc.dart';
import 'package:rapidlie/features/events/blocs/invite_contact_bloc/invite_contact_bloc.dart';
import 'package:rapidlie/features/events/blocs/like_bloc/like_event_bloc.dart';
import 'package:rapidlie/features/events/blocs/unlike_bloc/unlike_event_bloc.dart';
import 'package:rapidlie/features/events/provider/create_event_provider.dart';
import 'package:rapidlie/features/events/repository/consent_repository.dart';
import 'package:rapidlie/features/events/repository/create_event_repository.dart';
import 'package:rapidlie/features/events/repository/event_detail_respository.dart';
import 'package:rapidlie/features/events/repository/event_respository.dart';
import 'package:rapidlie/features/events/repository/invite_contact_repository.dart';
import 'package:rapidlie/features/events/repository/like_event_repository.dart';
import 'package:rapidlie/features/events/repository/unlike_event_repository.dart';
import 'package:rapidlie/features/file_upload/bloc/file_upload_bloc.dart';
import 'package:rapidlie/features/file_upload/repository/file_upload_repository.dart';
import 'package:rapidlie/features/login/bloc/login_bloc.dart';
import 'package:rapidlie/features/login/repository/login_repository.dart';
import 'package:rapidlie/features/logout/bloc/logout_bloc.dart';
import 'package:rapidlie/features/logout/repository/logout_repository.dart';
import 'package:rapidlie/features/otp/repository/resend_otp_repository.dart';
import 'package:rapidlie/features/otp/repository/verify_otp_repositoy.dart';
import 'package:rapidlie/features/otp/resend_bloc/resend_otp_bloc.dart';
import 'package:rapidlie/features/otp/verify_bloc/verify_otp_bloc.dart';
import 'package:rapidlie/features/password/blocs/change_password_bloc/change_password_bloc.dart';
import 'package:rapidlie/features/password/blocs/new_password_bloc/new_password_bloc.dart';
import 'package:rapidlie/features/password/blocs/request_reset_bloc/request_bloc.dart';
import 'package:rapidlie/features/password/repositories/change_password_repository.dart';
import 'package:rapidlie/features/password/repositories/new_password_repository.dart';
import 'package:rapidlie/features/password/repositories/request_repository.dart';
import 'package:rapidlie/features/register/bloc/register_bloc.dart';
import 'package:rapidlie/features/register/repository/register_repository.dart';
import 'package:rapidlie/features/settings/blocs/delete_account_bloc/delete_account_bloc.dart';
import 'package:rapidlie/features/settings/blocs/profile_bloc/profile_bloc.dart';
import 'package:rapidlie/features/settings/providers/change_language_provider.dart';
import 'package:rapidlie/features/settings/repositories/delete_account_repository.dart';
import 'package:rapidlie/features/settings/repositories/profile_repository.dart';
import 'package:rapidlie/injection_container.dart'; // Replace with actual imports

final List<SingleChildWidget> providers = [
  Provider<EventRepository>(
    create: (_) => EventRepositoryImpl(Dio()),
  ),
  BlocProvider<PrivateEventBloc>(
    create: (context) {
      final eventRepository = locator<EventRepository>();
      return PrivateEventBloc(eventRepository: eventRepository);
    },
  ),
  BlocProvider<PublicEventBloc>(
    create: (context) {
      final eventRepository = locator<EventRepository>();
      return PublicEventBloc(eventRepository: eventRepository);
    },
  ),
  BlocProvider<InvitedEventBloc>(
    create: (context) {
      final eventRepository = locator<EventRepository>();
      return InvitedEventBloc(eventRepository: eventRepository);
    },
  ),
  BlocProvider<UpcomingEventBloc>(
    create: (context) {
      final eventRepository = locator<EventRepository>();
      return UpcomingEventBloc(eventRepository: eventRepository);
    },
  ),
  BlocProvider<EventByCategoryBloc>(
    create: (context) {
      final eventRepository = locator<EventRepository>();
      return EventByCategoryBloc(eventRepository: eventRepository);
    },
  ),
  Provider<EventDetailRepository>(
    create: (_) => EventDetailRepository(Dio()), // use your implementation
  ),
  BlocProvider(
    create: (context) => EventDetailBloc(
      eventdetailRepository: EventDetailRepository(Dio()),
    ),
  ),
  BlocProvider(
    create: (context) =>
        ProfileBloc(profileRepository: ProfileRepository(dio: Dio())),
  ),
  BlocProvider<VerifyOtpBloc>(
    create: (context) => VerifyOtpBloc(
      verifyOtpRepository: VerifyOtpRepository(dio: Dio()),
    ),
  ),
  BlocProvider(
    create: (context) => RegisterBloc(
      registerRepository: RegisterRepository(dio: Dio()),
    ),
  ),
  BlocProvider(
    create: (context) => LoginBloc(
      loginRepository: LoginRepository(dio: Dio()),
    ),
  ),
  BlocProvider(
    create: (context) => LogoutBloc(
      logoutRepository: LogoutRepository(dio: Dio()),
    ),
  ),
  BlocProvider(
    create: (context) => ResendOtpBloc(
      resendOtpRepository: ResendOtpRepository(dio: Dio()),
    ),
  ),
  BlocProvider(
    create: (context) => ChangePasswordBloc(
      changePasswordRepository: ChangePasswordRepository(dio: Dio()),
    ),
  ),
  BlocProvider(
    create: (context) => CategoryBloc(
      categoryRepository: CategoryRepository(dio: Dio()),
    ),
  ),
  BlocProvider(
    create: (context) {
      final telephoneNumbersRepository = locator<TelephoneNumbersRepository>();
      return TelephoneNumbersBloc(
          telephoneNumbersRepository: telephoneNumbersRepository);
    },
  ),
  BlocProvider(
    create: (context) => FileUploadBloc(
      fileUploadRepository: FileUploadRepository(dio: Dio()),
    ),
  ),
  BlocProvider(
    create: (context) => CreateEventBloc(CreateEventRepository(dio: Dio())),
  ),
  BlocProvider(
    create: (context) => InviteContactBloc(InviteContactRepository(dio: Dio())),
  ),
  BlocProvider(
    create: (context) =>
        LikeEventBloc(likeEventRepository: LikeEventRepository(dio: Dio())),
  ),
  BlocProvider(
    create: (context) => UnlikeEventBloc(
        unlikeEventRepository: UnlikeEventRepository(dio: Dio())),
  ),
  BlocProvider(
    create: (context) =>
        RequestBloc(requestRepository: RequestRepository(dio: Dio())),
  ),
  BlocProvider(
    create: (context) => NewPasswordBloc(
        newPasswordRepository: NewPasswordRepository(dio: Dio())),
  ),
  BlocProvider(
    create: (context) =>
        ConsentBloc(consentRepository: ConsentRepository(dio: Dio())),
  ),
  BlocProvider(
    create: (context) => DeleteAccountBloc(
        deleteAccoutRepository: DeleteAccountRepository(dio: Dio())),
  ),
  BlocProvider(
    create: (context) => ContactsBloc(),
  ),
  ChangeNotifierProvider(
    create: (context) => ChangeLanguageProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => CreateEventProvider(),
  ),
  // Add more providers as needed
];
