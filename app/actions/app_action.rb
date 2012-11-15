class AppAction < Cramp::Action
	def start
    render File.read(SlideTapBackend::Application.root('app/views/app.html'))
    finish
  end
end