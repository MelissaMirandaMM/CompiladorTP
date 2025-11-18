/*
 *_____________________________________________________________
 *
 * Especificação JFlex para o Analisador Léxico Lang2 (TP1)
 * Dupla: Melissa MM Souza e Felipe Victor MS
 *_____________________________________________________________
 */

package lexer;

import java.util.Set;
import java.util.HashSet;

%%

/* Etapa 1: Configurações e Código de Usuário (Setup) */

// Definições Essenciais do JFlex
%class Lang2Lexer
%public
%unicode
%line
%column
%type Token

%{

    // Exceção personalizada para reportar erros léxicos com precisão de linha/coluna
    public static class LexerException extends RuntimeException {
        public LexerException(int line, int column, String message) {
            // JFlex usa 0-based; adicionamos +1 para uma contagem legível (1-based)
            super(String.format("LEX ERROR (%d,%d): %s", line + 1, column + 1, message));
        }
    }

    // Conjunto (Set) de palavras reservadas para verificação rápida
    private static final Set<String> KEYWORDS = new HashSet<>();
    static {
        // Palavras-chave de Controle e Estruturas
        KEYWORDS.add("if");
        KEYWORDS.add("else");
        KEYWORDS.add("iterate");
        KEYWORDS.add("data");
        KEYWORDS.add("class");
        KEYWORDS.add("instance");
        KEYWORDS.add("for");
        KEYWORDS.add("return");
        KEYWORDS.add("new");
        
        // Tipos Fundamentais
        KEYWORDS.add("Int");
        KEYWORDS.add("Char");
        KEYWORDS.add("Float");
        KEYWORDS.add("Bool");
        KEYWORDS.add("Void");

        // Literais Bool e Null
        KEYWORDS.add("true");
        KEYWORDS.add("false");
        KEYWORDS.add("null");
    }

    // Função auxiliar para criar um novo Token com informações de posição ajustadas
    private Token makeToken(String lexeme) {
        return new Token(yyline + 1, yycolumn + 1, lexeme);
    }

%}

/* Etapa 2: Definições de Macros (Padrões Léxicos Reutilizáveis)  */

// Fim de Linha (End Of Line)
EOL = \r|\n|\r\n

// Caracteres de espaço em branco (Tabulação e Espaço, excluindo EOL)
WHITESPACE_CHARS = [ \t\f]

// Padrão completo de espaço em branco (a ser ignorado)
WHITESPACE = {WHITESPACE_CHARS}+ | {EOL}

// Comentário Simples: Inicia com '--' e vai até o EOL
LINE_COMMENT = "--" [^\r\n]*

/* --- Expressões para Literais --- */
// Literal Inteiro (apenas dígitos)
INT = [0-9]+

// Literal Ponto Flutuante (tratando casos como .123, 1.0, 123.456)
FLOAT = [0-9]* \. [0-9]+

