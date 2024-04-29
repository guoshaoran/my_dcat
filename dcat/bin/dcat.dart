improt 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

const lineNumber ='line-number';

void main<List<String> arguments>{
  exitCode=0;
  final parser=ArgParser()..addFlag(lineNumber,negatable:false,abbe:'n');

  ArgResults argResults=parser.parse(arguments);
  final paths = argResult.rest;

    dcat(paths,showLineNumber:argResult[lineNumber]as bool);

}
Feture<void> dcat(List<String>paths,{bool showLineNumbers=false})async{
    if(paths.isEmpty){
        await stdin.pipe(stdout);

    }else{
        for(final path in paths){
            var lineNumber = 1;
            final lines = utf8.decoder.bind(File(path).openRead());
            try{
                await for(final line in lines){
                    if(showLineNumbers){
                        stdout.write('${lineNumber++}');
                }
                stdout.writeln(line);
                }
            }catch(_){
                await _handleError(path);
            }
        }
    }
}

Frture<void> _handleError(String path)async{
    if(await FileSystemEntity.isDirectory(path)){
        atderr.writeln('error:$path is directory');
    }else{
        exitCode=2;
    }
}