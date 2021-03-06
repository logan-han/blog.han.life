---
title: "Exclude a Kotlin subproject from Gradle Jacoco"
date: "2020-12-21"
description: "When a sub-project doesn't support Jacoco"
---

In my project, one of the subproject is NodeJS hence the usual Jacoco setup:
```
tasks.withType(Test) {
    finalizedBy jacocoTestReport
}
```
doesn't work as Jacoco fails since it can't locate test execution binary for the nodeJS project.

After some trial & error, found out this approch works:
```
tasks.withType(Test).each { testTask ->
    //nodeJS doesn't support jacoco
    if(!testTask.getProject().toString().contains("nodejsproject")) {
        testTask.finalizedBy(jacocoTestReport)
    }
}
```

then add jacoco gradle setup as usual with executionData setup:
```
apply plugin: 'jacoco'

jacocoTestReport {
    executionData { tasks.withType(Test).findAll { it.jacoco.destinationFile.exists() }*.jacoco.destinationFile }

    reports {
        xml.enabled true
        xml.destination(file("${jacoco.reportsDir}/xml/jacocoTestReport.xml"))
        html.enabled true
        html.destination(file("${jacoco.reportsDir}/html"))
    }
}
```

credit to: https://stackoverflow.com/questions/19025138/gradle-how-to-generate-coverage-report-for-integration-test-using-jacoco
