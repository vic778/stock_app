def sign_in_user
  user = create(:user, :confirmed)
  post "/api/users/login", params: { user: { email: user.email, password: user.password } }
  res = JSON.parse(response.body)
  res["user"]
end
