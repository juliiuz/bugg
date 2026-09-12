chcp 65001
title Bug-G v1.0.4 - by RTK_JulliZ
setlocal
call :setESC
CLS

:: ******************************************** STEAM GAME LIBRARY ********************************************
 
	for /f "tokens=3" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam"  /V InstallPath  ^|findstr /ri "REG_SZ"') do SET "steam_path= %%a"
	SET "desktop_folder=%userprofile%\Desktop"

:: ***********************************************************************************************************

CLS
@ECHO off

:start
	echo [101;93m                                                                                                                        [0m
	echo [101;93m                                      Bug-G Tools - @RTK_JulliZ - v1.0.4 Abr-2022                                       [0m
	echo [101;93m                                                                                                                        [0m
	ECHO.
	ECHO   [95m ************************************** WINDOWS **************************************** [0m
	ECHO   [95m *                                                                                    [95m * [0m
	ECHO   [95m *  •[0m Corrigir Lag na rede [95m[10][0m [90mA[0m                                                     [95m * [0m
	ECHO   [95m *  •[0m Encerrar processos irrelevantes [95m[11][0m [90mA[0m                                          [95m * [0m
	::ECHO   [95m *  •[0m Ajustar performance do Windows [95m[12][0m [90mA[0m                                           [95m * [0m
	ECHO   [95m *                                                                                    [95m * [0m
	ECHO   [95m *                                                                                    [95m * [0m
	ECHO   [95m *************************************************************************************** [0m
	ECHO.
	ECHO   [91m ************************************ ARQUIVOS ***************************************** [0m 
	ECHO   [91m *                                                                                    [91m * [0m
	ECHO   [91m *  [91m•[0m Eliminar arquivos temporários PUBG [91m[20][0m                                         [91m * [0m
	ECHO   [91m *  [91m•[0m Eliminar arquivos temporários PUBG e Windows [91m[21][0m [90mA[0m                             [91m * [0m
	ECHO   [91m *                                                                                    [91m * [0m
	ECHO   [91m *                                                                                    [91m * [0m
	ECHO   [91m *************************************************************************************** [0m
	ECHO.
	ECHO   [33m *********************************** PREFERÊNCIAS ************************************** [0m 
	ECHO   [33m *                                                                                    [33m * [0m
	ECHO   [33m *  [33m•[0m Vídeos:            Ativar [33m[30][0m   -   Desativar [33m[31][0m                             [33m * [0m
	ECHO   [33m *  [33m•[0m Config:            Backup [33m[32][0m   -   Restaurar [33m[33][0m                             [33m * [0m
	ECHO   [33m *  [33m•[0m Crash Reporter:    Ativar [33m[34][0m   -   Desativar [33m[35][0m                             [33m * [0m
	ECHO   [33m *                                                                                    [33m * [0m
	ECHO   [33m *                                                                                    [33m * [0m
	ECHO   [33m *************************************************************************************** [0m
	ECHO.
	ECHO   [32m *************************************** GAME ****************************************** [0m
	ECHO   [32m *                                                                                    [32m * [0m
	ECHO   [32m *  [32m•[0m Abrir game             [32m[90][0m                                                     [32m * [0m
	ECHO   [32m *  [32m•[0m Fechar e abrir game    [32m[98][0m [90mA[0m                                                   [32m * [0m
	ECHO   [32m *                                                                                    [32m * [0m
	ECHO   [32m *  [32m•[0m Fechar game            [32m[99][0m [90mA[0m                                                   [32m * [0m
	ECHO   [32m *                                                                                    [32m * [0m
	ECHO   [32m *                                                                                    [32m * [0m
	ECHO   [32m *************************************************************************************** [0m
	ECHO.
	ECHO     ^* [90mA[0m = Requer privilégios de administrador
	ECHO     ^* [90mL[0m = Requer logout
	ECHO     ^* [90mR[0m = Requer restart
	ECHO.
	ECHO.
	SET choice=
	SET /p choice=Sua opção: 
	
	if not '%choice%'=='' SET choice=%choice:~0,2%
	
	:: WINDOWS
	if '%choice%'=='10' GOTO fix_network_issues
	if '%choice%'=='11' GOTO end_winprocesses
	if '%choice%'=='12' GOTO adjust_performance

	:: FILES
	if '%choice%'=='20' GOTO clean_game_tempdir
	if '%choice%'=='21' GOTO clean_windows_tempdir

	:: PREFERENCES
	if '%choice%'=='30' GOTO enable_media
	if '%choice%'=='31' GOTO disable_media
	if '%choice%'=='32' GOTO config_backup
	if '%choice%'=='33' GOTO restore_backup
	if '%choice%'=='34' GOTO enable_crashreporter
	if '%choice%'=='35' GOTO disable_crashreporter

	:: GAME
	if '%choice%'=='90' GOTO open_game
	if '%choice%'=='98' GOTO end_open_game
	if '%choice%'=='99' GOTO end_game
	
	
	SET choice=
	if  '%choice%'=='' GOTO invalid_option
	CLS
	
	GOTO start
		:: ************************************************************ WINDOWS ************************************************************
		:fix_network_issues
			CLS
			ECHO [105m                                                                                                                        [0m
			ECHO [105m                                             CORRIGIR PROBLEMAS DE CONEXÃO                                              [0m
			ECHO [105m                                                                                                                        [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO.
			
			ECHO [95m • Resetando configurações de DNS...[0m
			ECHO.
			ipconfig /flushdns >nul 2>&1
			timeout /t 1 /nobreak >nul 2>&1
			
			ECHO [95m • Registrando configurações de DNS...[0m
			ECHO.
			ipconfig /registerdns >nul 2>&1
			timeout /t 1 /nobreak >nul 2>&1
			
			ECHO [95m • Configurando definições sobre IP...[0m
			ECHO.
			ipconfig /release >nul 2>&1
			timeout /t 1 /nobreak >nul 2>&1		
			
			ECHO [95m • Renovando configurações de IP...[0m
			ECHO.
			ipconfig /renew >nul 2>&1
			timeout /t 1 /nobreak >nul 2>&1	
			
			ECHO [95m • Configurando WinSock...[0m
			ECHO.
			netsh winsock reset>nul
			ECHO.
			ECHO.
			
			ECHO [95m------------------------------------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [95m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
			timeout /t 5 /nobreak >nul 2>&1
			CLS
			GOTO start
	
		:end_winprocesses
			openfiles >nul 2>&1 2>&1
			if not %ErrorLevel% equ 0 (
				GOTO requires_adm
			) else (
				CLS
				ECHO [105m                                                                                                                        [0m
				ECHO [105m                                      ENCERRAR PROCESSOS IRRELEVANTES DO WINDOWS                                        [0m
				ECHO [105m                                                                                                                        [0m
				ECHO.
				ECHO.
				timeout /t 2 /nobreak >nul 2>&1
				ECHO.
				
				ECHO [95m • Encerrando processos...
				ECHO.
				ECHO    - CHROME
				taskkill /f /IM "chrome.exe" >nul 2>&1
				taskkill /f /IM "GoogleCrashHandler64.exe" >nul 2>&1
				ECHO    - ONEDRIVE
				taskkill /f /IM "onedrive.exe" >nul 2>&1
				ECHO    - XBOX
				taskkill /f /IM "GameBarFTServer.exe" >nul 2>&1
				ECHO    - SKYPE
				taskkill /f /IM "Skype.exe" >nul 2>&1
				ECHO.
				ECHO.
				
				ECHO [95m • Encerrando serviços do Windows...
				ECHO.
				ECHO    - Windows Firewall
				netsh advfirewall set allprofiles state off >nul 2>&1
				ECHO    - Bluetooth
				NET STOP "BTAGService" /yes >nul 2>&1
				NET STOP "bthserv" /yes >nul 2>&1
				NET STOP "BluetoothUserService" /yes >nul 2>&1
				ECHO    - Serviços de Impressão
				NET STOP "Spooler" /yes >nul 2>&1
				ECHO    - Fax
				NET STOP "Fax" /yes >nul 2>&1
				ECHO    - Acesso Remoto
				NET STOP "RasMan" /yes >nul 2>&1
				NET STOP "SessionEnv" /yes >nul 2>&1
				NET STOP "TermService" /yes >nul 2>&1
				ECHO    - Windows Insider
				NET STOP "msiserver" /yes >nul 2>&1
				ECHO    - Secondary Logon
				NET STOP "seclogon" /yes >nul 2>&1
				ECHO    - Mapas
				NET STOP "mapsbroker" /yes >nul 2>&1
				ECHO    - Touch Keyboard and Handwriting Panel Service
				NET STOP "TabletInputService" /yes >nul 2>&1
				ECHO    - Offline Files
				NET STOP "CscService" /yes >nul 2>&1
				ECHO    - Remote Registry
				NET STOP "RemoteRegistry" /yes >nul 2>&1
				ECHO    - Application Layer Gateway Service
				NET STOP "ALG" /yes >nul 2>&1
				ECHO    - Smart Card
				NET STOP "SCardSvr" /yes >nul 2>&1
				ECHO    - Windows Image Acquisition ^(WIA^)
				NET STOP "stisvc" /yes >nul 2>&1
				ECHO    - Security Center
				NET STOP "wscsvc" /yes >nul 2>&1
				ECHO    - Connected User Experiences and Telemetry
				NET STOP "DiagTrack" /yes >nul 2>&1
				ECHO    - Retail Demo Service
				NET STOP "RetailDemo" /yes >nul 2>&1
				ECHO    - Windows Media Player Network Sharing Service
				NET STOP "WMPNetworkSvc" /yes >nul 2>&1
				ECHO    - AllJoyn Router Service
				NET STOP "AJRouter" /yes >nul 2>&1
				ECHO    - Geolocation Service
				NET STOP "lfsvc" /yes >nul 2>&1
				ECHO    - Enterprise App Management Service
				NET STOP "EntAppSvc" /yes >nul 2>&1
				ECHO    - Internet Connection Sharing
				NET STOP "SharedAccess" /yes >nul 2>&1
				ECHO    - Windows Biometric Service
				NET STOP "WbioSrvc" /yes >nul 2>&1
				ECHO    - Windows Mobile Hotspot Service
				NET STOP "icssvc" /yes >nul 2>&1
				ECHO    - AppX Deployment Service ^(AppXSVC^)
				NET STOP "AppXSvc" /yes >nul 2>&1
				ECHO    - Windows Search
				NET STOP "WSearch" /yes >nul 2>&1
				ECHO    - Click-to-Run Microsoft Office
				NET STOP "ClickToRunSvc" /yes >nul 2>&1
				ECHO    - Xbox
				NET STOP "XblAuthManager" /yes >nul 2>&1
				NET STOP "XblGameSave" /yes >nul 2>&1
				ECHO.
				ECHO    - Serviços diversos
				NET STOP "Origin Cliente Service" /yes >nul 2>&1
				NET STOP "Origin Web Helper Service" /yes >nul 2>&1
				NET STOP "Rockstar" /yes >nul 2>&1
				NET STOP "AdobeUpdateService" /yes >nul 2>&1
				ECHO.
				ECHO.
				
				ECHO [95m------------------------------------------------------------------------------------------------------------------------[0m
				ECHO.
				ECHO.
				ECHO [95m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
				timeout /t 5 /nobreak >nul 2>&1
				CLS
				GOTO start
			)
			
		:adjust_performance
			CLS
			ECHO [105m                                                                                                                        [0m
			ECHO [105m                                            AJUSTAR PERFORMANCE DO WINDOWS                                              [0m
			ECHO [105m                                                                                                                        [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO.
			
				:confirm_perf_mode
				ECHO [95m • Para qual perfil o Windows deve ser ajustado?[0m
				ECHO.
				ECHO.
				ECHO      [95m1[0m - Modo Performance
				ECHO      [95m0[0m - Automático
				ECHO.
				ECHO.
				set /P perf_mode=Sua resposta (1 ou 0): 
				if /I "%perf_mode%" EQU "1" goto :best_perf_mode
				if /I "%perf_mode%" EQU "0" goto :auto_perf_mode
				
				SET perf_mode=
				if  '%perf_mode%'=='' GOTO restore_backup
				goto :confirm_file_allocated
				
					:best_perf_mode
					ECHO best_perf_mode
					pause
				
					:auto_perf_mode
					ECHO auto_perf_mode
					pause
			
			
			
		:: ************************************************************* FILES *************************************************************
		:clean_game_tempdir
			CLS
			ECHO [41m                                                                                                                        [0m
			ECHO [41m                                        LIMPEZA DE ARQUIVOS TEMPORÁRIOS ^(PUBG^)                                          [0m
			ECHO [41m                                                                                                                        [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [91m • Removendo arquivos:[0m
			ECHO.
	
			ECHO [91m    - ../CRASHES[0m
			ECHO.
			timeout /t 1 /nobreak >nul 2>&1
			RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Crashes" >nul 2>&1
			
			ECHO [91m    - ../DEMOS[0m
			ECHO.
			timeout /t 1 /nobreak >nul 2>&1
			RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Demos" >nul 2>&1
			
			ECHO [91m    - ../DIST[0m
			ECHO.
			timeout /t 1 /nobreak >nul 2>&1
			RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Dist" >nul 2>&1
			
			ECHO [91m    - ../LOGS[0m
			ECHO.
			timeout /t 1 /nobreak >nul 2>&1
			RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Logs" >nul 2>&1

			ECHO [91m    - ../Arquivos diversos...[0m
			ECHO.
			timeout /t 1 /nobreak >nul 2>&1
			CD /D "%LOCALAPPDATA%\TslGame\Saved" >nul 2>&1
			DEL /Q *.ushaderprecache >nul 2>&1
			ECHO.
			ECHO.
			
			ECHO [91m------------------------------------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [91m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
			timeout /t 5 /nobreak >nul 2>&1
			CLS
			GOTO start
		
		:clean_windows_tempdir
			openfiles >nul 2>&1
			if not %ErrorLevel% equ 0 (
				GOTO requires_adm
			) else (
				CLS
				ECHO [41m                                                                                                                        [0m
				ECHO [41m                                   LIMPEZA DE ARQUIVOS TEMPORÁRIOS ^(PUBG + WINDOWS^)                                     [0m
				ECHO [41m                                                                                                                        [0m
				ECHO.
				ECHO.
				timeout /t 2 /nobreak >nul 2>&1
				ECHO [91m • Removendo arquivos:[0m
				ECHO.
				
				ECHO [91m    - ../CRASHES[0m
				ECHO.
				timeout /t 1 /nobreak >nul 2>&1
				RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Crashes" >nul 2>&1	

				ECHO [91m    - ../DEMOS[0m
				ECHO.
				timeout /t 1 /nobreak >nul 2>&1
				RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Demos" >nul 2>&1	
				
				ECHO [91m    - ../DIST[0m
				ECHO.
				timeout /t 1 /nobreak >nul 2>&1
				RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Dist" >nul 2>&1	
				
				ECHO [91m    - ../LOGS[0m
				ECHO.
				timeout /t 1 /nobreak >nul 2>&1
				RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Logs" >nul 2>&1	

				ECHO [91m    - ../Arquivos diversos...[0m
				ECHO.
				timeout /t 1 /nobreak >nul 2>&1
				CD /D "%LOCALAPPDATA%\TslGame\Saved" >nul 2>&1	
				DEL /Q *.ushaderprecache >nul 2>&1 >nul 2>&1	
				
				ECHO [91m    - ../Arquivos temporários do Windows...[0m
				ECHO.
				timeout /t 1 /nobreak >nul 2>&1
				RMDIR /S /Q "%LOCALAPPDATA%\Temp" >nul 2>&1	
				RMDIR /S /Q "%TEMP%"  >nul 2>&1
				RMDIR /S /Q "%systemdrive%\Windows\Temp" >nul 2>&1
				ECHO.
				ECHO.
				
				ECHO [91m------------------------------------------------------------------------------------------------------------------------[0m
				ECHO.
				ECHO.
				ECHO [91m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
				timeout /t 5 /nobreak >nul 2>&1
				CLS
				GOTO start
			)
		
		:: *********************************************************** PREFERENCES *********************************************************
		:enable_media
			CLS
			ECHO [43m                                                                                                                        [0m
			ECHO [43m                                             HABILITAR VÍDEOS DE INTRODUÇÃO                                             [0m
			ECHO [43m                                                                                                                        [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m • Habilitando vídeos...[0m
			ECHO.
	
			timeout /t 2 /nobreak >nul 2>&1
			CD /D "%steam_path%\steamapps\common\PUBG\TslGame\Content\Movies" 
			ren *.mp4_BAK *.mp4 >nul 2>&1
			ren *.webm_BAK *.webm >nul 2>&1
			ECHO.
			ECHO.
			
			ECHO [33m------------------------------------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [33m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
			timeout /t 5 /nobreak >nul 2>&1
			CLS
			GOTO start
			
		:disable_media
			CLS
			ECHO [43m                                                                                                                        [0m
			ECHO [43m                                           DESABILITAR VÍDEOS DE INTRODUÇÃO                                             [0m
			ECHO [43m                                                                                                                        [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m • Desabilitando vídeos...[0m
			ECHO.
			
			timeout /t 2 /nobreak >nul 2>&1
			CD /D "%steam_path%\steamapps\common\PUBG\TslGame\Content\Movies"
			del *.mp4_BAK >nul 2>&1
			del *.webm_BAK >nul 2>&1
			ren *.mp4 *.mp4_BAK >nul 2>&1
			ren *.webm *.webm_BAK >nul 2>&1
			ECHO [33m    - Vídeos desabilitados.[0m
			ECHO.
			ECHO.
			
			ECHO [33m------------------------------------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [33m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
			timeout /t 5 /nobreak >nul 2>&1
			CLS
			GOTO start
		
		:config_backup
			CLS
			ECHO [43m                                                                                                                        [0m
			ECHO [43m                                       CRIAR CÓPIA DE SEGURANÇA DAS CONFIGURAÇÕES PUBG                                  [0m
			ECHO [43m                                                                                                                        [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m • Localizando diretórios...[0m
			ECHO.
			
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m    - Gravando cópia de segurança...[0m
			XCOPY /D /F "%LocalAppData%\TslGame\Saved\Config\WindowsNoEditor\GameUserSettings.ini" "%desktop_folder%">nul
			timeout /t 2 /nobreak >nul 2>&1
			ECHO.
			ECHO [33m    - Salvo na pasta: [0m%desktop_folder% 
			ECHO.
			ECHO.
			
			ECHO [33m------------------------------------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [33m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
			timeout /t 5 /nobreak >nul 2>&1
			CLS
			GOTO start
		
		:restore_backup
			CLS
			ECHO [43m                                                                                                                        [0m
			ECHO [43m                                  RESTAURAR CÓPIA DE SEGURANÇA DAS CONFIGURAÇÕES PUBG                                   [0m
			ECHO [43m                                                                                                                        [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m • Localizando diretórios...[0m
			ECHO.
			
			:confirm_file_allocated
			timeout /t 2 /nobreak >nul 2>&1
			ECHO.
			ECHO    - COLOQUE O ARQUIVO DE BACKUP [33m "GameUserSettings.ini"[0m NA PASTA[33m "%desktop_folder%"[0m
			ECHO.
			ECHO      [33m1[0m - Sim, já coloquei
			ECHO      [33m0[0m - Não, preciso colocar
			ECHO.
			ECHO.
			set /P confirm_file=Sua resposta (1 ou 0): 
			if /I "%confirm_file%" EQU "1" goto :restore_config
			if /I "%confirm_file%" EQU "0" goto :start
			
			SET confirm_file=
			if  '%confirm_file%'=='' GOTO restore_backup
			goto :confirm_file_allocated
			
				:restore_config
				ECHO.
				ECHO.
				ECHO [33m     - Movendo arquivo...
				timeout /t 3 /nobreak >nul 2>&1
				XCOPY /D /F "%desktop_folder%\GameUserSettings.ini" "%LocalAppData%\TslGame\Saved\Config\WindowsNoEditor" >nul 2>&1
				DEL "%desktop_folder%\GameUserSettings.ini" >nul 2>&1
				ECHO.		
				ECHO [33m    - Arquivo movido. Configurações restauradas. 
				ECHO.
				ECHO.
				
				ECHO [33m------------------------------------------------------------------------------------------------------------------------[0m
				ECHO.
				ECHO.
				ECHO [33m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
				timeout /t 5 /nobreak >nul 2>&1
				CLS
				GOTO start
				
		:enable_crashreporter
			CLS
			ECHO [43m                                                                                                                        [0m
			ECHO [43m                                               ATIVAR PUBG CRASH REPORTER                                               [0m
			ECHO [43m                                                                                                                        [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m • Ativando BroCrashReporter...[0m
			ECHO.
	
			timeout /t 2 /nobreak >nul 2>&1
			CD /D "%steam_path%\steamapps\common\PUBG\TslGame\Binaries\ThirdParty\BroCrashReporter" >nul 2>&1
			ren *.exe_BAK *.exe >nul 2>&1
			ECHO [33m    - PUBG CrashRepoter ativado.[0m
			ECHO.
			ECHO.
			
			ECHO [33m------------------------------------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [33m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
			timeout /t 5 /nobreak >nul 2>&1
			CLS
			GOTO start
					
		:disable_crashreporter
			CLS
			ECHO [43m                                                                                                                        [0m
			ECHO [43m                                             DESATIVAR PUBG CRASH REPORTER                                              [0m
			ECHO [43m                                                                                                                        [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m • Desativando BroCrashReporter...[0m
			ECHO.
			
			timeout /t 2 /nobreak >nul 2>&1
			CD /D "%steam_path%\steamapps\common\PUBG\TslGame\Binaries\ThirdParty\BroCrashReporter"
			del *.exe_BAK >nul 2>&1
			ren *.exe *.exe_BAK >nul 2>&1
			ECHO [33m    - PUBG CrashRepoter desativado.[0m
			ECHO.
			ECHO.
			
			ECHO [33m------------------------------------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [33m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
			timeout /t 5 /nobreak >nul 2>&1
			CLS
			GOTO start

		:: ************************************************************** GAME *************************************************************
		:open_game
			CLS
			ECHO [42m                                                                                                                        [0m
			ECHO [42m                                                   PUBG BATTLEGROUNDS                                                   [0m
			ECHO [42m                                                                                                                        [0m
			ECHO.
			ECHO.
			
			ECHO [32m • Iniciando PUBG BATTLEGROUNDS...[0m
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			START steam://rungameid/578080 >nul 2>&1
			ECHO [32m    - Feito! O jogo iniciará em instantes.[0m
			ECHO.
			ECHO.
			
			ECHO [32m------------------------------------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [32m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
			timeout /t 5 /nobreak >nul 2>&1
			CLS
			GOTO start

		:end_open_game
			CLS
			ECHO [42m                                                                                                                        [0m
			ECHO [42m                                                   PUBG BATTLEGROUNDS                                                   [0m
			ECHO [42m                                                                                                                        [0m
			ECHO.
			ECHO.
			
			ECHO [32m • Encerrando PUBG BATTLEGROUNDS...[0m
			TASKKILL /f /IM ExecPubg.exe >nul 2>&1
			TASKKILL /f /IM TslGame.exe >nul 2>&1
			TASKKILL /f /IM TslGame_BE.exe >nul 2>&1
			TASKKILL /f /IM TslGame_UC.exe >nul 2>&1
			TASKKILL /f /IM TslGame_ZK.exe >nul 2>&1
			TASKKILL /f /IM zksvc.exe >nul 2>&1
			ECHO. 
			ECHO [32m • Encerrando BattleEye Service (requer ADM)...[0m
			NET STOP "BEService" /yes >nul 2>&1
			timeout /t 3 /nobreak >nul 2>&1
			ECHO.
			
			ECHO [32m • Iniciando PUBG BATTLEGROUNDS...[0m
			timeout /t 3 /nobreak >nul 2>&1
			START steam://rungameid/578080 >nul 2>&1
			ECHO.
			ECHO [32m    - Feito! O jogo iniciará em instantes.[0m
			ECHO.
			ECHO.
			
			ECHO [32m------------------------------------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [32m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
			timeout /t 5 /nobreak >nul 2>&1
			CLS
			GOTO start
			
		:end_game
			CLS
			ECHO [42m                                                                                                                        [0m
			ECHO [42m                                                   PUBG BATTLEGROUNDS                                                   [0m
			ECHO [42m                                                                                                                        [0m
			ECHO.
			ECHO.
			
			ECHO [32m • Encerrando PUBG BATTLEGROUNDS...[0m
			TASKKILL /f /IM ExecPubg.exe >nul 2>&1
			TASKKILL /f /IM TslGame.exe >nul 2>&1
			TASKKILL /f /IM TslGame_BE.exe >nul 2>&1
			TASKKILL /f /IM TslGame_UC.exe >nul 2>&1
			TASKKILL /f /IM TslGame_ZK.exe >nul 2>&1
			TASKKILL /f /IM zksvc.exe >nul 2>&1
			timeout /t 2 /nobreak >nul 2>&1
			ECHO. 
			ECHO [32m • Encerrando BattleEye Service (requer ADM)...[0m
			NET STOP "BEService" /yes >nul 2>&1
			timeout /t 3 /nobreak >nul 2>&1
			ECHO.
			ECHO [32m    - Feito! Jogo encerrado.[0m
			ECHO.
			ECHO.
			
			ECHO [32m------------------------------------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [32m                                               ^< OPERAÇÃO CONCLUÍDA ^>                                                 [0m
			timeout /t 5 /nobreak >nul 2>&1
			CLS
			GOTO start
		
		:: ************************************************************** APP CONTROL ******************************************************
		:invalid_option
			CLS
			ECHO	[91m
			ECHO    ######## ########  ########   #######  ########  
			ECHO    ##       ##     ## ##     ## ##     ## ##     ## 
			ECHO    ##       ##     ## ##     ## ##     ## ##     ## 
			ECHO    ######   ########  ########  ##     ## ########  
			ECHO    ##       ##   ##   ##   ##   ##     ## ##   ##   
			ECHO    ##       ##    ##  ##    ##  ##     ## ##    ##  
			ECHO    ######## ##     ## ##     ##  #######  ##     ##
			ECHO.
			ECHO    ----------- ESCOLHA UMA OPÇÃO VÁLIDA ---------- [0m
			timeout /t 5 /nobreak >nul 2>&1
			ECHO.
			CLS
			GOTO start
			
		:requires_adm
			CLS
			ECHO	[91m
			ECHO    ######## ########  ########   #######  ########  
			ECHO    ##       ##     ## ##     ## ##     ## ##     ## 
			ECHO    ##       ##     ## ##     ## ##     ## ##     ## 
			ECHO    ######   ########  ########  ##     ## ########  
			ECHO    ##       ##   ##   ##   ##   ##     ## ##   ##   
			ECHO    ##       ##    ##  ##    ##  ##     ## ##    ##  
			ECHO    ######## ##     ## ##     ##  #######  ##     ##
			ECHO.
			ECHO    --- OPÇÃO REQUER PRIVILÉGIOS ADMINISTRATIVOS --- [0m
			timeout /t 5 /nobreak >nul 2>&1
			ECHO.
			CLS
			GOTO start

	:end
Timeout -1 1>Nul