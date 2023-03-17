class GithubRepositoriesController < ApplicationController
  before_action :set_github_repository, only: %i[ show edit update destroy ]

  # GET /github_repositories
  def index
    @github_repositories = GithubRepository.all.order(:owner, :name)
    set_star_ranges
  end
 
  def refresh
    quals = RepoQualifiersBuilder.new
    url = "https://api.github.com/search/repositories?#{quals.to_params}"
    GithubRepositorySearch.new.async.call(url)
  
    head :accepted
  end

  # GET /github_repositories/1
  def show
  end

  # GET /github_repositories/new
  def new
    @github_repository = GithubRepository.new
  end

  # GET /github_repositories/1/edit
  def edit
  end

  # POST /github_repositories
  def create
    @github_repository = GithubRepository.new(github_repository_params)

    if @github_repository.save
      redirect_to @github_repository, notice: "Github repository was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /github_repositories/1
  def update
    if @github_repository.update(github_repository_params)
      redirect_to @github_repository, notice: "Github repository was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /github_repositories/1
  def destroy
    @github_repository.destroy
    redirect_to github_repositories_url, notice: "Github repository was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_github_repository
      @github_repository = GithubRepository.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def github_repository_params
      params.require(:github_repository).permit(:name, :owner, :url, :stars)
    end

  def set_star_ranges
    if GithubRepository.none?
      @star_ranges = {}
      return
    end

    max_stars = GithubRepository.all.pluck(:stargazers_count).max
    max_stars = (max_stars/200.0).ceil * 200

    @star_ranges = (1..max_stars).each_slice(200).with_object({}) do |rng, hash|
      hash[rng.first..rng.last] = GithubRepository.where(stargazers_count: rng.first..rng.last).count
    end
  end
end
