require 'spec_helper'

module SvatokCodebreaker
  RSpec.describe Game do
    context '#start' do
      let(:game) { Game.new }

      before do
        game.start
      end

      it 'generate secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).length).to eq(4)
      end
      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
      it 'system message about start game' do
        expect(game.start).to eq('----------Game started. Enter guess:----------')
      end
    end

    context '#codebreaker_answer' do
      let(:game) { Game.new }

      it 'codebreaker enter menu command' do
        expect(game.menu_command?('exit')).to eq(true)
      end
      it 'codebreaker enter guess' do
        expect(game.menu_command?('1234')).to eq(false)
      end
    end

    context '#command_exit' do
      let(:game) { Game.new }

      before do
        game.start
      end

      it 'set game_exit variable in true' do
        game.command_exit
        expect(game.exit_game).to eq(true)
      end
      it 'system message to the command Exit' do
        expect(game.command_exit).to eq('----------Bye!----------')
      end
    end

    context '#command_restart' do
      it 'count of attempts set maximum available' do
        game = Game.new
        game.start
        instance_variable_set(:@attempts, 6)
        game.command_restart
        expect(game.instance_variable_get(:@attempts)).to eq(ATTEMPTS)
      end
      it 'make available hint' do
        game = Game.new
        game.start
        instance_variable_set(:@hint, false)
        game.command_restart
        expect(game.instance_variable_get(:@hint)).to eq(true)
      end
      it 'generate new secret code' do
        game = Game.new
        game.start
        old_secret_code = game.instance_variable_get(:@secret_code)
        game.command_restart
        expect(game.instance_variable_get(:@secret_code)).not_to eq(old_secret_code)
      end
      it 'system message to the command Restart' do
        game = Game.new
        game.start
        expect(game.command_restart).to eq('----------Game restarted. Enter guess:----------')
      end
    end

    context '#command_hint' do
      it 'show one number of secrete_code' do
        game = Game.new
        game.start
        hint = game.command_hint
        expect(game.instance_variable_get(:@secret_code).include?(hint)).to eq(true)
      end
      it 'set command Hint unavailable' do
        game = Game.new
        game.start
        game.command_hint
        expect(game.instance_variable_get(:@hint)).to eq(false)
      end
    end

    context '#command_save' do
      it 'add new result to file with score' do
        game = Game.new
        game.start
        game.instance_variable_set(:@marking_guess, '++++')
        game_data = game.get_game_data.map { |k, v| "#{k}=#{v}" }.join(';')
        game.command_save
        saved_data = IO.readlines(game.instance_variable_get(:@file_path)).last
        expect(saved_data.gsub("\n","")).to eq(game_data)
      end
      it 'system message to the command Save' do
        game = Game.new
        game.start
        game.instance_variable_set(:@marking_guess, '++++')
        expect(game.command_save).to eq('----------Score saved!---------')
      end
    end

    context '#menu_command' do
      it 'show message if user enter not valid command' do
        game = Game.new
        expect(game.menu_command('sss')).to eq('You entered is not correct command. Enter the correct command.')
      end
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
      it 'codebreaker use one attempt' do
        game = Game.new
        game.start
        attempts_old = game.instance_variable_get(:@attempts)
        game.submit_guess('1234')
        expect(game.instance_variable_get(:@attempts)).to eq(attempts_old-1)
      end
      it 'system answer by marking the guess' do
        game = Game.new
        game.start
        game.submit_guess('1234')
        expect(game.instance_variable_get(:@marking_guess)).not_to be_nil
      end
      it 'system answer if proposed guess is not valid' do
        game = Game.new
        expect(game.submit_guess('11111')).to eq('Your code is not valid!')
      end
    end

    context '#result_after_marking' do
      it 'show marked code' do
        game = Game.new
        game.start
        game.submit_guess('5555')
        expected_message = game.result_after_marking[:marking_guess]
        expect(expected_message).to match(/[-+]{1,4}/) | eq('Sorry, but there is no match...')
      end
      it 'show count of attempts' do
        game = Game.new
        game.start
        game.submit_guess('5555')
        expected_message = game.result_after_marking[:attempts]
        expect(expected_message).to eq('You have 9 attempts.')
      end
      it 'show codebreaker wins' do
        game = Game.new
        game.start
        game.instance_variable_set(:@secret_code, 1234)
        game.submit_guess('1234')
        expect(game.result_after_marking[:game_end]).to eq('----------Congratulations! You win!----------')
      end
      it 'show codebreaker loses' do
        game = Game.new
        game.start
        game.instance_variable_set(:@secret_code, 1234)
        game.submit_guess('5555')
        game.instance_variable_set(:@attempts, 0)
        expect(game.result_after_marking[:game_end]).to eq('----------Sorry, but you lose :(----------')
      end
      it 'show commands when end of game' do
        game = Game.new
        game.start
        game.instance_variable_set(:@secret_code, 1234)
        game.submit_guess('1234')
        expect(game.result_after_marking[:commands]).to eq('You can Exit/Restart/Save. Enter the desired command:')
      end
      it 'show command Hint when it available' do
        game = Game.new
        game.start
        game.instance_variable_set(:@secret_code, 1234)
        game.submit_guess('5555')
        expect(game.result_after_marking[:commands]).to eq('You can use Hint. Enter it if you want.')
      end
      it 'show codebreaker can take another try' do
        game = Game.new
        game.start
        game.instance_variable_set(:@secret_code, 1234)
        game.submit_guess('5555')
        expect(game.result_after_marking[:next_step]).to eq('Enter a guess:')
      end
    end

  end
end
