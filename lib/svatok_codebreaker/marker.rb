module SvatokCodebreaker
  class Marker
    def initialize(secret_code, guess)
      @secret_code = secret_code.to_s.chars.to_a
      @guess = guess.to_s.chars.to_a
    end

    def marking_guess
      return '++++' if @secret_code == @guess
      mark = marking_exact_matches
      mark << marking_inexact_matches
      mark = mark.join
      mark != '' ? mark : 'Sorry, but there is no match...'
    end

    def marking_exact_matches
      @guess.each_with_index.map do |number, index|
        if number == @secret_code[index]
          @guess[index], @secret_code[index] = nil, nil
          '+'
        end
      end      
    end

    def marking_inexact_matches
      '-' * (@secret_code & @guess).compact.length
    end

  end
end
