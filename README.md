# SOM-Browser

This repository contains a complete copy of the Boyle Lab Human-Mouse SOM Browser,
described in (Reference Here).

The SOM Browser runs on two linked Docker containers: one containing the Catalyst
web app and nginx web server and the second containing the mySQL database. To set
up a local mirror, follow the directions under "INSTALLATION"


INSTALLATION

To streamline the installation process, we have provided the "install_browser.sh"
script, which automates all the steps to initialize the Docker containers.
Before running this, you will need to make some minor edits to it and some other
files in the SOM-Browser directory:

1) (Optional) Set the "BROWSER_PATH" variable at the head of "install_browser.sh"
   to the absolute path where the browser files exist. This defaults to the
   MouseSOM subdirectory of the present working directory.

2) Edit the "server name" variable in "nginx.conf" to match the name and port
   number of the host machine. 

3) (Optional) Enable browser monitoring on the docker container by uncommenting
   the relevant sections in install_browser.sh and editing the marked sections
   in monitrc to match your email server and email address.

4) Run the install_browser.sh script:

   `./install_browser.sh`

5) (Optional, but highly recommended!) Log in to the db container  with the command:

   `docker exec -it db bash`

   then log in to mysql, as root, with password "CHANGE_ME" and change the password
   following normal procedures.


STARTING AND STOPPING THE BROWSER

Shell scripts are provided to easily start and stop the browser:

`./start_browser.sh`
`./stop_browser.sh`

If you installed with monit enabled, you may also start the browser using the
following command. (This will also enable monitoring of an already-running
browser instance.)

`./monit_browser.sh`


UNINSTALLING THE BROWSER

To completely remove the browser, issues the following two commands after stopping
the browser with stop_browser.sh:

`docker rm -v db MouseSOM`

If desired, you can now delete the entire MouseSOM directory and its contents.


GETTING HELP / BUG REPORTS

Please submit pull requests through GitHub. Bug reports and questions can be emailed
to <adadiehl@umich.edu>.
