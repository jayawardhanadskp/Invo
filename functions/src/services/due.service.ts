import * as andmin from 'firebase-admin';

export async function getAllDues(uid: string): Promise<number> {
    const db = andmin.firestore();

    const buyerRef = db
    .collection('users')
    .doc(uid)
    .collection('buyers');

    const snapshot = await buyerRef
        .where('totalDue', '>', 0)
        .orderBy('totalDue', 'desc')
        .get();

    if (snapshot.empty) {
        return 0;
    }

    let totalDue = 0;

    snapshot.forEach(doc => {
        const data = doc.data();
        if (data.totalDue) {
            totalDue += data.totalDue;
        }});
    
    
    return totalDue;
}