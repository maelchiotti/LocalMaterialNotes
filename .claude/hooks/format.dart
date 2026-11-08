// Formats the Dart file that Claude just edited (PostToolUse hook).
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final input = jsonDecode(await stdin.transform(utf8.decoder).join());
  final filePath = (input is Map ? input['tool_input'] : null)?['file_path'];

  if (filePath is! String || !filePath.endsWith('.dart') || filePath.endsWith('.g.dart')) {
    return;
  }

  final root = Platform.environment['CLAUDE_PROJECT_DIR'] ?? Directory.current.path;
  if (!File(filePath).absolute.path.startsWith(Directory(root).absolute.path)) {
    return;
  }

  await Process.run('dart', ['format', filePath], workingDirectory: root, runInShell: true);
}
