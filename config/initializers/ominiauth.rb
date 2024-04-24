Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
  {
    scope: 'email, profile, http://gdata.youtube.com',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    image_size: 50
  }

  provider :cognito_idp, ENV['COGNITO_CLIENT_ID'],ENV['COGNITO_CLIENT_SECRET'],
    client_options: {
      site: ENV['COGNITO_USER_POOL_SITE']
    },
    name: 'cognito_idp',
    scope: 'email openid',
    user_pool_id: ENV['COGNITO_USER_POOL_ID'],
    aws_region: ENV['AWS_REGION']
end
