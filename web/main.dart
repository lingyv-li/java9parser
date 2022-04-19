import 'dart:html';
import 'package:antlr4/antlr4.dart';
import 'package:codemirror/codemirror.dart';
import 'package:my_project/Java9Lexer.dart';
import 'package:my_project/Java9Parser.dart';

class StringCollectingErrorListener extends BaseErrorListener {
  final StringBuffer _stringBuffer = StringBuffer();

  @override
  void syntaxError(dynamic recognizer, Object? offendingSymbol, int? line,
      int? charPositionInLine, String? msg, RecognitionException? e) {
    _stringBuffer.writeln('line $line:$charPositionInLine $msg');
  }

  String get errors => _stringBuffer.toString();
}

String runParser(String data) {
  Java9Lexer.checkVersion();
  Java9Parser.checkVersion();
  final input = InputStream.fromString(data);
  final lexer = Java9Lexer(input);
  final tokens = CommonTokenStream(lexer);
  final parser = Java9Parser(tokens);
  final errorListener = StringCollectingErrorListener();
  lexer.removeErrorListeners();
  lexer.addErrorListener(errorListener);
  parser.removeErrorListeners();
  parser.addErrorListener(errorListener);
  parser.buildParseTree = true;
  parser.compilationUnit();
  return errorListener.errors;
}

void main() {
  var options = {'mode': 'text/x-java', 'theme': 'monokai'};

  var editor = CodeMirror.fromElement(querySelector('#textContainer')!,
      options: options);

  querySelector('#submit')!.onClick.forEach((event) {
    var errors = runParser(editor.doc.getValue()!);
    if (errors.isNotEmpty) {
      querySelector('#output')!.text = 'Parser error: \n$errors';
    } else {
      querySelector('#output')!.text = 'Parser passed';
    }
  });
}
