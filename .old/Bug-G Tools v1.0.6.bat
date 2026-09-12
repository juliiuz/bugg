chcp 65001
mode con:cols=92 lines=50
title BUG-G v1.0.6 Dez-2024 (by JuliiuZ - @srsjuliano)
setlocal
call :setESC
CLS

:: ******************************************** STEAM GAME LIBRARY ********************************************
 
	for /f "delims=" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Valve\Steam" /V "InstallPath" ^|findstr /ri "REG_SZ"') do SET "steam_path=%%a"
	SET steam_path=%steam_path:~29%
	SET "desktop_folder=%userprofile%\Desktop"
	SET "t5=     "
	SET "t10=          "
	SET "t20=                    "
	SET "t30=                              "
	SET "t50=                                                  "
	SET "a5=*****"
	SET "a10=**********"
	SET "a20=********************"
	SET "a30=******************************"
	SET "a50=**************************************************"

:: ***********************************************************************************************************

CLS
@ECHO OFF

:start
	CLS
	echo [101;93m %t30%%t30%%t30% [0m
	echo [101;93m %t20% Bug-G Tools by @srsjuliano - v1.0.6 Dez-2024 %t20%%t5%[0m
	echo [101;93m %t30%%t30%%t30% [0m
	ECHO.
	ECHO   [95m * WINDOWS %a30%%a30%%a10%%a5%** [0m
	ECHO   [95m *  %t50%%t30%  [95m * [0m
	ECHO   [95m *  •[0m Corrigir Lag na rede [95m[10][0m [90mADM[0m %t50%[95m * [0m
	ECHO   [95m *  •[0m Encerrar processos desnecessários [95m[11][0m [90mADM[0m %t5%%t30%  [95m * [0m
	ECHO   [95m *  •[0m Ajustar Perfil de Performance... [95m[12][0m [90m[0m %t20%%t20% [95m * [0m
	ECHO   [95m *  •[0m Otimizar configurações para jogos [95m[13][0m [90mADM[0m %t5%%t30%  [95m * [0m
	ECHO   [95m *  %t50%%t30%  [95m * [0m
	ECHO   [95m *  %t50%%t30%  [95m * [0m
	ECHO   [95m %a50%%a30%%a5%** [0m
	ECHO.
	ECHO   [91m * ARQUIVOS **************************************************************************** [0m 
	ECHO   [91m *                                                                                    [91m * [0m
	ECHO   [91m *  [91m•[0m Eliminar arquivos temporários PUBG [91m[20][0m                                         [91m * [0m
	ECHO   [91m *  [91m•[0m Eliminar arquivos temporários PUBG e Windows [91m[21][0m [90mADM[0m                           [91m * [0m
	ECHO   [91m *                                                                                    [91m * [0m
	ECHO   [91m *                                                                                    [91m * [0m
	ECHO   [91m *************************************************************************************** [0m
	ECHO.
	ECHO   [33m * PUBG ******************************************************************************** [0m 
	ECHO   [33m *                                                                                    [33m * [0m
	ECHO   [33m *  [33m•[0m Vídeos:            Ativar [33m[30][0m   -   Desativar [33m[31][0m                             [33m * [0m
	ECHO   [33m *  [33m•[0m Config:            Backup [33m[32][0m   -   Restaurar [33m[33][0m                             [33m * [0m
	ECHO   [33m *  [33m•[0m Crash Reporter:    Ativar [33m[34][0m   -   Desativar [33m[35][0m                             [33m * [0m
	ECHO   [33m *  [33m•[0m Servidores Conectados     [33m[36][0m                                                  [33m * [0m
	ECHO   [33m *                                                                                    [33m * [0m
	ECHO   [33m *                                                                                    [33m * [0m
	ECHO   [33m *************************************************************************************** [0m
	ECHO.
	ECHO   [32m * EXECUÇÃO **************************************************************************** [0m
	ECHO   [32m *                                                                                    [32m * [0m
	ECHO   [32m *  [32m•[0m Abrir game             [32m[90][0m                                                     [32m * [0m
	ECHO   [32m *  [32m•[0m Fechar e abrir game    [32m[98][0m                                                     [32m * [0m
	ECHO   [32m *                                                                                    [32m * [0m
	ECHO   [32m *  [32m•[0m Fechar game            [32m[99][0m                                                     [32m * [0m
	ECHO   [32m *                                                                                    [32m * [0m
	ECHO   [32m *                                                                                    [32m * [0m
	ECHO   [32m *************************************************************************************** [0m
	ECHO.
	ECHO   [36m * BUG-G ****************************************************************************** [0m
	ECHO   [36m *                                                                                    [36m * [0m
	ECHO   [36m *  [36m•[0m Notas da versão        [36m[00][0m                                                     [36m * [0m
	ECHO   [36m *                                                                                    [36m * [0m
	ECHO   [36m *************************************************************************************** [0m
	ECHO.
	SET choice=
	SET /p choice=Sua opção: 
	
	if not '%choice%'=='' SET choice=%choice:~0,2%

	:: WINDOWS
	if '%choice%'=='10' GOTO fix_network_issues
	if '%choice%'=='11' GOTO end_winprocesses
	if '%choice%'=='12' GOTO adjust_performance
	if '%choice%'=='13' GOTO optimize_for_games

	:: FILES
	if '%choice%'=='20' GOTO clean_game_tempdir
	if '%choice%'=='21' GOTO clean_wingame_tempdir

	:: PREFERENCES
	if '%choice%'=='30' GOTO enable_media
	if '%choice%'=='31' GOTO disable_media
	if '%choice%'=='32' GOTO config_backup
	if '%choice%'=='33' GOTO restore_backup
	if '%choice%'=='34' GOTO enable_crashreporter
	if '%choice%'=='35' GOTO disable_crashreporter

	:: GAME
	if '%choice%'=='00' GOTO about
	
	:: BUG-G
	if '%choice%'=='90' GOTO open_game
	if '%choice%'=='98' GOTO end_open_game
	if '%choice%'=='99' GOTO end_game
	
	SET choice=
	if  '%choice%'=='' GOTO invalid_option
	CLS
	
	GOTO start
		:: ************************************************************ WINDOWS ************************************************************
		:fix_network_issues
		openfiles >nul 2>&1 2>&1
			if not %ErrorLevel% equ 0 (
				GOTO requires_adm
			) else (
				CLS
				ECHO [105m                                                                                            [0m
				ECHO [105m                              CORRIGIR PROBLEMAS DE CONEXÃO                                 [0m
				ECHO [105m                                                                                            [0m
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
				
				ECHO [95m--------------------------------------------------------------------------------------------[0m
				ECHO.
				ECHO.
				ECHO [95m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
				timeout /t 5 /nobreak >nul 2>&1
				CLS
				GOTO start
			)
	
		:end_winprocesses
			openfiles >nul 2>&1 2>&1
			if not %ErrorLevel% equ 0 (
				GOTO requires_adm
			) else (
				CLS
				ECHO [105m                                                                                            [0m
				ECHO [105m                          ENCERRAR PROCESSOS IRRELEVANTES DO WINDOWS                        [0m
				ECHO [105m                                                                                            [0m 
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
				
				ECHO [95m--------------------------------------------------------------------------------------------[0m
				ECHO.
				ECHO.
				ECHO [95m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
				timeout /t 5 /nobreak >nul 2>&1
				GOTO start
			)
		
		:optimize_for_games
			openfiles >nul 2>&1 2>&1
			if not %ErrorLevel% equ 0 (
				GOTO requires_adm
			) else (
				CLS
				ECHO [105m                                                                                            [0m
				ECHO [105m                      OTIMIZAR CONFIGURAÇÕES DO WINDOWS PARA JOGOS                          [0m
				ECHO [105m                                                                                            [0m
				ECHO.
				ECHO.
				timeout /t 2 /nobreak >nul 2>&1
				
				ECHO.
				ECHO [95m • Desabilitando Limitações de Rede ^(Network Throttling^)...[0m
				ECHO.
				Reg Add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1
				timeout /t 2 /nobreak >nul 2>&1	
				
				ECHO.
				ECHO [95m • Priorizar processos e GPU para jogos ...[0m
				ECHO.
				Reg Add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
				Reg Add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
				Reg Add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d High /f >nul 2>&1
				timeout /t 2 /nobreak >nul 2>&1	
				
				ECHO [95m--------------------------------------------------------------------------------------------[0m
				ECHO.
				ECHO.
				ECHO [95m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
				ECHO.
				ECHO.
				ECHO [95m                                                               Retornando em 5 segundos...   [0m
				timeout /t 5 /nobreak >nul 2>&1
				GOTO start
			)
		
		:adjust_performance
			CLS
			ECHO [105m                                                                                            [0m
			ECHO [105m                                AJUSTAR PERFORMANCE DO WINDOWS                              [0m
			ECHO [105m                                                                                            [0m
			ECHO.
			ECHO.
			
			:confirm_perf_mode
				ECHO [95m • Para qual perfil de desempenho você quer ajustar o Windows? [requer reinicialização][0m
				ECHO.
				ECHO.
				ECHO      [95m1[0m - Deixar o Windows Decidir
				ECHO      [95m2[0m - Modo Performance
				ECHO.
				ECHO      [95m0[0m - Voltar
				ECHO.
				ECHO.
				set /P perf_mode=Opção: 
				if /I "%perf_mode%" EQU "1" GOTO :auto_perf_mode
				if /I "%perf_mode%" EQU "2" GOTO :best_perf_mode
				if /I "%perf_mode%" EQU "0" GOTO :start
				
					:auto_perf_mode
					CLS
					ECHO [105m                                                                                            [0m
					ECHO [105m                                AJUSTAR PERFORMANCE DO WINDOWS                              [0m
					ECHO [105m                                                                                            [0m
					ECHO.
					ECHO.
					ECHO [95m • Ajustando perfil de desempenho do Windows para Automático...[0m
					ECHO.
					Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 0 /f >nul 2>&1
					Reg Add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "90 32 07 80 10 00 00 00" /f >nul 2>&1
					timeout /t 3 /nobreak >nul 2>&1
					ECHO.
					ECHO.
					
					ECHO [95m--------------------------------------------------------------------------------------------[0m
					ECHO.
					ECHO.
					ECHO [95m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
					ECHO.
					ECHO.
					ECHO [95m                                                               Retornando em 5 segundos...   [0m
					timeout /t 5 /nobreak >nul 2>&1
					GOTO start
				
					:best_perf_mode
					CLS
					ECHO [105m                                                                                            [0m
					ECHO [105m                                AJUSTAR PERFORMANCE DO WINDOWS                              [0m
					ECHO [105m                                                                                            [0m
					ECHO.
					ECHO.
					ECHO [95m • Ajustando perfil de desempenho do Windows para Melhor Performance...[0m
					ECHO.
					Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
					Reg Add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9E 12 03 80 10 00 00 00" /f >nul 2>&1
					timeout /t 3 /nobreak >nul 2>&1
					ECHO.
					ECHO.
					
					ECHO [95m--------------------------------------------------------------------------------------------[0m
					ECHO.
					ECHO.
					ECHO [95m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
					ECHO [91m                                  Reinicie seu computador                                     [0m
					ECHO.
					ECHO.
					ECHO [95m                                                               Retornando em 5 segundos...   [0m
					timeout /t 5 /nobreak >nul 2>&1
					GOTO start										
							
		
		:: ************************************************************* FILES *************************************************************
		:clean_game_tempdir
			CLS
			ECHO [41m                                                                                            [0m
			ECHO [41m                            LIMPEZA DE ARQUIVOS TEMPORÁRIOS ^(PUBG^)                          [0m
			ECHO [41m                                                                                            [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [91m • Removendo arquivos:[0m
			ECHO.
	
			ECHO [91m    - ../CRASHES[0m
			ECHO.
			timeout /t 1 /nobreak >nul 2>&1
			RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Crashes" >nul 2>&1
			RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\CohCache" >nul 2>&1
			
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
			RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\IntegrityCheck" >nul 2>&1

			ECHO [91m    - ../Arquivos diversos...[0m
			ECHO.
			timeout /t 1 /nobreak >nul 2>&1
			CD /D "%LOCALAPPDATA%\TslGame\Saved" >nul 2>&1
			DEL /Q *.ushaderprecache >nul 2>&1
			ECHO.
			ECHO.
			
			ECHO [91m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [91m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
			ECHO.
			ECHO.
			ECHO [91m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
			GOTO start
		
		:clean_wingame_tempdir
			openfiles >nul 2>&1
			if not %ErrorLevel% equ 0 (
				GOTO requires_adm
			) else (
				CLS
				ECHO [41m                                                                                            [0m
				ECHO [41m                     LIMPEZA DE ARQUIVOS TEMPORÁRIOS ^(PUBG + WINDOWS^)                       [0m
				ECHO [41m                                                                                            [0m
				ECHO.
				ECHO.
				timeout /t 2 /nobreak >nul 2>&1
				ECHO [91m • Removendo arquivos:[0m
				ECHO.
				
				ECHO [91m    - ../CRASHES[0m
				ECHO.
				timeout /t 1 /nobreak >nul 2>&1
				RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Crashes" >nul 2>&1	
				RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\CohCache" >nul 2>&1	

				ECHO [91m    - ../DEMOS[0m
				ECHO.
				timeout /t 1 /nobreak >nul 2>&1
				RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Demos" >nul 2>&1	
				
				ECHO [91m    - ../DIST[0m
				ECHO.
				timeout /t 1 /nobreak >nul 2>&1
				RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Dists" >nul 2>&1	
				
				ECHO [91m    - ../LOGS[0m
				ECHO.
				timeout /t 1 /nobreak >nul 2>&1
				RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\Logs" >nul 2>&1	
				RMDIR /S /Q "%LOCALAPPDATA%\TslGame\Saved\IntegrityCheck" >nul 2>&1

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
				
				ECHO [91m--------------------------------------------------------------------------------------------[0m
				ECHO.
				ECHO.
				ECHO [91m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
				ECHO.
				ECHO.
				ECHO [91m                                                               Retornando em 5 segundos...   [0m
				timeout /t 5 /nobreak >nul 2>&1
				GOTO start
			)
		
		:: *********************************************************** PREFERENCES *********************************************************
		:enable_media
			CLS
			ECHO [43m                                                                                            [0m
			ECHO [43m                              HABILITAR VÍDEOS DE INTRODUÇÃO                                [0m
			ECHO [43m                                                                                            [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m • Habilitando vídeos...[0m
			ECHO.
	
			timeout /t 2 /nobreak >nul 2>&1
			REN "%steam_path%\steamapps\common\PUBG\TslGame\Content\_Movies" "Movies"
			ECHO.
			ECHO.
			
			ECHO [33m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [33m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
			ECHO.
			ECHO.
			ECHO [33m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
			GOTO start
			
		:disable_media
			CLS
			ECHO [43m                                                                                            [0m
			ECHO [43m                            DESABILITAR VÍDEOS DE INTRODUÇÃO                                [0m
			ECHO [43m                                                                                            [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m • Desabilitando vídeos...[0m
			ECHO.
			
			timeout /t 2 /nobreak >nul 2>&1
			IF EXIST "%steam_path%\steamapps\common\PUBG\TslGame\Content\Movies" (
				IF EXIST "%steam_path%\steamapps\common\PUBG\TslGame\Content\_Movies" (
					RMDIR /S /Q "%steam_path%\steamapps\common\PUBG\TslGame\Content\_Movies" >nul 2>&1
					REN "%steam_path%\steamapps\common\PUBG\TslGame\Content\Movies" "_Movies"
				) ELSE (
					REN "%steam_path%\steamapps\common\PUBG\TslGame\Content\Movies" "_Movies"
				)
			) 
			ECHO [33m    - Vídeos desabilitados.[0m
			ECHO.
			ECHO.
			
			ECHO [33m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [33m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
			ECHO.
			ECHO.
			ECHO [33m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
			GOTO start
		
		:config_backup
			CLS
			ECHO [43m                                                                                            [0m
			ECHO [43m                      CRIAR CÓPIA DE SEGURANÇA DAS CONFIGURAÇÕES PUBG                       [0m
			ECHO [43m                                                                                            [0m
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
			
			ECHO [33m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [33m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
			ECHO.
			ECHO.
			ECHO [33m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
			GOTO start
		
		:restore_backup
			CLS
			ECHO [43m                                                                                            [0m
			ECHO [43m                    RESTAURAR CÓPIA DE SEGURANÇA DAS CONFIGURAÇÕES PUBG                     [0m
			ECHO [43m                                                                                            [0m
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
				
				ECHO [33m--------------------------------------------------------------------------------------------[0m
				ECHO.
				ECHO.
				ECHO [33m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
				ECHO.
				ECHO.
				ECHO [33m                                                               Retornando em 5 segundos...   [0m
				timeout /t 5 /nobreak >nul 2>&1
				GOTO start
				
		:enable_crashreporter
			CLS
			ECHO [43m                                                                                            [0m
			ECHO [43m                                   ATIVAR PUBG CRASH REPORTER                               [0m
			ECHO [43m                                                                                            [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m • Ativando BroCrashReporter...[0m
			ECHO.
	
			timeout /t 2 /nobreak >nul 2>&1
			REN "%steam_path%\steamapps\common\PUBG\TslGame\Binaries\ThirdParty\_BroCrashReporter" "BroCrashReporter"
			ECHO [33m    - PUBG CrashRepoter ativado.[0m
			ECHO.
			ECHO.
			
			ECHO [33m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [33m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
			ECHO.
			ECHO.
			ECHO [33m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
			GOTO start
					
		:disable_crashreporter
			CLS
			ECHO [43m                                                                                            [0m
			ECHO [43m                               DESATIVAR PUBG CRASH REPORTER                                [0m
			ECHO [43m                                                                                            [0m
			ECHO.
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			ECHO [33m • Desativando BroCrashReporter...[0m
			ECHO.
			
			timeout /t 2 /nobreak >nul 2>&1
			REN "%steam_path%\steamapps\common\PUBG\TslGame\Binaries\ThirdParty\BroCrashReporter" "_BroCrashReporter"
			ECHO [33m    - PUBG CrashRepoter desativado.[0m
			ECHO.
			ECHO.
			
			ECHO [33m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [33m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
			ECHO.
			ECHO.
			ECHO [33m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
			GOTO start

		:: ************************************************************ EXECUÇÃO ***********************************************************
		:open_game
			CLS
			ECHO [42m                                                                                            [0m
			ECHO [42m                                    PUBG BATTLEGROUNDS                                      [0m
			ECHO [42m                                                                                            [0m
			ECHO.
			ECHO.
			
			ECHO [32m • Iniciando PUBG BATTLEGROUNDS...[0m
			ECHO.
			timeout /t 2 /nobreak >nul 2>&1
			START steam://rungameid/578080 >nul 2>&1
			ECHO [32m    - Feito! O jogo iniciará em instantes.[0m
			ECHO.
			ECHO.
			
			ECHO [32m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [32m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
			ECHO.
			ECHO.
			ECHO [32m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
			GOTO start

		:end_open_game
			CLS
			ECHO [42m                                                                                            [0m
			ECHO [42m                                    PUBG BATTLEGROUNDS                                      [0m
			ECHO [42m                                                                                            [0m
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
			ECHO [32m • Encerrando BattleEye Service...[0m
			NET STOP "BEService" /yes >nul 2>&1
			timeout /t 1 /nobreak >nul 2>&1
			ECHO.
			
			ECHO [32m • Iniciando PUBG BATTLEGROUNDS...[0m
			timeout /t 1 /nobreak >nul 2>&1
			START steam://rungameid/578080 >nul 2>&1
			ECHO.
			ECHO [32m    - Feito! O jogo iniciará em instantes.[0m
			ECHO.
			ECHO.
			
			ECHO [32m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [32m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
			ECHO.
			ECHO.
			ECHO [32m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
			GOTO start
			
		:end_game
			CLS
			ECHO [42m                                                                                            [0m
			ECHO [42m                                    PUBG BATTLEGROUNDS                                      [0m
			ECHO [42m                                                                                            [0m
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
			
			ECHO [32m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [32m                                   ^< OPERAÇÃO CONCLUÍDA ^>                                   [0m
			ECHO.
			ECHO.
			ECHO [32m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
			GOTO start
			
		:about
			CLS
			ECHO [42m                                                                                            [0m
			ECHO [42m                                      NOTAS DA VERSÃO                                       [0m
			ECHO [42m                                                                                            [0m
			ECHO.
			
			ECHO                                                                           ← Voltar [enter]
			ECHO.
			ECHO.
			ECHO [36m • v1.0.6 [14 dez 2024]
			ECHO           - Adicionado opção para ver notas de versão
			ECHO           - Corrigido opção de desabilitar vídeos após novos serem adicionados
			ECHO           - Ajustes de Menu/UI
			ECHO [0m
			ECHO.
			ECHO.
			PAUSE>nul
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
			ECHO.
			ECHO [91m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [91m                                   ^< OPÇÃO INVÁLIDA ^>                                   [0m
			ECHO.
			ECHO.
			ECHO [91m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
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
			ECHO.
			ECHO [91m--------------------------------------------------------------------------------------------[0m
			ECHO.
			ECHO.
			ECHO [91m                       ^< OPÇÃO REQUER PRIVILÉGIOS DE ADMINISTRADOR ^>                        [0m
			ECHO.
			ECHO.
			ECHO [91m                                                               Retornando em 5 segundos...   [0m
			timeout /t 5 /nobreak >nul 2>&1
			GOTO start

	:end
timeout -1 1>Nul



