import java.io.*;

public class LexicalAnalyzerTester {
  public static void main(String...z) {
    try {
      LexicalAnalyzer lex = new LexicalAnalyzer(new FileReader(z[0]));
      while(lex.yylex() != null) {}
      System.out.println("\n\n");
      System.out.println("Trie Table for identifiers:\n");
      lex.printTable();
      System.out.println("\n\n");
    }
    catch (Exception e) {
      System.out.println("Usage: java LexicalAnalyzerTester <Input File Name>");
    }
  }
}