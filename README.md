# Brututs Mini-lab
## 1. Project Overview  

This Project is a self-contained security testing mini-lab build around the Brutus multi-protocol credential testing tool. 

The purpose of the lab is to demonstrate credential testing against intentionally vulnerable, locally hosted services in an isolated Docker environment.

The lab currently contains three different Network protocols:
- SSH
- FTP
- Telnet

All targets are intentionally created for this laboratoy environment. The lab is not intended for testing against systems outside the local Docker environment.

The Project contains both: 
	1. vulnerable configurations, where weak test credentials can be tested
	2. secured configurations, where security controls are introduced and the same tests can be compared.

2. Objectives

3. Lab architecture

The lab consists of three Docker containers connected to a dedicated Docker Network.
Hos machine --> Docker / Docker Compose --> brutus-lab Network --> SSH target (port 2222 --> 22), FTP target (port 2121 --> 21) and Telnet target (port 2323 --> 23).

The FTP service also uses a passive-mode port range: 30000-30009. These ports are published by Docker because FTP passive-mode data connections require additional ports.

4. Requirements

The lab is designed to run using Docker.

Required software:
	- Docker Desktop or another Docker Engine supporting Docker Compose
	- Git
	- A terminal capable of running Shell commands.

The current development environment is Windows with Docker Desktop and Git Bash.

The lab itself runs the vulnerable services inside Debian-based Docker containers.

5. Project structure

Current Project structure:

brutus-mini-lab/ ├── docker-compose.yml │ ├── targets/ │ ├── ssh/ │ │ └── Dockerfile │ │ │ ├── ftp/ │ │ └── Dockerfile │ │ │ └── telnet/ │ └── Dockerfile │ ├── brutus/ ├── docs/ ├── tests/ └── wordlists/

Additional scripts and documentation will be added during the implementation.

6. Setup

Clone the repository and enter the Project directory:

	git clone <REPOSITORY-URL>

	cd brutus-mini-lab

Build the Docker targets:

	docker compose build

Start the lab:

	docker compose up -d

Check the status:

	docker compose ps

All three target containers should report an Up status.

7. Vulnerable test credentials

The current laboratory targets use the following intentionally weak test credentials:

Username: labuser
Password: labpassword

These credentials exist only inside the Docker laboratory.

The weak credentials are intentionally included so that credential-testing behaviour can later be demonstrated in a controlled environment.

8. SSH Target

The SSH Service runs inside the SSH target container on TCP port 22.

Docker publishes it as:

	- localhost:2222
Manual connectivity test:
	ssh -p 2222 labuser@localhost
Use the given credentials when prompted:
	- Username: labuser
	- Password: labpassword
The SSH connection was successfully tested during development.

After login, the SSH session can be closed with "exit".

9. FTP target
The FTP Service runs inside the FTP target container on TCP port 21.
Docker publishes it as:
	- localhost:2121
FTP passive-mode port:
	- 30000-30009
Manual authentication test:
curl -v -u 'labuser:labpassword' ftp://localhost:2121/
The test successfully demonstrated:
	- connection to the FTP Service
	- authentication using the laboratory account
	- successful 230 Login successful response
	- successful passive-mode data connection
	- successful directory listing (?)
The FTP Service uses vsftpd.
Anonymous authentication is disabled.

10. Telnet target
The Telnet Service runs inside the Telnet target container on TCP port 23.
Docker publishes it as:
	localhost:2323
The Service was tested from the host environment and successfully returned a Telnet login prompt. 

The test envrironment does not currently require a native Telnet client on the host.

11. Vulnerable configuration

The vulnerable version of the lab intentionally contains weak authentication credentials.

The purpose is to create a reproducible test case for credential-testing behavior.

The vulnerable configuration is restricted to the Docker lab.

No external or production systems are involved.

12. Secure configuration

This section will be completed after the vulnerable demonstrations are working.

The secured version will introduce appropriate authentication/security controls and will be tested using the same laboratory test procedure.

The objective is to compare:

Vulnerable configuration
        ↓
Credential testing
        ↓
Expected weak-credential result

versus

Secured configuration
        ↓
Same test
        ↓
Expected mitigation / reduced effectiveness

13. Brutus integration

Brutus is an open-source multi-protocol authentication testing tool developed by Praetorian.

Official repository:

https://github.com/praetorian-inc/brutus

The official project describes Brutus as a multi-protocol credential testing tool implemented in Go. The project documentation lists support for multiple network authentication protocols. [1]

Brutus integration into this laboratory is currently in progress.

The final version of this section will document:

Brutus version used
installation method
configuration
supported protocols used in this lab
exact test commands
test results
limitations and observations

14. Testing methodology

All credential-testing activity is intended to remain inside the Docker laboratory.

The planned workflow is:

1. Start vulnerable targets
2. Verify all target services
3. Start/configure Brutus
4. Run controlled credential tests
5. Record results
6. Stop vulnerable targets
7. Start secured configuration
8. Repeat the same tests
9. Compare results

The final implementation will use small laboratory-specific wordlists rather than large external password databases.

15. Cleanup

Stop the laboratory:

docker compose down

To rebuild the containers:

docker compose build --no-cache

To start the laboratory again:

docker compose up -d

References
