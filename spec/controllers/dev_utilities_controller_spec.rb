#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe DevUtilitiesController do
  render_views

  before do
    @tom = Factory.create(:user_with_aspect, :email => "tom@tom.joindiaspora.org")
    sign_in :user, @tom
  end

  describe "#zombiefriends" do
    it "succeeds" do
    pending
      get :zombiefriends
      response.should be_success
    end
  end

  def config_file_path(filename)
    File.join(File.dirname(__FILE__), "..", "..", "config", filename)
  end

  describe "operations that affect config/backer_number.yml" do
    # In case anyone wants their config/backer_number.yml to still exist after running specs
    before do
      @backer_number_file = config_file_path("backer_number.yml")
      @temp_file = config_file_path("backer_number.yml-tmp")
      FileUtils.mv(@backer_number_file, @temp_file, :force => true) if File.exists?(@backer_number_file)
    end
    after do
      if File.exists?(@temp_file)
        FileUtils.mv(@temp_file, @backer_number_file, :force => true)
      else
        FileUtils.rm_rf(@backer_number_file)
      end
    end

    describe "#set_backer_number" do
      it "creates a file containing the seed number" do
    pending
        File.should_not exist(@backer_number_file)
        get :set_backer_number, 'number' => '3'
        File.should exist(@backer_number_file)
        YAML.load_file(@backer_number_file)[:seed_number].to_i.should == 3
      end
    end

    describe "#set_profile_photo" do
      before do
        config = YAML.load_file(config_file_path("deploy_config.yml"))
        seed_numbers = config["servers"]["backer"].map {|b| b["number"] }
        @good_number = seed_numbers.max
        @bad_number = @good_number + 1
      end
      it "succeeds when a backer with the seed number exists" do
    pending
        get :set_backer_number, 'number' => @good_number.to_s
        get :set_profile_photo
        response.should be_success
      end
      it "fails when a backer with the seed number does not exist" do
    pending
        get :set_backer_number, 'number' => @bad_number.to_s
        expect { get :set_profile_photo }.to raise_error
      end
    end
  end
end
