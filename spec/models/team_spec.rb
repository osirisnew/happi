require "rails_helper"

RSpec.describe Team, type: :model do
  it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to have_many(:customers) }
  it { is_expected.to have_many(:message_threads) }
  it { is_expected.to have_many(:custom_email_addresses) }

  it { is_expected.to validate_presence_of(:name) }

  describe "#emails_to_send_from" do
    let(:team) { teams(:payhere) }

    context "if no custom emails exist" do
      before { team.custom_email_addresses.destroy_all }

      it "returns yo@happi.team" do
        expect(team.emails_to_send_from).to eq(["Payhere <yo@happi.team>"])
      end
    end

    context "if custom emails are added and verified" do
      it "includes them" do
        expect(team.emails_to_send_from).to eq(
          [
            "Payhere Support <support@payhere.co>",
            "Payhere <yo@happi.team>"
          ]
        )
      end
    end
  end
end
