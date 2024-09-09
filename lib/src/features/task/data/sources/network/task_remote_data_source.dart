import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:maecha_tasks/src/features/task/domain/entities/task/task_model.dart';

@injectable
class TaskRemoteDataSource {
  final FirebaseFirestore db;
  final String collectionPath = "tasks";
  final String secondCollectionPath = "my_tasks";

  TaskRemoteDataSource({required this.db});

  Future<void> createTask(TaskModel task) async {
    final collectionReference = db
        .collection('tasks') // Collection principale
        .doc(task.user!.uid) // Document pour l'utilisateur spécifique
        .collection(secondCollectionPath); // Sous-collection pour les tâches de l'utilisateur

    // Ajout de la tâche avec un identifiant généré automatiquement
    final docRef = await collectionReference.add({
      'title': task.title,
      'desc': task.desc,
      'dateTime': task.dateTime!.toIso8601String(), // Convertir DateTime en String
      'priority': task.priority!.name, // Convertir enum en String, ajuster selon votre implémentation
      'user': task.user!.toJson(),
      'done': task.done,
      'notify':task.notify,
      'createdAt': DateTime.timestamp().toIso8601String(),
      'updatedAt': DateTime.timestamp().toIso8601String(),
      'favorite': false
    });

    // Récupérer l'ID généré et mettre à jour le document avec cet ID dans le champ 'id'
    await docRef.update({'id': docRef.id});
  }

  Future<void> updateTask(TaskModel task) async {
    await db
        .collection(collectionPath) // Collection principale
        .doc(task.user!.uid) // Document pour l'utilisateur spécifique
        .collection(secondCollectionPath) // Sous-collection pour les tâches de l'utilisateur
        .doc(task.id)// Ajouter la tâche avec un identifiant généré automatiquement  }
        .update({
          'title': task.title,
          'desc': task.desc,
          'dateTime': task.dateTime!.toIso8601String(), // Convertir DateTime en String
          'priority': task.priority!.name, // Convertir enum en String, ajuster selon votre implémentation
          'user': task.user!.toJson(),
          'done': task.done,
          'notify':task.notify,
          'updatedAt': DateTime.timestamp().toIso8601String()
        });
  }

  Future<void> deleteTask(TaskModel task) async {
    await FirebaseFirestore.instance
        .collection(collectionPath) // Collection principale
        .doc(task.user!.uid) // Document pour l'utilisateur spécifique
        .collection('my_tasks') // Sous-collection pour les tâches de l'utilisateur
        .doc(task.id) // Document spécifique à la tâche
        .delete(); // Supprimer la tâche
  }

  Future<List<TaskModel>> getTasks(TaskModel task) async {
   final querySnapshot= await FirebaseFirestore.instance
        .collection(collectionPath) // Collection principale
        .doc(task.user!.uid) // Document pour l'utilisateur spécifique
        .collection(secondCollectionPath) // Sous-collection pour les tâches de l'utilisateur
        .orderBy('updatedAt', descending: true) // Trier par la date de modification en ordre décroissant
        .get(); // Récupérer tous les documents de la sous-collection

   //Conversion
   return querySnapshot.docs.map((doc) {
     final data =doc.data();
     return TaskModel.fromJson(data).copyWith(id: doc.id); // Ajouter l'ID du document
   }).toList();
  }

  Future<bool> getTaskWithTitle(String uid,String title)async{
    final collectionReference = db
        .collection(collectionPath) // Collection principale
        .doc(uid) // Document pour l'utilisateur spécifique
        .collection(secondCollectionPath); // Sous-collection pour les tâches de l'utilisateur

    // Requête pour rechercher des tâches avec le titre spécifié
    final querySnapshot = await collectionReference
        .where('title', isEqualTo: title)
        .get();
    //on renvoie le résultat
    return querySnapshot.docs.isNotEmpty;
  }

  Future<TaskModel?> getTaskWithId(String uid,String id)async{
    final collectionReference = db
        .collection(collectionPath) // Collection principale
        .doc(uid) // Document pour l'utilisateur spécifique
        .collection(secondCollectionPath); // Sous-collection pour les tâches de l'utilisateur

    // Requête pour rechercher la tâche avec l'id spécifié
    final querySnapshot = await collectionReference
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    // Vérification si le document existe
    if (querySnapshot.docs.isNotEmpty) {
      // Conversion du document en TaskModel
      final taskDocument = querySnapshot.docs.first;
      return TaskModel.fromJson(taskDocument.data()).copyWith(id:taskDocument.id);
    } else {
      // Retourner null si aucun document n'a été trouvé
      return null;
    }
  }
}