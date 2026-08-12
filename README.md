# Brutus Mini-Lab

## 1. Project Overview

This project is a self-contained security testing mini-lab built around the Brutus multi-protocol credential testing tool.

The purpose of the lab is to demonstrate controlled credential testing against intentionally vulnerable, locally hosted services in an isolated Docker environment.

The lab contains three different network protocols:

- SSH
- FTP
- Telnet

All targets are intentionally created for this laboratory environment.

The lab is **not intended for testing against systems outside the local Docker environment**.

The project contains both:

1. A vulnerable configuration using intentionally weak laboratory credentials.
2. A secured configuration using stronger credentials so that the same credential-testing procedure can be compared.

---

## 2. Objectives

The main objectives of the mini-lab are:

- Build a self-contained Docker-based security testing environment.
- Integrate the Brutus credential-testing tool.
- Demonstrate Brutus against at least three different protocols.
- Provide intentionally vulnerable local targets.
- Provide secured versions of the targets.
- Demonstrate the difference between vulnerable and secured configurations.
- Provide reproducible test commands.
- Document the setup, usage, testing methodology and results.
- Keep all credential-testing activity inside an isolated local laboratory.

The three protocols implemented in the lab are:

| Protocol | Host Port | Container Port |
|---|---:|---:|
| SSH | 2222 | 22 |
| FTP | 2121 | 21 |
| Telnet | 2323 | 23 |

FTP also uses passive-mode ports `30000-30009`.

---

## 3. Lab Architecture

The laboratory consists of three Docker containers connected to a dedicated Docker bridge network.

```text
Host machine
     |
     v
Docker / Docker Compose
     |
     v
brutus-lab network
     |
     +-------------------+
     |                   |
     v                   v
 SSH target          FTP target
 2222 -> 22          2121 -> 21
                         |
                         +--> 30000-30009
     |
     v
 Telnet target
 2323 -> 23
```

The containers are:
- brutus-ssh
- brutus-ftp
- brutus-telnet

## 4. Requirements

The lab is designed to run using Docker.

Required software:

- Docker Desktop or another Docker Engine supporting Docker Compose
- Git
- A terminal capable of running shell commands

The current development environment is Windows with Docker Desktop and Git Bash.

The lab itself runs the vulnerable services inside Docker containers, so the target services do not need to be installed directly on the host machine.

## 5. Project structure

The current project structure is:

```text
brutus-mini-lab/
├── docker-compose.yml
├── docker-compose.secured.yml
├── targets/
│   ├── ssh/
│   │   ├── Dockerfile
│   │   └── Dockerfile.secured
│   ├── ftp/
│   │   ├── Dockerfile
│   │   └── Dockerfile.secured
│   └── telnet/
│       ├── Dockerfile
│       └── Dockerfile.secured
├── brutus/
│   └── bin/
│       ├── brutus.exe
│       ├── LICENSE
│       └── README.md
├── tests/
│   └── test-brutus.ps1
├── docs/
└── wordlists/
```

The Project contains:
- Docker compose configurations for the vulnerable and secured lab versions.
- Separate Dockerfiles for the three target protocols.
- The Brutus executable used for credential testing.
- Automated Powershell tests.
- Documentation and supporting files.

The vulnerable targets use intentionally weak credentials for the demonstration.

The secured targets use different, stronger credentials so that the same Brutus tests no longer succeed with the weak credentials.

## 6. Setup

Clone the repository:

	git clone <REPOSITORY-URL>
Enter the Project directory:

	cd brutus-mini-lab

Build the Docker targets:

	docker compose build

Start the vulnerable lab:

	docker compose up -d

Check the status of containers:

	docker compose ps

All three target containers should report an Up status.

To stop the lab:
	
	docker compose down

## 7. Vulnerable Test Credentials

The vulnerable laboratory targets use intentionally weak test credentials.

These credentials exist only inside the isolated Docker laboratory and are not intended for use on external or production systems.

### SSH

```text
Username: labuser
Password: labpassword
```

### FTP

```text
Username: labuser
Password: labpassword
```

