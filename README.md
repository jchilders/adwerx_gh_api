# README

## Setup

```
# Install required gems
bundle install    

# Initialize the database
rails db:setup
```

In order to be able to communicate with the GitHub API an access token will need to be provided.

```
print "GITHUB_API_KEY=<your access token>" > .env
```

Start Rails:

```
bin/div
```

The application should now be available at http://localhost:3000.

![homepage_empty](https://user-images.githubusercontent.com/105418/225953598-cae9ed6f-2dc9-4f86-b195-728c17df5aad.png)

Click on the "Refresh Repositories" button to update the repositories from GitHub. This is an asynchronous operation. Check the logs to see how it's going:

```
10:53:59 web.1  | Started POST "/github_repositories/refresh" for 127.0.0.1 at 2023-03-17 10:53:59 -0500
10:53:59 web.1  | Processing by GithubRepositoriesController#refresh as TURBO_STREAM
10:53:59 web.1  |   Parameters: {"authenticity_token"=>"[FILTERED]"}
10:53:59 web.1  | Completed 202 Accepted in 2ms (ActiveRecord: 0.0ms | Allocations: 1231)
10:53:59 web.1  |
10:53:59 web.1  |
10:54:03 web.1  | Received 100 / 2967 repositories from Github API
10:54:06 web.1  | Received 200 / 2967 repositories from Github API
...
```

Refresh the page and it should look similar to the following:

![homepage_filled](https://user-images.githubusercontent.com/105418/225956534-4a1a5807-c905-4b8e-b010-270ef423235b.png)

Note that the GitHub search API will return a maximum of 1000 results. See [here](https://docs.github.com/en/rest/search?apiVersion=2022-11-28#about-the-search-api) for more info.

## Other Notes

This application uses sqlite for the database. It has been tested against Ruby 3.2.0 and Rails 7.0.4.3.

Given more time I would improve the following:

- Add tests, especially around the API operations
- Add the VCR gem (or similar) to test good/bad responses from the API
- Improve the feedback given to the user about the status of the processing of the GH API responses
