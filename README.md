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

### Note
* Make sure to install the submodule instructed above
* Make sure to open the ***WhatsInTheFridge.xcworkspace*** to run the file
* Make sure to run with the following scheme and simulator ***WhatsInTheFridge > iphone11***

#### Submodules
* This will add a submodule
```git
git submodule add <submodule url>
```

* This will pull the submodule repos upon initialization `git submodule update --init`, to inialize a specific submodule, do `git submodule update --init --remote <module name>`

* Subsequent updates to submodules `git submodule update`, to update a specific submodule, do `git submodule update --remote <module name>`

## Features
* User is able to input/delete/move ingredients
* User is able to select preferences and restrictions for a meal
* The app is able to display recipes for users to like or collect (save to profile)
* Recipes are able to be updated through calls to the recipe API
* Recipes are able to be recommened to user through calls to the recipe API
* Store state (preferences, likes, and collects) using CoreData
* Recommend recipes based on user history (likes, collects, preferences)

## Techonologies
* UIKit
* ResearchKit
* Pods - SkeletonView
