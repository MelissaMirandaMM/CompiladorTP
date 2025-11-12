# _____________________________________________________
#
# Dupla: Melissa MM Souza e Felipe Victor M Sousa
# 
# TP1 - Compiladores
# 
# Makefile - Analisador Léxico Lang2 (TP1)
# _____________________________________________________

# Configuração da Ferramenta JFlex 
JLEX = jflex

# Configuração do Compilador Java
JC = javac
JFLAGS = -g -Xlint:none

# Definições de Diretórios
SRC_ROOT = src
BIN_DIR = bin
LEXER_PKG_DIR = $(SRC_ROOT)/lexer

# Definições de Arquivos de Origem
# O arquivo .jflex é a especificação para o gerador do código Java.
LEXER_DEF = $(LEXER_PKG_DIR)/Lang2Lexer.jflex
# Este é o arquivo gerado pelo JFlex.
LEXER_JAVA = $(LEXER_PKG_DIR)/Lang2Lexer.java

# Outros componentes Java (código escrito manualmente)
OTHER_JAVA = $(LEXER_PKG_DIR)/Main.java $(LEXER_PKG_DIR)/Token.java

# Definições de Saída
JAR_FILE = lexer.jar
# Classe principal para execução.
MAIN_CLASS = lexer.Main

# --- Objetivos (Targets) ---

# Target Padrão: Constrói o artefato principal (o JAR).
all: $(JAR_FILE)

# Cria o Pacote JAR
$(JAR_FILE): compile
	@echo "Empacotando o executável: $(JAR_FILE)..."
	jar cfe $(JAR_FILE) $(MAIN_CLASS) -C $(BIN_DIR) .
	@echo "Compilação e empacotamento concluídos. Use 'make run-lex FILE=...' para iniciar."

# Etapa de Compilação: Transforma .java em .class
compile: $(LEXER_JAVA) $(OTHER_JAVA)
	@echo "Iniciando a compilação dos fontes Java para o $(BIN_DIR)..."
	mkdir -p $(BIN_DIR)
	$(JC) $(JFLAGS) -d $(BIN_DIR) $(LEXER_JAVA) $(OTHER_JAVA)

# Regra de Geração: Executa o JFlex
# Esta regra garante que o Lang2Lexer.java esteja atualizado antes da compilação.
$(LEXER_JAVA): $(LEXER_DEF)
	@echo "Invoca JFlex para gerar $(LEXER_JAVA) a partir de $(LEXER_DEF)..."
	$(JLEX) $(LEXER_DEF)

# Target de Execução do Lexer 🚀
# Requer a variável 'FILE' para especificar o arquivo de entrada.
# Uso: make run-lex FILE=teste.lang2
run-lex: $(JAR_FILE)
	@if [ -z "$(FILE)" ]; then \
		echo "ERRO: O arquivo de entrada deve ser fornecido via 'FILE'."; \
		echo "Formato: make run-lex FILE=nome_do_arquivo.lang2"; \
		exit 1; \
	fi
	@echo "Executando o analisador léxico para o arquivo: $(FILE)..."
	java -jar $(JAR_FILE) -lex $(FILE)

# Target de Limpeza 🗑️
clean:
	@echo "Removendo artefatos gerados (bin, .java gerado, .jar)..."
	rm -rf $(BIN_DIR)
	rm -f $(LEXER_JAVA)
	rm -f $(JAR_FILE)
	@echo "Sistema limpo."

# Targets que não criam arquivos (Phony Targets)
.PHONY: all compile run-lex clean