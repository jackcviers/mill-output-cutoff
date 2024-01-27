package com.github.jackcviers.example

import cats.data.NonEmptyList
import cats.effect._
import com.dimafeng.testcontainers.ContainerDef
import com.dimafeng.testcontainers.PostgreSQLContainer
import com.dimafeng.testcontainers.munit.TestContainerForAll
import fly4s._
import fly4s.data._
import munit.CatsEffectSuite
import org.postgresql.ds.PGSimpleDataSource
import org.testcontainers.containers.{
  PostgreSQLContainer => JavaPostgreSQLContainer
}
import org.typelevel.log4cats.SelfAwareStructuredLogger
import org.typelevel.log4cats.slf4j.Slf4jLogger

import scala.concurrent.duration._
import scala.jdk.CollectionConverters._

class MillOutputSuite extends CatsEffectSuite with TestContainerForAll {
  override def munitIOTimeout: Duration = 2.minutes

  implicit def logger: SelfAwareStructuredLogger[IO] = Slf4jLogger.getLogger[IO]

  override val containerDef: ContainerDef =
    PostgreSQLContainer.Def()

  override def afterContainersStart(containers: this.Containers): Unit =
    applyFlywayMigrationsOrFail(containers)

  private def applyFlywayMigrationsOrFail(containers: this.Containers): Unit =
    containers.foreach {
      case c: PostgreSQLContainer =>
        val javaContainer = c.underlyingUnsafeContainer
        (Fly4s
          .makeFor[IO](
            IO.pure {
              val source = new PGSimpleDataSource()
              source.setServerNames(Array(javaContainer.getHost()))
              source.setDatabaseName(c.databaseName)
              source.setUser(c.username)
              source.setPassword(c.password)
              source.setPortNumbers(
                Array(
                  javaContainer.getMappedPort(
                    JavaPostgreSQLContainer.POSTGRESQL_PORT
                  )
                )
              )
              source
            },
            Fly4sConfig(
              connectRetries = 5,
              lockRetryCount = 5,
              validateMigrationNaming = true,
              schemaNames = Some(NonEmptyList("core", List.empty[String]))
            ),
            getClass().getClassLoader()
          )
          .use { m =>
            m.migrate
              .flatMap(r =>
                IO.pure(r.success)
                  .ifM(
                    logger.warn(r.warnings.asScala.mkString) >> logger.info(
                      s"Flyway migrations: ${r.migrationsExecuted} executed in: ${r.getTotalMigrationTime()} ms"
                    ),
                    logger.warn(r.warnings.asScala.mkString) >> IO
                      .raiseError[Unit](r.exceptionObject)
                  )
              )
              .void
          })
          .unsafeRunSync()

      case _ => IO.unit.unsafeRunSync()
    }

  test("The migrations should work to create the database") {
    withContainers { case c: PostgreSQLContainer =>
      IO.pure(true).assert
    }
  }

  test("The migrations should be safe to run many times") {
    withContainers { case c: PostgreSQLContainer =>
      IO.blocking(applyFlywayMigrationsOrFail(c.asInstanceOf[this.Containers]))
        .as(true)
        .assert
    }
  }
}
