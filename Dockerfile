FROM tomcat:9
COPY target/java-maven-app-1.0.jar /usr/local/tomcat/webapps/
