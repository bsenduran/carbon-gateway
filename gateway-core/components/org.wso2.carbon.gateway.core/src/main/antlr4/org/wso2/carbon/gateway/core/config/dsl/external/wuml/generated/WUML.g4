grammar WUML;

script: commentStatement?
        START_UML NEWLINE+
        statementList
        END_UML
        NEWLINE*?
        EOF;

commentStatement: LINE_COMMENT | COMMENT | HASH_COMMENT;

LINE_COMMENT : '//' .*? NEWLINE+ -> skip ; // Match "//" stuff '\n'
COMMENT : '/*' .*? '*/' NEWLINE* -> skip ; // Match "/*" stuff "*/"
HASH_COMMENT: '#' .*?  NEWLINE+ -> skip;

statementList: (statement NEWLINE+)*;

statement
    : titleStatement
    | participantStatement
    | groupStatement
    | commentStatement;


/* Definition of the participating components which represents a
lifeline in the visual representation */
participantStatement
    : inboundEndpointDefStatement
    | pipelineDefStatement
    | outboundEndpointDefStatement
    ;


titleStatement: titleStatementDef;

titleStatementDef: INTEGRATIONFLOWX LPAREN IDENTIFIER_STRINGX RPAREN;

// Definition for a Inbound Endpoint
inboundEndpointDefStatement:
        PARTICIPANT WS+ IDENTIFIER WS+ COLON WS+ inboundEndpointDef;


inboundEndpointDef: INBOUNDENDPOINTX LPAREN PROTOCOLDEF PARAMX* RPAREN;

pipelineDefStatement
    : PARTICIPANT WS+ IDENTIFIER WS+ COLON WS+ pipelineDef;
pipelineDef: PIPELINEX LPAREN IDENTIFIER_STRINGX RPAREN;

outboundEndpointDefStatement
    : PARTICIPANT WS+ IDENTIFIER WS+ COLON WS+ outboundEndpointDef;

outboundEndpointDef: OUTBOUNDENDPOINTX LPAREN PROTOCOLDEF PARAMX* RPAREN;


groupStatement: groupDefStatement
                (subGroupStatement+ | messageflowStatementList)
                END;

groupDefStatement: GROUP WS+  GROUP_NAME_DEF WS*
                                 COMMA_SYMBOL WS* GROUP_PATH_DEF
                                 COMMA_SYMBOL WS* GROUP_SCHEME_DEF
                                 (COMMA_SYMBOL WS* GROUP_METHOD_DEF)? NEWLINE+;

GROUP_NAME_DEF: NAME WS* EQ_SYMBOL IDENTIFIER_STRINGX;
GROUP_PATH_DEF: PATH WS* EQ_SYMBOL WS* URL_STRINGX;
GROUP_SCHEME_DEF: SCHEME WS* EQ_SYMBOL WS* IDENTIFIER_STRINGX;
GROUP_METHOD_DEF: METHOD WS* EQ_SYMBOL WS* IDENTIFIER_STRINGX;

subGroupStatement: subGroupDefStatement
                    messageflowStatementList
                    END NEWLINE+;

subGroupDefStatement: SUB_GROUP WS+ GROUP_PATH_DEF COMMA_SYMBOL
                                      WS* GROUP_METHOD_DEF NEWLINE+;

messageflowStatementList: (messageflowStatement NEWLINE+)*;

messageflowStatement: routingStatement
                          | mediatorStatement
                          | parallelStatement
                          | ifStatement
                          | loopStatement
                          | refStatement;

routingStatement: routingStatementDef;

routingStatementDef: IDENTIFIER WS+ ARROW WS+ IDENTIFIER WS+ COLON WS+ DESCRIPTION_STRINGX;

mediatorStatement : mediatorStatementDef;

mediatorStatementDef: MEDIATORDEFINITIONX ARGUMENTLISTDEF;

parallelStatement
    : PAR NEWLINE?
      NEWLINE parMultiThenBlock
      END
    ;

parMultiThenBlock
    : messageflowStatementList NEWLINE (parElseBlock)? ;


parElseBlock
    : (ELSE NEWLINE messageflowStatementList)+ ;


ifStatement
    : ALT WS WITH WS conditionStatement NEWLINE
      NEWLINE? ifMultiThenBlock
      END
    ;

conditionStatement
    : conditionDef;

conditionDef: CONDITIONX LPAREN SOURCEDEF PARAMX* RPAREN;

SOURCEDEF: SOURCE LPAREN CONFIGPARAMS RPAREN;

ifMultiThenBlock
    : messageflowStatementList NEWLINE (ifElseBlock)? ;


ifElseBlock
    : (ELSE NEWLINE messageflowStatementList)+ ;


loopStatement
    : LOOP WS EXPRESSIONX NEWLINE
      NEWLINE? messageflowStatementList
      END
    ;

refStatement
    : REF WS IDENTIFIER NEWLINE?;


NEWLINE: ('\n'| '\r\n' | '\r');

START_UML: '@startuml';
END_UML:'@enduml';

