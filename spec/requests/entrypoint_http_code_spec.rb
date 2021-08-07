require "rails_helper"

RSpec.describe "Entrypoint test http code", type: :request do
  it "has http code 200" do
    get "/"

    expect(response).to have_http_status :ok
  end
end
