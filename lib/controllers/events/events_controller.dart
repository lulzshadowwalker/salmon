import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/controllers/users/users_controller.dart';
import 'package:salmon/helpers/salmon_extensions.dart';
import 'package:salmon/helpers/salmon_helpers.dart';

import '../../models/event.dart';
import '../../models/salmon_user.dart';
import '../../providers/a12n/a12n_provider.dart';

final eventsControllerProvider =
    Provider<EventsController>((ref) => EventsController(ref));

final class EventsController {
  EventsController(this.ref);

  final Ref ref;

  final _db = FirebaseFirestore.instance;
  final _log = SalmonHelpers.getLogger('EventsController');

  Future<List<Event>> get events async => await _db
      .collection('events')
      .orderBy('date_created', descending: true)
      .get()
      .then(
        (query) => query.docs
            .map(
              (doc) => Event.fromMap(doc.data()),
            )
            .toList(),
      );

  Future<void> interested(Event event) async {
    try {
      final uid = ref.read(a12nProvider).userId;

      await _db
          .collection('events')
          .doc(event.id)
          .collection('users')
          .doc(uid)
          .set({
        'userId': uid,
        'submittedOn': DateTime.now().toUtc(),
      });

      _log.v('''✨ user is interested in the event:
id: ${event.id}
title: ${event.enTitle}
''');
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
    }
  }

  Future<void> uninterested(Event event) async {
    try {
      final uid = ref.read(a12nProvider).userId;

      await _db
          .collection('events')
          .doc(event.id)
          .collection('users')
          .doc(uid)
          .delete();

      _log.v('''🥱 user is uninterested in the event:
id: ${event.id}
title: ${event.enTitle}
''');
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
    }
  }

  /// TODO [interestedUsers] should return a stream of users
  Future<List<SalmonUser>?> interestedUsers(Event event) async {
    try {
      final ids = await _db
          .collection('events')
          .doc(event.id)
          .collection('users')
          .get()
          .then(
            (query) => query.docs
                .map(
                  (doc) => doc.data()['userId'] as String?,
                )
                .toCompactMap
                .toList(),
          );

      final users = <SalmonUser?>[];
      for (var id in ids) {
        users.add(await ref.read(usersControllerProvider).fetchUser(id));
      }

      return Future.value(users.toCompactMap.toList());
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }

  Future<SalmonUser?> check(Event event) async {
    try {
      final uid = ref.read(a12nProvider).userId;

      final res = await _db
          .collection('events')
          .doc(event.id)
          .collection('users')
          .where('userId', isEqualTo: uid)
          .get()
          .then((query) {
        final doc = query.docs.firstOrNull;
        return doc != null ? SalmonUser.fromMap(doc.data()) : null;
      });

      _log.v('''✨ User is ${res == null ? 'not' : ''} interested in the event:
id: ${event.id}
title: ${event.enTitle}
''');

      return res;
    } catch (e) {
      SalmonHelpers.handleException(e: e, logger: _log);
      return null;
    }
  }
}
