require 'spec_helper'

module SvatokCodebreaker
  RSpec.describe Game do
    context '#start' do
      let(:game) {Game.new}

      before do
        game.start
      end

      it 'generate secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it 'saves 4 numbers secret code'do
        expect(game.instance_variable_get(:@secret_code).length).to eq(4)
      end
      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
    end

    context '#codebreaker_answer' do
      it 'codebreaker enter menu command' do
        game = Game.new
        expect(game.menu_command?('q')).to eq(true)
      end
      it 'codebreaker enter guess' do
        game = Game.new
        expect(game.menu_command?('1234')).to eq(false)
      end
    end

    context '#menu_command' do
      it 'codebreaker enter exit command'
      it 'codebreaker enter hind command'
    end

    context '#valid_guess?' do
      it 'not valid if guess empty' do
        game = Game.new
        expect(game.valid_guess?('')).to eq(false)
      end
      it 'not valid if guess is not 4 numbers' do
        game = Game.new
        expect(game.valid_guess?('12345')).to eq(false)
      end
      it 'not valid if guess is not with numbers from 1 to 6' do
        game = Game.new
        expect(game.valid_guess?('7777')).to eq(false)
      end
      it 'valid guess' do
        game = Game.new
        expect(game.valid_guess?('1234')).to eq(true)
      end
    end

    context '#submit_guess' do
      it 'system answer if proposed guess is not valid' do
        game = Game.new
        expect(game.submit_guess('11111')).to eq('Your code is not valid!')
      end
      it 'system answer by marking the guess' do
        game = Game.new
        game.start
        expect(game.submit_guess('1234')).not_to be_nil
      end
    end

  end
end
