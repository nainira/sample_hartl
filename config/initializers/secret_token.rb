# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
# SampleHartl::Application.config.secret_key_base = '2637ae9fc313d61e8928f61f5a4e15c1204df4c2ef39465f56a4a3f9d945ab14e692f110f5176b5250981b1354968a597a7a6bca399fb6dd12270a58ed88b939'

require 'securerandom'

def secure_token
	token_file = Rails.root.join('.secret')
	if File.exist?(token_file)
		File.read(token_file).chomp
	else
		token = SecureRandom.hex(64)
		File.wirte(token_file, token)
		token
	end
end

SampleHartl::Application.config.secret_key_base = secure_token
