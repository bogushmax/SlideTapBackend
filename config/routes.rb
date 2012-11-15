# Check out https://github.com/joshbuddy/http_router for more information on HttpRouter
HttpRouter.new do
  add('/listen').to(ListenAction)
  add('/trigger').to(TriggerAction)

  get('/app').to(AppAction)
end