### Telnet

```text
Username: user
Password: password
```

The weak credentials are intentionally included so that Brutus can demonstrate credential-testing behaviour against all three supported protocols in a controlled environment.

The credentials are part of the vulnerable configuration only. The secured configuration uses different, stronger passwords so that the same Brutus tests can be repeated and compared.

## 8. SSH Target

The SSH service runs inside the SSH target container on TCP port 22.

Docker publishes the service on:

	localhost:2222

Manual connectivity test:

	ssh -p 2222 labuser@localhost

Use the following laboratory credentials when prompted:

	Username: labuser
	Password: labpassword

The SSH connection was successfully tested during development.

After logging in, the SSH session can be closed with:

	exit

## 9. FTP target
The FTP service runs inside the FTP target container on TCP port 21.

Docker publishes the service on:

	localhost:2121

The FTP service uses passive mode with the following port range:

	30000-30009

Manual authentication test:

	curl -v -u 'labuser:labpassword' ftp://localhost:2121/

The test successfully demonstrated:

- connection to the FTP service
- authentication using the laboratory account
- successful 230 Login successful response
- successful passive-mode data connection
- successful directory listing

The FTP service uses vsftpd.

Anonymous authentication is disabled.

## 10. Telnet target  

The Telnet service runs inside the Telnet target container on TCP port 23.

Docker publishes the service on:

	localhost:2323

The service was tested from the host environment and successfully returned a Telnet login prompt.  

The laboratory does not require a native Telnet client on the host for the automated Brutus tests.

The vulnerable Telnet target uses the following credentials:

	Username: user
	Password: password

The Telnet target is based on the wistic/telnetd Docker image and is included as one of the three protocol targets required by the laboratory assignment.

## 11. Vulnerable configuration

The vulnerable configuration is the default configuration of the laboratory.

It contains intentionally weak credentials that are used to demonstrate credential testing with Brutus.

The vulnerable targets are:

- SSH
- FTP
- Telnet

The vulnerable Docker Compose configuration is:

	docker compose.yml

The targets can be built and started with:

	docker compose build
and

	docker compose up -d

The vulnerable test credentials are:

Protocol	Username	Password
SSH	labuser	labpassword
FTP	labuser	labpassword
Telnet	user	password

The automated Brutus test can be executed with:

	.\tests\test-brutus.ps1

The expected result for the vulnerable configuration is successful authentication against all three laboratory targets.  

The vulnerable configuration is intentionally insecure and exists only for controlled testing inside the local Docker laboratory.  
 
It must not be exposed to external networks or used with real credentials.  


## 12. Secure configuration

The laboratory includes a separate secured configuration that can be started using:

	docker compose -f docker-compose.secured.yml up -d

The secured configuration uses the same three protocols as the vulnerable configuration:

- SSH
- FTP
- Telnet

The main difference is that the secured configuration does not use the weak credentials from the vulnerable targets.

The secured credentials are:

SSH and FTP

	Username: labuser
	Password: ThisIsAStrongLabPassword_2026!
	
Telnet

	Username: user
	Password: ThisIsAStrongPassword123

The same Brutus tests can be executed against the secured configuration.

The expected result is that the weak credentials used against the vulnerable configuration are no longer valid.

This provides a simple comparison:

Vulnerable configuration
        ↓
Brutus credential test
        ↓
Weak credentials accepted
        ↓
Authentication succeeds

versus:

Secured configuration
        ↓
Same Brutus credential test
        ↓
Weak credentials rejected
        ↓
Authentication fails

The secured configuration is provided as a separate Docker Compose file:

	docker-compose.secured.yml

The individual secured target configurations are:

	targets/ssh/Dockerfile.secured
	targets/ftp/Dockerfile.secured
	targets/telnet/Dockerfile.secured

The purpose of the secured configuration is to demonstrate the difference between intentionally vulnerable laboratory credentials and stronger credentials in an otherwise comparable environment.

## 13. Brutus integration

Brutus is an open-source multi-protocol authentication testing tool developed by Praetorian.