WS: ' ';
TAB: [ \t]+ -> skip;
COLON: ':';
LPAREN: '(';
RPAREN: ')';
DOUBLEQUOTES: '"';
COMMA_SYMBOL: ',';
EQ_SYMBOL: '=';
ARROW: '->';
SINGLEQUOTES:'\'';
AMP_SYMBOL : '&' ;
AMPAMP_SYMBOL : '&&' ;
CARET_SYMBOL : '^' ;
COMMENT_SYMBOL : '--' ;
CONTINUATION_SYMBOL : '\\' | '\u00AC' ;
GE_SYMBOL : '>=' | '\u2265' ;
GT_SYMBOL : '>' ;
LE_SYMBOL : '<=' | '\u2264' ;
LT_SYMBOL : '<' ;
MINUS_SYMBOL : '-' ;
NE_SYMBOL : '<>' | '\u2260';
PLUS_SYMBOL : '+' ;
STAR_SYMBOL : '*' ;
SLASH_SYMBOL : '/' ;
UNDERSCORE : '-';


PARTICIPANT: P A R T I C I P A N T;
PROTOCOL: P R O T O C O L;



INTEGRATIONFLOWX: INTEGRATIONFLOW;
INBOUNDENDPOINTX: INBOUNDENDPOINT;
PIPELINEX: PIPELINE;
OUTBOUNDENDPOINTX: OUTBOUNDENDPOINT;
IDENTIFIER_STRINGX: IDENTIFIER_STRING;
URL_STRINGX: URL_STRING;
DESCRIPTION_STRINGX: DESCRIPTION_STRING;
MEDIATORDEFINITIONX: MEDIATORDEFINITION;
EXPRESSIONX: EXPRESSION;
CONDITIONX: CONDITION;
END: E N D;
GROUP: G R O U P;
SUB_GROUP: 'sub-group';
NAME: N A M E;
PATH: P A T H;
SCHEME: S C H E M E;
METHOD: M E T H O D;
PAR: P A R;
ELSE: E L S E;
ALT: A L T;
WITH: W I T H;
LOOP: L O O P;
REF: R E F;
SOURCE: S O U R C E;


fragment INTEGRATIONFLOW: I N T E G R A T I O N F L O W;
fragment INBOUNDENDPOINT: I N B O U N D E N D P O I N T;
fragment PIPELINE: P I P E L I N E;
fragment OUTBOUNDENDPOINT: O U T B O U N D E N D P O I N T;
fragment IDENTIFIER_STRING: DOUBLEQUOTES IDENTIFIER DOUBLEQUOTES;
fragment URL_STRING: DOUBLEQUOTES URL DOUBLEQUOTES;
fragment EXPRESSION: E X P R E S S I O N;
fragment CONDITION: C O N D I T I O N;
fragment MEDIATORDEFINITION: IDENTIFIER COLON COLON IDENTIFIER;

ARGUMENTLISTDEF: LPAREN (CONFIGPARAMS COMMA_SYMBOL)* (CONFIGPARAMS)* RPAREN;


IDENTIFIER
    : ( 'a'..'z' | 'A'..'Z' ) ( 'a'..'z' | 'A'..'Z' | '0'..'9' | '_')+ ;

URL: ([a-zA-Z/\?&] | COLON | [0-9])+;

ANY_STRING: (IDENTIFIER|URL)+;

PROTOCOLDEF:  PROTOCOL LPAREN IDENTIFIER_STRINGX RPAREN;

fragment CONFIGPARAMS: (WS | [a-zA-Z\?] | COLON | [0-9] | '$' | '.' | '@' |
                        SINGLEQUOTES | DOUBLEQUOTES | '{' | '}' | AMP_SYMBOL |
                        AMPAMP_SYMBOL | CARET_SYMBOL | COMMA_SYMBOL |
                        COMMENT_SYMBOL | CONTINUATION_SYMBOL | EQ_SYMBOL |
                        GE_SYMBOL | GT_SYMBOL | LE_SYMBOL | LT_SYMBOL |
                        MINUS_SYMBOL | NE_SYMBOL | PLUS_SYMBOL | STAR_SYMBOL |
                        SLASH_SYMBOL )+;

PARAMX: COMMA_SYMBOL IDENTIFIER LPAREN DOUBLEQUOTES ANY_STRING DOUBLEQUOTES RPAREN;

fragment DESCRIPTION_STRING: DOUBLEQUOTES .*? DOUBLEQUOTES;




// case insensitive lexer matching
fragment A:('a'|'A');
fragment B:('b'|'B');
fragment C:('c'|'C');
fragment D:('d'|'D');
fragment E:('e'|'E');
fragment F:('f'|'F');
fragment G:('g'|'G');
fragment H:('h'|'H');
fragment I:('i'|'I');
fragment J:('j'|'J');
fragment K:('k'|'K');
fragment L:('l'|'L');
fragment M:('m'|'M');
fragment N:('n'|'N');
fragment O:('o'|'O');
fragment P:('p'|'P');
fragment Q:('q'|'Q');
fragment R:('r'|'R');
fragment S:('s'|'S');
fragment T:('t'|'T');
fragment U:('u'|'U');
fragment V:('v'|'V');
fragment W:('w'|'W');
fragment X:('x'|'X');
fragment Y:('y'|'Y');
fragment Z:('z'|'Z');