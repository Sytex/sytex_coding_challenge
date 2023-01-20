import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:tiny_storage/tiny_storage.dart';

/// The router for the server.
///
/// This is a simple router that has two routes:
/// - GET /form
/// - PATCH /form/content/\<entry_id\>
final router = Router()
  ..get('/form', _getFormHandler)
  ..patch('/form/content/<entry_id>', _patchEntryHandler);

/// The handler for getting the form. This corresponds to a GET request.
///
/// The response body will be the form as a JSON object.
Future<Response> _getFormHandler(Request request) async {
  final database = request.context['database']! as TinyStorage;
  final form = database.get<Map<String, dynamic>>('form');
  final formJson = json.encode(form);
  await _simulateNetworkDelay();
  return Response.ok(
    formJson,
    headers: {
      'Content-Type': 'application/json',
    },
  );
}

/// The handler for updating an entry. This corresponds to a PATCH request.
///
/// The request body should be a JSON object with a single key, `answer`.
/// The response body will be the updated entry as a JSON object.
Future<Response> _patchEntryHandler(Request request) async {
  final body = await request.readAsString();
  final bodyJson = json.decode(body) as Map<String, dynamic>;

  final entryId = request.params['entry_id'];
  final answer = bodyJson['answer'];

  final database = request.context['database']! as TinyStorage;
  final form = database.get<Map<String, dynamic>>('form');

  final currentContent = form['content'] as List<dynamic>;

  // Going to mutate this, for simplicity's sake.
  final newContent = List<Map<String, dynamic>>.from(currentContent);

  Map<String, dynamic>? updatedEntry;
  for (final item in newContent) {
    final isEntry = item['type'] == 'entry';
    final matchesId = item['id'] == entryId;
    if (isEntry && matchesId) {
      item['answer'] = answer;
      updatedEntry = item;
      break;
    }
  }

  if (updatedEntry == null) {
    return Response.notFound('Entry not found!');
  }

  // Also mutating this copy.
  final newForm = Map<String, dynamic>.from(form);
  newForm['content'] = newContent;

  database.set('form', newForm);

  final updatedEntryJson = json.encode(updatedEntry);
  await _simulateNetworkDelay();
  return Response.ok(
    updatedEntryJson,
    headers: {
      'Content-Type': 'application/json',
    },
  );
}

/// A function which returns after [delay] without any value.
///
/// This is used to simulate a slow network connection.
Future<void> _simulateNetworkDelay({
  Duration delay = const Duration(seconds: 1),
}) async {
  return Future.delayed(delay);
}

void main(List<String> args) async {
  // Open the database.
  final directoryPathSegments = Platform.script.path.split('/');
  final directoryPath = directoryPathSegments
      .sublist(0, directoryPathSegments.length - 1)
      .join('/');
  final database = await TinyStorage.init(
    'database.db',
    path: directoryPath,
  );

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests and injects the database.
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_injectDatabase(database))
      .addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  stdout.write('Server listening on port ${server.port}\n');
}

Middleware _injectDatabase(TinyStorage database) {
  return (Handler innerHandler) {
    return (request) {
      final newRequest = request.change(context: {'database': database});
      return innerHandler(newRequest);
    };
  };
}
