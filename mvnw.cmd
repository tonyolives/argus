@REM ----------------------------------------------------------------------------
@REM Licensed to the Apache Software Foundation (ASF) under one
@REM or more contributor license agreements.  See the NOTICE file
@REM distributed with this work for additional information
@REM regarding copyright ownership.  The ASF licenses this file
@REM to you under the Apache License, Version 2.0 (the
@REM "License"); you may not use this file except in compliance
@REM with the License.  You may obtain a copy of the License at
@REM
@REM    https://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing,
@REM software distributed under the License is distributed on an
@REM "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
@REM KIND, either express or implied.  See the License for the
@REM specific language governing permissions and limitations
@REM under the License.
@REM ----------------------------------------------------------------------------

@REM Apache Maven Wrapper startup batch script, version 3.2.0

@IF "%__MVNW_ARG0_NAME__%"=="" (SET "BASE_DIR=%~dp0")

@SET "MAVEN_WRAPPER_PROPERTIES=%BASE_DIR%.mvn\wrapper\maven-wrapper.properties"

@FOR /F "tokens=2 delims==" %%A IN ('FINDSTR /I "distributionUrl" "%MAVEN_WRAPPER_PROPERTIES%"') DO @SET "DISTRIBUTION_URL=%%A"

@FOR %%F IN ("%DISTRIBUTION_URL%") DO @SET "DIST_FILENAME=%%~nxF"
@SET "DIST_NAME=%DIST_FILENAME:-bin.zip=%"
@SET "MAVEN_HOME=%USERPROFILE%\.m2\wrapper\dists\%DIST_NAME%"

@IF NOT EXIST "%MAVEN_HOME%\bin\mvn.cmd" (
    @ECHO Downloading Apache Maven %DIST_NAME% ...
    @MD "%MAVEN_HOME%" 2>NUL
    @curl -o "%MAVEN_HOME%\%DIST_FILENAME%" -L "%DISTRIBUTION_URL%"
    @tar -xf "%MAVEN_HOME%\%DIST_FILENAME%" -C "%MAVEN_HOME%"
    @XCOPY /E /I /Q "%MAVEN_HOME%\%DIST_NAME%\*" "%MAVEN_HOME%\" >NUL
    @RD /S /Q "%MAVEN_HOME%\%DIST_NAME%"
    @DEL "%MAVEN_HOME%\%DIST_FILENAME%"
)

@"%MAVEN_HOME%\bin\mvn.cmd" %*
