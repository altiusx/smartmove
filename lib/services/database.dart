import 'package:flutter/foundation.dart';

import 'package:smartmove/models/entry.dart';
import 'package:smartmove/models/task.dart';
import 'package:smartmove/services/api_path.dart';
import 'package:smartmove/services/firestore_service.dart';

abstract class Database {
  Future<void> setTask(Task task);
  Future<void> deleteTask(Task task);
  Stream<List<Task>> tasksStream();
  Stream<Task> taskStream({@required String taskId});

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Task task});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setTask(Task task) async => await _service.setData(
        path: APIPath.task(uid, task.id),
        data: task.toMap(),
      );

  @override
  Future<void> deleteTask(Task task) async {
    //delete where entry.taskId == task.taskId
    final allEntries = await entriesStream(task: task).first;
    for (Entry entry in allEntries) {
      if (entry.taskId == task.id) {
        await deleteEntry(entry);
      }
    }
    //delete task
    await _service.deleteData(path: APIPath.task(uid, task.id));
  }

  @override
  Stream<Task> taskStream({@required String taskId}) => _service.documentStream(
      path: APIPath.task(uid, taskId),
      builder: (data, documentId) => Task.fromMap(data, documentId));

  @override
  Stream<List<Task>> tasksStream() => _service.collectionStream(
        path: APIPath.tasks(uid),
        builder: (data, documentId) => Task.fromMap(data, documentId),
      );

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Task task}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: task != null
            ? (query) => query.where('taskId', isEqualTo: task.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}

//database.entriesstream: gets all entries for user, optionally filtering by task
