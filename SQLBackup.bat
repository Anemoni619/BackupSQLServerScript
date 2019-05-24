::imposta di non fare vedere la finestra di cmd
echo off
:: pulisce la console
cls

:: --------------------------------------------------
:: definisce le variabili con l'indirizzo del server e del dbase 

set SERVERNAME=NOMEISTANZA
set DATABASENAME=NOMEDBASE

:: recupera l'ora e la data per comporre il nome del file
:: DDMMYYYYHHMMSS,SS
set MyTime=%TIME: =0%
set MyDate=%DATE:/=%%TIME::=%
set FileName=%DATABASENAME%_%MyDate%.bak

:: imposta il percorso dove salvare il backup
set BAK_PATH=C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\Backup\
set DEST_FILE=%BAK_PATH%%FileName%


:: --------------------------------------------------
:: BACKUP Database
:: NOTE: se compare l'errore "accesso negato" andare :
:: pannello di controllo/strumenti di amministrazione/servizi/SQL Server()/Proprietà/Connessione

:: ----------------comandi sqlcmd--------------------
:: -E (use trusted connection) 
:: -S [protocol:]server[instance_name][,port] 
:: -d db_name
:: -Q "cmdline query" (and exit) 

::  ----------------opzioni Query--------------------
:: INIT specifica che tutti i set di backup devono essere sovrascritti
:: NOUNLOAD Specifica che dopo l'operazione BACKUP il nastro rimane caricato sull'unità nastro
:: NOSKIP gli eventuali set di backup con lo stesso nome presenti nel supporto vengono sovrascritti
:: STATS = 10 ogni quanta % di completamento aggiornare lo stato di avanzamento
:: NOFORMAT specifica che l'operazione di backup deve mantenere l'intestazione supporto e i set di backup esistenti nei volumi dei supporti usati per l'operazione di backup stessa

sqlcmd -E -S %SERVERNAME% -d master -Q "BACKUP DATABASE [%DATABASENAME%] TO DISK = N'%DEST_FILE%' WITH INIT , NOUNLOAD , NAME = N'%DATABASENAME% backup', NOSKIP , STATS = 10, NOFORMAT"


:: --------------------------------------------------
:: Zippa il file
C:
cd\
cd "Program Files\7-Zip"
7z.exe a -tzip "%DEST_FILE%.zip" "%DEST_FILE%"

 
:: --------------------------------------------------
:: Cancella il file originale non zippato
DEL "%DEST_FILE%"