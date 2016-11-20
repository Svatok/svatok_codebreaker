require 'spec_helper'

module SvatokCodebreaker
  RSpec.describe Marker do
    context '#marking_guess' do
      it 'guess is a winning' do
        marker = Marker.new(1234, 1234)
        expect(marker.marking_guess).to eq('++++')
      end
      it 'guess has correct numbers' do
        marker = Marker.new(1234, 1534)
        expect(marker.marking_guess).to match(/^([-]{1,4}|[+]{1,3}|[+-]{1,3}[-])$/)
      end
      it 'guess does not have the right numbers' do
        marker = Marker.new(1234, 5555)
        expect(marker.marking_guess).to match('Sorry, but there is no match...')
      end
    end

    context '#marking_exact_matches' do
      let(:marker) { Marker.new(1234, 1534) }

      it 'marking exact matches with +' do
        expect(marker.marking_exact_matches).to match(['+', nil, '+', '+'])
      end
      it 'code and guess leave without exact matchec numbers' do
        marker.marking_exact_matches
        expect(marker.instance_variable_get(:@secret_code)).to match([nil, '2', nil, nil])
        expect(marker.instance_variable_get(:@guess)).to match([nil, '5', nil, nil])
      end
    end

    context '#marking_inexact_matches' do
      it 'marking inexact matches with -' do
        marker = Marker.new(1254, 1532)
        marker.marking_exact_matches
        expect(marker.marking_inexact_matches).to match('--')
      end
    end
  end

end
