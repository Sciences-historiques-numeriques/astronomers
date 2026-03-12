## Install Java and Fuseki


* Check which version of Java is installed and install Java if no version is available
  * Please note that for Fuseki Version 6, you need at least Java version 21 or higher.
  * Check your Java version with this command:
    $ java --version
  * If Java version < 21, uninstall Java [following these instructions](https://www.java.com/download/help/uninstall_java.html) for Windows and [these for other operating systems](https://www.java.com/en/download/uninstalltool.jsp)
  * Then install JDK Java according to your [laptop system and hardware](https://www.oracle.com/java/technologies/downloads) version
  * For Windows, prefer the .msi Java installer version
* [Download Fuseki](https://jena.apache.org/documentation/fuseki2/) and put it into a dedicated folder (but not into the GitHub folder!)
* Unzip Fuseki.
* Open Powershell (Windows) or Terminal (MacOS/Linux).
* Use the ***cd*** command to navigate to the unzipped Fuseki folder.
* Launch Fuseki with the command ./fuseki-server.
* See [this instructions page](https://jena.apache.org/documentation/fuseki2/fuseki-server.html).
* The server will launch and the graphical interface will be available at [http://localhost:3030](http://localhost:3030/).
* Create a new dataset with a name corresponding to your project, e.g.*astrophysicists* , using the “Persistent (TDB2)” dataset type
* Open the ‘Query’ tab of the dataset
* To import data and write to Fuseki, use a write endpoint URL, for example */astrophysicists/*
* To stop the Fuseki server go to the Powershell/Terminal and type Ctrl-C or Command-C
