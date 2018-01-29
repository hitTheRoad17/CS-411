// Lexical Analyzer Tester
import java.io.*;

public class LexicalAnalyzerTester {

  public static void main(String...z) {

    try {
      LexicalAnalyzer lex = new LexicalAnalyzer(new FileReader(z[0]));

      while(lex.yylex() != null) {}
      System.out.println("\nTrie Table:\n");
      lex.printTable();
      System.out.println("");
    }
    catch (Exception e) {
      System.out.println("Abort");
    }
  }
}
