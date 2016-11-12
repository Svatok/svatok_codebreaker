module SvatokCodebreaker
  class Game

    def initialize
      @secret_code = ''
      @guess = ''
      @menu_commands = ['q', 'hint']
    end

    def start
      @secret_code = '1234'
    end

    def codebreaker_answer(answer)
      menu_command?(answer)? menu_command(answer) : submit_guess(answer)
    end

    def menu_command?(command)
      @menu_commands.include?(command)
    end

    def menu_command(command)
    end

    def submit_guess(guess)
      if (valid_guess?(guess))
        marker = Marker.new(instance_variable_get(:@secret_code), guess)
        marker.marking_guess
      else
        'Your code is not valid!'
      end
    end

    def valid_guess?(guess)
      return false unless !!guess
      return false unless guess.length == 4
      return false unless /[1-6]+/=~guess
      return true
    end

  end
end
