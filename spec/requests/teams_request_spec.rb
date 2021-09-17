require "rails_helper"

RSpec.describe "Teams", type: :request do
  before { sign_in(users(:pete)) }

  describe "GET /new" do
    it "returns http success" do
      get "/teams/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /" do
    it "creates a new team and defaults plan to free trial" do
      perform_enqueued_jobs do
        post "/teams", params: {
          team: {
            name: "Polywork",
            time_zone: "Eastern Time (US & Canada)",
            country_code: "US"
          }
        }

        expect(response).to redirect_to(dashboard_path)
        expect(delivered_emails.size).to eq(1)
        expect(last_email.subject).to eq("Admin alert: A new team needs reviewed")
        expect(Team.last.plan).to eq("free")
        expect(Team.last.subscription_status).to eq("trialing")
      end
    end

    it "sets plan and pending status when plan is passed" do
      post "/teams", params: {
          team: {
            name: "Polywork",
            time_zone: "Eastern Time (US & Canada)",
            country_code: "US",
            plan: "basic"
          }
        }

        expect(response).to redirect_to(dashboard_path)
        expect(Team.last.plan).to eq("basic")
        expect(Team.last.subscription_status).to eq("pending")
    end
  end
end
