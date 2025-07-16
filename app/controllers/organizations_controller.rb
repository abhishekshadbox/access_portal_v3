class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:show, :update, :destroy, :analytics]
  before_action :authorize_organization, only: [:show, :update, :destroy, :analytics]

  # GET /organizations
  def index
    @organizations = Organization.all
    render json: @organizations
  end

  # GET /organizations/:id
  def show
    render json: @organization
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      render json: @organization, status: :created
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /organizations/:id
  def update
    if @organization.update(organization_params)
      render json: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  # DELETE /organizations/:id
  def destroy
    @organization.destroy
    head :no_content
  end

  # GET /organizations/:id/analytics
  def analytics
    users = @organization.users

    stats = {
      total_users: users.count,
      by_role: users.group(:role).count,
      under_13: users.select { |u| u.age && u.age < 13 }.count,
      average_age: users.map(&:age).compact.sum / [users.count, 1].max
    }

    render json: stats
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def authorize_organization
    authorize @organization
  end

  def organization_params
    params.require(:organization).permit(:name, :slug)
  end
end
