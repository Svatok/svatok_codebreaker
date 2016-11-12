module SvatokCodebreaker
  class Marker
    def initialize(secret_code, guess)
      @secret_code, @guess = secret_code, guess
    end

    def marking_guess
      return '++++' if @secret_code == @guess
      secret_code_array = @secret_code.to_s.chars.to_a
      guess_array = @guess.to_s.chars.to_a
      mark = guess_array.each_with_index.map do |number, index|
        if number == secret_code_array[index]
          guess_array[index], secret_code_array[index] = nil, nil
          '+'
        end
      end
      mark << '-' * (secret_code_array & guess_array).compact.length
      mark = mark.join
      mark != '' ? mark : 'Sorry, but there is no match...'
    end
  end
end
