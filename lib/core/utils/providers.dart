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
import 'package:rapidlie/features/bookmarks/blocs/bookmark_bloc/bookmark_bloc.dart';
import 'package:rapidlie/features/bookmarks/data/bookmark_repository.dart';
import 'package:rapidlie/features/tickets/blocs/ticket_bloc/ticket_bloc.dart';
import 'package:rapidlie/features/tickets/data/repository/ticket_repository.dart';
import 'package:rapidlie/features/reels/blocs/reel_bloc/reel_bloc.dart';
import 'package:rapidlie/features/reels/data/repository/reel_repository.dart';
import 'package:rapidlie/features/polls/blocs/poll_bloc/poll_bloc.dart';
import 'package:rapidlie/features/polls/data/repository/poll_repository.dart';
import 'package:rapidlie/features/contributions/blocs/contribution_bloc/contribution_bloc.dart';
import 'package:rapidlie/features/contributions/data/repository/contribution_repository.dart';
import 'package:rapidlie/features/lens/blocs/lens_bloc/lens_bloc.dart';
import 'package:rapidlie/features/lens/data/repository/lens_repository.dart';
import 'package:rapidlie/features/sage/blocs/sage_bloc/sage_bloc.dart';
import 'package:rapidlie/features/sage/data/repository/sage_repository.dart';
import 'package:rapidlie/features/mood/blocs/mood_bloc/mood_bloc.dart';
import 'package:rapidlie/features/mood/data/repository/mood_repository.dart';
import 'package:rapidlie/features/groups/blocs/groups_bloc/groups_bloc.dart';
import 'package:rapidlie/features/groups/data/repository/group_repository.dart';
import 'package:rapidlie/features/notifications/blocs/announce_bloc/announce_bloc.dart';
import 'package:rapidlie/features/notifications/data/device_token_repository.dart';
import 'package:rapidlie/features/events/blocs/like_toggle_bloc/like_toggle_bloc.dart';
import 'package:rapidlie/features/events/provider/create_event_provider.dart';
import 'package:rapidlie/features/events/repository/consent_repository.dart';
import 'package:rapidlie/features/events/repository/create_event_repository.dart';
import 'package:rapidlie/features/events/repository/event_detail_respository.dart';
import 'package:rapidlie/features/events/repository/event_respository.dart';
import 'package:rapidlie/features/events/repository/invite_contact_repository.dart';
import 'package:rapidlie/features/file_upload/bloc/file_upload_bloc.dart';
import 'package:rapidlie/features/file_upload/repository/file_upload_repository.dart';
import 'package:rapidlie/features/home/bloc/notifications_bloc.dart';
import 'package:rapidlie/features/home/repository/notification_repository.dart';
import 'package:rapidlie/features/login/bloc/login_bloc.dart';
import 'package:rapidlie/features/login/repository/login_repository.dart';
import 'package:rapidlie/features/logout/bloc/logout_bloc.dart';
import 'package:rapidlie/features/logout/repository/logout_repository.dart';
import 'package:rapidlie/features/otp/otp_bloc/otp_bloc.dart';
import 'package:rapidlie/features/otp/repository/resend_otp_repository.dart';
import 'package:rapidlie/features/otp/repository/verify_otp_repositoy.dart';
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
import 'package:rapidlie/injection_container.dart';

