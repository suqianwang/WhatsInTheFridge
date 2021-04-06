# What's In The Fridge

## Description
What's In The Fridge is an iOS mobile app that suggests recipes to users based on the ingredient in their fridge and their history preferences.

## Goals
* Create a functional app with the basic features listed below
* Pleasing & intuitive user interface
* Able to handle possible errors & exceptions

## Installation
```git
git clone git@gitlab.oit.duke.edu:CS207_Spring2021/ml4-whats-in-the-fridge.git
git checkout <desired branch>
git submodule update --init
```
### Submodules
* This will add a submodule
```git
git submodule add <submodule url>
```

* This will pull the submodule repos upon initialization
```git
git submodule update --init
```
, to inialize a specific submodule, do
```git
git submodule update --init --remote <module name>
```

* Subsequent updates to submodules
```git
git submodule update=
```
, to update a specific submodule, do
```git
git submodule update --remote <module name>
```

## Features
* User is able to input/delete/move ingredients
* User is able to select preferences and restrictions for a meal
* The app is able to display recipes for users to like or collect (save to profile)
* Recipes are able to be updated through calls to the recipe API
* Recipes are able to be recommened to user through calls to the recipe API
* Store state (preferences, likes, and collects) using CoreData
* Recommend recipes based on user history (likes, collects, preferences)
* User profile management such as updating username, recipes they liked or collected
* Filter functionalities for browsing recipes

## Techonologies
* UIKit
* ResearchKit
