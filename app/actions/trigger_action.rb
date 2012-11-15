class TriggerAction < Cramp::Action
  on_start  :open_redis_connection,
            :publish
  on_finish :close_redis_connection

  class << self
    def validate_presense_of(*params)
      params.each do |param|
        before_start do
          if params[param].empty?
            halt 400, {'errors' => '#{param.capitalize} cannot be empty'}
          else
            yield
          end
        end
      end
    end
  end

  validate_presense_of :token, :event, :data

  def open_redis_connection
    @redis = EM::Hiredis.connect
  end

  def close_redis_connection
    @redis.close_connection
  end

  def publish
    message = params.dup
    message.delete :token
    @redis.publish(params[:token], message.to_json)
    render({}.to_json)
    finish
  end

  def respond_with
    headers = {}
    headers['Cache-Control'] = 'no-cache, no-store'
    [200, headers]
  end
end