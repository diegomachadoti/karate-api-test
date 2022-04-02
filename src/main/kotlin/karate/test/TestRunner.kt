package karate.test

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class TestRunner

fun main(args: Array<String>) {
	runApplication<TestRunner>(*args)
}
