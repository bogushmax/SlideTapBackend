class ListenAction < Cramp::SSE
	on_start  :open_redis_connection,
            :create_session,
            :subscribe_to_channel
  on_finish :unsubscribe_from_channel,
            :close_redis_connection

  def open_redis_connection
    @redis = EM::Hiredis.connect
  end

  def create_session
    @token = rand(36**8).to_s(36)
    data   = { token: @token }.to_json
    render data, :event => 'initialized'
  end

  def close_redis_connection
    @redis.close_connection
  end

  def subscribe_to_channel
    @redis.subscribe @token
    @redis.on(:message) do |channel, message|
      message = JSON.parse message, :symbolize_keys => true
      render message[:data].to_json, :event => message[:event]
    end
  end

  def unsubscribe_from_channel
    @redis.unsubscribe @token
  end
end