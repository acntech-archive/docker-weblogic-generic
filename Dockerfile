FROM acntech/maven:3.3.9
MAINTAINER Thomas Johansen "thomas.johansen@accenture.com"


ENV ORACLE_HOME /u01/oracle
ENV USER_MEM_ARGS -Djava.security.egd=file:/dev/./urandom


RUN apt-get -y update

RUN mkdir -p /u01/oracle/.inventory

COPY files/fmw_12.2.1.1.0_wls.jar /u01/fmw_wls.jar
COPY files/install.file files/oraInst.loc /u01/

RUN useradd -b /u01 -m -s /bin/bash oracle
RUN echo oracle:welcome1 | chpasswd
RUN chown oracle:oracle -R /u01

RUN su -c "$JAVA_HOME/bin/java -jar /u01/fmw_wls.jar -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME -ignoreSysPrereqs -force -novalidation ORACLE_HOME=$ORACLE_HOME INSTALL_TYPE=\"WebLogic Server\"" - oracle
RUN rm /u01/fmw_wls.jar /u01/install.file /u01/oraInst.loc

RUN chown oracle:oracle -R /u01


CMD ["/bin/bash"]