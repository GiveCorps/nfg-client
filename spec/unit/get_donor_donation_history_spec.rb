require 'spec_helper'
require 'unit/response_stubs/get_donor_donation_history_stubs'

describe NFGClient::Client do
  let(:nfg_client) { NFGClient.new('aiduuad', 'aooaid', 'sosois', 'ksidi', true) }
  subject { nfg_client.get_donor_donation_history(get_donor_donation_history_params) }

  describe "#get_donor_donation_history" do
    context "with a successful response" do
      it "should return a hash with a new TotalChargeAmount" do
        nfg_client.expects(:ssl_post).returns(nfg_response('200',successful_get_donor_donation_history_response))
        expect(subject['StatusCode']).to eq('Success')
        expect(subject['DonorToken']).to eq('1828282')
        expect(subject['Donations'].length).to eq(2)
        expect(subject['Donations'].first['ChargeId']).to eq('292929')
        expect(subject['Donations'].last['ChargeId']).to eq('8939399')
      end
    end

    context "with a server error" do
      it "should return an UnexpectedError" do
        nfg_client.expects(:ssl_post).returns(nfg_response('500',server_error_response))
        expect(subject['StatusCode']).to eq('UnexpectedError')
      end
    end

    context "with an unsuccessful response" do
      it "should return the appropriate error with new COFid" do
        nfg_client.expects(:ssl_post).returns(nfg_response('200',unsuccessful_get_donor_donation_history_response))
        expect(subject['StatusCode']).to eq('Success')
        expect(subject['Donations'].length).to eq(0)
      end
    end
  end
end