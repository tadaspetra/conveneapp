import 'package:conveneapp/features/authentication/model/user.dart';
import 'package:conveneapp/features/book/model/book_model.dart';

// TODO: @varunbhalerao56 please refactor this, use the one in the test helper
const bookModel = BookModel(
    id: "123",
    title: "Test Book",
    authors: ['Test Author'],
    pageCount: 4,
    coverImage: 'https://picsum.photos/200/300',
    currentPage: 89);

const userModel = LocalUser(uid: "921012123", email: 'example@gmail.com', name: 'John');
