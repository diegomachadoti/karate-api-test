import com.intuit.karate.junit5.Karate


internal class RunnerTests {
    @Karate.Test
    fun testAll(): Karate {
        val testName = System.getProperty("karate.options", "")
        val tags = System.getProperty("karate.options.tags", "")

        return if (testName.isNotEmpty()) {
            Karate.run(testName)
        } else if (tags.isNotEmpty()) {
            Karate.run().tags(tags)
        } else {
            Karate.run().relativeTo(javaClass)
        }
    }

}


