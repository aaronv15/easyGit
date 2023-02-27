@echo off

set yesNo=[36m([0m[32my[0m[36m/[32m[31mn[0m[36m): [0m

set arg=%1
set branch=%2
set message=%3

set setI=false
set setN=false
set setP=false

if not %arg:h=%==%arg% goto :help
if not %arg:p=%==%arg% goto :pull
if not %arg:i=%==%arg% set setI=true
if not %arg:n=%==%arg% (
	set setN=true
	set message=%branch%
	set branch=-n
)
if [%message%]==[] set message="Made some changes"


if %setI%==true (
	goto :setI
) else (
	goto :setC
)

:help
	echo [35m"	=================================	"
	echo "	|	-p to pull		|	"
	echo "	|	-i for ignore mode	|	"
	echo "	|	-n to ignore branches	|	"
	echo "	|	-c for chatty mode	|	"
	echo "	=================================	"[0m

:setI
	set toPrint=[36mThis will pull and push commits to and from [35m%branch%[36m. Continue? %yesNo%
	if %branch%==-n set toPrint=[36mThis will pull and push commits to and from [35mcurrent branch[36m. Continue? %yesNo% 
	git status
	git branch -a
	set /p affirm=%toPrint%
	if /i "%affirm%"=="Y" goto :didConfirm
	goto :end
	
:didConfirm
	if not %branch%==-n git checkout %branch%
	git pull
	git add .
	git commit -m "%message%"
	git push
	echo [32mAll done[0m
	goto :end
	
:setC
	git status
	if not %branch%==-n git checkout %branch%
	set /p affirm=[36mDo you wish to add your changes? %yesNo% 
	if /i %affirm%==Y (git add .) else goto :end
	set /p affirm=[36mDo you wish to commit these changes? %yesNo% 
	if /i %affirm%==Y (git commit -m %message%) else goto :end
	set /p affirm=[36mDo you wish to push these changes? %yesNo% 
	if /i %affirm%==Y (git push) else goto :end
	echo [32mAll done[0m
	goto :end
	
:pull
	if %setN%==true (
		git checkout %branch%
	)
	git pull
	goto :end
	
:end
	exit /B