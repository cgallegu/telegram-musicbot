require 'telegram/bot'
require 'pp'
require 'faraday'
require 'pry'
require 'rb-readline'

token = ENV['TELEGRAM_MUSICBOT_TOKEN']

state = :stopped
current_audio = 'metallica'

def normalize(text)
  text.downcase.strip
end

def is_match(candidate, current_audio)
  normalize(candidate) == normalize(current_audio)
end

def is_command(command)
  lambda { |m| m.start_with?(command) }
end

begin
  puts 'Starting...'
  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
      case message.text
      when nil
        next
      when '/start'
        # TODO: Move the state-machine logic into a proper bot class, so we just do
        # the integration with telegram itself here.
        if state == :stopped
          state = :started
          puts "Sending audio"
          bot.api.send_message(chat_id: message.chat.id, text: 'Ok, partamos el juego. De quien es esta cancion? Para responder, di `/try <artista>`.')
          result = bot.api.send_voice(
            chat_id: message.chat.id,
            # TODO: Handle file uploads. Telegram stores audio server side, and we can
            # key it by id here. Maybe a bot interface to upload audio?
            voice: 'AwADAQADjgADFBl5RE9z00bPjGFfAg',
            caption: 'quien sera'
          )
          puts "Audio sent successfully. Result follows"
          pp result
        else
          bot.api.send_message(chat_id: message.chat.id, text: "Parece que ya estamos jugando. Si quieres parar, di '/stop'")
        end
      when is_command('/try')
        if state == :started
          parsed = message.text.split(' ')
          if parsed.length != 2
            bot.api.send_message(chat_id: message.chat.id, text: "Para responder, di /try <artista>.")
            next
          end
          answer = parsed[1]
          if is_match(answer, current_audio)
            bot.api.send_message(chat_id: message.chat.id, text: "Bien! Le achuntaste. La respuesta es #{current_audio}.")
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Nope, sigue intentando.")
          end
        else
          bot.api.send_message(chat_id: message.chat.id, text: "Cuando quieras jugar, di '/start'.")
        end
      when '/stop'
        state = :stopped
        bot.api.send_message(chat_id: message.chat.id, text: "Esta bien. Cuando quieras jugar, di '/start'.")
      when '/stats'
        bot.api.send_message(chat_id: message.chat.id, text: "Todavia no se llevar el puntaje.")
      end
    end
  end
ensure
  # Ensure something here
end
