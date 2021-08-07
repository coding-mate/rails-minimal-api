require "rails_helper"

RSpec.describe "Entrypoint test response body", type: :request do
  it "renders ok message" do
    get "/"

    expect(response.body).to eq({message: "ok"}.to_json)
  end
end
