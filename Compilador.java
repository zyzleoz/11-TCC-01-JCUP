import java.io.*;

public class Compilador {
    public void compilar(String caminhoDoArquivoDeEntrada) throws Exception {
        FileReader fileReader = null;
        BufferedReader bufferedReader = null;

        try {
            fileReader = new java.io.FileReader(caminhoDoArquivoDeEntrada);
            bufferedReader = new BufferedReader(fileReader);
            String linha;

            while ((linha = bufferedReader.readLine()) != null) {
                if (linha == null || linha.trim().isEmpty())
                    continue;
                System.out.println("> " + linha);
                processar(linha);
            }
        } catch (IOException e) {
            System.err.println("Erro ao ler arquivo de entrada: " + e.getMessage());
        } finally {
            if (bufferedReader != null)
                bufferedReader.close();
            if (fileReader != null)
                fileReader.close();
        }
    }

    public void processar(String linha) {
        // Adicionar um \n no final para garantir que o analisador leia a linha
        // completa:
        StringReader stringReader = new StringReader(linha + "\n");

        MeuParser meuParser = new MeuParser(new MeuScanner(stringReader));

        try {
            meuParser.parse();
        } catch (Exception e) {
            System.err.println("Erro na expressão: " + e.getMessage());
        } finally {
            stringReader.close();
        }
    }
}
