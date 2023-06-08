package perf

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._

import scala.concurrent.duration._
import scala.language.postfixOps

class TestSimulation extends Simulation {

  val protocol = karateProtocol(
    "/api/todos/{id}" -> Nil
  )

  val main = scenario("main").exec(karateFeature("classpath:perf/simple.feature"))

  setUp(
    main.inject(rampUsers(10) during (5 seconds)).protocols(protocol)
  )

}