Official repository:

	https://github.com/praetorian-inc/brutus

Brutus is implemented in Go and supports multiple network authentication protocols.

A pre-built Brutus executable is included in the laboratory repository:

```
brutus/
└── bin/
    ├── brutus.exe
    ├── LICENSE
    └── README.md
```

The laboratory uses Brutus to test authentication against the three locally hosted protocol targets:

- SSH
- FTP
- Telnet

The targets are exposed on the following host ports:

	SSH:    127.0.0.1:2222
	FTP:    127.0.0.1:2121
	Telnet: 127.0.0.1:2323

The Brutus integration was verified using an automated PowerShell test script:

	tests/test-brutus.ps1

The automated test executes controlled authentication tests against all three laboratory services.

For the vulnerable configuration, the expected valid credentials are:

SSH:

	labuser / labpassword

FTP:

	labuser / labpassword

Telnet:

	user / password

The tests successfully demonstrated valid authentication against all three protocols.

The Brutus test output reports the target information, protocol, authentication result and test summary.

The Brutus executable is used only against the intentionally vulnerable services running locally as part of this laboratory.

## 14. Testing methodology

All credential-testing activity is intended to remain inside the isolated Docker laboratory.

The laboratory uses a controlled and reproducible testing workflow.

### Vulnerable configuration

Start the vulnerable targets:

	docker compose build
	docker compose up -d

Verify that the containers are running:

	docker compose ps

Run the automated Brutus tests:

	.\tests\test-brutus.ps1

The test script checks all three protocols:

	SSH
	FTP
	Telnet

The vulnerable configuration should result in successful authentication using the intentionally weak laboratory credentials.

### Secured configuration

Stop the vulnerable configuration:

	docker compose down

Build the secured targets:

	docker compose -f docker-compose.secured.yml build --no-cache

Start the secured configuration:

	docker compose -f docker-compose.secured.yml up -d

Verify the Compose configuration:

	docker compose -f docker-compose.secured.yml config

Verify the running containers:

	docker compose -f docker-compose.secured.yml ps

Run the same Brutus test script:

	.\tests\test-brutus.ps1

The weak credentials used by the vulnerable configuration should now be rejected.

### Test comparison

The test results can therefore be compared between the two configurations:

Configuration	SSH	FTP	Telnet
Vulnerable	Valid	Valid	Valid
Secured	Invalid	Invalid	Invalid

This demonstrates the effect of changing the authentication credentials while keeping the protocol targets and network structure otherwise comparable.

The tests use small, laboratory-specific credential data. No large external password databases are required.

The purpose of the testing is demonstration and validation of the laboratory environment, not testing against external systems.

## 15. Cleanup

To stop the vulnerable laboratory:

	docker compose down

To stop the secured laboratory:

	docker compose -f docker-compose.secured.yml down

To rebuild the vulnerable containers from scratch:

	docker compose build --no-cache

To rebuild the secured containers from scratch:

	docker compose -f docker-compose.secured.yml build --no-cache

To start the vulnerable laboratory again:

	docker compose up -d

To start the secured laboratory again:

	docker compose -f docker-compose.secured.yml up -d

To check the status of the vulnerable laboratory:

	docker compose ps

To check the status of the secured laboratory:

	docker compose -f docker-compose.secured.yml ps

After finishing the demonstrations, the containers should be stopped with the appropriate docker compose down command.

##  16. References

### Brutus

Praetorian's Brutus project:

https://github.com/praetorian-inc/brutus

Brutus is used in this project as the credential-testing tool for the SSH, FTP and Telnet laboratory targets.

### Telnet target

The Telnet target is based on the wistic/telnetd Docker image.

The image is used as a simple Telnet service target for the isolated laboratory environment.

### Inspiration and external resources

The project uses Brutus as the primary external tool and wistic/telnetd as the base image for the Telnet target.

The Docker target configurations for SSH and FTP were created specifically for this laboratory using standard Debian packages and service configurations.

No external credential databases are required by the laboratory.

All credential-testing demonstrations are restricted to the locally hosted Docker targets included in this project.
