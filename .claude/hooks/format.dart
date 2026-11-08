// Formats the Dart file that Claude just edited (PostToolUse hook).
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final input = jsonDecode(await stdin.transform(utf8.decoder).join());
  final toolInput = input is Map ? input['tool_input'] : null;
  final filePath = toolInput is Map ? toolInput['file_path'] : null;

  if (filePath is! String || !filePath.endsWith('.dart') || filePath.endsWith('.g.dart')) {
    return;
  }

  final environment = Platform.environment;
  final root = environment['CLAUDE_PROJECT_DIR'] ?? Directory.current.path;
  final absoluteRoot = Directory(root).absolute.path;
  if (!File(filePath).absolute.path.startsWith(absoluteRoot)) {
    return;
  }

  await Process.run('dart', ['format', filePath], workingDirectory: root, runInShell: true);
}
