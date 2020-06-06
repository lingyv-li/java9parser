import 'package:antlr4/antlr4.dart';
import 'package:my_project/Java9Parser.dart';
import 'package:my_project/Java9Lexer.dart';

void main(List<String> args) async {
  Java9Lexer.checkVersion();
  Java9Parser.checkVersion();
  final input = await InputStream.fromPath(args[0]);
  final lexer = Java9Lexer(input);
  final tokens = CommonTokenStream(lexer);
  final parser = Java9Parser(tokens);
  parser.buildParseTree = true;
  final compilationUnit = parser.compilationUnit();
  assert(!compilationUnit.isEmpty);
  assert(parser.isMatchedEOF());
}
