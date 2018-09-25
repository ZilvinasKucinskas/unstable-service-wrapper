[![Build Status](https://travis-ci.org/ZilvinasKucinskas/unstable-service-wrapper.svg?branch=master)](https://travis-ci.org/ZilvinasKucinskas/unstable-service-wrapper)

# Description

Client has unstable service which sometimes fail. This wrapper adds some resiliency to upstream problems and also adds additional filtering capabilities.

## Hosted on Heroku

You can check response in a browser by clicking [here](https://unstable-service-wrapper.herokuapp.com/tree/input?indicator_ids[]=31&indicator_ids[]=32&indicator_ids[]=1)

## Prerequisites

* [Recommended] [rbenv](https://github.com/rbenv/rbenv)
* Ruby 2.5.1
* [Bundler](https://bundler.io)

## Installation

```
git clone git@github.com:ZilvinasKucinskas/unstable-service-wrapper.git
cd unstable-service-wrapper
bundle install
```

## Run locally

```
bundle exec rails s
```

## Testing

```
bundle exec rspec # Runs all specs
```

## Testing the endpoints

### Heroku

```
# Original
curl "https://unstable-service-wrapper.herokuapp.com/tree/input" -v

# Filtered
curl "https://unstable-service-wrapper.herokuapp.com/tree/input?indicator_ids[]=31&indicator_ids[]=32&indicator_ids[]=1" --globoff -v

# Not Found
curl "https://unstable-service-wrapper.herokuapp.com/tree/asd" -v

# Malformed parameters
curl "https://unstable-service-wrapper.herokuapp.com/tree/input?indicator_ids[]=asd" --globoff -v
```

### Locally

```
# Original
curl "http://localhost:3000/tree/input" -v

# Filtered
curl "http://localhost:3000/tree/input?indicator_ids[]=31&indicator_ids[]=32&indicator_ids[]=1" --globoff -v

# Not Found
curl "http://localhost:3000/tree/asd" -v

# Malformed parameters
curl "http://localhost:3000/tree/input?indicator_ids[]=asd" --globoff -v
```
