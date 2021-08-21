[![Build Status](https://github.com/cloudacademy/voteapp-frontend-react-2020/actions/workflows/main.yml/badge.svg)] ![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/cloudacademy/voteapp-frontend-react-2020?style=social)

# Background
Provides a web based frontend written in React. The web application provides a programming language voting feature where end users can vote on 6 different languages (C#, Python, JavaScript, Go, Java, and NodeJS). 

The React based web application is designed to be compiled and containerised, and eventually deployed into a Kubernetes cluster. 

The web application generates AJAX requests which are sent to a publicly exposed API hosted on the same cluster. The API is written in Go and reads/writes to a MongoDB database, also hosted within a cluster using a StatefulSet setup.

![Language Vote Application](/doc/voteapp.png)
