require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe 'index' do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end
    # before do
    #   sign_in FactoryGirl.create(:user)
    #   FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
    #   FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
    #   visit users_path
    # end
    it { should have_title('All users') }
    it { should have_content('All users') }
    # it "should list each user" do
    #   User.all.each do |user|
    #     expect(page).to have_selector('li', text: user.name)
    #   end
    # end

    describe 'pagination' do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') } 

      it "should list each other" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end # index pagination

    describe 'delete links' do
      it { should_not have_link('delete') } 
      describe 'as an admin user' do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        
        it { should have_link('delete', href: user_path(User.first)) } 
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end # index delete links as an admin user should be able to delete another user
        it { should_not have_link('delete', href: user_path(admin)) }
      end # index delete links as an admin user
      
    end # index delete links
  end # index

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) } 
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end # Signup page

  describe "signup" do
    before { visit signup_path }

    let(:submit) { "Create my account" } 

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error')}
      end
    end # with invalid information

    describe "with valid infomation" do
      before do
        fill_in "Name",  with: "Example User" 
        fill_in "Email",  with: "user@example.com" 
        fill_in "Password",  with: "foobar" 
        fill_in "Confirm Password",  with: "foobar" 
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') } 

        it { should have_title(user.name) }
        it { should have_link('Sign out') } 
        it { should have_selector('div.alert.alert-success', text: 'Welcome') } 
      end
    end # with valid infomation
  end # Sign up

  describe 'edit' do
    let(:user) { FactoryGirl.create(:user) } 
    # before { visit edit_user_path(user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe 'page' do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') } 
    end # edit page

    describe 'with invalid information' do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end # edit with invalid info

    describe 'with valid information' do
      let(:new_name) { "New Name" } 
      let(:new_email) { "new@example.com" } 
      before do
        fill_in "Name",  with: new_name 
        fill_in "Email",  with: new_email
        fill_in "Password",  with: user.password 
        fill_in "Confirm Password",  with: user.password 
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') } 
      it { should have_link('Sign out', href: signout_path) } 
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end # edit with valid info

    describe 'forbidden attributes' do
      let(:params) do
        { user: { admin: true, password: user.password, password_confirmation: user.password } }
      end

      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end # edit forbidden attributes
  end # edit
end
