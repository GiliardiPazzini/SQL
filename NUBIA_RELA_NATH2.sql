
SET ANSI_NULLS ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 


DECLARE @CR_STATUS VARCHAR(9)
DECLARE @CR_DATALIB DATE
DECLARE @DATAINI DATE 
DECLARE @DATAFIM DATE 
DECLARE @PEDIDO VARCHAR(15)
DECLARE @TOTAL_PED2 VARCHAR(15)
DECLARE @TOTAL_PED VARCHAR(15)
DECLARE @VLLIMIT_PED VARCHAR(15)
DECLARE @VLINI VARCHAR(15)
DECLARE @USER VARCHAR(15)

 

SET @CR_STATUS = '02'
SET @DATAINI = '20230301'
SET @DATAFIM  ='20230328'
SET @VLINI  ='10000'
SET @USER ='000160'


SELECT  * FROM ( 
		SELECT DISTINCT
			C7_FILIAL   ,
			C7_NUM 		,
   			CR_STATUS   ,
       		CAST(C7_EMISSAO AS DATE) C7_EMISSAO,
       		CAST(SA2.A2_NOME  AS VARCHAR (30)) A2_NOME,
			TOTAL_PED = (SELECT SUM(SC7T.C7_TOTAL)  FROM SC7010 SC7T(NOLOCK) WHERE SC7.C7_FILIAL+SC7.C7_NUM+SC7.C7_FORNECE+SC7.C7_LOJA=SC7T.C7_FILIAL+SC7T.C7_NUM+SC7T.C7_FORNECE+SC7T.C7_LOJA),
   			A2_LOJA,
			C7_USER
   			--CR_NUM        ,
   		    --A2_COD        ,
   			--C7_QUANT    ,
			USR_NOME,
			USR_CODIGO
   		FROM 
       		SCR010 SCR WITH(NOLOCK)
   			INNER JOIN SC7010 SC7 WITH(NOLOCK)
   			ON SCR.CR_NUM  = SC7.C7_NUM
   			INNER JOIN SYS_USR USR  WITH(NOLOCK)
   			ON SCR.CR_USER  = USR.USR_ID
   			INNER JOIN SA2010 SA2 WITH(NOLOCK)
   			ON SC7.C7_FORNECE = SA2.A2_COD
   			LEFT JOIN SC1010 SC1
   			ON SC1.C1_NUM = C7_NUMSC AND SC1.D_E_L_E_T_=''
 

   		WHERE 0=0
       			AND SCR.D_E_L_E_T_ =''
       			AND SC7.D_E_L_E_T_ =''
       			AND CR_STATUS = '02'
       			AND CR_FILIAL = SC7.C7_FILIAL 
       			AND C7_LOJA = A2_LOJA
				and C7_EMISSAO >= @DATAINI
				AND C7_EMISSAO <= @DATAFIM
				AND C7_MOEDA ='01'
				AND C7_USER =@USER
				--AND C7_USER like  '%'+@USER+'%'
				AND CAST(C7_EMISSAO AS DATE) BETWEEN @DATAINI AND @DATAFIM
				--GROUP BY C7_FILIAL,C7_NUM,CR_STATUS,C7_EMISSAO,A2_NOME,A2_LOJA,TOTAL_PED
				--HAVING (SELECT SUM(SC7T.C7_TOTAL)  FROM SC7010 SC7T(NOLOCK) WHERE SC7.C7_FILIAL+SC7.C7_NUM+SC7.C7_FORNECE+SC7.C7_LOJA=SC7T.C7_FILIAL+SC7T.C7_NUM+SC7T.C7_FORNECE+SC7T.C7_LOJA) >= 10000

) TAB1

WHERE TOTAL_PED >= @VLINI