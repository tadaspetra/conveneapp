const functions = require("firebase-functions");

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require("firebase-admin");
admin.initializeApp();
const database = admin.firestore();

// executes at every hour mark
exports.moveClubBookToHistory = functions.pubsub.schedule("0 * * * *")
    .onRun(async (context) => {
      const query = await database.collection("clubs")
          .where("currentBook.dueDate", "<=", admin.firestore.Timestamp.now().seconds)
          .get();
      query.forEach(async (eachClub) => {
        console.log("From Club: " + eachClub.id + " - " + eachClub.data()["name"]);
        console.log("Move this book to history: " + eachClub.data()["currentBook"]["title"]);
        await database.doc("clubs/" + eachClub.id).collection("history").add({
          "name": eachClub.data()["currentBook"]["title"],
          "authors": eachClub.data()["currentBook"]["authors"],
          "dueDate": eachClub.data()["currentBook"]["dueDate"],
          "pageCount": eachClub.data()["currentBook"]["pageCount"],
          "coverImage": eachClub.data()["currentBook"]["coverImage"],
        });
        await database.doc("clubs/" + eachClub.id).update({
          "currentBook": admin.firestore.FieldValue.delete(),
        });
      });
    });
