
# TP1 - Compiladores

Este projeto implementa um **analisador léxico completo** para a linguagem **Lang2**, desenvolvido em **Java** utilizando o **gerador de lexer JFlex**.

---

##  Estrutura da pasta

```
langLexer/
├── src/
│ └── lexer/
│ ├── Lang2Lexer.jflex 
│ ├── Main.java 
│ └── Token.java 
├── Makefile 
└── exemplo1.lang2 
└── exemplo2.lang2
```

---

##  Requisitos necessários

Antes de executar o projeto, certifique-se de ter instalado:

* **Java (JDK)**
* **JFlex** (disponível no seu `PATH` como `jflex`)
* **make**

---

---

## Atenção ao Fim de Linha (LF × CRLF)
Este projeto deve ser compilado e executado em Linux, portanto todos os arquivos de código devem usar quebras de linha no formato LF.

 Como garantir que os arquivos estejam em LF

No VS Code:

Abra qualquer arquivo .java.

No canto inferior direito, clique em LF (ou em CRLF, se estiver errado).

Selecione "LF" na lista.

Salve o arquivo (Ctrl+S).

Verificar via Git (recomendado)

Use o comando:

git ls-files --eol


Procure por:

i/lf    w/lf


Isso indica que o arquivo está em LF tanto no repositório quanto no diretório de trabalho.

 Configuração recomendada do Git (Windows)

Para evitar que o Git converta automaticamente LF → CRLF no Windows:

git config --global core.autocrlf false
---
---
## Compilar o Projeto

O **Makefile** automatiza todo o processo:

1. Executa o **JFlex** para gerar o arquivo `src/lexer/Lang2Lexer.java`.
2. Compila todos os arquivos `.java` para o diretório `bin/`.
3. Cria um **JAR executável** chamado `lexer.jar`.

```bash
make
# ou
make all
```

---

###  Executar o Analisador Léxico

Para rodar o analisador em um arquivo de entrada, use o target `run-lex`:

```bash
make run-lex FILE=exemplo1.lang2
```

Esse comando é um atalho para:

```bash
java -jar lexer.jar -lex exemplo1.lang2
```

---

###  Limpar os Arquivos Gerados

Para remover arquivos compilados (`bin/`), o `lexer.jar` e o `Lang2Lexer.java` gerado:

```bash
make clean
```

---

##  Detalhes do Projeto

* O analisador foi desenvolvido com fins acadêmicos, como parte do Trabalho Prático 1 da disciplina de Compiladores.

* O arquivo `.jflex` pode ser facilmente modificado para incluir novos tokens, regras léxicas adicionais ou tratamento diferenciado de erros.

* A implementação segue as especificações oficiais da linguagem Lang2, respeitando sua gramática e convenções.
---

## Dupla

Melissa M. M. Souza
Felipe Victor M. Sousa

