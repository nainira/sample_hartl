require 'spec_helper'

describe "AuthenticationPages" do
  subject { page } 

  describe "signin" do
    before { visit signin_path }    
    it { should have_content('Sign in') }
    it { should have_title('Sign in') }

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) } 
      before do
        # valid_signin(user)
        sign_in user
      end
      it { should have_title(user.name) }
      it { should have_link('Users', href: users_path) } 
      it { should have_link("Profile", href: user_path(user)) } 
      it { should have_link('Settings', href: edit_user_path(user)) } 
      it { should have_link("Sign out", href: signout_path) } 
      it { should_not have_link("Sign in", href: signin_path) } 
      describe 'followed by a signout' do
        before { click_link "Sign out" }
        it { should have_link('Sign in') } 
      end

    end # with valid info

    describe 'with invalid information' do
      before { click_button 'Sign in' }

      it { should have_title('Sign in') }  
      it { should_not have_link('Profile') }    
      it { should_not have_link('Settigns') }
      it { should have_error_message('Invalid') }
      describe 'after visiting another page' do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') } 
      end
    end # with invalid info

  end  # Signin 

  describe 'authorization' do
    describe 'for non-signed-in users' do
      let(:user) { FactoryGirl.create(:user) } 

      describe 'in the Users controller' do
        
        describe 'visiting the edit page' do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end # authorization for non-signed-in users in the Users controller visiting the edit page

        describe 'visiting the user index' do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        describe 'submitting to the update action' do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) } 
        end # authorization submitting to update action
        
        describe 'for visiting the following page' do
          before { visit following_user_path(user) }
          it { should have_title('Sign in') }
        end # for visiting the following page

        describe 'visiting the followers page' do
          before { visit followers_user_path(user) }
          it { should have_title('Sign in') }
        end # visiting the followers page
      end # authorization for non-signed-in users in the Users controller

      describe 'in the Microposts controller' do

        describe 'submitting to the create action' do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end # submitting to create action

        describe 'submitting to the destroy aciton' do
          before { delete micropost_path(FactoryGirl.create("micropost")) }
          specify { expect(response).to redirect_to(signin_path) }
        end # submtting to destroy aciton
      end # authorization for onon-signed-in usrs in the Microposts controller

      describe 'when attempting to visit a protected page' do
        before do
          visit edit_user_path(user)
          fill_in "Email",  with: user.email 
          fill_in "Password",  with: user.password 
          click_button "Sign in"
        end

        describe 'after signing in' do
          it "should render the desired portected page" do
            expect(page).to have_title('Edit user') 
          end
        end # authorization for non-signed-in users when attempting to visit a protected page after signing in   
      end # authorization for non-signed-in users when attempting to visit a protected page
    end # authorization for nono-signed-in users

    describe 'as wrong user' do
      let(:user) { FactoryGirl.create(:user) } 
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") } 
      before { sign_in user, no_capybara: true }

      describe 'submitting a GET request to the User#edit action' do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end # authorization as wrong user submitting a Get request 

      describe 'submitting a PATCH request to the Users#update action' do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end # authorization as wrong user submitting a PATCH request
    end # authorization as wrong user

    describe 'as non-admin user' do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe 'submtting a DELETE request to the Users#destroy action' do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end # authorization as non-admin user submtting a DELETE request
    end # authorization as non-admin user
    describe 'as admin user' do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin, no_capybara: true
      end
      it "should_not be able to delete admin himself" do
          expect do
            delete user_path(admin.id)
          end.not_to change(User, :count).by(-1)
      end
    end # authorization as admin

  end # authorization 

end
