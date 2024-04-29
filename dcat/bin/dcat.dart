import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

const lineNumber = 'line-number';

void main(List<String> arguments) async {
  exitCode = 0; // Presume success
  final parser = ArgParser()..addFlag(lineNumber, negatable: false, abbr: 'n');

  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  dcat(paths, showLineNumbers: argResults[lineNumber] as bool);

  appendQuotes();
}

Future<void> dcat(List<String> paths, {bool showLineNumbers = false}) async {
  if (paths.isEmpty) {
    // No files provided as arguments. Read from stdin and print each line.
    await stdin.pipe(stdout);
  } else {
    for (final path in paths) {
      var lineNumber = 1;
      final lines = utf8.decoder
          .bind(File(path).openRead())
          .transform(const LineSplitter());
      try {
        await for (final line in lines) {
          if (showLineNumbers) {
            stdout.write('${lineNumber++} ');
          }
          stdout.writeln(line);
        }
      } catch (_) {
        await _handleError(path);
      }
    }

  }
}

Future<void>appendQuotes() async{
  final quotes=File('quotes.txt');
  const stronger = 'That which does not kill us makes us stronger. -Nietzsche';

  // 将第一句引用追加到文件
  await quotes.writeAsString(stronger, mode: FileMode.append);

  // 创建一个写入流以追加第二条及其后的引用
  final quotesSink = quotes.openWrite(mode: FileMode.append);

  // 写入和追加新的引用
  quotesSink.write("Don't cry because it's over, ");
  quotesSink.writeln('smile because it happened. -Dr. Seuss');

  // 关闭写入流
  await quotesSink.close();
}

Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}