final List<SingleChildWidget> providers = [
  Provider<EventRepository>(
    create: (_) => EventRepositoryImpl(Dio()),
  ),
  BlocProvider<PublicEventBloc>(
    create: (_) =>
        PublicEventBloc(eventRepository: locator<EventRepository>()),
  ),
  BlocProvider<PrivateEventBloc>(
    create: (_) =>
        PrivateEventBloc(eventRepository: locator<EventRepository>()),
  ),
  BlocProvider<InvitedEventBloc>(
    create: (_) =>
        InvitedEventBloc(eventRepository: locator<EventRepository>()),
  ),
  BlocProvider<UpcomingEventBloc>(
    create: (_) =>
        UpcomingEventBloc(eventRepository: locator<EventRepository>()),
  ),
  BlocProvider<EventByCategoryBloc>(
    create: (_) =>
        EventByCategoryBloc(eventRepository: locator<EventRepository>()),
  ),
  Provider<EventDetailRepository>(
    create: (_) => EventDetailRepository(Dio()),
  ),
  BlocProvider<EventDetailBloc>(
    create: (_) =>
        EventDetailBloc(eventdetailRepository: EventDetailRepository(Dio())),
  ),
  BlocProvider<ProfileBloc>(
    create: (_) =>
        ProfileBloc(profileRepository: ProfileRepository(dio: Dio())),
  ),
  // Merged OTP bloc handles both verify and resend
  BlocProvider<OtpBloc>(
    create: (_) => OtpBloc(
      verifyOtpRepository: VerifyOtpRepository(dio: Dio()),
      resendOtpRepository: ResendOtpRepository(dio: Dio()),
    ),
  ),
  BlocProvider<RegisterBloc>(
    create: (_) =>
        RegisterBloc(registerRepository: RegisterRepository(dio: Dio())),
  ),
  BlocProvider<LoginBloc>(
    create: (_) => LoginBloc(loginRepository: LoginRepository(dio: Dio())),
  ),
  BlocProvider<LogoutBloc>(
    create: (_) =>
        LogoutBloc(logoutRepository: LogoutRepository(dio: Dio())),
  ),
  BlocProvider<ChangePasswordBloc>(
    create: (_) => ChangePasswordBloc(
        changePasswordRepository: ChangePasswordRepository(dio: Dio())),
  ),
  BlocProvider<CategoryBloc>(
    create: (_) =>
        CategoryBloc(categoryRepository: CategoryRepository(dio: Dio())),
  ),
  BlocProvider<NotificationsBloc>(
    create: (_) => NotificationsBloc(
        notificationsRepository: NotificationsRepository(dio: Dio())),
  ),
  BlocProvider<TelephoneNumbersBloc>(
    create: (_) => TelephoneNumbersBloc(
        telephoneNumbersRepository: locator<TelephoneNumbersRepository>()),
  ),
  BlocProvider<FileUploadBloc>(
    create: (_) =>
        FileUploadBloc(fileUploadRepository: FileUploadRepository(dio: Dio())),
  ),
  BlocProvider<CreateEventBloc>(
    create: (_) => CreateEventBloc(CreateEventRepository(dio: Dio())),
  ),
  BlocProvider<InviteContactBloc>(
    create: (_) =>
        InviteContactBloc(InviteContactRepository(dio: Dio())),
  ),
  BlocProvider<BookmarkBloc>(
    create: (_) =>
        BookmarkBloc(bookmarkRepository: BookmarkRepository(dio: Dio())),
  ),
  BlocProvider<AnnounceBloc>(
    create: (_) =>
        AnnounceBloc(repository: DeviceTokenRepository(dio: Dio())),
  ),
  BlocProvider<TicketBloc>(
    create: (_) => TicketBloc(ticketRepository: TicketRepository(dio: Dio())),
  ),
  BlocProvider<ReelBloc>(
    create: (_) => ReelBloc(reelRepository: ReelRepository(dio: Dio())),
  ),
  BlocProvider<PollBloc>(
    create: (_) => PollBloc(pollRepository: PollRepository(dio: Dio())),
  ),
  BlocProvider<ContributionBloc>(
    create: (_) => ContributionBloc(
        contributionRepository: ContributionRepository(dio: Dio())),
  ),
  BlocProvider<LensBloc>(
    create: (_) => LensBloc(lensRepository: LensRepository(dio: Dio())),
  ),
  BlocProvider<SageBloc>(
    create: (_) => SageBloc(sageRepository: SageRepository(dio: Dio())),
  ),
  BlocProvider<MoodBloc>(
    create: (_) => MoodBloc(moodRepository: MoodRepository(dio: Dio())),
  ),
  BlocProvider<GroupsBloc>(
    create: (_) =>
        GroupsBloc(groupRepository: GroupRepository(dio: Dio())),
  ),
  // Merged like/unlike toggle bloc
  BlocProvider<LikeToggleBloc>(
    create: (_) =>
        LikeToggleBloc(likeToggleRepository: LikeToggleRepository(dio: Dio())),
  ),
  BlocProvider<RequestBloc>(
    create: (_) =>
        RequestBloc(requestRepository: RequestRepository(dio: Dio())),
  ),
  BlocProvider<NewPasswordBloc>(
    create: (_) => NewPasswordBloc(
        newPasswordRepository: NewPasswordRepository(dio: Dio())),
  ),
  BlocProvider<ConsentBloc>(
    create: (_) =>
        ConsentBloc(consentRepository: ConsentRepository(dio: Dio())),
  ),
  BlocProvider<DeleteAccountBloc>(
    create: (_) => DeleteAccountBloc(
        deleteAccoutRepository: DeleteAccountRepository(dio: Dio())),
  ),
  BlocProvider<ContactsBloc>(
    create: (_) => ContactsBloc(),
  ),
  ChangeNotifierProvider<ChangeLanguageProvider>(
    create: (_) => ChangeLanguageProvider(),
  ),
  ChangeNotifierProvider<CreateEventProvider>(
    create: (_) => CreateEventProvider(),
  ),
];
