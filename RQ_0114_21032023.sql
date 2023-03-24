
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 

DECLARE @CR_STATUS VARCHAR(9)
DECLARE @CR_EMISSAO DATE
DECLARE @DATAINI DATE 
DECLARE @DATAFIM DATE 
DECLARE @PEDIDO VARCHAR(15)
 
 

SET @CR_STATUS = '03'
SET @CR_EMISSAO = (SELECT Cast(YEAR (SYSDATETIME()) as varchar(4)) + right('0'+cast( MONTH(SYSDATETIME())as varchar(2)),2) + right('0'+cast( DAY(SYSDATETIME())as varchar(2)),2))
SET @DATAINI = '20230105'-- Cast(YEAR (SYSDATETIME()) as varchar(4)) + right('0'+cast( MONTH(SYSDATETIME())as varchar(2)),2) +'01'
SET @DATAFIM  ='20230106'-- Cast(YEAR (SYSDATETIME()) as varchar(4)) + right('0'+cast( MONTH(SYSDATETIME())as varchar(2)),2) + right('0'+cast( DAY(SYSDATETIME())as varchar(2)),2)
SET @PEDIDO = ''
 

SELECT DISTINCT 
    NUM_SOLICITA = C7_NUMSC,
    CR_STATUS    ,
    C7_FILIAL    ,
    C7_NUM        ,
    C7_ITEM        ,
        CAST(C7_EMISSAO AS DATE) C7_EMISSAO,
        CAST(SA2.A2_NOME  AS VARCHAR (30)) A2_NOME     ,
        CAST(C7_NOMEFOR AS VARCHAR (30)) C7_NOMEFOR    ,
    C7_APROV    ,
    C7_PRECO    ,
    C7_TOTAL    ,
    USR_CODIGO    ,
        CAST(C7_DESCRI AS VARCHAR (30)) C7_DESCRI    ,
    CR_NUM        ,
    A2_COD        ,
    C7_QUANT    ,
    A2_LOJA        ,
    C7_CC        ,
    C7_OBS        ,
CR_NIVEL,
    ISNULL(C1_SOLICIT,'XXXXX') C1_SOLICIT,
    CAST(CR_DATALIB AS DATE) CR_DATALIB 
 
 
    FROM 
        SCR010 SCR WITH(NOLOCK)
    INNER JOIN    
        SC7010 SC7 WITH(NOLOCK)
    ON
        SCR.CR_NUM  = SC7.C7_NUM
    INNER JOIN 
        SYS_USR USR  WITH(NOLOCK)
    ON 
        SCR.CR_USER  = USR.USR_ID
    INNER JOIN 
        SA2010 SA2 WITH(NOLOCK)
    ON 
        SC7.C7_FORNECE = SA2.A2_COD
    LEFT JOIN 
        SC1010 SC1
    ON 
        SC1.C1_NUM = C7_NUMSC
        AND SC1.D_E_L_E_T_=''
 
       WHERE 0=0
        AND SCR.D_E_L_E_T_ =''
        AND SC7.D_E_L_E_T_ =''
        AND CR_STATUS = '03'
        AND C7_NUM LIKE '%'+ TRIM(@PEDIDO) +'%'
        AND CR_FILIAL = SC7.C7_FILIAL 
        AND C7_LOJA = A2_LOJA
       AND CR_NIVEL ='99' --// NIVEL MAXIMO DIS APROVADORES
       AND CAST(CR_EMISSAO AS DATE) BETWEEN @DATAINI AND @DATAFIM