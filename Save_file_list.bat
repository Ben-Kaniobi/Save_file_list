@ECHO off
SETLOCAL

REM Get name and path of this file
SET filename=%~n0
SET filepath=%~d0%~p0
CD /D "%filepath%"
REM Check if a textfile with this name already file exists
IF EXIST "%filepath%%filename%.txt" (
	GOTO :label_userinput1
) ELSE (
	GOTO :label_filename_ok
)

:label_userinput1
CLS
ECHO.
REM Get user input
SET /P user_input=""%filename%.txt" already exists, do you want to overwrite it? [Y/N]:"
REM Check user input
IF %user_input% == Y (
	GOTO :label_filename_ok
) ELSE (
IF %user_input% == y (
	GOTO :label_filename_ok
) ELSE (
IF %user_input% == N (
	GOTO :label_filename_not_ok
) ELSE (
IF %user_input% == n (
	GOTO :label_filename_not_ok
) ELSE (
	ECHO Please enter Y to include subfolders or N to exclude subfolders.
	GOTO :label_userinput1
))))

:label_filename_not_ok
REM Add a number to the filename (e.g. replace "file" with "file_1")
SET i=1
:label_while1
IF EXIST "%filepath%%filename%_%i%.txt" (
	REM Continue while
) ELSE (
	GOTO :label_endwhile1
)
REM While body
	REM Increment i
	SET /A i = %i% + 1
REM End of while body
GOTO :label_while1
:label_endwhile1
SET filename=%filename%_%i%

:label_filename_ok

:label_userinput2
CLS
ECHO.
REM Display current directory
ECHO Current directory: %CD%
REM Get user input
SET /P user_input="Change directory? [Y/N]:"
REM Check user input
IF %user_input% == Y (
	GOTO :label_userinput3
) ELSE (
IF %user_input% == y (
	GOTO :label_userinput3
) ELSE (
IF %user_input% == N (
	GOTO :label_userinput4
) ELSE (
IF %user_input% == n (
	GOTO :label_userinput4
) ELSE (
	ECHO Please enter Y to include subfolders or N to exclude subfolders.
	GOTO :label_userinput2
))))

:label_userinput3
REM Get user input
SET /P user_input="Path:"
REM Check user input
IF EXIST "%user_input%" (
    CD /D "%user_input%"
	GOTO :label_userinput2
) ELSE (
	ECHO Path does not exist.
	GOTO :label_userinput3
)

:label_userinput4
CLS
ECHO.
REM Get user input
SET /P user_input="Include subfolders? [Y/N]:"
REM Check user input
IF %user_input% == Y (
	GOTO :label_include_subfolders
) ELSE (
IF %user_input% == y (
	GOTO :label_include_subfolders
) ELSE (
IF %user_input% == N (
	GOTO :label_exclude_subfolders
) ELSE (
IF %user_input% == n (
	GOTO :label_exclude_subfolders
) ELSE (
	ECHO Please enter Y to include subfolders or N to exclude subfolders.
	GOTO :label_userinput4
))))

:label_include_subfolders
CLS
ECHO.
ECHO Creating file...
REM Include subfolders and all files:
DIR /s /b > "%filepath%%filename%.txt" || REM When using "|| REM" errorlevel is correctly set
GOTO :label_end

:label_exclude_subfolders
CLS
ECHO.
ECHO Creating file...
REM Only files and folders in this folder:
DIR /b > "%filepath%%filename%.txt" || REM When using "|| REM" errorlevel is correctly set
GOTO :label_end

:label_end
REM Check for errors
IF %errorlevel% == 0 (
    CLS
    ECHO.
	ECHO "%filename%.txt" created.
)

REM Wait for user to close
ECHO.
PAUSE

REM Sources:
REM http://en.wikibooks.org/wiki/Windows_Batch_Scripting
REM http://www.howtogeek.com/98064/how-to-print-or-save-a-directory-listing-to-a-file/
REM http://superuser.com/questions/32771/list-all-files-in-all-subfolders
