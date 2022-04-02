package webServiceApi

import com.intuit.karate.junit5.Karate


internal class WebServiceRunner {
    @Karate.Test
    fun testAll(): Karate {
        return Karate.run().relativeTo(javaClass)
    }
}


