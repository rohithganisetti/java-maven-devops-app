FROM tomcat:9
COPY target/java-maven-app.jar /usr/local/tomcat/webapps/
