@ECHO off
SETLOCAL

REM Get name and path of this file
SET filename=%~n0
SET filepath=%~d0%~p0
CD "%filepath%"
REM Check if a textfile with this name already file exists
IF EXIST "%filepath%%filename%.txt" (
	GOTO :label_userinput1
) ELSE (
	GOTO :label_filename_ok
)

:label_userinput1
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
REM Add a number to the filename (e.g. file_1.txt)
SET i=1
:label_while1
IF NOT EXIST "%filepath%%filename%_%i%.txt" (
	GOTO :label_endwhile1
)
REM Increment i
SET /A i = %i% + 1
GOTO :label_while1
:label_endwhile1
SET filename=%filename%_%i%

:label_filename_ok

:label_userinput2
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
	GOTO :label_userinput2
))))

:label_include_subfolders
ECHO.
REM Include subfolders and all files:
DIR /s /b > "%filepath%%filename%.txt" || REM When using "|| REM" errorlevel is correctly set
GOTO :label_end

:label_exclude_subfolders
ECHO.
REM Only files and folders in this folder:
DIR /b > "%filepath%%filename%.txt" || REM When using "|| REM" errorlevel is correctly set
GOTO :label_end

:label_end
REM Check for errors
IF %errorlevel% == 0 (
	ECHO "%filename%.txt" created.
)

REM Wait for user to close
ECHO.
PAUSE

REM Sources:
REM http://en.wikibooks.org/wiki/Windows_Batch_Scripting
REM http://www.howtogeek.com/98064/how-to-print-or-save-a-directory-listing-to-a-file/
REM http://superuser.com/questions/32771/list-all-files-in-all-subfolders