// Escapes básicos dentro de um Char
CHAR_ESCAPE_SIMPLE = \\ [ntbr'\" \\]
// Escapes Octais (três dígitos)
CHAR_ESCAPE_OCTAL = \\ [0-9]{3}
// Qualquer caractere que não precise de escape e não seja delimitador
CHAR_REGULAR = [^ \\ ']
// O corpo de um literal CHAR (um dos três tipos acima)
CHAR_BODY = ( {CHAR_ESCAPE_SIMPLE} | {CHAR_ESCAPE_OCTAL} | {CHAR_REGULAR} )
// O literal CHAR completo (delimitado por aspas simples)
CHAR = \' {CHAR_BODY} \'

/* --- Expressões para Identificadores --- */
// ID de Variável/Função: Começa com minúscula
ID = [a-z] [a-zA-Z0-9_]*

// TYID de Tipo/Classe: Começa com maiúscula (Upper-case ID)
TYID = [A-Z] [a-zA-Z0-9_]*


/* --- Definição de Estados --- */
// Estado para lidar com comentários aninhados de bloco '{- ... -}'
%state BLOCK_COMMENT

%%


<YYINITIAL> {
    
    // 1. Omissão de Espaços
    {WHITESPACE}          { /* Descarta espaços e quebras de linha */ }

    // 2. Omissão de Comentários de Linha
    {LINE_COMMENT}        { /* Descarta o comentário */ }
    
    // 3. Início de Comentário em Bloco
    "{-"                  { yybegin(BLOCK_COMMENT); }

    /*
     * 4. Símbolos, Delimitadores e Operadores
     * Prioridade para os operadores de múltiplos caracteres
     */
    "::"                  { return makeToken("::"); } // Tipo/Contexto
    "=="                  { return makeToken("=="); } // Igualdade
    "!="                  { return makeToken("!="); } // Diferença
    "&&"                  { return makeToken("&&"); } // AND Lógico
    "->"                  { return makeToken("->"); } // Lexema: Operador de função / seta

        /*
     * 5. Literais
     * (a precedencia do FLOAT vem antes do INT)
     */
    {FLOAT}               { return makeToken(yytext()); }
    {INT}                 { return makeToken(yytext()); }
    {CHAR}                { return makeToken(yytext()
    
    // Símbolos de um caractere
    "("                   { return makeToken("("); }
    ")"                   { return makeToken(")"); }
    "["                   { return makeToken("["); }
    "]"                   { return makeToken("]"); }
    "{"                   { return makeToken("{"); }
    "}"                   { return makeToken("}"); }
    ">"                   { return makeToken(">"); }
    ";"                   { return makeToken(";"); }
    ":"                   { return makeToken(":"); }
    "."                   { return makeToken("."); }
    ","                   { return makeToken(","); }
    "="                   { return makeToken("="); } // Atribuição
    "<"                   { return makeToken("<"); }
    "+"                   { return makeToken("+"); }
    "-"                   { return makeToken("-"); }
    "*"                   { return makeToken("*"); }
    "/"                   { return makeToken("/"); }
    "%"                   { return makeToken("%"); } // Módulo
    "!"                   { return makeToken("!"); } // NOT Lógico
    
    /*
     * 6. Identificadores (ID de Variável e TYID de Tipo)
     * O token é criado. A identificação de Palavra-chave (Keyword) será feita
     * na classe Token ou no Parser, usando o Set estático.
     */
    {ID}                  { return makeToken(yytext()); }
    {TYID}                { return makeToken(yytext()); }

    /*
     * 7. Detecção de Erros Específicos em Literais CHAR
     * Regras de erro que devem ser tratadas antes do 'catch-all' [^]
     */
    // Char vazio: ''
    \'\'                  { throw new LexerException(yyline, yycolumn, "Literal char vazio detectado"); }
    // Char com conteúdo excessivo
    \' {CHAR_BODY} {CHAR_BODY}+ \' { throw new LexerException(yyline, yycolumn, "Literal char contém mais de um caractere: " + yytext()); }
    // Char com escape não reconhecido (ex: '\z')
    \' \\ [^ntbr'\" \\ 0-9] [^\']* \' { throw new LexerException(yyline, yycolumn, "Sequência de escape inválida ('\\...') no char: " + yytext()); }
    // Char com octal incompleto (menos de 3 dígitos)
    \' \\ [0-9]{1,2} [^\'0-9] [^\']* \' { throw new LexerException(yyline, yycolumn, "Escape octal deve ser \\ddd (3 dígitos): " + yytext()); }
    // Char não terminado (apenas o delimitador de abertura)
    \'                    { throw new LexerException(yyline, yycolumn, "Literal char não está fechado"); }
}


/*
 * Regras Léxicas para o Estado BLOCK_COMMENT
 */
<BLOCK_COMMENT> {
    
    // 1. Marcador de Fim de Comentário em Bloco
    "-}"                  { yybegin(YYINITIAL); } // Retorna ao estado inicial
    
    // 2. Consumo de Conteúdo
    // [^-}]+ consome o máximo de caracteres válidos
    [^-}]+                { /* Ignora conteúdo do bloco */ }
    
    // Consome os caracteres '-' ou '}' sozinhos para evitar quebrar o loop
    "-" | "}"             { /* Ignora separadamente */ }
    
    // 3. Tratamento de Erro (EOF)
    <<EOF>>               { throw new LexerException(yyline, yycolumn, "Fim de Arquivo encontrado dentro de um comentário em bloco não encerrado"); }
}


/*
 * 8. Regra de Erro Léxico Genérico
 * Esta é a última regra no YYINITIAL, capturando tokens que não se encaixam
 * em nenhum dos padrões válidos definidos acima. .
 */
[^]                   { throw new LexerException(yyline, yycolumn, "Caractere não reconhecido/inválido: " + yytext()); }