# Backgrounder [![Build Status](https://app.bitrise.io/app/c5c769425cbf7857/status.svg?token=w5p2dL6QtqDQIyTcjXxSvw&branch=master)](https://app.bitrise.io/app/c5c769425cbf7857) [![codebeat badge](https://codebeat.co/badges/184d8902-c499-4ead-b778-a467d9544c24)](https://codebeat.co/projects/github-com-agapovone-backgrounder-master)

Download best available background for your iOS device

## How to use:
1. Install cocoapods-keys plugin
`gem install cocoapods-keys`
2. Install all pods
3. Use your own keys for unsplash api, or [ask me](https://twitter.com/agapov_one) to provide it.
4. Use :)

## Features

Unsplash application.
- Photos list with popular/new ordering and search
- Collections list with search
- Download or share a photo in high quality

## Architecture

Experimenting with MVVM + Coordinators

RxSwift is used in:
- Network layer
- Binders to View layer
- Interface in ViewModel layer
- Some observable interfaces

## Date

February 2019
