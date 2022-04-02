# karate-api-test

1- Setar configurações do IntelliJ
```
Open IntelliJ on your project and go to File >> Project Structure >> Project and on the option Project SDK Select java 11 and apply the changes.
Intellij Project structure
Edit--------
Then try these options on File >> Settings.

1.Set Gradle JVM Home Gradle JVM
2.Set the JDK version in the Project module settings JDK version in the Project module
3.Check the JDK version in the Modules version in the Modules
Close IntelliJ and open it again.
```
Erro comum executando na JDK errada 
```
karate/test/TestRunner has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
```



REF
- https://karatelabs.github.io/karate/
- https://github.com/karatelabs/karate/tree/master/karate-junit4/src/test/java/com/intuit/karate/junit4/demos