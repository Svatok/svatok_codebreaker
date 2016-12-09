require 'spec_helper'

module SvatokCodebreaker
  RSpec.describe Game do
    subject(:game) { Game.new }

    context '#initialize' do
      it 'generate secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).length).to eq(4)
      end
      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
    end

    context '#valid_guess?' do
      it 'not valid if guess empty' do
        expect(game.valid_guess?('')).to eq(false)
      end
      it 'not valid if guess is not 4 numbers' do
        expect(game.valid_guess?('12345')).to eq(false)
      end
      it 'not valid if guess is not with numbers from 1 to 6' do
        expect(game.valid_guess?('7777')).to eq(false)
      end
      it 'valid guess' do
        expect(game.valid_guess?('1234')).to eq(true)
      end
    end

    context '#submit_guess' do
      it 'return nil if end of game' do
        game.instance_variable_set(:@attempts, 0)
        expect(game.submit_guess('1234')).to eq(nil)
      end
      it 'codebreaker use one attempt' do
        attempts_old = game.instance_variable_get(:@attempts)
        game.submit_guess('1234')
        expect(game.instance_variable_get(:@attempts)).to eq(attempts_old - 1)
      end
      it 'set value for @marking_guess' do
        game.submit_guess('1234')
        expect(game.instance_variable_get(:@marking_guess)).not_to be_nil
      end
    end

    context '#end_of_game?' do
      it 'return true if win' do
        game.instance_variable_set(:@marking_guess, '++++')
        game.instance_variable_set(:@attempts, 4)
        expect(game.end_of_game?).to eq(true)
      end
      it 'return true if lose' do
        game.instance_variable_set(:@marking_guess, '++-')
        game.instance_variable_set(:@attempts, 0)
        expect(game.end_of_game?).to eq(true)
      end
      it 'return false if not end of game' do
        game.instance_variable_set(:@marking_guess, '++-')
        game.instance_variable_set(:@attempts, 4)
        expect(game.end_of_game?).to eq(false)
      end
    end

    context '#show_hint' do
      it 'show one number of secrete_code' do
        hint = game.show_hint
        expect(game.instance_variable_get(:@secret_code).include?(hint)).to eq(true)
      end
      it 'set command Hint unavailable' do
        game.show_hint
        expect(game.instance_variable_get(:@hint)).to eq(false)
      end
    end

    context '#save_game' do
      it 'add new result to file with score' do
        game.instance_variable_set(:@marking_guess, '++++')
        game_data = game.get_game_data.map { |k, v| "#{k}=#{v}" }.join(';')
        game.save_game
        saved_data = IO.readlines(game.instance_variable_get(:@file_path)).last
        expect(saved_data.gsub("\n", '')).to eq(game_data)
      end
    end
  end
end
