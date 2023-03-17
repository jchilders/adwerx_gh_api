require "rails_helper"

RSpec.describe GithubRepositoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/github_repositories").to route_to("github_repositories#index")
    end

    it "routes to #new" do
      expect(get: "/github_repositories/new").to route_to("github_repositories#new")
    end

    it "routes to #show" do
      expect(get: "/github_repositories/1").to route_to("github_repositories#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/github_repositories/1/edit").to route_to("github_repositories#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/github_repositories").to route_to("github_repositories#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/github_repositories/1").to route_to("github_repositories#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/github_repositories/1").to route_to("github_repositories#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/github_repositories/1").to route_to("github_repositories#destroy", id: "1")
    end
  end
end
