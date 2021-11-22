#!/bin/bash -e

# Add preview banner to MOTD
cat >> /etc/motd << EOF
*******************************************************
**            This VM was built by:                  **
**      !!   Sacha Roussakis-Notter   !!             **
**    Any bruteforcing attacks will be logged        **
*******************************************************
EOF
