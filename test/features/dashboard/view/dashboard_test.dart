import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/apis/firebase/book.dart';
import 'package:conveneapp/features/dashboard/view/dashboard.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../test_helpers.dart';

class MockAuthApi extends Mock implements AuthApi {}

class MockBookApi extends Mock implements BookApi {}

class FakeRoute extends Fake implements Route {}

class FakeSearchBookModel extends Fake implements SearchBookModel {}

void main() {
  late MockAuthApi mockAuthApi;
  late MockUser mockUser;
  late MockBookApi mockBookApi;
  late MockNavigator mockNavigator;

  setUp(() {
    mockAuthApi = MockAuthApi();
    mockBookApi = MockBookApi();
    mockUser = MockUser();
    mockNavigator = MockNavigator();

    registerFallbackValue(FakeRoute());
    registerFallbackValue(FakeSearchBookModel());
  });

  // const dashBoardOpenDrawerKey = Key('dashBoard-openDrawer');
  // const dashBoardAddPersonalBookKey = Key('dashBoard-addPersonalBook');
  // const dashBoardOpenMenuKey = Key('dashBoard-openMenu');
  const dashBoardLoadingKey = Key('dashBoard-loading');
  const email = 'email@gmail.com';
  const uid = 'uid';
  const displayName = 'displayName';

  void mockCurrentUser() {
    when(() => mockAuthApi.currentUser()).thenAnswer((_) => Stream.value(mockUser));
    when(() => mockUser.email).thenAnswer((_) => email);
    when(() => mockUser.uid).thenAnswer((_) => uid);
    when(() => mockUser.displayName).thenAnswer((_) => displayName);
  }

  // TODO: fix
  // void mockCurrentBooks([List<BookModel> books = const []]) {
  //   when(() => mockBookApi.getCurrentBooks()).thenAnswer((_) => Stream.value(books));
  // }

  Widget renderDashBoard([List<Override> overrides = const []]) {
    final _overrides = overrides.isNotEmpty
        ? overrides
        : [
            authApiProvider.overrideWithValue(mockAuthApi),
            bookApiProvider.overrideWithValue(
              mockBookApi,
            ),
          ];
    return ProviderScope(
      child: MaterialApp(
        home: MockNavigatorProvider(
          navigator: mockNavigator,
          child: const Dashboard(),
        ),
      ),
      overrides: _overrides,
    );
  }

  // TODO: Fix this
  // group('Drawer', () {
  //   testWidgets('should open drawer when [appBar] drawer action is tapped', (tester) async {
  //     mockCurrentUser();
  //     mockCurrentBooks();

  //     await tester.pumpWidget(renderDashBoard());

  //     await tester.tap(find.byKey(dashBoardOpenDrawerKey));
  //     await tester.pumpAndSettle();

  //     expect(find.text('Logout'), findsOneWidget);
  //   });

  //   testWidgets('should [signOut]  the current user when [SignOut] is requested ', (tester) async {
  //     mockCurrentUser();
  //     when(() => mockAuthApi.signOut()).thenAnswer((_) async => right(Future<void>.value()));
  //     mockCurrentBooks();

  //     await tester.pumpWidget(renderDashBoard());

  //     await tester.tap(find.byKey(dashBoardOpenDrawerKey));

  //     await tester.pumpAndSettle();
  //     await tester.tap(find.text('Logout'));

  //     verify(() => mockAuthApi.signOut());
  //   });
  // });

  // TODO: Fix this
  // group('AppBar', () {
  //   testWidgets(
  //     'should render current users display name [Hi, Current User] with message when user has a dsiplay name',
  //     (tester) async {
  //       mockCurrentUser();
  //       mockCurrentBooks();

  //       await tester.pumpWidget(renderDashBoard());
  //       await tester.pumpAndSettle();

  //       expect(find.text('Hi, $displayName!'), findsOneWidget);
  //     },
  //   );
  // });

  group('Body', () {
    //TODO: Fix This
    // testWidgets('should render [Looks like you aren’t reading any books currently] when books are empty',
    //     (tester) async {
    //   mockCurrentUser();
    //   mockCurrentBooks();

    //   await tester.pumpWidget(renderDashBoard());
    //   await tester.pumpAndSettle();

    //   expect(find.text('Looks like you aren’t reading any books currently'), findsOneWidget);
    // });

    testWidgets('should render [CircularProgressIndicator] when the state is [AsyncLoading]', (tester) async {
      mockCurrentUser();
      when(() => mockBookApi.getCurrentBooks()).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(renderDashBoard());

      expect(find.byKey(dashBoardLoadingKey), findsOneWidget);
    });

    // tested one usecase book, can be also tested with multiple books
    // TODO: fix this
    // testWidgets('should render books', (tester) async {
    //   await mockNetworkImages(() async {
    //     mockCurrentUser();
    //     mockCurrentBooks([bookModel]);

    //     await tester.pumpWidget(renderDashBoard());
    //     await tester.pump(const Duration(seconds: 300));

    //     expect(find.byType(BookSlidable), findsOneWidget);
    //   });
    // });

    //TODO: Fix this
    // testWidgets('should [add] new book when add new when a book is selected and returned', (tester) async {
    //   mockCurrentUser();
    //   mockCurrentBooks();
    //   when(() => mockNavigator.push(any())).thenAnswer((_) async => searchBookModel);
    //   when(() => mockBookApi.addBook(any())).thenAnswer((_) async => right(Future<void>.value()));
    //   await tester.pumpWidget(renderDashBoard());
    //   await tester.pump();
    //   await tester.tap(find.byKey(dashBoardOpenMenuKey));
    //   await tester.pump();
    //   await tester.tap(find.byKey(dashBoardAddPersonalBookKey));

    //   verifyInOrder([
    //     () => mockNavigator.push(any()),
    //     () => mockBookApi.addBook(any()),
    //   ]);
    // });

    // TODO: Fix this
    // testWidgets('should display [SnackBar] when a failure occurs while adding a book', (tester) async {
    //   mockCurrentUser();
    //   mockCurrentBooks();
    //   when(() => mockNavigator.push(any())).thenAnswer((_) async => searchBookModel);
    //   when(() => mockBookApi.addBook(any())).thenAnswer((_) async => left(BookFailure()));

    //   await tester.pumpWidget(renderDashBoard());
    //   await tester.pump();
    //   await tester.tap(find.byKey(dashBoardOpenMenuKey));
    //   await tester.tap(find.byKey(dashBoardAddPersonalBookKey));
    //   await tester.pump();

    //   expect(find.text(BookFailure().message), findsOneWidget);
    // });
  });
}
