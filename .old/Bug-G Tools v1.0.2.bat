chcp 65001
setlocal
call :setESC


REM ******************************************** STEAM GAME LIBRARY ********************************************
 
	for /f "tokens=3" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam"  /V InstallPath  ^|findstr /ri "REG_SZ"') do SET "steam_path= %%a

REM *********************************************************************************************************

@ECHO off
CLS


:start
	echo [101;93m                                                                                                                    [0m
	echo [101;93m                                      [37m Bug-G Tools - @RTK_JulliZ - v1.0.2 Aug-2021                                  [0m
	echo [101;93m                                                                                                                    [0m
	ECHO.
	ECHO [101;93m Escolha uma opção:                                                                                                 [0m
	ECHO.
	ECHO     [95m 1. Corrigir Lag na Rede (Requer Admin) [0m
	ECHO     [33m 2. Habilitar vídeos [0m
	ECHO     [91m 3. Desabilitar vídeos [0m
	ECHO     [94m 4. Backup de configurações [0m
	ECHO     [93m 5. Restaurar backup [0m
	ECHO.
	ECHO     0. Fechar o jogo;
	ECHO.
	ECHO.
	ECHO ************************************************************************************************
	SET choice=
	SET /p choice=Sua opção: 
	
	if not '%choice%'=='' SET choice=%choice:~0,1%
	if '%choice%'=='1' GOTO LAG_NA_REDE
	if '%choice%'=='2' GOTO HABILITAR_VIDEOS
	if '%choice%'=='3' GOTO DESABILITAR_VIDEOS
	if '%choice%'=='4' GOTO BACKUP
	if '%choice%'=='5' GOTO RESTAURAR_BACKUP
	if '%choice%'=='0' GOTO FECHAR_JOGO
	
	CLS
	
	GOTO start
		:LAG_NA_REDE
			CLS
			ECHO [105m                                                                                                             [0m
			ECHO [105m                                Iniciando comandos para LAG NA REDE...                                       [0m
			ECHO [105m                                                                                                             [0m
			ECHO.
			timeout /t 3 /nobreak >nul
			CLS
			
			ECHO. 
			ECHO [95m                                  Resetando configurações de DNS...                                [
			ECHO.
			ECHO.
			ipconfig /flushdns
			timeout /t 2 /nobreak >nul
			CLS
			
			ECHO.
			ECHO [95m                                  Registrando configurações de DNS...                                [0
			ECHO.
			ECHO.
			ipconfig /registerdns
			timeout /t 2 /nobreak >nul
			CLS
			
			ECHO.
			ECHO [95m                                 Configurando definições sobre IP...                                [0
			ECHO.
			ECHO.
			ipconfig /release
			timeout /t 2 /nobreak >nul
			CLS
			
			ECHO.
			ECHO [95m                                  Renovando configurações de IP...                                [0
			ECHO.
			ECHO.
			ipconfig /renew
			timeout /t 2 /nobreak >nul
			CLS
			
			ECHO.
			ECHO [95m                          Configurando WinSock ...                                [0m
			ECHO.
			ECHO.
			netsh winsock reset
			timeout /t 2 /nobreak >nul
			CLS
			ECHO                       [102m                                                                        [0m
			ECHO                       [102m                       AS CONFIGURAÇÕES FORAM REDEFINIDAS               [0m
			ECHO                       [102m        Se o erro persistir, tente execução como administrador.         [0m
			ECHO                       [102m                                                                        [0m
			ECHO.
			ECHO.
			GOTO start
		
	
		:HABILITAR_VIDEOS
			CLS
			ECHO [43m                                                                                                             [0m
			ECHO [43m                         Iniciando comandos para habilitar vídeos ...                                        [0m
			ECHO [43m                                                                                                             [0m
			ECHO.
			timeout /t 3 /nobreak >nul
			CLS
	
			ECHO.
			ECHO [33m                                  Habilitando vídeos...                                          [0
			ECHO.
			timeout /t 2 /nobreak >nul
			CD /D "%steam_path%\steamapps\common\PUBG\TslGame\Content\Movies" 
			ren *.mp4_BAK *.mp4
			ren *.webm_BAK *.webm
			CLS
			
			ECHO.
			ECHO [33m                                  Guardando cópias de segurança ...                                          [0
			ECHO.
			timeout /t 2 /nobreak >nul
			CLS
			
			ECHO                       [102m                                                                        [0m
			ECHO                       [102m                OS VÍDEOS DE INTRODUÇÃO FORAM HABILITADOS               [0m
			ECHO                       [102m         Caso mude de ideia, você poderá reverter a operação.           [0m
			ECHO                       [102m                                                                        [0m
			ECHO.
			ECHO.
			GOTO start
			
		:DESABILITAR_VIDEOS
			CLS
			ECHO [41m                                                                                                             [0m
			ECHO [41m                        Iniciando comandos para desabilitar vídeos ...                                       [0m
			ECHO [41m                                                                                                             [0m
			ECHO.
			timeout /t 3 /nobreak >nul	
			CLS
			
			ECHO.
			ECHO [91m                                  Desabilitando vídeos...                                          [0
			ECHO.
			timeout /t 2 /nobreak >nul
			CD /D "%steam_path%\steamapps\common\PUBG\TslGame\Content\Movies"
			del *.mp4_BAK
			del *.webm_BAK
			ren *.mp4 *.mp4_BAK
			ren *.webm *.webm_BAK
			CLS
			
			ECHO.
			ECHO [91m                                  Removendo cópias de segurança ...                                          [0
			ECHO.
			timeout /t 2 /nobreak >nul
			CLS
			
			ECHO                       [102m                                                                        [0m
			ECHO                       [102m               OS VÍDEOS DE INTRODUÇÃO FORAM DESABILITADOS              [0m
			ECHO                       [102m         Caso mude de ideia, você poderá reverter a operação.           [0m
			ECHO                       [102m                                                                        [0m
			ECHO.
			ECHO.
			GOTO start
		
		:BACKUP
			CLS
			ECHO [44m                                                                                                             [0m
			ECHO [44m                            Iniciando comandos para realização de backup...                                  [0m
			ECHO [44m                                                                                                             [0m
			CLS
			
			ECHO.
			ECHO [94m                                  Localizando diretório ...                                          [0
			ECHO.
			timeout /t 2 /nobreak >nul
			CLS
			XCOPY /F "%LocalAppData%\TslGame\Saved\Config\WindowsNoEditor\GameUserSettings.ini"
			CLS
			
			ECHO.
			ECHO [94m                                  Gravando cópia de segurança...                                          [0
			ECHO.
			timeout /t 2 /nobreak >nul
			CLS
			
			ECHO                       [102m                                                                        [0m
			ECHO                       [102m                         BACKUP REALIZADO COM SUCESSO                   [0m
			ECHO                       [102m            Guarde o arquivo gerado neste mesmo diretório.              [0m
			ECHO                       [102m                                                                        [0m
			ECHO.
			ECHO.
			GOTO start
		
		:RESTAURAR_BACKUP
			XCOPY /F "GameUserSettings.ini" "%LocalAppData%\TslGame\Saved\Config\WindowsNoEditor"
			CLS
			ECHO                       [102m                                                                        [0m
			ECHO                       [102m                    RESTAURAÇÃO REALIZADA COM SUCESSO                   [0m
			ECHO                       [102m             Suas configurações foram movidas para o game.              [0m
			ECHO                       [102m                                                                        [0m
			ECHO.
			ECHO.
			GOTO start
			
		:FECHAR_JOGO
			TASKKILL /f /IM TslGame.exe
			TASKKILL /f /IM zksvc.exe
			CLS
			ECHO JOGO ENCERRADO!
			ECHO.
			ECHO.
			GOTO start

	:end
Timeout -1 1>Nul