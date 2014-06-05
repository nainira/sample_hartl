require 'spec_helper'

describe "StaticPages" do

    let(:base_title) { "Ruby on Rails Tutorial Sample App" } 
    subject { page }

    describe "Home page" do
      before { visit root_path }
    	# it "should have the content 'Sample App'" do
    	#     expect(page).to have_content('Sample App')
    	# end
      it { should have_content('Sample App') }
    	# it "should have the title" do
    	# 	expect(page).to have_title("#{base_title}") 
    	# end
      it { should have_title("#{base_title}") }
      # it "should not have a custom page title" do
      #   expect(page).not_to have_title('| Home') 
      # end
      it { should_not have_title('| Home') }

    end # Home page test
    describe "Help Page" do
      before { visit help_path }
    	# it "should have the content 'Help'" do
    	# 	visit '/static_pages/help'
    	# 	expect(page).to have_content('Help')
    	# end

      it { should have_content('Help') }

    	# it "should have the title 'Help'" do
    	# 	visit '/static_pages/help'
    	# 	expect(page).to have_title("#{base_title} | Help") 
    	# end
      it { should have_title("#{base_title} | Help") }
    end # Help page test

    describe "About page" do
      before { visit about_path }
    	# it "should have the content 'About Us'" do
    	# 	visit '/static_pages/about'
    	# 	expect(page).to have_content('About Us') 
    	# end
      it { should have_content('About Us') }

    	# it "should have the title 'About Us'" do
    	# 	visit '/static_pages/about'
    	# 	expect(page).to have_title("#{base_title} | About Us")
    	# end
      it { have_title("#{base_title} | About Us") }
    end # About page

    describe "Contact" do
      before { visit contact_path }
      # it "should have the content 'Contact'" do
      #     visit '/static_pages/contact'
      #     expect(page).to have_content('Contact') 
      # end
      it { should have_content('Contact') }

      # it "should have the title 'Contact'" do
      #     visit '/static_pages/contact'
      #     expect(page).to have_title("#{base_title} | Contact") 
      # end
      it { should have_title("#{base_title} | Contact")  }
    end # Contat page
end # Static pages
