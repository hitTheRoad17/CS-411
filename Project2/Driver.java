public class Driver {
  public static void main(String...z) {
    LexicalAnalyzer scanner = null;
    try {
      scanner = new LexicalAnalyzer( new java.io.FileReader(z[0]) );
    }
    catch(Exception e) {
      System.out.printf("File %s doesn't exist\n", z[0]);
    }
    try {
      parser p = new parser(scanner);
      p.parse();

      System.out.println();
    }
    catch(Exception e) {
      System.out.println("Exception while parsing");
    }
  }
}