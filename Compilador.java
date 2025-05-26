import java.io.*;

public class Compilador {
  public void compilar() throws Exception {
    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
    System.out.println("Digite expressões (termine com ';') e pressione ENTER. Ctrl+C para sair.");

    while (true) {
      System.out.print("> ");
      
      String linha = bufferedReader.readLine();

      if (linha == null || linha.trim().isEmpty()) 
        continue;

      // Adicionar um \n no final para garantir que o analisador leia a linha completa:
      StringReader stringReader = new StringReader(linha + "\n");

      MeuParser meuParser = new MeuParser(new MeuScanner(stringReader));
      
      try {
        meuParser.parse();
      } catch (Exception e) {
        System.err.println("Erro na expressão: " + e.getMessage());
      }
    }
  }
}