require 'spec_helper'

describe "StaticPages" do

    subject { page }
    let(:base_title) { "Ruby on Rails Tutorial Sample App" } 

    shared_examples_for "all static pages" do
      it { should have_selector('h1', text: heading) } 
      it { should have_title(full_title(page_title)) }
    end

    describe "Home page" do
      before { visit root_path }
    	# it "should have the content 'Sample App'" do
    	#     expect(page).to have_content('Sample App')
    	# end
      # it "should have the title" do
      #   expect(page).to have_title("#{base_title}") 
      # end
      # it "should not have a custom page title" do
      #   expect(page).not_to have_title('| Home') 
      # end

      # it { should have_content('Sample App') }
      # it { should have_title("#{base_title}") }
      # it { should_not have_title('| Home') }
      let(:heading) { 'Sample App' } 
      let(:page_title) { '' }

      it_should_behave_like "all static pages"
      it { should_not have_title('| Home') }

      describe 'for signed-in users' do
        let(:user) { FactoryGirl.create(:user) }
        before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          sign_in user
          visit root_path
        end

        it "should render the user's feed" do
          user.feed.each do |item|
            expect(page).to have_selector("li##{item.id}", text: item.content)
          end
        end # should render user feed

        describe 'follower/follwing counts' do
          let(:other_user) { FactoryGirl.create(:user) }
          before do
            other_user.follow!(user)
            visit root_path
          end

          it { should have_link('0 following', href: following_user_path(user)) } 
          it { should have_link('1 followers', href: followers_user_path(user)) } 
        end

      end # Home page for signed-in users

    end # Home page test
    describe "Help Page" do
      before { visit help_path }
    	# it "should have the content 'Help'" do
    	# 	visit '/static_pages/help'
    	# 	expect(page).to have_content('Help')
    	# end


      # it "should have the title 'Help'" do
      #   visit '/static_pages/help'
      #   expect(page).to have_title("#{base_title} | Help") 
      # end

      # it { should have_content('Help') }
      # it { should have_title("#{base_title} | Help") }
      let(:heading) { 'Help' } 
      let(:page_title) { 'Help' } 

      it_should_behave_like "all static pages"
    end # Help page test

    describe "About page" do
      before { visit about_path }
    	# it "should have the content 'About Us'" do
    	# 	visit '/static_pages/about'
    	# 	expect(page).to have_content('About Us') 
    	# end

      # it "should have the title 'About Us'" do
      #   visit '/static_pages/about'
      #   expect(page).to have_title("#{base_title} | About Us")
      # end

      # it { should have_content('About Us') }
      # it { have_title("#{base_title} | About Us") }
      let(:heading) { 'About' } 
      let(:page_title) { 'About' } 
      it_should_behave_like "all static pages"

    end # About page

    describe "Contact" do
      before { visit contact_path }
      # it "should have the content 'Contact'" do
      #     visit '/static_pages/contact'
      #     expect(page).to have_content('Contact') 
      # end
      # it { should have_content('Contact') }

      # it "should have the title 'Contact'" do
      #     visit '/static_pages/contact'
      #     expect(page).to have_title("#{base_title} | Contact") 
      # end

      # it { should have_selector('h1', text: 'Contact') } 
      # it { should have_title("#{base_title} | Contact")  }
      let(:heading) { 'Contact' } 
      let(:page_title) { 'Contact' } 

      it_should_behave_like "all static pages"

    end # Contat page
    it "should have the right links on the layout" do
      visit root_path
      click_link "About"
      expect(page).to have_title(full_title('About Us')) 
      click_link "Help"
      expect(page).to have_title(full_title('Help'))
      click_link "Contact"
      expect(page).to have_title(full_title('Contact')) 
      click_link "Home"
      expect(page).to have_title(full_title('')) 
      click_link "Sign up now!"
      expect(page).to have_title(full_title('Sign up')) 
      click_link "sample app"
      expect(page).to have_title(full_title('')) 
    end
end # Static pages
