module SvatokCodebreaker
  ATTEMPTS = 10

  class Game
    attr_accessor :attempts, :codebreaker_name
    attr_reader :exit_game

    def initialize
      @secret_code = ''
      @guess = ''
      @attempts = ATTEMPTS
      @hint = true
      @menu_commands = %w(exit restart hint save)
      @codebreaker_name = 'Test'
      @file_path = File.join(File.dirname(__FILE__), 'scores.txt')
      @exit_game = false
    end

    def show_about
      about_game = {}
      about_game[:title] = '
--------------------CODEBREAKER--------------------
       '
      about_game[:about] = '  Codebreaker is a logic game in which a player
tries to break a secret code created by a computer. The
code-maker, which will be played by the application we’re
going to write, creates a secret code of four numbers
between 1 and 6.
 '
      about_game[:rules] = '  Computer creates a secret code of four numbers between 1
and 6. You get ' + ATTEMPTS.to_s + ' chances to break the code.
In each turn, you make a guess of four numbers. Computer
then marks the guess with up to four + and - signs.
  A + indicates an exact match: one of the numbers in the guess
is the same as one of the numbers in the secret code and
in the same position.
  A - indicates a number match: one of the numbers in the guess
is the same as one of the numbers in the secret code but in a
different position.
  At any time during a game, you can request a hint, at which
point the system reveals one of the numbers in the
secret code. After the game is won or lost, you can opt
to save information about the game.
 '
      about_game[:commands] = 'During the game you can use the commands Exit, Restart,
Hint, Save.
 '
      about_game[:take_player_name] = 'Please, enter your name:'
      about_game.values
    end

    def start
      @secret_code = ''
      4.times { @secret_code += rand(1..6).to_s }
      '----------Game started. Enter guess:----------'
    end

    def codebreaker_answer(answer)
      menu_command?(answer) ? menu_command(answer) : submit_guess(answer)
    end

    def menu_command?(command)
      @menu_commands.include?(command)
    end

    def menu_command(command)
      command.downcase!
      send(('command_' + command).to_sym)
    end

    def method_missing(meth)
      if meth.to_s =~ /^command_(\w+)$/
        'You entered is not correct command. Enter the correct command.'
      else
        super
      end
    end

    def command_exit
      @exit_game = true
      '----------Bye!----------'
    end

    def command_restart
      @attempts = ATTEMPTS
      @hint = true
      old_secret_code = @secret_code
      start while old_secret_code == @secret_code
      '----------Game restarted. Enter guess:----------'
    end

    def command_hint
      return 'You have already used a hint.' unless @hint
      @hint = false
      @secret_code.to_s[rand(0..3)]
    end

    def command_save
      return 'Sorry, but command Save not available at the moment.' unless (@marking_guess == '++++' || @attempts.zero?)
        score_file = File.open(@file_path, 'a')
        score_file.puts get_game_data.map { |k,v| "#{k}=#{v}" }.join(';')
        score_file.close
        '----------Score saved!---------'
    end

    def submit_guess(guess)
      if (valid_guess?(guess))
        @attempts -= 1
        marker = Marker.new(instance_variable_get(:@secret_code), guess)
        @marking_guess = marker.marking_guess
        result_after_marking
      else
        'Your code is not valid!'
      end
    end

    def valid_guess?(guess)
      return false unless !!guess
      return false unless guess.length == 4
      return false unless /[1-6]+/=~guess
      true
    end

    def result_after_marking
      message_for_user = {}
      message_for_user[:marking_guess] = @marking_guess
      message_for_user[:game_end] = '----------Congratulations! You win!----------' if @marking_guess == '++++'
      message_for_user[:game_end] = '----------Sorry, but you lose :(----------' if @attempts.zero?
      message_for_user[:commands] = 'You can use Hint. Enter it if you want.' if @hint
      message_for_user[:commands] = 'You can Exit/Restart/Save. Enter the desired command:' if !!message_for_user[:game_end]
      unless !!message_for_user[:game_end]
        message_for_user[:attempts] = 'You have ' + @attempts.to_s + ' attempts.'
        message_for_user[:next_step] = 'Enter a guess:'
      end
      message_for_user
    end

    def get_game_data
      {
        codebreaker_name: @codebreaker_name,
        secret_code: @secret_code,
        marking_guess: @marking_guess,
        attempts: @attempts,
        hint: @hint == true ? 'not used' : 'used',
        game_date: Time.now.strftime('%d/%m/%Y')
      }
    end
  end

end
