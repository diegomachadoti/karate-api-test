import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "2.4.1"
    id("io.spring.dependency-management") version "1.0.10.RELEASE"
    kotlin("jvm") version "1.4.21"
    kotlin("plugin.spring") version "1.4.21"
    jacoco
    id("scala")
}

group = "karate"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_11


repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    implementation(kotlin("stdlib-jdk8"))
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.4.2")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.4.2")

    // Karate
    testCompile("com.intuit.karate:karate-apache:0.9.6")
    testImplementation("com.intuit.karate:karate-junit5:1.1.0")

    // Karate Gatling
    implementation("com.intuit.karate:karate-gatling:1.4.0")
    testImplementation("com.intuit.karate:karate-netty:0.9.3.RC1")
    implementation("io.netty:netty-resolver-dns-native-macos:4.1.90.Final")
    implementation("io.netty:netty-tcnative-boringssl-static:2.0.61.Final")

}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs = listOf("-Xjsr305=strict")
        jvmTarget = "11"
    }
}

sourceSets.getByName("test") {
    resources.srcDir("src/test/resources")
    resources.srcDir("src/test/kotlin")
}

tasks.withType<Test> {
    useJUnitPlatform()
    systemProperties(System.getProperties().mapKeys { it.key as String })
    // pull do karate options para ser utilizado em tempo de execução com o gradlew
    systemProperty("karate.options", System.getProperty("karate.options"))
    // pull do karate env para ser utilizado em tempo de execução com o gradlew
    systemProperty("karate.env", System.getProperty("karate.env"))
    outputs.upToDateWhen { false }
    testLogging.showStandardStreams = true
    finalizedBy("jacocoTestReport")
}

tasks.register<JavaExec>("gatlingRun") {
    group = "Web Tests"
    description = "Run Gatling Tests"
    val gatlingReportDir = File(buildDir, "reports/gatling")
    gatlingReportDir.mkdirs()
    classpath = sourceSets["test"].runtimeClasspath
    main = "io.gatling.app.Gatling"
    args = listOf(
        "-s", "mock.CatsKarateSimulation",
        "-rf", gatlingReportDir.absolutePath
    )
    //systemProperties(System.getProperties())
    systemProperty("java.util.logging.config.file", "logging.properties")
    systemProperty("karate.env", "test")
}
