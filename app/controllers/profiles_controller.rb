class ProfilesController < ApplicationController
  before_action :set_profile, except: [ :create ]

  # GET / ou GET /profiles
  def index
    @profiles = Profile.all.order(:name, :github_username)
  end

  def show_by_short
    url = UrlShortenerService.expand_url params[:short_code]
    if url
      redirect_to(url, allow_other_host: true)
    else
      redirect_to(profiles_path, allow_other_host: true, alert: "Perfil não encontrado!")
    end
  end

  # GET /profiles/search
  def search
    @profiles = Profile.search(params[:q]).order(:name)
    render :index
  end

  # GET /profiles/:id
  def show
  end

  # GET /profiles/new
  def new
  end

  # POST /profiles
  def create
    @profile = Profile.new profile_params

    if @profile.save
      begin
        @profile.update_github_data!
        redirect_to @profile, notice: "Perfil do Github criado com sucesso!"
      rescue GithubService::Errors::UserDataNotFoundError => e
        Rails.logger.error "Erro ao criar perfil: #{e.message}"
        redirect_to @profile, alert: "Erro ao coletar dados do Github. Tente novamente."
      end
    else
      @profiles = Profile.all.order(:name)
      render :index, status: :unprocessable_entity
    end
  end

  # GET /profiles/:id/edit
  def edit
  end

  # PATCH/PUT /profiles/:id
  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: "Perfil atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/:id
  def destroy
    @profile.destroy
    redirect_to profiles_path, notice: "Perfil removido com sucesso!"
  end

  # PATCH /profiles/:id/rescan
  def rescan
    begin
      @profile.update_github_data!
      redirect_to @profile, notice: "Dados do GitHub atualizados com sucesso!"
    rescue => e
      Rails.logger.error "Erro ao re-escanear perfil: #{e.message}"
      redirect_to @profile, alert: "Erro ao atualizar dados do GitHub. Tente novamente."
    end
  end

  private

  def set_profile
    @profile = Profile.new
    return unless params[:id].present?

    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:name, :github_url)
  end
end
