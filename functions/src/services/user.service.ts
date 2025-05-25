import * as admin from "firebase-admin";

/**
 * Creates or updates a user document in Firestore.
 *
 * @param uid - Firebase Auth user ID.
 * @param data - User data including email, name, and photo URL.
 * @returns A promise resolving to user document data.
 */
export async function upsertUser(
  uid: string,
  data: {
    email: string;
    displayName: string;
    photoURL: string;
  }
) {
  const userRef = admin.firestore().collection("users").doc(uid);
  const userSnap = await userRef.get();

  if (!userSnap.exists) {
    await userRef.set({
      email: data.email,
      displayName: data.displayName,
      photoURL: data.photoURL,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    await userRef.update({ id: uid });
  }

  const updatedSnap = await userRef.get();
  return updatedSnap.data();
}
