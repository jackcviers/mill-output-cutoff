import $ivy.`io.github.davidgregory084::mill-tpolecat::0.3.5`
import mill._
import mill.scalalib._
import io.github.davidgregory084.TpolecatModule

val versions = new {
  val munit = "1.0.0-M10"
  val testcontainersScalaVersion = "0.41.0"
  val fly4s = "1.0.0"
  val log4cats = "2.6.0"
  val logback = "1.4.14"
  val munitCatsEffect = "2.0.0-M4"
  val postgres = "42.7.1"
  val `flyway-database-postgresql` = "10.5.0"
}

object `mill-output-cutoff` extends ScalaModule {

  def scalaVersion = "2.13.12"

  override def scalacOptions = super.scalacOptions() ++ Seq("-Ymacro-annotations", "-feature", "-language:existentials")

  def ivyDeps = Agg(
      ivy"org.postgresql:postgresql:${versions.postgres}"
  )

  object test extends ScalaTests with TestModule.Munit {

    override def scalacOptions = super.scalacOptions() ++ Seq("-Ymacro-annotations", "-feature", "-language:existentials")

    def ivyDeps = Agg(
      ivy"org.scalameta::munit:${versions.munit}",
      ivy"org.typelevel::munit-cats-effect:${versions.munitCatsEffect}",
      ivy"com.dimafeng::testcontainers-scala-munit:${versions.testcontainersScalaVersion}",
      ivy"com.dimafeng::testcontainers-scala-postgresql:${versions.testcontainersScalaVersion}",
      ivy"com.github.geirolz::fly4s:${versions.fly4s}",
      ivy"org.typelevel::log4cats-slf4j:${versions.log4cats}",
      ivy"ch.qos.logback:logback-classic:${versions.logback}",
      ivy"org.flywaydb:flyway-database-postgresql:${versions.`flyway-database-postgresql`}",
    )
  }
}
