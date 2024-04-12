Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?

  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
    {
      scope: 'email, profile, http://gdata.youtube.com',
      prompt: 'select_account',
      image_aspect_ratio: 'square',
      image_size: 50
    }

end
