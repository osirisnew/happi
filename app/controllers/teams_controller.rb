class TeamsController < ApplicationController
  skip_before_action :ensure_team!
  before_action :set_team, only: %i[edit update]

  layout "auth"

  def index
    @teams = current_user.teams
  end

  def change
    team = current_user.teams.find(params[:id])
    current_user.update(team: team)
    redirect_to dashboard_path, notice: t(".switched_to", name: team.name)
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams.new(
      team_params.merge(plan: plan_name)
    )

    if @team.save
      @team.add_user(current_user, set_active_team: true)

      session.delete(:signup_plan)

      AdminMailer.notification("A new team needs reviewed", "#{@team.name} just signed up for Happi and needs reviewed.").deliver_later

      billing_plan = BillingPlan.new(name: @team.plan)
      @team.change_plan(billing_plan)

      if billing_plan.current_price.zero?
        redirect_to dashboard_path
      else
        checkout = create_checkout(with_plan: billing_plan)
        redirect_to checkout.url
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to dashboard_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def logo_upload
    if current_team.update(logo_upload_params)
      redirect_to settings_path, notice: t(".logo_saved")
    else
      flash[:error] = t(".problem")
      redirect_to settings_path
    end
  end

  private

  def set_team
    @team = current_user.teams.find(params[:id])
  end

  def plan_name
    params.dig(:team, :plan) || "free"
  end

  def team_params
    params.require(:team).permit(:name, :time_zone, :country_code)
  end

  def logo_upload_params
    params.require(:team).permit(:logo)
  end
end
