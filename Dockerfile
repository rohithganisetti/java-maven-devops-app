FROM tomcat:9
COPY target/java-maven-app-1.0.war /usr/local/tomcat/webapps/ROOT.war
